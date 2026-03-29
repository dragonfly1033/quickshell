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
    property string tempSensor: "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon5/temp1_input"

    Process {
        id: tempProc
        command: ["cat", root.tempSensor]
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
            //showTempSensor.running = true
            tempProc.running = true
        }
    }

    Process {
        id: getTempSensor
        command: ["./get_temp_sensor.sh"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.tempSensor = this.text
            }
        }
    }

    Process {
        id: showTempSensor
        command: ["notify-send", root.ratio, root.temp + root.tempSensor]
        running: false
    }

}
