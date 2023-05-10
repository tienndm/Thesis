import QtQuick 2.0
import QtQuick 2.1
import QtQuick 2.4

import QtQuick.Window 2.1
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
// import QtQuick.Timeline 1.0
// import QtPositioning 5.5
// import QtLocation 5.6

// import QtQuick.Scene3D 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

import QtQuick.Window 2.2
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.2
//
import QtQuick.Dialogs 1.1

import "Component"

Item{
    id: captionItem
    property string _caption: "Powered by Nguyen Do Minh Tien"

    Connections{
        target: _mainWindowVM
        function onMsgSignal(_value){
            captionLabel.text = _value
            console.log("Mess -- Change _caption to " + captionLabel.text)
        }
    }

    Text{
        anchors{            
            left: parent.left
            leftMargin: 3
            top: parent.top
            topMargin: 3
            fill: parent
        }
        text: "CAPTION:"
        font.pixelSize: 25
        font.bold: true
        color: "red"
        horizontalAlignment: Text.AlignHCenter
        renderType: Text.NativeRendering
    }
    
    Label{
        id: captionLabel
        anchors{
            left: parent.left
            leftMargin: 3
            top: parent.top
            topMargin: 3
            fill: parent
        }
        text: captionItem._caption
        font.pixelSize: 25
        color: "Aqua"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        renderType: Text.NativeRendering
        wrapMode: Text.WordWrap

        function formatText() {
            var sentences = text.split(". ")
            var formattedText = ""

            for (var i = 0; i < sentences.length; i++) {
                if (i === sentences.length - 1) {
                    formattedText += sentences[i]
                } else {
                    formattedText += sentences[i] + ".\n"
                }
            }

            return formattedText
        }
        Component.onCompleted: {
            text = formatText()
        }
    }
}