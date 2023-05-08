import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.2
Rectangle{
    property int  _space:20
    property int _thinkness:2
    property int _height:100
    property color _color:"deepskyblue"
    width:_space
    height:_height
    color:"transparent"
    Rectangle{
        width:_thinkness
        height:parent.height*0.8
        color:_color    
        anchors.verticalCenter: parent.verticalCenter
        anchors.centerIn: parent                                       
    }
}