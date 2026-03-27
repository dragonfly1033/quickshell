import Quickshell
import Quickshell.Wayland
import QtQuick
import "../singletons"

Scope {
    id: root
    
    required property var screen
    required property real progress
    required property bool visible

    PanelWindow {
        screen: root.screen
        anchors.left: true
        exclusiveZone: Scheme.barWidth * (root.progress == 1)
        implicitWidth: 1; implicitHeight: 1
        color: "transparent"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        mask: Region {}
        visible: root.visible
    }

    PanelWindow {
        screen: root.screen
        anchors.right: true
        exclusiveZone: Scheme.borderThickness * root.progress
        implicitWidth: 1; implicitHeight: 1
        color: "transparent"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        mask: Region {}
        visible: root.visible
    }

    PanelWindow {
        screen: root.screen
        anchors.top: true
        exclusiveZone: Scheme.borderThickness * root.progress
        implicitWidth: 1; implicitHeight: 1
        color: "transparent"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        mask: Region {}
        visible: root.visible
    }

    PanelWindow {
        screen: root.screen
        anchors.bottom: true
        exclusiveZone: Scheme.borderThickness * root.progress
        implicitWidth: 1; implicitHeight: 1
        color: "transparent"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        mask: Region {}
        visible: root.visible
    }
}
