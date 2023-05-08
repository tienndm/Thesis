import QtQuick 2.0
import QtQuick 2.1
import QtQuick 2.9

import QtQuick.Window 2.1
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Layouts 1.0

import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.1

import "Component"

Item{
    width: parent.width
    height: parent.height
    
    property string _fontFamily: "Adobe Gothic Std B"
    Row{
        anchors{
            top: parent.top
            topMargin: 10
        }
        CustomButtonImage{
            id: btnLoadImage
            width: 90
            height: 110
            text: "Load Image"
            sourceImage: "../../resources/image.png"
            font.family:_fontFamily
            onClicked:{
                fileDialog.open()
            }
        }
        SpaceV{
            height:110
        }
        CustomButtonImage{
            id: btnLoadFolder
            width: 90
            height: 110
            text:"Train"
            sourceImage:"../../resources/brain.png"
            font.family: _fontFamily
            onClicked:{
                _mainWindowVM.handleTrainButton()
            }
        }
    }
    FileDialog {
        id: fileDialog
        width:550
        height:300
        visible:false
        title: "Please choose a folder"
        folder: "file:///D:/ImageCaptioning/DataFlick8k/Test/Images"
        selectFolder :false
        onAccepted: {
            console.log("Mes -- You chose: " + fileDialog.fileUrls)     
            _mainWindowVM.setPathImage(fileDialog.fileUrls)
        }
        onRejected: {
            console.log("Mes -- Canceled from Dialog Ribbon")
        }       
    }
    FileDialog {
        id: folderDialog
        width:550
        height:300
        visible:false
        title: "Please choose a folder"
        folder: "file:///D:/ImageCaptioning/DataFlick8k/"
        selectFolder :true
        onAccepted: {
            console.log("Mes -- You chose: " + fileDialog.fileUrls) 
        }
        onRejected: {
            console.log("Mes -- Canceled from Dialog Ribbon")
        }       
    }
}