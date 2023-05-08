import QtQuick 2.1
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

Button{
    id: btnTopBar
    // CUSTOM PROPERTIES
    property url btnIconSource: "../../resources/minimize_icon.svg"
    property color btnColorDefault: "transparent"
    property color btnColorMouseOver: "transparent"
    property color btnColorClicked: "lime"
    property color btnColorOverlay : "#203852"
    property color btnColorOverlayBlink :"transparent"
    property   int _width:35
    property   int _height:35
    property bool  _isBlink :false
    property int  _timeBlink:600
    visible :_isBlink
    QtObject{
        id: internal
    }
    width: _width
    height: _height
    background: Rectangle{
        id: bgBtn
        color: "transparent"
        radius:5       
        Image {
            id: iconBtn
            source: btnIconSource
            height: _height
            width: _width
            visible: false
            fillMode: Image.PreserveAspectFit
            antialiasing: false
        }
        ColorOverlay{
            anchors.fill: iconBtn
            source: iconBtn
            color: btnColorOverlay
            antialiasing: false  
            id:coOverlay
            ColorAnimation on color{
                from:btnColorOverlayBlink
                to:btnColorOverlay
                duration: _timeBlink
                running:_isBlink
                loops: Animation.Infinite
                easing.type: Easing.Linear;
                onRunningChanged: if(!running){coOverlay.color = btnColorOverlayBlink} // reset
            }     
        }
    }
}


