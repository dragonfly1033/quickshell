pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import "../singletons"

Item {
    id: root
    anchors.fill: parent

    required property real progress

    // Animated values driven by progress
    readonly property real animMargin: Scheme.borderThickness * progress
    readonly property real animRadius: Scheme.borderRadius * progress

    Rectangle {
        anchors.fill: parent
        color: Scheme.bgColor

        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource: borderMask
            maskEnabled: true
            maskInverted: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }
    }

    Item {
        id: borderMask
        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            anchors.fill: parent
            anchors.topMargin: root.animMargin
            anchors.bottomMargin: root.animMargin
            anchors.rightMargin: root.animMargin
            anchors.leftMargin: Scheme.barWidth * root.progress
            radius: root.animRadius
        }
    }
}
