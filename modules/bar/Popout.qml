import QtQuick
import QtQuick.Shapes
import "../singletons"

Item {
    id: root

    required property string side
    required property Item anchor
    property string mergeSide: "middle"
    property bool clipContents: false

    property int animDuration: 700
    property color color: Scheme.bgColor

    property bool open: false

    function activate():   void { open = true  }
    function deactivate(): void { open = false }
    function toggle():     void { open = !open }

    signal activated
    signal deactivated
    onOpenChanged: open ? activated() : deactivated()

    readonly property alias hovered: popoutHover.hovered
    HoverHandler { id: popoutHover }

    // Children declared inside Popout { ... } are reparented into the container
    default property alias content: container.data
    // Alternative: set contentFactory to a Component — it will be loaded into the container.
    // Use this when the popout also needs to be shown on the modal layer (showOnModal).
    property Component contentFactory: null

    // Modal support
    property var modal: null
    property Item modalAnchor: null
    property Popout modalPopout: null
    
    property bool animateModalOpen: false
    property bool inModal: false
    Component.onCompleted: { if (animateModalOpen && inModal) open = true }


    // Modal child contract
    property bool requestFocus: false
    signal closingDone
    function close() { open = false; _closeTimer.restart() }
    Timer { id: _closeTimer; interval: root.animDuration; onTriggered: root.closingDone() }

    // Creates a copy of this popout in the modal layer using modalAnchor.
    // Requires contentFactory and modal to be set.
    function showOnModal() {
        if (!modal) return
        var comp = Qt.createComponent(Qt.resolvedUrl("Popout.qml"))
        if (comp.status !== Component.Ready) return
        var item = modal.show(comp, {
            side: root.side,
            mergeSide: root.mergeSide,
            color: root.color,
            animDuration: root.animDuration,
            anchor: root.modalAnchor ?? root.anchor,
            contentFactory: root.contentFactory,
            inModal: true,
            open: !root.animateModalOpen,
            animateModalOpen: root.animateModalOpen,
        })
        item.closingDone.connect(function() { root.modalPopout = null })
        modalPopout = item
    }

    // Stay visible while animating closed (width > 0 while shrinking)
    visible: open || width > 0

    x: {
        anchor.x; anchor.y; anchor.width; anchor.height
        if (side === "left")  return anchor.mapToItem(parent, anchor.width, 0).x
        if (side === "right") return anchor.mapToItem(parent, 0, 0).x - width
        if (mergeSide === "right") return Window.window.width - Scheme.borderThickness - width
        if (mergeSide === "left")   return Scheme.barWidth
        return anchor.mapToItem(parent, anchor.width / 2, 0).x - width / 2
    }
    y: {
        anchor.x; anchor.y; anchor.width; anchor.height
        if (side === "top")    return anchor.y+anchor.height
        if (side === "bottom") return anchor.y-height
        if (mergeSide === "bottom") return Window.window.height - Scheme.borderThickness - height
        if (mergeSide === "top")   return Scheme.borderThickness
        return anchor.mapToItem(parent, 0, anchor.height / 2).y - height / 2
    }

    readonly property bool horizontal: side === "left" || side === "right"

    readonly property string position: {
        let ms = root.mergeSide === "middle" ? "" : root.mergeSide
        let name = root.side + ms;
        if (name === "lefttop") { name = "topleft"; }
        else if (name === "righttop") { name = "topright"; }
        else if (name === "leftbottom") { name = "bottomleft"; }
        else if (name === "rightbottom") { name = "bottomright"; }
        return name;
    }

    readonly property real startCrossSize: horizontal ? anchor.height : anchor.width
    readonly property real startContentSize: 0

    property int radius: Math.min(Scheme.borderRadius, Math.min(container.childrenRect.width, container.childrenRect.height) / Math.sqrt(2))

    readonly property real radialPadding: radius * (2 - Math.sqrt(2)) / 2

    // readonly property real mergeExtra: mergeSide === "left" ? 

    readonly property real contentSize: horizontal
        ? (side === "left" 
            ? container.childrenRect.width  + radialPadding //+ radius
            : container.childrenRect.width  + radialPadding*2 - Scheme.borderThickness //+ radius
        )
        : container.childrenRect.height + radialPadding*2 - Scheme.borderThickness //+ radius
    readonly property real crossSize: horizontal
        ? (mergeSide !== "middle" 
            ? (mergeSide === "left"
                ? container.childrenRect.height + radialPadding
                : container.childrenRect.height + radialPadding*2 - Scheme.borderThickness
            )
            : container.childrenRect.height + radialPadding*2
        )
        : (mergeSide !== "middle" 
            ? (mergeSide === "left"
                ? container.childrenRect.width + radialPadding
                : container.childrenRect.width + radialPadding*2 - Scheme.borderThickness
            )
            : container.childrenRect.width + radialPadding*2
        )

    readonly property real animatedContentSize: open ? contentSize : startContentSize
    readonly property real animatedCrossSize: open ? crossSize : startCrossSize

    width:  horizontal ? animatedContentSize : animatedCrossSize
    height: horizontal ? animatedCrossSize : animatedContentSize

    Behavior on width  {
        NumberAnimation {
            duration: root.animDuration
            easing.type: Easing.InOutCubic
        }
    }
    Behavior on height {
        NumberAnimation {
            duration: root.animDuration
            easing.type: Easing.InOutCubic
        }
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            id: sp
            fillColor: root.color
            strokeWidth: -1

            readonly property real r: root.horizontal? Math.min(root.radius, root.width / 2) : Math.min(root.radius, root.height / 2)
            readonly property real w: root.width
            readonly property real h: root.height

            readonly property string position: root.position

            readonly property real dx: w - r * 2
            readonly property real dy: h - r * 2

            startX: position === "bottomright" || 
                    position === "right" ? sp.w :
                    position === "top" || 
                    position === "bottom" || 
                    position === "topright" ? -sp.r : 0 

            startY: position === "bottom" ? sp.h : 
                    position === "top" || 
                    position === "topleft" || 
                    position === "topright" ? 0 : -sp.r

            PathArc {
                relativeX: sp.position === "topleft" ? 0 :  
                        sp.position === "right" || 
                        sp.position === "bottomright" ? -sp.r : sp.r 
                relativeY: sp.position === "topleft" ? 0 :
                        sp.position === "bottom" ? -sp.r : sp.r
                radiusX: sp.r
                radiusY: sp.r
                direction: sp.position === "left" || 
                        sp.position === "bottom" || 
                        sp.position === "bottomleft" ? PathArc.Counterclockwise : PathArc.Clockwise
            }
            PathLine {
                relativeX: sp.position === "left" ||
                        sp.position === "bottomleft" ? sp.dx :
                        sp.position === "topleft" ? sp.dx + 3*sp.r :
                        sp.position === "right" ||
                        sp.position === "bottomright" ? -sp.dx : 0
                relativeY: sp.position === "bottom" ? -sp.dy :
                        sp.position === "top" ||
                        sp.position === "topright" ? sp.dy : 0
            }
            PathArc {
                relativeX: sp.position === "topleft" || 
                        sp.position === "right" || 
                        sp.position === "bottomright" ? -sp.r : sp.r 
                relativeY: sp.position === "bottom" ? -sp.r : sp.r
                radiusX: sp.r
                radiusY: sp.r
                direction: sp.position === "topleft" || 
                        sp.position === "topright" || 
                        sp.position === "top" || 
                        sp.position === "right" || 
                        sp.position === "bottomright" ? PathArc.Counterclockwise : PathArc.Clockwise
            }
            PathLine {
                relativeX: sp.position === "top" ||
                        sp.position === "bottom" ||
                        sp.position === "topright" ? sp.dx : 0
                relativeY: sp.position === "top" ||
                        sp.position === "bottom" ||
                        sp.position === "topright" ? 0 : sp.dy
            }
            PathArc {
                relativeX: sp.position === "left" || 
                        sp.position === "topleft" || 
                        sp.position === "bottomright" ? -sp.r : sp.r 
                relativeY: sp.position === "top" ? -sp.r : sp.r
                radiusX: sp.r
                radiusY: sp.r
                direction: sp.position === "top" || 
                        sp.position === "right" || 
                        sp.position === "bottomleft" ? PathArc.Counterclockwise : PathArc.Clockwise
            }
            PathLine {
                relativeX: sp.position === "bottomright" ? sp.dx + 3*sp.r :
                        sp.position === "bottomleft" ? -(sp.dx + 3*sp.r) :
                        sp.position === "right" ? sp.dx :
                        sp.position === "left" ||
                        sp.position === "topleft" ? -sp.dx : 0
                relativeY: sp.position === "topright" ? -(sp.dy + 3*sp.r) : 
                        sp.position === "top" ? -sp.dy :
                        sp.position === "bottom" ? sp.dy : 0
            }
            PathArc {
                relativeX: sp.position === "left" || 
                        sp.position === "topleft" ? -sp.r :
                        sp.position === "top" ||
                        sp.position === "right" ||
                        sp.position === "bottom" ? sp.r : 0
                relativeY: sp.position === "top" ? -sp.r :
                        sp.position === "topright" ||
                        sp.position === "bottomright" ||
                        sp.position === "bottomleft" ? 0: sp.r
                radiusX: sp.r
                radiusY: sp.r
                direction: sp.position === "left" || 
                        sp.position === "topleft" || 
                        sp.position === "bottom" ? PathArc.Counterclockwise : PathArc.Clockwise
            }
            PathLine {
                relativeX: sp.position === "top" ||
                        sp.position === "bottom" ? -(sp.dx + 2*sp.r) :
                        sp.position === "topright" ? -(sp.dx + sp.r) : 0
                relativeY: sp.position === "left" || 
                        sp.position === "right" ? -(sp.dy + 2*sp.r) : 
                        sp.position === "topleft" ||
                        sp.position === "bottomleft" ||
                        sp.position === "bottomright" ? -(sp.dy + 3*sp.r) : 0
            }
        }
    }

    Item {
        anchors.fill: parent
        clip: root.clipContents

        // Rectangle {
        //     anchors.fill: parent
        //     color: '#00dd00'
        // }

        Item {
            id: container
            Loader { sourceComponent: root.contentFactory }
            x: root.side === "left"   ? root.width - childrenRect.width - root.radialPadding
             : root.side === "right"  ? root.radialPadding
             : (root.side === "top" && root.mergeSide === "right") 
              || (root.side === "bottom" && root.mergeSide === "right")  
                ? root.radialPadding//(root.width - childrenRect.width) 
             : (root.side === "top" && root.mergeSide === "left") 
              || (root.side === "bottom" && root.mergeSide === "left")  
                ? root.width - childrenRect.width - root.radialPadding 
             : (root.width - childrenRect.width) / 2
            y: root.side === "top"    ? root.height - childrenRect.height - root.radialPadding
             : root.side === "bottom" ? root.radialPadding
             : (root.side === "left" && root.mergeSide === "bottom") 
              || (root.side === "right" && root.mergeSide === "bottom")  
                ? root.radialPadding//(root.height - childrenRect.height)
             : (root.side === "left" && root.mergeSide === "top") 
              || (root.side === "right" && root.mergeSide === "top")  
                ? root.height - childrenRect.height - root.radialPadding 
             : (root.height - childrenRect.height) / 2
        }
    }
}
