pragma ComponentBehavior: Bound
import QtQuick
import "../singletons"

Rectangle {
    id: root

    required property string position
    property bool show: false

    readonly property alias hovered: hover.hovered
    signal tapped

    opacity: show ? 1 : 0
    color: "#ff0000"

    anchors.left: (
        position === "leftTop" || 
        position === "topLeft" || 
        position === "bottomLeft" || 
        position === "leftMiddle" || 
        position === "leftBottom"
    ) ? parent.left : undefined 

    anchors.right: (
        position === "rightTop" || 
        position === "topRight" || 
        position === "bottomRight" || 
        position === "rightMiddle" || 
        position === "rightBottom"
    ) ? parent.right : undefined 
    
    anchors.top: (
        position === "topLeft" || 
        position === "leftTop" || 
        position === "rightTop" || 
        position === "topMiddle" || 
        position === "topRight"
    ) ? parent.top : undefined 

    anchors.bottom: (
        position === "bottomLeft" || 
        position === "leftBottom" || 
        position === "rightBottom" || 
        position === "bottomMiddle" || 
        position === "bottomRight"
    ) ? parent.bottom : undefined 

    anchors.horizontalCenter: (
        position === "bottomMiddle" || 
        position === "topMiddle"
    ) ? parent.horizontalCenter : undefined 

    anchors.verticalCenter: (
        position === "leftMiddle" || 
        position === "rightMiddle"
    ) ? parent.verticalCenter : undefined 

    anchors.leftMargin: (
        position === "topLeft" || 
        position === "bottomLeft" 
    ) ? Scheme.barWidth : 0

    HoverHandler { id: hover }
    TapHandler { onTapped: root.tapped() }
}
