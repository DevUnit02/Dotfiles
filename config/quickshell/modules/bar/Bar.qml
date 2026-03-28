import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    property var theme: BarTheme {}

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 34
    color: root.theme.bgBase

    // ── Borde inferior dorado ──
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: root.theme.bgBorder
    }

    // ── Línea interior decorativa ──
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: 4
        height: 1
        color: root.theme.bgBorderInner
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        anchors.topMargin: 2
        anchors.bottomMargin: 6
        spacing: 0

        // ── IZQUIERDA ──
        Workspaces {
                theme: root.theme
	    }

        Item { Layout.fillWidth: true }

        // ── IZQUIERDA ──
	RowLayout {
	    spacing: 10
	
	    Tray {
		theme: root.theme
	    } 

	    SystemStats {
		theme: root.theme
	    }

	    Rectangle { width: 1; height: 14; color: root.theme.bgBorder }

	    SysInfo {
		theme: root.theme
	    }

	    Rectangle {width: 1; height: 14; color: root.theme.bgBorder }

	    Clock {
		theme: root.theme
		Layout.alignment: Qt.AlignVCenter
	    }
	}
    }
}
