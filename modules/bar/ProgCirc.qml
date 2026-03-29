import QtQuick
import "../types"
import "../singletons"

Item {
    id: root
    required property color progressColor 
    required property color bgColor
    required property color fgColor
    required property int size
    property real iconRatio: 0.8
    property real value: 0
    property int thickness: 3
    property int animationTime: 1000
    property Icon icon: null
    property string text: ""
    width: size
    height: size

    onValueChanged: c.ratio = value

    Canvas {
        id: c
        property real ratio: 0

        anchors.fill: parent
        antialiasing: true
        onRatioChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d");

            var cx = root.width / 2;
            var cy = root.height / 2;

            var radius = root.size / 2
            var startAngle = -Math.PI / 2;
            var progressAngle = -Math.PI / 2 + 2 * Math.PI * ratio;

            ctx.reset()

            ctx.fillStyle = root.progressColor;
            ctx.beginPath();
            ctx.moveTo(cx, cy);
            ctx.arc(cx, cy, radius, startAngle, progressAngle);
            ctx.lineTo(cx, cy);
            ctx.fill();
            ctx.fillStyle = root.bgColor;
            ctx.beginPath();
            ctx.moveTo(cx, cy);
            ctx.arc(cx, cy, radius-root.thickness, startAngle, startAngle+Math.PI*2);
            ctx.lineTo(cx, cy);
            ctx.fill();

        }

        Behavior on ratio {
            NumberAnimation {
                duration: root.animationTime
            }
        }
    }

    Text {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: root.icon ? root.icon.xOff : 0
        anchors.verticalCenterOffset: root.icon ? root.icon.yOff : 0
        text: root.icon ? root.icon.glyph : root.text
        color: root.fgColor
        font.family: root.icon ? Scheme.iconFont : Scheme.font
        font.pixelSize: root.size * root.iconRatio * (root.icon ? root.icon.scale : 1.0)
        rotation: root.icon ? root.icon.rotation : 0
    }
}