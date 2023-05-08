import PyQt5
from PyQt5 import QtCore, QtGui, QtQml,QtQuick
from PyQt5.QtGui import QIcon,QImage,QPixmap,QColor, QImage, QIcon, QGuiApplication, QWindow,QPixmap
from PyQt5.QtCore import QObject, QThread
from PyQt5.QtQuick import QQuickView,QQuickPaintedItem,QQuickImageProvider
from PyQt5.QtQml import QQmlContext,QQmlApplicationEngine,qmlRegisterType 

import time
import sys
import os

import torch
from torchvision import transforms
