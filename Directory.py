import os
import pathlib

CWD = pathlib.Path(__file__).parent.absolute()

class UI():
    MainQML = os.path.join(CWD,"qml",'main.qml')

    PathImage = str(0)

    PathFolder = str(0)

    Icon = r'D:\OwnGit\ImageCaptioning\resources\bkLogo.png'

    dataDir = r'D:\OwnGit\Thesis\Backend\Data'