// Mirrors another item's screen geometry into the current window's coordinate space.
// Works when source and target windows are both full-screen panel windows at (0,0).
// Bind `epoch` to any value that changes when the source's screen position changes
// (e.g. bar progress) so the x/y bindings re-evaluate.
import QtQuick

Item {
    id: va
    required property Item source
    property var epoch  // invalidation dependency — bind to bar progress etc.

    x: { epoch; source.mapToItem(null, 0, 0).x }
    y: { epoch; source.mapToItem(null, 0, 0).y }
    width: source.width
    height: source.height

    readonly property bool hovered: source.hovered ?? false
    signal tapped

    Connections {
        target: va.source
        ignoreUnknownSignals: true
        function onTapped() { va.tapped() }
    }
}
