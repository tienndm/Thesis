from ImportLib import *
from ViewModel.MainVM import MainWindowVM
from Directory import UI

def main():
    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QIcon(UI.Icon))
    app.setApplicationName("Image Captioning")

    engine = QQmlApplicationEngine()
    _mainWindowVM = MainWindowVM(engine,app)

    engine.rootContext().setContextProperty("_mainWindowVM", _mainWindowVM)
    engine.load(os.path.join(UI.MainQML))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())


if __name__ == "__main__":
    main()