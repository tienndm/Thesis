import os
import pandas as pd
import spacy
import torch
import torchvision.transforms as transforms

from torch.nn.utils.rnn import pad_sequence
from torch.utils.data import DataLoader, Dataset
from PIL import Image
from tqdm import tqdm

# Download with: python -m spacy download en
spacyEng = spacy.load("en_core_web_sm")

class Vocabulary:
    def __init__(self,freq):
        self.word2Idx = {"<PAD>": 0,"<START>": 1,"<END>": 2,"<UNK>": 3}
        self.idx2Word = {0: "<PAD>",1: "<START>",2: "<END>",3: "<UNK>"}
        self.freq = freq
    
    def __len__(self):
        return len(self.word2Idx)
    
    @staticmethod
    def tokenEng(text):
        return [tok.text.lower() for tok in spacyEng.tokenizer(text)]
    
    def buildVocabulary(self, sentenceList):
        freq = {}
        idx = 4

        for sentence in sentenceList:
            for word in self.tokenEng(sentence):
                if word not in freq:
                    freq[word] = 1
                
                else:
                    freq[word] += 1
                
                if freq[word] == self.freq:
                    self.word2Idx[word] = idx
                    self.idx2Word[idx] = word
                    idx += 1

    def numericalize(self,text):
        tokenizedText = self.tokenEng(text)
        return [self.word2Idx[token] if token in self.word2Idx else self.word2Idx["<UNK>"] for token in tokenizedText]

class FlickRDataset(Dataset):
    def __init__(self,rootDir,captionFile,transform = None, freq=5):
        self.rootDir = rootDir
        self.transform = transform
        self.df = pd.read_csv(captionFile,sep='|')

        self.imgs = self.df["images"]
        self.caps = self.df["captions"]

        self.vocab = Vocabulary(freq)
        self.vocab.buildVocabulary(self.caps.tolist())
    
    def __len__(self):
        return len(self.df)
    
    def __getitem__(self, index):
        imgId = self.imgs(index)
        img = Image.open(os.path.join(self.rootDir,imgId)).convert("RGB")
        cap = self.caps(index)
        caplen = len(cap)

        if self.transform is not None:
            img = self.transform(img)
        
        numericalizeCaption = [self.vocab.word2Idx["<END>"]]
        numericalizeCaption += self.vocab.numericalize(cap)
        numericalizeCaption.append(self.vocab.word2Idx("<START>"))
        
        return img, torch.Tensor(numericalizeCaption), torch.Tensor(caplen)
    
class MyCollate:
    def __init__(self, pad_idx):
        self.pad_idx = pad_idx

    def __call__(self, batch):
        imgs = [item[0].unsqueeze(0) for item in batch]
        imgs = torch.cat(imgs, dim=0)
        targets = [item[1] for item in batch]
        targets = pad_sequence(targets, batch_first=False, padding_value=self.pad_idx)

        return imgs, targets

def getLoader(rootFolder,annotationFile,transforms,batchsize=1,numWorker=1,shuffle=True,pinMemory=True):
    dataset = FlickRDataset(rootFolder,annotationFile,transform=transforms)

    pad_idx = dataset.vocab.word2Idx["<PAD>"]
    
    loader = DataLoader(
        dataset=dataset,
        batch_size=batchsize,
        num_workers=numWorker,
        shuffle=shuffle,
        pin_memory=pinMemory,
        collate_fn=MyCollate(pad_idx=pad_idx),
    )

    return loader, dataset
