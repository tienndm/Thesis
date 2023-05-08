import QtQuick 2.0
import QtQuick 2.1
import QtQuick 2.9

import QtQuick.Window 2.1
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

import QtQuick.Window 2.2
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.2
//
import QtQuick.Dialogs 1.1

import "Component"

ApplicationWindow{
    property string _captionChange: "Powered by Nguyen Do Minh Tien"

    signal _changeCaption (string newCaption)

    id: mainWindow
    visible: true
    width: 1280
    height: 780
    color: "#322F2E"
    // flags: Qt.Window | Qt.FramelessWindowHint



    Rectangle{
        width: parent.width
        height: 145
        color: "black"
        border.width:1
        border.color: "gray"
        anchors{
            left: parent.left
            top: parent.top
        }
        Ribbon{
            id:viewImage
        }
    }

    Rectangle{
        width: 800
        height: parent.height * 0.85
        color:"transparent"
        border.width:1
        border.color: "gray"
        anchors{
            top: parent.top
            topMargin:parent.height * 0.175 + 8
            left: parent.left
        }
        ImageView{
            _pathImage :  pathImage.qml_prop_str
            id: imageView
        }
    }
    Rectangle{
        width:480
        height:250
        color:"transparent"
        border.width:1
        border.color: "gray"
        anchors{
            top: parent.top
            topMargin:parent.height * 0.175 + 8
            right: parent.right
        }
        Caption{
            anchors.fill: parent
            }
    }

    Rectangle{
        width: 480
        height: 250
        color: "transparent"
        border.width:1 
        border.color: "gray"
        anchors{
            top: parent.top
            topMargin: parent.height * 0.175 + 258
            right: parent.right
        }
        TextBox{
            anchors.fill: parent
        }

    }

    CustomButtonImage{
        id: btnLoadFolder
        anchors{
            bottom: parent.bottom
            bottomMargin: 10
            right: parent.right
            rightMargin: 195
        }
        width: 90
        height: 110
        text:"Predict"
        sourceImage:"../../resources/BlackspikeTorus1.png"
        font.family: "Adobe Gothic Std B"
        onClicked:{
            _mainWindowVM.handlePredictButton()
        }
    }
}