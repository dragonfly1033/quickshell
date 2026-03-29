import QtQuick
import QtQuick.Effects
import "../singletons"
import "../types"

Item {
    id: root 

    required property color progressColor
    required property color bgColor
    required property color fgColor
    required property Icon icon
    property int animationTime: 1000
    property int barWidth: Scheme.barWidth * 0.6
    property int barHeight: barWidth * 2
    property real fontSizeRatio: 0.5
    property real iconRatio: 0.5
    property real iconPadding: 2
    property real iconHeight: width * iconRatio + iconPadding * 2


    width: barWidth
    height: barHeight + iconHeight

    property int radius: width / 2

    property real value: 0
    property string label: ""
    onValueChanged: fill.animValue = value

    Rectangle {
        id: full
        anchors.fill: parent
        color: Qt.lighter(root.bgColor, 3)
        radius: root.radius
        layer.enabled: true
        layer.smooth: true
    }

    Item {
        id: icon
        anchors.fill: full
        visible: false

        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: root.width * root.iconRatio + root.iconHeight
            color: Qt.lighter(root.bgColor, 3)

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: root.icon.xOff
                y: root.iconPadding + root.icon.yOff + 1
                text: root.icon.glyph
                color: root.fgColor
                font.family: Scheme.iconFont
                font.pixelSize: root.width * root.iconRatio * root.icon.scale
                rotation: root.icon.rotation
            }
        }
    }

    MultiEffect {
        anchors.fill: full
        maskEnabled: true
        source: icon
        maskSource: full
        maskThresholdMin: 0.5
        maskSpreadAtMin: 1.0
    }

    Item {
        id: bar
        width: root.barWidth
        height: root.barHeight
        anchors.bottom: parent.bottom

        Rectangle {
            id: bg
            anchors.fill: parent
            color: Qt.lighter(root.bgColor, 2)
            radius: root.radius
            layer.enabled: true
            layer.smooth: true
        }

        Item {
            id: fill
            anchors.fill: bg
            visible: false

            property real animValue: 0
            Behavior on animValue {
                NumberAnimation { duration: root.animationTime; easing.type: Easing.InOutCubic }
            }

            Rectangle {
                id: fillLine
                anchors.bottom: parent.bottom
                height: parent.animValue * parent.height
                color: root.progressColor
                width: parent.width
            }
        }

        MultiEffect {
            anchors.fill: bg
            maskEnabled: true
            source: fill
            maskSource: bg
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }

        Text {
            id: label
            anchors.horizontalCenter: parent.horizontalCenter

            property real fillTop: bar.height * (1 - fill.animValue)
            // property bool flipped: fillTop < (height + gap + 1)
            property bool flipped: fill.animValue > 0.5
            property int gap: 2
            
            y: flipped ? fillTop + gap : fillTop - height// - gap
            color: flipped ? root.bgColor : root.fgColor
            
            text: root.label
            font.family: Scheme.font
            font.pixelSize: bar.width * root.fontSizeRatio
            font.bold: true
            antialiasing: true
        }
    }    
}
