import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.1
import "Component"
import "Dialog"

Item{
    property string _content: "Please write down new caption that you satified"
    property bool   _approval: false

    Connections{
        target: _mainWindowVM
        function onApprovalSignal(_value){
            _approval = _value
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
        text: "NEW CAPTION:"
        font.pixelSize: 25
        font.bold: true
        color: "red"
        horizontalAlignment: Text.AlignHCenter
        renderType: Text.NativeRendering
    }
    CustomTextField{
        width: parent.width
        height: parent.height - 40
        color: "Aqua"
        anchors{
            top: parent.top
            topMargin: 40
        }
        placeholderText: "NEW CAPTION"
        text: _content
        font.pointSize:10
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        onTextChanged:{
            if (_content == ""){
                _content = "Please write down new caption that you satified"
            }else{
                console.log("Mess -- content " + _content)
                _content = text
            }
        }
    }

    Dialog {           
        id: addDialog
        width:260
        height:200
        parent:Overlay.overlay
        x:parent.width/2-width/2
        y:parent.height/2-height/2
        Label { 
            anchors{
                top: parent.top
                topMargin: 5
            } 
            text: 'Are you sure to add \nthis caption into database' 
            font.bold:true
            height:13
            font.pointSize:10
            color:"#4A4A45"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            }
        footer: DialogButtonBox {
            standardButtons: DialogButtonBox.Ok | DialogButtonBox.Cancel 
            onAccepted:{
                console.log("Mess -- Click OK from Dialog")
            }
            onRejected:{
                console.log("Mess -- Click Cancel from Dialog")
            }
        }
               
        MouseArea{
            id: iMouseArea
            property int prevX: 0
            property int prevY: 0
            anchors.fill: dialog
            onPressed: {prevX=mouseX; prevY=mouseY}
            onPositionChanged:{
                var deltaX = mouseX- prevX;
                dialog.x += deltaX;
                prevX = mouseX- deltaX;

                var deltaY = mouseY - prevY
                dialog.y += deltaY;
                prevY = mouseY- deltaY;
            }
        }
    }

    Dialog{
        id: warnDialog
        width:260
        height:200
        parent:Overlay.overlay
        x:parent.width/2-width/2
        y:parent.height/2-height/2
        Label {
            anchors{
                top: parent.top
                topMargin: 5
            } 
            text: 'Please select an image' 
            font.bold:true
            height:13
            font.pointSize:10
            color:"#4A4A45"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        footer: DialogButtonBox {
            standardButtons: DialogButtonBox.Ok | DialogButtonBox.Cancel 
            onAccepted:{
                console.log("Mess -- Click OK from Dialog")
            }
            onRejected:{
                console.log("Mess -- Click Cancel from Dialog")
            }
        }
        MouseArea{
            property int prevX: 0
            property int prevY: 0
            anchors.fill: dialog
            onPressed: {prevX=mouseX; prevY=mouseY}
            onPositionChanged:{
                var deltaX = mouseX- prevX;
                dialog.x += deltaX;
                prevX = mouseX- deltaX;

                var deltaY = mouseY - prevY
                dialog.y += deltaY;
                prevY = mouseY- deltaY;
            }
        }
    }
    
    Button{
        text: "Add"
        anchors{
            bottom: parent.bottom
            bottomMargin: 5
            horizontalCenter: parent.horizontalCenter
        }
        onClicked:{
            _mainWindowVM.handleAddButton(_content)
            if (_approval == true){addDialog.open()} else {warnDialog.open()}
        }
    }
}