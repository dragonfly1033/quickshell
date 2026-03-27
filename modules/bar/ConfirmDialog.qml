pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import "../singletons"

Item {
    id: root
    anchors.fill: parent

    property real progress: 0
    property int size: 220
    property string action: ""

    property int animDuration: 220
    property int rippleFadeDuration: 900
    property int rippleOutDuration: 900

    readonly property bool contentHovered: hoverHandler.hovered

    signal confirmed
    signal cancelled
    signal closingDone

    property color _rippleColor: Scheme.bgColor
    property real _rippleProgress: 0

    Component.onCompleted: openAnim.restart()

    function close() {
        closeAnim.restart()
    }

    function splashClose() {
        rippleOutAnim.restart()
    }

    function doConfirm() {
        root.confirmed()
        root.splashClose()
    }

    focus: true
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            doConfirm()
            event.accepted = true
        }
    }

    NumberAnimation {
        id: openAnim
        target: root; property: "progress"
        from: 0; to: 1
        duration: root.animDuration
        easing.type: Easing.InOutCubic
    }

    NumberAnimation {
        id: closeAnim
        target: root; property: "progress"
        from: root.progress; to: 0
        duration: root.animDuration
        easing.type: Easing.InOutCubic
        onFinished: root.closingDone()
    }

    NumberAnimation {
        id: rippleOutAnim
        target: root; property: "_rippleProgress"
        from: 0; to: 1
        duration: root.rippleOutDuration
        easing.type: Easing.OutCubic
        onStarted: rippleFadeDelay.restart()
    }

    Timer {
        id: rippleFadeDelay
        interval: root.rippleOutDuration - root.rippleFadeDuration
        onTriggered: rippleFadeAnim.restart()
    }

    NumberAnimation {
        id: rippleFadeAnim
        target: root; property: "progress"
        from: root.progress; to: 0
        duration: root.rippleFadeDuration
        easing.type: Easing.OutCubic
        onFinished: root.closingDone()
    }

    Rectangle {
        anchors.centerIn: parent
        visible: root._rippleProgress > 0
        radius: width / 2
        color: Qt.darker(root._rippleColor, 1.2)
        opacity: root.progress

        readonly property real maxR: Math.max(root.width, root.height)
        width: root.size + maxR * root._rippleProgress
        height: width
    }

    Rectangle {
        id: circle
        anchors.centerIn: parent
        width: root.size
        height: root.size
        radius: width / 2
        color: hoverHandler.hovered
            ? Qt.lighter(Scheme.bgColor, 1.3)
            : Scheme.bgColor
        border.color: Scheme.accent
        border.width: 2
        opacity: root.progress
        scale: 0.88 + 0.12 * root.progress

        Behavior on color { ColorAnimation { duration: 150 } }

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.action
                color: Scheme.fgColor
                font.family: Scheme.font
                font.pixelSize: 20
                font.bold: true
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "↵  confirm"
                color: Qt.rgba(Scheme.fgColor.r, Scheme.fgColor.g, Scheme.fgColor.b, 0.4)
                font.family: Scheme.font
                font.pixelSize: 11
            }
        }

        HoverHandler { id: hoverHandler }
        TapHandler { onTapped: root.doConfirm(); }
    }
}
