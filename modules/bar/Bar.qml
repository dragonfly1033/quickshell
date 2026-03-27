import QtQuick
import Quickshell.Io
import "../singletons"
import "../etc"

Item {
    id: root

    required property real progress
    required property var screen
    required property var window
    required property SpawnZones spawnZones
    required property var modal

    property var popouts: [powerPopout,searchPopout]

    anchors.fill: parent

    Rectangle {
        id: rect

        x: Scheme.barWidth * (root.progress - 1.0)
        y: 0
        width: Scheme.barWidth
        height: parent.height
        color: Scheme.bgColor

        // ── Bar content goes here ─────────────────────────────────────────────
        Item {
            anchors.fill: parent

            // Bottom group
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                spacing: 10
                bottomPadding: spacing

                DateTime {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: root.width
                    bgColor: Scheme.bgColor
                    fgColor: Scheme.fgColor
                    font: Scheme.font
                }
              
                ProgCirc {
                    id: updates
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: root.width
                    progressColor: Scheme.colorful ? UpdateCountProc.progressColor : Scheme.accent
                    icon: UpdateCountProc.icon ?? Icons.unknown
                    iconRatio: 0.65
                    thickness: 2
                    bgColor: Scheme.bgColor
                    fgColor: Scheme.fgColor
                    size: Scheme.barWidth * 0.6
                    value: UpdateCountProc.ratio
                }

                Row {
                    id: statusBars
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: root.width
                    spacing: Scheme.barWidth * 0.1
                    leftPadding: (root.width - childrenRect.width) / 2

                    ProgNum {
                        progressColor: Scheme.colorful ? TempProc.progressColor : Scheme.accent
                        icon: Icons.fire
                        iconRatio: 0.8
                        bgColor: Scheme.bgColor
                        fgColor: Scheme.fgColor
                        barWidth: Scheme.barWidth * 0.245
                        barHeight: barWidth * 2.5 
                        fontSizeRatio: 0.65
                        label: TempProc.temp
                        value: TempProc.ratio
                    }

                    ProgNum {
                        progressColor: Scheme.colorful ? BatteryProc.progressColor : Scheme.accent
                        icon: BatteryProc.icon ?? Icons.unknown
                        iconRatio: 0.8
                        bgColor: Scheme.bgColor
                        fgColor: Scheme.fgColor
                        barWidth: Scheme.barWidth * 0.245
                        barHeight: barWidth * 2.5 
                        fontSizeRatio: 0.65
                        label: BatteryProc.level
                        value: BatteryProc.ratio
                    }

                    readonly property alias hovered: hover.hovered 
                    HoverHandler {
                        id: hover
                    }
                }

            }
        }




        

        
        
        // Popout {
        //     side: "left"
        //     mergeSide: "middle"
        //     anchor: root.spawnZones.leftMiddle
        //     open: true//root.spawnZones.leftMiddle.hovered 
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     side: "left"
        //     mergeSide: "top"
        //     anchor: root.spawnZones.leftTop
        //     open: true//root.spawnZones.leftTop.hovered 
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     side: "left"
        //     mergeSide: "bottom"
        //     anchor: root.spawnZones.leftBottom
        //     open: true//root.spawnZones.leftBottom.hovered 
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     side: "right"
        //     mergeSide: "middle"
        //     anchor: root.spawnZones.rightMiddle
        //     open: true//root.spawnZones.rightMiddle.hovered 
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     side: "right"
        //     mergeSide: "top"
        //     anchor: root.spawnZones.rightTop
        //     open: true//root.spawnZones.rightTop.hovered 
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     side: "right"
        //     mergeSide: "bottom"
        //     anchor: root.spawnZones.rightBottom
        //     open: true//root.spawnZones.rightBottom.hovered 
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     side: "top"
        //     mergeSide: "middle"
        //     anchor: root.spawnZones.topMiddle
        //     open: true//root.spawnZones.topMiddle.hovered 
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     side: "top"
        //     mergeSide: "left"
        //     anchor: root.spawnZones.topLeft
        //     open: true//root.spawnZones.topLeft.hovered 
        //     color: '#aaff0000'
        //     TestRectV {}
        // }
        // Popout {
        //     side: "top"
        //     mergeSide: "right"
        //     anchor: root.spawnZones.topRight
        //     open: true//root.spawnZones.topRight.hovered 
        //     color: '#aaff0000'
        //     TestRectV {}
        // }
        // Popout {
        //     side: "bottom"
        //     mergeSide: "middle"
        //     anchor: root.spawnZones.bottomMiddle
        //     open: true//root.spawnZones.bottomMiddle.hovered 
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     side: "bottom"
        //     mergeSide: "left"
        //     anchor: root.spawnZones.bottomLeft
        //     open: true//root.spawnZones.bottomLeft.hovered 
        //     color: '#aaff0000'
        //     TestRectV{}
        // }
        // Popout {
        //     side: "bottom"
        //     mergeSide: "right"
        //     anchor: root.spawnZones.bottomRight
        //     open: true//root.spawnZones.bottomRight.hovered 
        //     color: '#aaff0000'
        //     TestRectV {}
        // }

        // component TestRectH: Rectangle {
        //     color: '#4400ff00'
        //     width: 500
        //     height: 100
        // }
        // component TestRectV: Rectangle {
        //     color: '#4400ff00'
        //     width: 100
        //     height: 500
        // }
    }

    Popout {
        id: powerPopout
        side: "right"
        mergeSide: "bottom"
        anchor: root.spawnZones.rightBottom
        open: root.spawnZones.rightBottom.hovered || powerPopout.hovered
        color: Scheme.bgColor
        animDuration: 400

        PowerMenu {
            modal: root.modal
        }
    }

    Popout {
        id: searchPopout
        side: "bottom"
        mergeSide: "middle"
        anchor: root.spawnZones.bottomMiddle
        open: root.searchIpcOpen || root.spawnZones.bottomMiddle.hovered || searchPopout.hovered
        color: Scheme.bgColor
        animDuration: 400

        onDeactivated: root.searchIpcOpen = false

        PowerMenu {
            modal: root.modal
        }
    }

    property bool searchIpcOpen: false

    TapHandler {
        enabled: root.searchIpcOpen
        onTapped: root.searchIpcOpen = false
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.searchIpcOpen
        onActivated: root.searchIpcOpen = false
    }

    Binding {
        target: root.window.WlrLayershell
        property: "keyboardFocus"
        value: root.searchIpcOpen ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
        when: !root.modal.open
    }

    Connections {
        target: root.window
        enabled: root.searchIpcOpen
        function onActiveFocusChanged() {
            if (!root.window.activeFocus) root.searchIpcOpen = false
        }
    }

    IpcHandler {
        target: "search." + root.screen.name
        function toggle(): void { root.searchIpcOpen = !root.searchIpcOpen; }
        function show(): void   { root.searchIpcOpen = true; }
        function hide(): void   { root.searchIpcOpen = false; }
    }
}
