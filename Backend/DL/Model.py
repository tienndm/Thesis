import torch
import torch.nn as nn
import torchvision.models as models

device = "cuda" if torch.cuda.is_available() else "cpu"

class Encoder(nn.Module):
    def __init__(self,encodedImageSize=14):
        super(Encoder,self).__init__()
        self.encodedImageSize = encodedImageSize
        resnet = models.resnet101(pretrained=True)
        module = list(resnet.children())[:-2]
        self.resnet = nn.Sequential(*module)

        self.adaptivePool = nn.AdaptiveAvgPool2d((encodedImageSize,encodedImageSize))
        self.finetune()
    
    def forward(self,images):
        out = self.resnet(images)
        out = self.adaptivePool(out)
        out = out.permute(0,2,3,1)
        return out

    def finetune(self,finetune=True):
        for p in self.resnet.parameters():
            p.requires_grad = False
        for c in list(self.resnet.children())[5:]:
            for p in c.parameters():
                p.requires_grad = finetune

class Attention(nn.Module):
    def __init__(self,encoderDim,decoderDim,attentionDim):
        super(Attention,self).__init__()
        self.encoderAttn = nn.Linear(encoderDim,attentionDim) # linear layer to transform encoded image
        self.decoderAttn = nn.Linear(decoderDim,attentionDim) # linear layer to transform decoder's output
        self.fullAttn = nn.Linear(attentionDim,1) # linear layer to calculate values to be softmax-ed
        self.relu = nn.ReLU()
        self.softmax = nn.Softmax(dim=1)
    
    def forward(self,encoderOut,decoderHidden):
        attn1 = self.encoderAttn(encoderOut)
        attn2 = self.decoderAttn(decoderHidden)
        attn  = self.fullAttn(self.relu(attn1 + attn2.unsqueeze(1))).squeeze(2) #(batchsize, num_pixels)
        alpha = self.softmax(attn)
        attentionWeightEncoding = (encoderOut * alpha.unsqueeze(2)).sum(dim=1) #(batchsize, encoder_dim)

        return attentionWeightEncoding,alpha
    
class DecoderWithAttention(nn.Module):
    def __init__(self,attentionDim,embedDim,decoderDim,vocabSize,encoderDim=2048,dropout=0.5):
        super(DecoderWithAttention,self).__init__()
        self.encoderDim = encoderDim
        self.attentionDim = attentionDim
        self.embedDim = embedDim
        self.decoderDim = decoderDim
        self.vocabSize = vocabSize
        self.dropOut = dropout

        self.attention = Attention(encoderDim,decoderDim,attentionDim)

        self.embedding = nn.Embedding(vocabSize,embedDim)
        self.dropOut = nn.Dropout(dropout)
        self.decodeStep = nn.LSTMCell(embedDim + encoderDim, decoderDim, bias=True)
        self.initH = nn.Linear(encoderDim,decoderDim)
        self.initC = nn.Linear(encoderDim,decoderDim)
        self.fBeta = nn.Linear(decoderDim,encoderDim)
        self.sigmoid = nn.Sigmoid()
        self.fc = nn.Linear(decoderDim,vocabSize)
        self.initWeight()
    
    def initWeight(self):
        self.embedding.weight.data.uniform_(-0.1,0.1)
        self.fc.bias.data.fill_(0)
        self.fc.weight.data.uniform_(-0.1,0.1)
    
    def initHiddenState(self,encoderOut):
        meanEncoderOut = encoderOut.mean(dim=1)
        h = self.initH(meanEncoderOut)
        c = self.initC(meanEncoderOut)
        return h,c
    
    def forward(self,encoderOut,encodeCaptions,captionLengths):
        batchSize = encoderOut.size(0)
        encoderDim = encoderOut.size(-1)
        vocabSize = self.vocabSize

        #Flatten image
        encoderOut = encoderOut.view(batchSize,-1,encoderDim) #(batch_size,num_pixels,encoder_dim)
        numPixels = encoderOut.size(1)

        # Sort input data by decreasing lengths; why? apparent below
        captionLengths,sortInd = captionLengths.squeeze.sort(dim=0,descending=True)
        encoderOut = encoderOut[sortInd]
        encodeCaptions = encodeCaptions[sortInd]

        #Embedding
        embeddings = self.embedding(encodeCaptions) #(batch_size,max_caption_length,embed_dim)

        #Initialize LSTM state
        h,c = self.initHiddenState(encoderOut)
        
        # We won't decode at the <end> position, since we've finished generating as soon as we generate <end>
        # So, decoding lengths are actual lengths - 1
        decodeLength = (captionLengths - 1).tolist()

        # Create tensors to hold word predicion scores and alphas
        predictions = torch.zeros(batchSize,max(decodeLength),vocabSize).to(device)
        alphas = torch.zeros(batchSize,max(decodeLength),numPixels).to(device)

        for t in range(max(decodeLength)):
            batchSizeT = sum([l > t for l in decodeLength])
            attentionWeightEncoding, alpha = self.attention(encoderOut[:batchSizeT],
                                                            h[:batchSizeT])
            gate = self.sigmoid(self.fBeta(h[:batchSizeT]))
            attentionWeightEncoding = gate * attentionWeightEncoding
            h,c = self.decodeStep(torch.cat([embeddings[:batchSizeT,t,:],attentionWeightEncoding],dim=1),
                                  (h[:batchSizeT],c[:batchSizeT])) #(batch_size_t,decoder_dim)
            preds = self.fc(self.dropOut(h)) #(batch_size_t,decoder_dim)
            predictions[:batchSizeT,t,:] = preds
            alphas[:batchSizeT,t,:] = alpha

        return predictions,encodeCaptions,decodeLength,alphas,sortInd