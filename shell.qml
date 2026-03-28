pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import "modules/etc"
import "modules/bar"
import "modules/singletons"

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        Scope {
            id: perScreen

            property alias shown: persist.shown
            property alias progress: persist.progress
            property alias reserveSpace: persist.reserveSpace
            PersistentProperties {
                id: persist
                reloadableId: "persistedStates"

                property bool shown: false
                property real progress: shown ? 1.0 : 0.0
                onShownChanged: progress = shown ? 1.0 : 0.0
                property bool reserveSpace: true
            }

            required property var modelData
            property var screen: modelData
            
            Behavior on progress {
                NumberAnimation { duration: 400; easing.type: Easing.InOutCubic }
            }

            IpcHandler {
                target: "bar." + perScreen.screen.name
                function toggle(): void { 
                    perScreen.shown = !perScreen.shown; 
                    perScreen.reserveSpace = true;
                }
                function toggleOver(): void { 
                    perScreen.shown = !perScreen.shown; 
                    perScreen.reserveSpace = false;
                }
                function show(): void   { 
                    perScreen.shown = true; 
                    perScreen.reserveSpace = true
                }
                function showOver(): void   { 
                    perScreen.shown = true; 
                    perScreen.reserveSpace = false
                }
                function hide(): void   { perScreen.shown = false; }
            }

            PanelWindow {
                id: win
                screen: perScreen.screen

                anchors.top: true
                anchors.bottom: true
                anchors.left: true
                anchors.right: true

                color: "transparent"
                WlrLayershell.layer: WlrLayer.Top
                WlrLayershell.exclusionMode: ExclusionMode.Ignore
                surfaceFormat.opaque: false

                mask: Region {
                    x: Scheme.barWidth * perScreen.shown
                    y: Scheme.borderThickness * perScreen.shown
                    width: win.width - (Scheme.barWidth + Scheme.borderThickness) * perScreen.shown
                    height: win.height - (Scheme.borderThickness * 2) * perScreen.shown
                    intersection: Intersection.Xor

                    regions: popoutRegions.instances
                }

                Variants {
                    id: popoutRegions
                    model: bar.popouts

                    Region {
                        required property Item modelData
                        item: modelData
                        intersection: Intersection.Subtract
                    }
                }

                BorderFrame {
                    progress: perScreen.progress
                }

                Bar {
                    id: bar
                    screen: perScreen.screen
                    window: win
                    progress: perScreen.progress
                    spawnZones: spawnZones
                    modal: modal
                }

                SpawnZones {
                    id: spawnZones
                    anchors.fill: parent
                    progress: perScreen.progress
                    show: false
                }
            }

            ExclusionZones {
                screen: perScreen.screen
                progress: perScreen.progress
                visible: perScreen.reserveSpace
            }

            Modal {
                id: modal
                screen: perScreen.screen
                progress: perScreen.progress
            }
        }
    }
}

