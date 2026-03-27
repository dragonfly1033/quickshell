pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string hour
    property string min
    property string day
    property string date
    property string month

    Process {
        id: dateProc
        command: ["date", "+%H,%M,%A,%d,%B"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const parts = this.text.trim().split(",")
                root.hour = parts[0]
                root.min = parts[1]
                root.day = parts[2]
                root.date = parts[3]
                root.month = parts[4]
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            dateProc.running = true
        }
    }
}
