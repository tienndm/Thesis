import QtQuick 2.0
import QtQuick.Controls 2.12

Item{
    Rectangle {
        id: titleBar
        height: 40
        width: parent.width
        color: "steelblue"

        RowLayout {
            anchors.fill: parent
            spacing: 10

            // Add your title text
            Text {
                text: "My Application"
                color: "white"
                font.bold: true
                font.pointSize: 18
            }

            // Add your buttons
            Button {
                text: "-"
                onClicked: Window {
                    id: window
                    width: 400
                    height: 300
                    title: "My Application"
                    visible: true
                    flags: Qt.Window
                    maximumHeight: screen.height
                    maximumWidth: screen.width
                }.showMinimized()
            }

            Button {
                text: "+"
                onClicked: Window {
                    id: window
                    width: 400
                    height: 300
                    title: "My Application"
                    visible: true
                    flags: Qt.Window
                    maximumHeight: screen.height
                    maximumWidth: screen.width
                }.showMaximized()
            }

            Button {
                text: "X"
                onClicked: Qt.quit()
            }
        }
    }
}