pragma ComponentBehavior: Bound
import QtQuick
import "../singletons"
import "../etc"
import "../types"

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

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                spacing: 10
                topPadding: spacing

                Logo {
                    anchors.horizontalCenter: parent.horizontalCenter
                    iconRatio: 1
                    size: Scheme.barWidth * 0.55
                }
            }

            // Bottom group
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                spacing: 10
                bottomPadding: spacing

                DateTime {
                    id: time
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: root.width
                    bgColor: Scheme.bgColor
                    fgColor: Scheme.fgColor
                    font: Scheme.font

                    readonly property alias hovered: timeHover.hovered
                    HoverHandler {id: timeHover}
                }

                HideModalButton {
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: root.modal.open
                    modal: root.modal
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
                        progressColor: Scheme.colorful ? UpdateCountProc.progressColor : Scheme.accent
                        icon: UpdateCountProc.icon ?? Icons.unknown
                        iconRatio: 0.8
                        bgColor: Scheme.bgColor
                        fgColor: Scheme.fgColor
                        barWidth: Scheme.barWidth * 0.245
                        barHeight: barWidth * 2.5 
                        fontSizeRatio: 0.65
                        label: UpdateCountProc.count
                        value: UpdateCountProc.ratio
                    }

                    readonly property alias hovered: statusHover.hovered 
                    HoverHandler {
                        id: statusHover
                    }
                }

                ProgNum {
                    id: battery
                    anchors.horizontalCenter: parent.horizontalCenter
                    progressColor: Scheme.colorful ? BatteryProc.progressColor : Scheme.accent
                    icon: BatteryProc.icon ?? Icons.unknown
                    iconRatio: 0.4
                    bgColor: Scheme.bgColor
                    fgColor: Scheme.fgColor
                    barWidth: Scheme.barWidth * 0.55
                    barHeight: barWidth * 1.5
                    radius: 6
                    fontSizeRatio: 0.4
                    label: BatteryProc.level
                    value: BatteryProc.ratio
                }
            }
        }




        

        
        
        // Popout {
        //     progress: root.progress
        //     side: "left"
        //     mergeSide: "middle"
        //     anchor: root.spawnZones.leftMiddle
        //     //open: true
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     progress: root.progress
        //     side: "left"
        //     mergeSide: "top"
        //     anchor: root.spawnZones.leftTop
        //     //open: true
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     progress: root.progress
        //     side: "left"
        //     mergeSide: "bottom"
        //     anchor: root.spawnZones.leftBottom
        //     //open: true
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     progress: root.progress
        //     side: "right"
        //     mergeSide: "middle"
        //     anchor: root.spawnZones.rightMiddle
        //     //open: true
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     progress: root.progress
        //     side: "right"
        //     mergeSide: "top"
        //     anchor: root.spawnZones.rightTop
        //     //open: true
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     progress: root.progress
        //     side: "right"
        //     mergeSide: "bottom"
        //     anchor: root.spawnZones.rightBottom
        //     //open: true
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     progress: root.progress
        //     side: "top"
        //     mergeSide: "middle"
        //     anchor: root.spawnZones.topMiddle
        //     //open: true
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     progress: root.progress
        //     side: "top"
        //     mergeSide: "left"
        //     anchor: root.spawnZones.topLeft
        //     //open: true
        //     color: '#aaff0000'
        //     TestRectV {}
        // }
        // Popout {
        //     progress: root.progress
        //     side: "top"
        //     mergeSide: "right"
        //     anchor: root.spawnZones.topRight
        //     //open: true
        //     color: '#aaff0000'
        //     TestRectV {}
        // }
        // Popout {
        //     progress: root.progress
        //     side: "bottom"
        //     mergeSide: "middle"
        //     anchor: root.spawnZones.bottomMiddle
        //     //open: true
        //     color: '#aaff0000'
        //     TestRectH {}
        // }
        // Popout {
        //     progress: root.progress
        //     side: "bottom"
        //     mergeSide: "left"
        //     anchor: root.spawnZones.bottomLeft
        //     //open: true
        //     color: '#aaff0000'
        //     TestRectV{}
        // }
        // Popout {
        //     progress: root.progress
        //     side: "bottom"
        //     mergeSide: "right"
        //     anchor: root.spawnZones.bottomRight
        //     //open: true
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

    // Popout {
    //     id: datePopout
    //     progress: root.progress
    //     side: "left"
    //     anchor: time
    //     color: Scheme.bgColor
    //     animDuration: 400

    //     name: "date." + root.screen.name
    //     modal: root.modal
    //     modalAnchor: time // but in modal????
    //     contentFactory: Component {
    //         Text {
    //             text: {
    //                 return DateProc.hour + ":" + 
    //                 DateProc.min + " " + 
    //                 DateProc.day + " " + 
    //                 DateProc.date + " " + 
    //                 DateProc.month
    //             }
    //             color: Scheme.fgColor
    //             font.pixelSize: 18
    //             font.family: Scheme.font
    //             transformOrigin: Item.Center
    //         }
    //     }
    // }

    Popout {
        id: powerPopout
        progress: root.progress
        side: "right"
        mergeSide: "bottom"
        anchor: root.spawnZones.rightBottom
        color: Scheme.bgColor
        animDuration: 400

        name: "power." + root.screen.name
        modal: root.modal
        modalAnchor: root.modal.spawnZones.rightBottom
        contentFactory: Component { PowerMenu { modal: root.modal } }
    }

    Popout {
        id: searchPopout
        progress: root.progress
        side: "bottom"
        mergeSide: "middle"
        anchor: root.spawnZones.bottomMiddle
        color: Scheme.bgColor
        animDuration: 400
        clipContents: false

        name: "search." + root.screen.name
        modal: root.modal
        modalAnchor: root.modal.spawnZones.bottomMiddle
        contentFactory: Component { PowerMenu { modal: root.modal } }
    }
}
