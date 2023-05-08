import QtQuick 2.1
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

/*
- Using Small Button for small icon no describle
- Using ColorOverlay to change color icon in svg/png fomat (backgroud :transparent)
*/

Button{
    id: btnTopBar
   
    property   int _width:35
    property   int _height:35
    width: _width
    height: _height

    property string _toolTip:"my tooltip"

    property url _btnIconSource: "../../resources/minimize_icon.svg"

    property color _btnColorDefault: "#1c1d20"
    property color _btnColorMouseOver: "#23272E"
    property color _btnColorClicked: "#00a1f1"
    property color _btnColorOverlay : "#ffffff"
    property color _colorToolTip:"springgreen"
    property bool _visibleTooltip: true

    QtObject{
        id: internal
        property var dynamicColor: if(btnTopBar.down){
                                       btnTopBar.down ? _btnColorClicked : _btnColorDefault
                                   } else {
                                       btnTopBar.hovered ? _btnColorMouseOver : _btnColorDefault
                                   }
    }
    ToolTip{     
        id:tooltipControl             
        visible: btnTopBar.hovered && _visibleTooltip
        text:_toolTip
        width:100
        background:Rectangle{
            width:tooltipControl.width
            color:"lightgray"
            radius:3   
            anchors{
                horizontalCenter:parent.horizontalCenter
                top: parent.top
                topMargin: 0
            }                   
        }     
    }
    background: Rectangle{
        id: bgBtn
        color:"transparent"
        radius:5    
        Image {
            id: iconBtn
            source: _btnIconSource
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.width-2
            width: parent.height-2
            visible: false
            fillMode: Image.PreserveAspectFit
            antialiasing: false
        }
        ColorOverlay{
            anchors.fill: iconBtn
            source: iconBtn
            color: _btnColorOverlay
            antialiasing: false        
        }
    }
}