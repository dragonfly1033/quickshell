pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../types"
import "../singletons"

Singleton {
    id: root
    property string count
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
                let countStr = this.text.replace("!", "")
                let countNum = Number(countStr)
                root.count = countNum < 300 ? countStr : "!!" 
                root.ratio = Math.min(Math.max(countNum/root.updateThreshold, 0), 1); 
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
