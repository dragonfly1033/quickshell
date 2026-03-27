pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../types"
import "../singletons"

Singleton {
    id: root
    property real ratio
    property Icon icon
    property color progressColor

    property int updateThreshold: 100

    Process {
        id: updateNum
        command: ["get_update_number", "plain"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.endsWith("!")) {
                    root.icon = Icons.hazard
                } else {
                    root.icon = Icons.updates
                }
                root.ratio = Number(this.text.replace("!", ""))/root.updateThreshold
                if (root.ratio < 0.5) {
                    root.progressColor = Scheme.green
                } else if (root.ratio < 0.8) {
                    root.progressColor = Scheme.orange
                } else {
                    root.progressColor = Scheme.red
                }
            }
        }
    }

    Timer {
        interval: 60*60*1000
        running: true
        repeat: true
        onTriggered: {
            updateNum.running = true
        }
    }
}
