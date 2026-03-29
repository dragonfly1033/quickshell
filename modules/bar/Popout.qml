import QtQuick
import QtQuick.Shapes
import Quickshell.Io
import "../singletons"

Item {
    id: root

    required property string side
    required property var anchor
    required property real progress
    property string mergeSide: "middle"
    property bool clipContents: false
    // When true, x stays fixed at the anchor's edge and only width animates.
    // Use for anchors that are inside the bar (not at the screen edge) so the
    // popout doesn't slide through the bar content during open/close.
    property bool growInPlace: false

    property int animDuration: 700
    property color color: Scheme.bgColor


    property bool open: (anchor.hovered || hovered) && !modalPopout

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
    property string name: ""
    property var modal: null
    property Item modalAnchor: null
    property Popout modalPopout: null
    
    property bool animateModalOpen: false
    property bool inModal: false
    Component.onCompleted: { if (animateModalOpen && inModal) open = true }


    // Tap the anchor zone → open on modal (only when modal is configured)
    Connections {
        target: root.anchor
        enabled: root.modal ? true : false
        function onTapped() { 
            if (root.modalPopout) root.modalPopout.close()
            else root.showOnModal(false)
        }
    }

    // IPC control (only active when name is set and modal is configured)
    IpcHandler {
        target: root.name
        enabled: root.modal ? true : false
        function show(): void   { root.showOnModal(true) }
        function hide(): void   { if (root.modalPopout) root.modalPopout.close() }
        function toggle(): void {
            if (root.modalPopout) root.modalPopout.close()
            else {
                root.showOnModal(true)
            }
        }
    }

    // Modal child contract
    property bool requestFocus: false
    signal closingDone
    function close() { open = false; _closeTimer.restart() }
    Timer { id: _closeTimer; interval: root.animDuration; onTriggered: root.closingDone() }

    // Creates a copy of this popout in the modal layer using modalAnchor.
    // Requires contentFactory and modal to be set.
    // A VirtualAnchor is created in modal.contentLayer to mirror the anchor's geometry —
    // this handles cross-window anchors (bar widgets) and same-window anchors alike,
    // since both windows are full-screen PanelWindows at (0,0).
    function showOnModal(animateModalOpen) {
        if (!modal) return
        var comp = Qt.createComponent(Qt.resolvedUrl("Popout.qml"))
        if (comp.status !== Component.Ready) return

        var effectiveAnchor = root.modalAnchor ?? root.anchor
        var vaComp = Qt.createComponent(Qt.resolvedUrl("../etc/VirtualAnchor.qml"))
        var virtualAnchor = vaComp.status === Component.Ready
            ? vaComp.createObject(modal.contentLayer, { source: effectiveAnchor, epoch: Qt.binding(function() { return root.progress }) })
            : effectiveAnchor

        var item = modal.show(comp, {
            progress: root.progress,
            side: root.side,
            mergeSide: root.mergeSide,
            color: root.color,
            animDuration: root.animDuration,
            anchor: virtualAnchor,
            contentFactory: root.contentFactory,
            growInPlace: root.growInPlace,
            clipContents: root.clipContents,
            inModal: true,
            open: !animateModalOpen,
            animateModalOpen: animateModalOpen,
        })
        item.progress = Qt.binding(function() { return root.progress })
        item.closingDone.connect(function() {
            root.modalPopout = null
            if (virtualAnchor !== effectiveAnchor) virtualAnchor.destroy()
        })
        modalPopout = item
    }

    // Stay visible while animating closed (width > 0 while shrinking)
    visible: !modalPopout && (open || width > 0)

    property real animatedBarWidth: Scheme.barWidth * progress
    property real animatedBorderThickness: Scheme.borderThickness * progress

    function lerp(a, b, t) { return a + t * (b - a) }

    x: {
        anchor.x; anchor.y; anchor.width; anchor.height; animatedBarWidth; animatedBorderThickness; openProgress
        if (side === "left")       return growInPlace
                                       ? anchor.mapToItem(parent, anchor.width, 0).x
                                       : lerp(-contentSize,          anchor.mapToItem(parent, anchor.width, 0).x,                  openProgress)
        if (side === "right")      return growInPlace
                                       ? anchor.mapToItem(parent, 0, 0).x - contentSize
                                       : lerp(Window.window.width,   anchor.mapToItem(parent, 0, 0).x - contentSize,               openProgress)
        if (mergeSide === "right") return lerp(Window.window.width,   Window.window.width - animatedBorderThickness - crossSize,    openProgress)
        if (mergeSide === "left")  return lerp(-crossSize,            animatedBarWidth,                                             openProgress)
        return anchor.mapToItem(parent, anchor.width / 2, 0).x - width / 2
    }
    y: {
        anchor.x; anchor.y; anchor.width; anchor.height; animatedBarWidth; animatedBorderThickness; openProgress
        if (side === "top")         return lerp(-contentSize,          anchor.y + anchor.height,                                    openProgress)
        if (side === "bottom")      return lerp(Window.window.height,  anchor.y - contentSize,                                      openProgress)
        if (mergeSide === "bottom") return lerp(Window.window.height,  Window.window.height - animatedBorderThickness - crossSize,  openProgress)
        if (mergeSide === "top")    return lerp(-crossSize,            animatedBorderThickness,                                     openProgress)
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

    readonly property real contentSize: horizontal
        ? (side === "left"
            ? container.childrenRect.width  + radialPadding //+ radius
            : container.childrenRect.width  + radialPadding*2 - animatedBorderThickness //+ radius
        )
        : container.childrenRect.height + radialPadding*2 - animatedBorderThickness //+ radius
    readonly property real crossSize: horizontal
        ? (mergeSide !== "middle"
            ? (mergeSide === "left"
                ? container.childrenRect.height + radialPadding
                : container.childrenRect.height + radialPadding*2 - animatedBorderThickness
            )
            : container.childrenRect.height + radialPadding*2
        )
        : (mergeSide !== "middle"
            ? (mergeSide === "left"
                ? container.childrenRect.width + radialPadding
                : container.childrenRect.width + radialPadding*2 - animatedBorderThickness
            )
            : container.childrenRect.width + radialPadding*2
        )

    property bool animateCross: false

    property real openProgress: open ? 1.0 : 0.0
    Behavior on openProgress {
        NumberAnimation { duration: root.animDuration; easing.type: Easing.InOutCubic }
    }

    readonly property real animatedCrossSize: animateCross
        ? lerp(startCrossSize, crossSize, openProgress)
        : crossSize

    width:  horizontal ? openProgress * contentSize : animatedCrossSize
    height: horizontal ? animatedCrossSize           : openProgress * contentSize

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
