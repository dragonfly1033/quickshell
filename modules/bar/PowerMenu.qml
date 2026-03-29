pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import "../singletons"

Item {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    required property var modal

    property int size: 96
    property int spacing: 12
    property int padding: 6


    Component {
        id: confirmDialog
        ConfirmDialog {}
    }

    component PowerButton: Rectangle {
        id: btn

        required property string glyph
        required property string action
        required property list<string> command
        required property color iconColor
        property bool confirm: false

        property bool hovered: hoverHandler.hovered

        width: root.size
        height: root.size
        radius: Scheme.borderShrink(2)
        color: hovered ? Qt.lighter(Scheme.bgColor, 2.5) : Qt.lighter(Scheme.bgColor, 1.6)

        Behavior on color { ColorAnimation { duration: 150 } }

        HoverHandler { id: hoverHandler }

        Text {
            anchors.centerIn: parent
            text: btn.glyph
            color: btn.hovered ? btn.iconColor : Scheme.fgColor
            font.family: Scheme.iconFont
            font.pixelSize: 22

            Behavior on color { ColorAnimation { duration: 150 } }
        }

        function handle() {
            if (btn.confirm) {
                var item = root.modal.show(confirmDialog, {
                    action: btn.action,
                })
                let confirmFlag = false
                item.confirmed.connect(() => { confirmFlag = true })
                item.cancelled.connect(item.close)
                item.closingDone.connect(() => { if (confirmFlag) proc.running = true })
            } else {
                proc.running = true
            }
        }

        TapHandler {
            onTapped: {
                btn.handle()
            }
        }

        IpcHandler {
            target: btn.action
            function activate() : void { btn.handle() }
        }

        Process {
            id: proc
            command: btn.command
        }
    }

    // Rectangle {
    //     anchors.fill: parent
    //     radius: Scheme.borderShrink(1)
    //     color: '#ff0000'
    // }

    Row {
        id: row
        spacing: root.spacing
        topPadding: root.padding
        bottomPadding: root.padding
        leftPadding: root.padding
        rightPadding: root.padding


        PowerButton {
            glyph: Icons.logout.glyph
            action: "Logout"
            command: ["niri", "msg", "action", "quit"]
            iconColor: Scheme.yellow
            confirm: true
        }
        PowerButton {
            glyph: Icons.lock.glyph
            action: "Lock"
            command: ["swaylock"]
            iconColor: Scheme.blue
            confirm: true
        }
        PowerButton {
            glyph: Icons.reboot.glyph
            action: "Reboot"
            command: ["notify-send", "reboot"]
            iconColor: Scheme.orange
            confirm: true
        }
        PowerButton {
            glyph: Icons.power.glyph
            action: "Shutdown"
            command: ["shutdown", "now"]
            iconColor: Scheme.red
            confirm: true
        }
    }
}
