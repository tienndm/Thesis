import requests
import torch
import os
from PIL import Image
from transformers import *
from tqdm import tqdm
import urllib.parse as parse
from deep_translator import GoogleTranslator 

device = "cuda" if torch.cuda.is_available() else "cpu"

class Predict:
    def __init__(self):
        self.finetunedModel = VisionEncoderDecoderModel.from_pretrained("nlpconnect/vit-gpt2-image-captioning").to(device)
        self.finetunedTokenizer = GPT2TokenizerFast.from_pretrained("nlpconnect/vit-gpt2-image-captioning")
        self.finetunedImageProcessor = ViTImageProcessor.from_pretrained("nlpconnect/vit-gpt2-image-captioning")
    
    def isUrl(self,string):
        try:
            result = parse.urlparse(string)
            return all([result.scheme, result.netloc, result.path])
        except:
            return False
        
    def loadImage(self,imagePath):
        if self.isUrl(imagePath):
            return Image.open(requests.get(imagePath, stream=True).raw)
        elif os.path.exists(imagePath):
            return Image.open(imagePath)

    def getCaption(self,imagePath,langMode):
        img = self.loadImage(imagePath)
        img = self.finetunedImageProcessor(img,return_tensors="pt").to(device)
        output = self.finetunedModel.generate(**img)
        caption = self.finetunedTokenizer.batch_decode(output,skip_special_tokens=True)[0]
        if langMode == 1:
            caption = self.translate(caption)
        return caption
    
    def translate(self,text):
        translator = GoogleTranslator(source='en',target='vi')  
        translated = translator.translate(text)
        return translated
        