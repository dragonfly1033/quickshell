import QtQuick
import "../singletons"

Column {
  id: root

  required property color bgColor
  required property color fgColor
  required property string font

  property int dateSize: 18

  Text {
      anchors.horizontalCenter: root.horizontalCenter
      text: DateProc.hour
      color: root.fgColor
      font.pixelSize: root.dateSize
      font.family: root.font
      transformOrigin: Item.Center
  }
  Text {
      anchors.horizontalCenter: root.horizontalCenter
      text: DateProc.min
      color: root.fgColor
      font.pixelSize: root.dateSize
      font.family: root.font
      transformOrigin: Item.Center
  }
}
