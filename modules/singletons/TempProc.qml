pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../singletons"

Singleton {
    id: root

    property string temp
    property real ratio
    property color progressColor

    Process {
        id: tempProc
        command: ["cat", Scheme.tempSensor]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                let temp = this.text.slice(0, -4)
                root.temp = temp == "100" ? "" : temp

                let num = Number(temp)
                root.ratio = num / 100
                if (num < 50) {
                    root.progressColor = Scheme.green
                } else if (num < 80) {
                    root.progressColor = Scheme.orange
                } else {
                    root.progressColor = Scheme.red
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            tempProc.running = true
        }
    }
}
