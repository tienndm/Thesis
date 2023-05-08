import QtQuick 2.1
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

TextField {
    id: textField
    width: parent.width* 0.8
    height: parent.height *0.9
    // Custom Properties
    property color colorDefault: "transparent"
    property color colorOnFocus: "#242831"
    property color colorMouseOver: "#2B2F38"
    property int componentWidth: parent.width

    property int _pointSize: 7
    
    QtObject{
        id: internal

        property var dynamicColor: if(textField.focus){
                                        textField.focus ? colorOnFocus : colorDefault
                                   }else{
                                       textField.hovered ? colorMouseOver : colorDefault
                                   }
    }

    

    implicitWidth: componentWidth
    implicitHeight: 40
    placeholderText: qsTr("Type something")
    color: "Aqua"
    font.pointSize:_pointSize
    background: Rectangle {
        color: internal.dynamicColor
       
        radius: 4
    }
    onActiveFocusChanged: {
        if (activeFocus) {
            text = ""
        }
    }
    selectByMouse: true
    selectedTextColor: "#FFFFFF"
    selectionColor: "#ff007f"
}