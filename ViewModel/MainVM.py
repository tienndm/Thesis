from ImportLib import *
from ViewModel.BaseViewModel import TwoWayBindingParam
from Config import Config
from Directory import UI

from Backend.Predict import Predict

class MainWindowVM(QObject):
    msgSignal = QtCore.pyqtSignal(str)
    approvalSignal = QtCore.pyqtSignal(bool)

    def __init__(self,_engine,_app):
        QObject.__init__(self)
        self.app = _app
        self.engine = _engine

        self.path_image = TwoWayBindingParam("")
        self.selection = TwoWayBindingParam(0)

        self.initDefaultParam()

        self.predictEngine = Predict()
        self.imageDir = ''

    def initDefaultParam(self):
        self.engine.rootContext().setContextProperty("pathImage", self.path_image)
        self.engine.rootContext().setContextProperty("langMode", self.selection)


    @QtCore.pyqtSlot(str)
    def setPathImage(self,_value):
        self.path_image.set(_value)
        print(_value.replace("file:///D:/ImageCaptioning/DataFlick8k/Test/Images/",""))
        self.imageDir = _value.replace("file:///","")
        Config.currentImageName = _value.replace("file:///","")

    @QtCore.pyqtSlot()
    def changeText(self):
        print('Click add')
    
    @QtCore.pyqtSlot(str)
    def handleAddButton(self,_value):
        with open(f'{UI.dataDir}/dataAdd.txt','a') as f:
            if Config.currentImageName != '':
                f.writelines(f'{Config.currentImageName}|{_value}\n')
                self.approvalSignal.emit(True)
            else:
                print('Please load an image')
                self.approvalSignal.emit(False)

    @QtCore.pyqtSlot(int)
    def handlePrediction(self,_value):
        self.selection = _value
        print(_value)

    @QtCore.pyqtSlot()
    def handlePredictButton(self):
        print('Enter predict mode')
        res = self.predictEngine.getCaption(self.imageDir,self.selection)
        self.msgSignal.emit(res)
