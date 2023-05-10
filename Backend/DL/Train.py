import time
import torch.backends.cudnn as cudnn
import torch.optim as optim
import torchvision.transforms as transforms

from torch.nn.utils.rnn import pad_packed_sequence
from Model import Encoder, DecoderWithAttention
from nltk.translate.bleu_score import corpus_bleu

def main():
    word