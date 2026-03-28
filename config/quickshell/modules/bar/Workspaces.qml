import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    id: root
    required property var theme
    spacing: 6

    Repeater {
        model: 9
        Item {
            width: 18
            height: 18

            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)

            Text {
                anchors.centerIn: parent
                text: isActive ? "󰪥" : ""
                font.family: root.theme.fontIcons
                font.pixelSize: isActive ? 14 : 9
                color: isActive          ? root.theme.accentPrimary
                     : ws       	 ? root.theme.textSecondary
                     :            	   root.theme.bgBorderInner

                Behavior on color { ColorAnimation { duration: 150 } }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("workspace " + (index + 1))
            }
        }
    }
}
