pragma Singleton

import QtQuick

QtObject {
    readonly property int borderThickness: 8
    readonly property int barWidth: 52
    readonly property int borderRadius: 24
    readonly property string font: "FiraCode Nerd Font"
    readonly property string iconFont: "Symbols Nerd font"
    readonly property string tempSensor: "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon5/temp1_input"
    readonly property string battery: "/sys/class/power_supply/BAT1"

    readonly property bool colorful: false
    
    readonly property color accent: "#cba6f7"

    readonly property color bgColor: "#006644"
    // readonly property color bgColor: Qt.darker("#1e1e2e", 1.1)
    readonly property color fgColor: '#cdd6f4'
    readonly property color red: '#f38ba8'
    readonly property color orange: '#d5ada5'
    readonly property color green: '#a6e2a1'

    readonly property color black: "#45475A"
    readonly property color yellow: "#F9E2AF"
    readonly property color blue: "#89B4FA"
    readonly property color magenta: "#F5C2E7"
    readonly property color cyan: "#94E2D5"
    readonly property color white: "#BAC2DE"
}