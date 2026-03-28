import QtQuick
import "../types"
import "../singletons"

Item {
    id: root

    property Icon icon: Icons.unknown
    property var modal: null

    property int size: Scheme.barWidth * 0.7
    width: size
    height: size

    readonly property alias hovered: hover.hovered

    Rectangle {
        anchors.fill: parent
        radius: width/4
        color: root.hovered ? Qt.lighter(Scheme.bgColor, 3) : Qt.lighter(Scheme.bgColor, 2)

        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        Text {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: root.icon.xOff
            anchors.verticalCenterOffset: root.icon.yOff
            text: root.icon.glyph
            font.family: Scheme.iconFont
            font.pixelSize: root.size * 0.5 * root.icon.scale
            color: Scheme.fgColor
            rotation: root.icon.rotation
        }
    }

    HoverHandler { id: hover }
    TapHandler { onTapped: root.modal.close() }
}
