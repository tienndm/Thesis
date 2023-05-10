import QtQuick 2.1
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Item{
    width: parent.width
    height: parent.height
    
    ComboBox {
        id: comboBox
        width: parent.width
        height: parent.height
        model: ["English", "Tiếng Việt"]
        currentIndex: 0
        
        contentItem: Rectangle {
            color: "dimgray"
            anchors{
                top: parent.top
                left: parent.left
            }
            height: parent.height
            width: parent.width

            Row {
                anchors{
                    bottom: parent.bottom
                    bottomMargin: 1
                }
                Image {
                    source: "qrc:/resources/975645.png"
                    width: 14
                    height: 14
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: comboBox.currentText
                    font.pointSize: 16
                    color: "Aqua"
                }
            }
        }
        
        delegate: ItemDelegate {
            width: parent.width
            height: 50
            highlighted: highlightedIndex === index
            
            contentItem: Row {
                Image {
                    source: "qrc:/resources/975645.png"
                    width: 16
                    height: 16
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: modelData
                    color: "Aqua"
                    font.pointSize: 13
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            
            background: Rectangle {
                color: "black"
            }
        }
        onCurrentIndexChanged: {
            _mainWindowVM.handlePrediction(currentIndex)
        }
    }
}