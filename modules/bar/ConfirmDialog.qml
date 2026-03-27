pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import "../singletons"

Item {
    id: root

    property string action: ""

    signal confirmed
    signal cancelled

    implicitWidth: circle.width
    implicitHeight: circle.height

    // Keyboard: Enter = confirm, Escape handled by Modal
    focus: true
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            doConfirm()
            event.accepted = true
        }
    }

    function doConfirm() {
        root.confirmed()
    }

    Rectangle {
        id: circle
        width: 220
        height: 220
        radius: width / 2
        color: hoverHandler.hovered
            ? Qt.lighter(Scheme.bgColor, 1.3)
            : Scheme.bgColor
        border.color: Scheme.accent
        border.width: 2

        Behavior on color { ColorAnimation { duration: 150 } }

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.action
                color: Scheme.fgColor
                font.family: Scheme.font
                font.pixelSize: 20
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "↵  confirm"
                color: Qt.rgba(Scheme.fgColor.r, Scheme.fgColor.g, Scheme.fgColor.b, 0.4)
                font.family: Scheme.font
                font.pixelSize: 11
            }
        }

        HoverHandler { id: hoverHandler }
        TapHandler { onTapped: root.doConfirm() }
    }
}
