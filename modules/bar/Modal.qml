pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import "../singletons"

Scope {
    id: root

    required property var screen
    property bool open: _progress > 0.001
    property int animDuration: 220
    property int rippleAnimDuration: 1000
    property int rippleFadeDuration: 900

    property var _currentItem: null
    property color _rippleColor: Scheme.accent

    function show(component, props) {
        if (_currentItem) _currentItem.destroy()
        _currentItem = component.createObject(contentHolder, props || {})
        normalOpenAnim.restart()
        return _currentItem
    }

    function close() {
        normalCloseAnim.restart()
    }

    function splashClose(color) {
        root._rippleColor = color
        rippleAnim.restart()
        rippleFadeDelay.restart()
    }

    function cleanup() {
        if (_currentItem) {
            _currentItem.destroy()
            _currentItem = null
        }
        closed()
    }

    signal closed

    Timer {
        id: rippleFadeDelay
        interval: root.rippleAnimDuration - root.rippleFadeDuration
        onTriggered: rippleFadeAnim.restart()
    }

    property real _progress: 0.0

    NumberAnimation {
        id: normalOpenAnim
        target: root; property: "_progress"
        from: root._progress; to: 1
        duration: root.animDuration
        easing.type: Easing.InOutCubic
    }

    NumberAnimation {
        id: normalCloseAnim
        target: root; property: "_progress"
        from: root._progress; to: 0
        duration: root.animDuration
        easing.type: Easing.InOutCubic
        onFinished: root.cleanup()
    }

    NumberAnimation {
        id: rippleFadeAnim
        target: root; property: "_progress"
        from: root._progress; to: 0
        duration: root.rippleFadeDuration
        easing.type: Easing.OutCubic
        onFinished: root.cleanup()
    }

    property real _rippleProgress: 0
    NumberAnimation {
        id: rippleAnim
        target: root; property: "_rippleProgress"
        from: 0; to: 1
        duration: root.rippleAnimDuration
        easing.type: Easing.OutCubic
        onFinished: root._rippleProgress = 0
    }

    PanelWindow {
        id: win
        screen: root.screen
        visible: root._progress > 0.001 || root._rippleProgress > 0

        anchors.top: true
        anchors.bottom: true
        anchors.left: true
        anchors.right: true

        color: "transparent"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: root.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
        surfaceFormat.opaque: false

        Shortcut {
            sequence: "Escape"
            enabled: root.open
            onActivated: root.close()
        }

        // Dark backdrop
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.55 * root._progress)

            TapHandler {
                onTapped: root.close()
            }
        }

        // Ripple
        Rectangle {
            anchors.centerIn: parent
            visible: root._rippleProgress > 0
            radius: width / 2
            color: Qt.darker(Scheme.bgColor, 1.2)

            readonly property real maxR: Math.max(win.width, win.height)
            width: 220 + maxR * root._rippleProgress
            height: width
            opacity: root._progress
        }

        // Centered card
        Rectangle {
            anchors.centerIn: parent
            color: "transparent"
            radius: Scheme.borderRadius
            width: contentHolder.width + 40
            height: contentHolder.height + 32

            opacity: root._progress
            scale: 0.88 + 0.12 * root._progress

            TapHandler {}

            Item {
                id: contentHolder
                x: 20; y: 16
                implicitWidth: childrenRect.width
                implicitHeight: childrenRect.height
                width: implicitWidth
                height: implicitHeight
            }
        }
    }
}
