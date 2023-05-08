from typing import Union
from PyQt5 import QtCore 

class TwoWayBindingParam(QtCore.QObject):

    valueChanged = QtCore.pyqtSignal()
    def __init__(self, value, parent_=None):
        super().__init__(parent_)
        self.value = value
        return None

    @QtCore.pyqtSlot(str)
    @QtCore.pyqtSlot(int)
    @QtCore.pyqtSlot(bool)
    @QtCore.pyqtSlot(list)
    @QtCore.pyqtSlot(float)
    def set(self, value):
        self.value = value
        self.valueChanged.emit()

    def get(self) -> Union[str, int, bool, list,float]:
        return self.value

    """
    Define type of Property
    """
    qml_prop_int = QtCore.pyqtProperty(int, get, set, notify=valueChanged)
    qml_prop_float = QtCore.pyqtProperty(float, get, set, notify=valueChanged)
    qml_prop_bool = QtCore.pyqtProperty(bool, get, set, notify=valueChanged)
    qml_prop_str = QtCore.pyqtProperty(str, get, set, notify=valueChanged)
    qml_prop_list = QtCore.pyqtProperty(list, get, set, notify=valueChanged)