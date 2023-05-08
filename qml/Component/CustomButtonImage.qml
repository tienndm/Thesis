import QtQuick 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0
import QtQuick.Controls 2.1
import QtQuick.Controls 2.2
import QtQuick 2.3
import QtQuick 2.4
import QtQuick 2.9
import QtQuick 2.0


import QtQuick.Window 2.1
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3

/*
- Decribe CustomButton Image
- Using for big button and have text
- Content {

    ToolTip
    Image
    Text
}
*/

Button {
    id: button   
    enabled:enabled.parent == undefined?true:enabled.parent

    property color colorDefault: "#273035"
    property color colorMouseOver: "#55AAFF"
    property color colorPressed: "#3F7EBD"
    property string sourceImage :""
    property string _toolTip:"Ctrl+R"
    property string _fontFamily:"Adobe Gothic Std B"   
    
    opacity: enabled ? 1:0.1
    // ToolTip{                  
    //     visible: button.hovered
    //     text:_toolTip
    //     font.bold:false
    //     width:parent.width*0.8
    //     background:Rectangle{
    //         color:"lightgray"
    //         radius:3   
    //         anchors{
    //             horizontalCenter:parent.horizontalCenter
    //             top: parent.top
    //             topMargin: 0
    //         }                   
    //     }     
    // }
    QtObject{
        id: internal
        property var dynamicColor: if(button.down){
                                       button.down ? colorPressed : colorDefault
                                   }else{
                                       button.hovered ? colorMouseOver : colorDefault
                                   }
    }   
    font.weight: Font.Light  
    contentItem: Item{        
        Image {
                id: visualImage
                width: parent.width*0.9
                height: parent.height* 0.6
                source : sourceImage    
                fillMode: Image.PreserveAspectFit                                   
                anchors{
                    top: parent.top
                    left:parent.left
                    right: parent.right
                    topMargin: 2
                    leftMargin:2
                    rightMargin:2
                }                         
            }
            Text{
                text: button.text
               // wrapMode: Text.WordWrap
                
                color: "#ffffff"
                font.family: _fontFamily
                font.pointSize:8          
                anchors.horizontalCenter: parent.horizontalCenter
                anchors{
                    bottom: parent.bottom
                    bottomMargin:2
                }
            }       
    }
    background: Rectangle{
        color: internal.dynamicColor
        border.color :"silver"         
        anchors{
            top:parent.top
            left:parent.left
            right:parent.right
            bottom:parent.bottom
            topMargin:5
            rightMargin:2
            leftMargin:2
            bottomMargin:2
        }     
        radius: 5
    }
}