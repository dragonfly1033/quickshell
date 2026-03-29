pragma Singleton

import QtQuick
import "../types"

QtObject {
    readonly property Icon unknown: Icon {
        glyph: ""
        xOff: 0
        yOff: 0
        scale: 1
        rotation: 0
    }

    readonly property Icon hazard: Icon {
        glyph: ""
        xOff: 0
        yOff: -1
        scale: 1
        rotation: 0
    }

    readonly property Icon updates: Icon {
        glyph: "󰶡"//"󰦗"
        xOff: 0
        yOff: -1
        scale: 1
        rotation: 0
    }

    readonly property Icon batteryDischarging: Icon {
        glyph: "󰁿"
        xOff: 1
        yOff: -1
        scale: 1
        rotation: 0
    }
    readonly property Icon batteryCharging: Icon {
        glyph: "󱐋"
        xOff: 1
        yOff: -1
        scale: 1
        rotation: 0
    }
    readonly property Icon fire: Icon {
        glyph: "󰈸"
        xOff: 0
        yOff: -1
        scale: 1
        rotation: 0
    }
    readonly property Icon power: Icon {
        glyph: ""
        xOff: 0
        yOff: 0
        scale: 1
        rotation: 0
    }
    readonly property Icon reboot: Icon {
        glyph: ""
        xOff: 0
        yOff: 0
        scale: 1
        rotation: 0
    }
    readonly property Icon lock: Icon {
        glyph: ""
        xOff: 0
        yOff: 0
        scale: 1
        rotation: 0
    }
    readonly property Icon logout: Icon {
        glyph: "󰍃"
        xOff: 0
        yOff: 0
        scale: 1
        rotation: 0
    }

    readonly property Icon arch: Icon {
        glyph: "󰣇"
        xOff: 0
        yOff: 0
        scale: 1
        rotation: 0
    }
}
