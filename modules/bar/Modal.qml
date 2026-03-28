pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import "../etc"

Scope {
    id: root

    required property var screen
    required property real progress
    property var _items: []
    property var _focusedItem: null
    readonly property bool open: _items.length > 0

    onOpenChanged: {
        if (!open) 
            closed() 
    }

    // Child interface — items passed to show() should implement:
    //
    //   function close()             (called by spawning widget)
    //     Begin the item's close animation. Should eventually emit closingDone.
    //     Modal itself never calls this — it is for the widget that opened the
    //     item (e.g. PowerMenu calling item.close() on cancel).
    //
    //   signal closingDone
    //     Emit when the item's close animation finishes. Modal will call
    //     _remove(), destroying the item and popping it from the stack.
    //     If absent, the item is never automatically removed — close() must
    //     be called on the modal to force-clear all items.
    //
    //   property bool requestFocus   (optional, default false)
    //     If true, modal takes exclusive keyboard focus while this item is the
    //     most recently focused item in the stack. The item is responsible for
    //     handling its own Escape / tap-to-dismiss behaviour.
    //
    //   background dimming rectangle   (optional)

    function show(component, props) {
        var item = component.createObject(contentLayer, props || {})
        var newItems = _items.slice()
        newItems.push(item)
        _items = newItems
        if (item.requestFocus ?? false) _focusedItem = item
        if ('closingDone' in item)
            item.closingDone.connect(function() { root._remove(item) })
        return item
    }

    function _remove(item) {
        var idx = _items.indexOf(item)
        if (idx < 0) return
        var newItems = _items.slice()
        newItems.splice(idx, 1)
        item.destroy()
        _items = newItems
        _focusedItem = null
        for (var i = _items.length - 1; i >= 0; i--) {
            if (_items[i].requestFocus) { _focusedItem = _items[i]; break }
        }
    }

    function close() {
        var snapshot = _items.slice()
        _focusedItem = null
        for (var i = 0; i < snapshot.length; i++) {
            snapshot[i].close()
        }
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
        WlrLayershell.keyboardFocus: root._focusedItem ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.OnDemand
        surfaceFormat.opaque: false

        mask: root._focusedItem ? null : contentMask

        Region {
            id: contentMask
            regions: inputRegions.instances
        }

        Variants {
            id: inputRegions
            model: root._items
            Region {
                required property Item modelData
                item: modelData
            }
        }

        Shortcut {
            sequence: "Escape"
            enabled: root.open && !root._focusedItem
            onActivated: root.close()
        }

        Item {
            id: contentLayer
            anchors.fill: parent
        }

        SpawnZones {
            id: modalSpawnZones
            anchors.fill: parent
            progress: root.progress
            show: false
        }
    }

    readonly property alias spawnZones: modalSpawnZones
}
