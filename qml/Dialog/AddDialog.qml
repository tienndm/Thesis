import QtQuick 2.0
import QtQuick.Dialogs 1.2

Item {
    Dialog {
        id: addDialog
        title: "Dialog Title"
        text: "Dialog Text"
        visible: false

        Button {
            text: "Close Dialog"
            onClicked: dialog.close()
        }
    }
}