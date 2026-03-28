import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

RowLayout {
    id: root
    required property var theme
    spacing: 6

    Repeater {
	model: SystemTray.items

	Component.onCompleted: console.log("Tray item:", count)

        delegate: Item {
            width: 18
            height: 18

            required property SystemTrayItem modelData

            Image {
                anchors.centerIn: parent
                source: modelData.icon
                width: 16
                height: 16
                smooth: true
	    }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor

                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton)
                        modelData.secondaryActivate(0, 0)
                    else
                        modelData.activate(0, 0)
                }
            }
        }
    }
}
