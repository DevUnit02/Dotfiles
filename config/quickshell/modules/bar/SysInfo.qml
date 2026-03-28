import QtQuick
import QtQuick.Layouts
import Quickshell.Io

RowLayout {
    id: root
    required property var theme
    spacing: 6
 
    // ── Ethernet ──
    Text {
        id: ethIcon
        text: "󰈀"
        font.family: root.theme.fontIcons
        font.pixelSize: 13
        color: root.theme.accentPrimary
    }
    Text {
        id: ethLabel
        text: "..."
        font.family: root.theme.fontDisplay
        font.pixelSize: root.theme.fontSize
        color: root.theme.textPrimary
    } 

    Item { width: 2}

    // ── Volumen ──
    Text {
        id: volIcon
        text: "󰕾"
        font.family: root.theme.fontIcons
        font.pixelSize: 13
        color: root.theme.textSecondary
    }
    Text {
        id: volLabel
        text: "0%"
        font.family: root.theme.fontDisplay
        font.pixelSize: root.theme.fontSize
        color: root.theme.textPrimary
    }

    // ── Pollers ──
    Process {
        id: volPoller
        command: ["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
        running: false
        stdout: StdioCollector {
	    onStreamFinished: {
		const out = this.text.trim()
		const isMuted = out.includes("[MUTED]")
		const val = Math.round(parseFloat(out.split(" ")[1]) * 100)
		volLabel.text = isMuted ? "Muted" : val + "%"
		volIcon.text = isMuted ? "󰝟" : val === 0 ? "󰕿" : val < 50 ? "󰖀" : "󰕾"
		volIcon.color = isMuted ? root.theme.accentRed : root.theme.textSecondary
		volLabel.color = isMuted ? root.theme.accentRed : root.theme.textPrimary
	    }
        }
    }

    // Watcher - dispara el poller cuando hay cambios reales
    Process {
	id: volWatcher
	command: ["bash", "-c", "pactl subscribe | grep --line-buffered 'sink'"]
	running: true
	stdout: SplitParser {
		onRead: data => volPoller.running = true 
	}
    }

    // Timer de respaldo
    Timer { interval: 5000; running: true; repeat: true; triggeredOnStart: true; onTriggered: volPoller.running = true }

    Process {
        id: ethPoller
        command: ["bash", "-c", "cat /sys/class/net/enp12s0/operstate | tr -d '[:space:]'"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const state = this.text.trim().toLowerCase()
                ethLabel.text = state === "up" ? "" : "Disconnected"
		ethIcon.color = state === "up"
		    ? root.theme.accentPrimary
		    : root.theme.textMuted
		ethLabel.visible = state !== "up"
            }
        }
    }
    Timer { interval: 10000; running: true; repeat: true; triggeredOnStart: true; onTriggered: ethPoller.running = true }
}
