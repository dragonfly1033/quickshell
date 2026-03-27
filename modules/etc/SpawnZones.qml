pragma ComponentBehavior: Bound
import QtQuick
import "../singletons"

Item {
    id: root

    required property real progress
    property bool show: false

    readonly property alias rightMiddle:  rightMiddle
    readonly property alias rightBottom:  rightBottom
    readonly property alias rightTop:     rightTop
    readonly property alias leftMiddle:   leftMiddle
    readonly property alias leftTop:      leftTop
    readonly property alias leftBottom:      leftBottom
    readonly property alias topMiddle:    topMiddle
    readonly property alias topRight:     topRight
    readonly property alias topLeft:      topLeft
    readonly property alias bottomMiddle: bottomMiddle
    readonly property alias bottomLeft:   bottomLeft
    readonly property alias bottomRight:   bottomRight

    SpawnZone { 
        id: rightMiddle  
        position: "rightMiddle"  
        show: root.show 
        width: Scheme.borderThickness * root.progress 
        height: 300 
        color: '#99ff0000'
    }

    SpawnZone { 
        id: rightBottom  
        position: "rightBottom"  
        show: root.show 
        width: Scheme.borderThickness * root.progress 
        height: 75 
        color: '#99ff0000'
    }

    SpawnZone { 
        id: rightTop     
        position: "rightTop"     
        show: root.show 
        width: Scheme.borderThickness * root.progress 
        height: 75 
        color: '#99ff0000'
    }

    SpawnZone { 
        id: leftMiddle   
        position: "leftMiddle"   
        show: root.show 
        width: Scheme.barWidth * root.progress        
        height: 250 
        color: '#9900ff00'
    }

    SpawnZone { 
        id: leftTop      
        position: "leftTop"      
        show: root.show 
        width: Scheme.barWidth * root.progress        
        height: 75 
        color: '#9900ff00'
    }

    SpawnZone { 
        id: leftBottom      
        position: "leftBottom"      
        show: root.show 
        width: Scheme.barWidth * root.progress        
        height: 75 
        color: '#9900ff00'
    }

    SpawnZone { 
        id: topMiddle    
        position: "topMiddle"    
        show: root.show 
        width: 300                    
        height: Scheme.borderThickness * root.progress 
        color: '#990000ff'
    }

    SpawnZone { 
        id: topRight     
        position: "topRight"     
        show: root.show 
        width: 75                     
        height: Scheme.borderThickness * root.progress 
        color: '#990000ff'
    }

    SpawnZone { 
        id: topLeft      
        position: "topLeft"      
        show: root.show 
        width: 75                     
        height: Scheme.borderThickness * root.progress 
        color: '#990000ff'
    }

    SpawnZone { 
        id: bottomMiddle 
        position: "bottomMiddle" 
        show: root.show 
        width: 300                    
        height: Scheme.borderThickness * root.progress 
        color: '#99ffff00'
    }

    SpawnZone { 
        id: bottomLeft   
        position: "bottomLeft"   
        show: root.show 
        width: 75                     
        height: Scheme.borderThickness * root.progress 
        color: '#99ffff00'
    }

    SpawnZone { 
        id: bottomRight     
        position: "bottomRight"     
        show: root.show 
        width: 75                     
        height: Scheme.borderThickness * root.progress 
        color: '#990000ff'
        visible: false
    }

}
