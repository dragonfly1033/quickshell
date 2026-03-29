import QtQuick
import "../types"
import "../singletons"

Item {
    id: root 
    
    required property real iconRatio 
    required property real size 
    property Icon icon: Icons.arch 

    width: size
    height: size
    
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: root.icon.xOff
        anchors.verticalCenterOffset: root.icon.yOff
        text: root.icon.glyph
        color: Scheme.fgColor
        font.family: Scheme.iconFont
        font.pixelSize: root.iconRatio * root.size * root.icon.scale
        rotation: root.icon.rotation

    }
}
