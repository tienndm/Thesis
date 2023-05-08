import QtQuick 2.0
import QtQuick 2.1
import QtQuick 2.9

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
    property string _pathImage:"../../resources/bkLogo.png"
    
    width: parent.width
    height: parent.height
    Rectangle {
        color:"transparent"
        width:parent.width
        height:parent.height
        Image{
            source:_pathImage
            width:parent.width - 1
            height:parent.height - 4
            anchors{
                top: parent.top
                topMargin: 2
            } 
        }
    }
}