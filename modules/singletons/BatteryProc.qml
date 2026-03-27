pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "../singletons"
import "../types"

Singleton {
    id: root

    property string level
    property real ratio
    property Icon icon
    property color progressColor

    Process {
        id: batteryProc
        command: ["cat", Scheme.battery+"/capacity", Scheme.battery+"/status"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                let parts = this.text.split("\n")
                let level = parts[0]
                let status = parts[1]
                root.level = level == "100" ? "" : level
                let num = Number(level)
                root.ratio = num / 100
                if (num < 20) {
                    root.progressColor = Scheme.red
                } else if (num < 50) {
                    root.progressColor = Scheme.orange
                } else {
                    root.progressColor = Scheme.red
                }
                if (status == "Charging") {
                    root.icon = Icons.batteryCharging
                } else {
                    root.icon = Icons.batteryDischarging
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            batteryProc.running = true
        }
    }
}
