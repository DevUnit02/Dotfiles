import QtQuick
import QtQuick.Layouts
import Quickshell.Io

RowLayout {
    id: root
    required property var theme
    spacing: 6

    Rectangle { width: 1; height: 14; color: root.theme.bgBorderInner }

    // ── GPU Temp ──
    Text {
    	id: gpuTempIcon
    	font.family: root.theme.fontIcons
    	font.pixelSize: 13
    	text: "󱃃"
    	color: root.theme.textSecondary
    }
    Text {
    	id: gpuTempLabel
    	text: "0°"
    	font.family: root.theme.fontDisplay
    	font.pixelSize: root.theme.fontSize
    	color: root.theme.textPrimary

    	onTextChanged: {
            const val = parseInt(text)
            if (val >= 75) {
            	gpuTempIcon.text = "󰸁"
            	gpuTempIcon.color = root.theme.accentRed
            } else if (val >= 50) {
            	gpuTempIcon.text = "󰔏"
            	gpuTempIcon.color = root.theme.accentOrange
            } else {
            	gpuTempIcon.text = "󱃃"
            	gpuTempIcon.color = root.theme.textSecondary
            }
    	}
    } 
 
    // ── CPU Temp ──
    Text {
    	id: cpuTempIcon
    	font.family: root.theme.fontIcons
    	font.pixelSize: 13
    	text: "󱃃"
    	color: root.theme.textSecondary
    }
    Text {
    	id: cpuTempLabel
    	text: "0°"
    	font.family: root.theme.fontDisplay
    	font.pixelSize: root.theme.fontSize
    	color: root.theme.textPrimary

    	onTextChanged: {
            const val = parseInt(text)
            if (val >= 75) {
            	cpuTempIcon.text = "󰸁"
            	cpuTempIcon.color = root.theme.accentRed
            } else if (val >= 50) {
            	cpuTempIcon.text = "󰔏"
            	cpuTempIcon.color = root.theme.accentOrange
            } else {
            	cpuTempIcon.text = "󱃃"
            	cpuTempIcon.color = root.theme.textSecondary
            }
	}
    }  

    Rectangle { width: 1; height: 14; color: root.theme.bgBorderInner }

    // ── CPU ──
    Text {
        text: "󰍛"
        font.family: root.theme.fontIcons
        font.pixelSize: 13
        color: root.theme.textSecondary
    }
    Text {
        id: cpuLabel
        text: "0%"
        font.family: root.theme.fontDisplay
        font.pixelSize: root.theme.fontSize
        color: root.theme.textPrimary
    }  

    // ── RAM ──
    Text {
        text: "󰘚"
        font.family: root.theme.fontIcons
        font.pixelSize: 13
        color: root.theme.textSecondary
    }
    Text {
        id: memLabel
        text: "0%"
        font.family: root.theme.fontDisplay
        font.pixelSize: root.theme.fontSize
        color: root.theme.textPrimary
    }    

    // ── Pollers ──
    Process {
        id: cpuPoller
        command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print int($2)}'"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: cpuLabel.text = this.text.trim() + "%"
        }
    }
    Timer { interval: 3000; running: true; repeat: true; triggeredOnStart: true; onTriggered: cpuPoller.running = true }

    Process {
        id: memPoller
        command: ["bash", "-c", "free | awk '/Mem:/ {printf \"%d\", $3/$2*100}'"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: memLabel.text = this.text.trim() + "%"
        }
    }
    Timer { interval: 3000; running: true; repeat: true; triggeredOnStart: true; onTriggered: memPoller.running = true }

    Process {
        id: cpuTempPoller
        command: ["bash", "-c", "sensors k10temp-pci-00c3 | awk '/Tctl/ {gsub(/[^0-9.]/, \"\", $2); printf \"%d\", $2}'"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: cpuTempLabel.text = this.text.trim() + "°"
        }
    }
    Timer { interval: 5000; running: true; repeat: true; triggeredOnStart: true; onTriggered: cpuTempPoller.running = true }

    Process {
        id: gpuTempPoller
        command: ["bash", "-c", "sensors amdgpu-pci-0300 | awk '/edge/ {gsub(/[^0-9.]/, \"\", $2); printf \"%d\", $2}'"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: gpuTempLabel.text = this.text.trim() + "°"
        }
    }
    Timer { interval: 5000; running: true; repeat: true; triggeredOnStart: true; onTriggered: gpuTempPoller.running = true }
}
