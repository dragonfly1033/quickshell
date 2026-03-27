pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick

Scope {
    id: root

    required property var screen
    property var _currentItem: null
    property real _backdropProgress: _currentItem ? _currentItem.progress : 0
    readonly property bool open: _backdropProgress > 0.001
    readonly property bool _contentHovered: _currentItem ? (_currentItem.contentHovered ?? false) : false

    function show(component, props) {
        if (_currentItem) _currentItem.destroy()
        _currentItem = component.createObject(contentLayer, props || {})
        if ('closingDone' in _currentItem)
            _currentItem.closingDone.connect(root.cleanup)
        return _currentItem
    }

    function close() {
        if (_currentItem)
            _currentItem.close()
    }

    function cleanup() {
        if (_currentItem) {
            _currentItem.destroy()
            _currentItem = null
        }
        closed()
    }

    signal closed

    PanelWindow {
        id: win
        screen: root.screen
        visible: root.open

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

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.55 * root._backdropProgress)

            TapHandler {
                onTapped: if (!root._contentHovered) root.close()
            }
        }

        Item {
            id: contentLayer
            anchors.fill: parent
        }
    }
}
