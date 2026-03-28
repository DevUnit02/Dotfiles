import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    required property LockContext context

    // ── Tema — mismo que el launcher ──
    readonly property color bgBase:        "#1a1410"
    readonly property color bgSurface:     "#2a2018"
    readonly property color bgBorder:      "#5a4520"
    readonly property color bgBorderInner: "#3a2810"
    readonly property color textPrimary:   "#d4b878"
    readonly property color textSecondary: "#8a7050"
    readonly property color textMuted:     "#4a3820"
    readonly property color accentPrimary: "#b8922a"
    readonly property color accentRed:     "#a84030"
    readonly property string fontDisplay:  "Cinzel"
    readonly property string fontBody:     "IM FELL English"

    color: bgBase

    // ── Borde doble exterior ──
    Rectangle {
        anchors.fill: parent
        anchors.margins: 8
        color: "transparent"
        border.color: root.bgBorder
        border.width: 1
    }
    Rectangle {
        anchors.fill: parent
        anchors.margins: 12
        color: "transparent"
        border.color: root.bgBorderInner
        border.width: 1
    }

    // ── Reloj — esquina superior izquierda ──
    Item {
        id: clockCorner
        anchors {
            top: parent.top
            left: parent.left
            topMargin: 32
            leftMargin: 40
        }

        property var now: new Date()
        Timer {
            running: true; repeat: true; interval: 1000
            onTriggered: clockCorner.now = new Date()
        }

        Text {
            id: timeLabel
            font.family: root.fontDisplay
            font.pixelSize: 32
            font.letterSpacing: 4
            color: root.textPrimary
            renderType: Text.NativeRendering
            text: {
                const h = clockCorner.now.getHours().toString().padStart(2, '0')
                const m = clockCorner.now.getMinutes().toString().padStart(2, '0')
                return `${h}:${m}`
            }
        }

        Text {
            anchors { top: timeLabel.bottom; topMargin: 4 }
            font.family: root.fontBody
            font.pixelSize: 11
            font.italic: true
            color: root.textMuted
            renderType: Text.NativeRendering
            text: {
                const dias  = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
                const meses = ["January","February","March","April","May","June",
                               "July","August","September","October","November","December"]
                const d = clockCorner.now
                return `${dias[d.getDay()]}, ${d.getDate()} ${meses[d.getMonth()]}`
            }
        }
    }

    // ── Centro ──
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 0

        // Header "★ Locked ★"
        Row {
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 8
            spacing: 8

            Text {
                text: "★"
                color: root.bgBorder
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: "Locked"
                color: root.accentPrimary
                font.family: root.fontDisplay
                font.pixelSize: 11
                font.letterSpacing: 4
            }
            Text {
                text: "★"
                color: root.bgBorder
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Divisor con diamante
        Row {
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 28
            spacing: 0

            Rectangle { width: 120; height: 1; color: root.bgBorderInner; anchors.verticalCenter: parent.verticalCenter }
            Rectangle { width: 6; height: 6; rotation: 45; color: root.accentPrimary; anchors.verticalCenter: parent.verticalCenter }
            Rectangle { width: 120; height: 1; color: root.bgBorderInner; anchors.verticalCenter: parent.verticalCenter }
        }

        // Avatar
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 16
            width: 72; height: 72; radius: 36
            color: root.bgSurface
            border.color: root.bgBorder
            border.width: 1

            Canvas {
                anchors.fill: parent
                onPaint: {
                    const ctx = getContext("2d")
                    const cx = width / 2, cy = height / 2
                    ctx.fillStyle = "#8a7050"
                    ctx.beginPath(); ctx.arc(cx, cy - 8, 12, 0, Math.PI * 2); ctx.fill()
                    ctx.beginPath(); ctx.arc(cx, cy + 26, 18, Math.PI, 0); ctx.fill()
                }
            }

            // Diamante decorativo en la esquina del avatar
            Rectangle {
                width: 8; height: 8; rotation: 45
                color: root.bgBase
                border.color: root.bgBorder
                border.width: 1
                anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; bottomMargin: -4 }
            }
        }

        // Nombre de usuario
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 24
            font.family: root.fontDisplay
            font.pixelSize: 13
            font.letterSpacing: 3
            color: root.textSecondary
            text: "unit02_md"
        }

        // Campo de contraseña
        Rectangle {
            id: inputPill
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 24
            width: 260; height: 44; radius: 2
            color: root.bgSurface
            border.width: 1
            border.color: root.context.showFailure ? root.accentRed
                        : passwordBox.activeFocus   ? root.accentPrimary
                        :                             root.bgBorder

            Behavior on border.color { ColorAnimation { duration: 200 } }

            SequentialAnimation {
                id: shakeAnim
                NumberAnimation { target: inputPill; property: "x"; to: inputPill.x - 8; duration: 50 }
                NumberAnimation { target: inputPill; property: "x"; to: inputPill.x + 8; duration: 50 }
                NumberAnimation { target: inputPill; property: "x"; to: inputPill.x - 5; duration: 50 }
                NumberAnimation { target: inputPill; property: "x"; to: inputPill.x + 5; duration: 50 }
                NumberAnimation { target: inputPill; property: "x"; to: inputPill.x;     duration: 50 }
            }

            Connections {
                target: root.context
                function onFailed() { shakeAnim.start() }
            }

            TextInput {
                id: passwordBox
                anchors { fill: parent; leftMargin: 16; rightMargin: 16 }
                verticalAlignment: TextInput.AlignVCenter
                font.family: root.fontBody
                font.pixelSize: 15
                color: root.textPrimary
                echoMode: TextInput.Password
                inputMethodHints: Qt.ImhSensitiveData
                enabled: !root.context.unlockInProgress
                focus: true

                onTextChanged: root.context.currentText = this.text
                onAccepted:    root.context.tryUnlock()

                Connections {
                    target: root.context
                    function onCurrentTextChanged() {
                        if (passwordBox.text !== root.context.currentText)
                            passwordBox.text = root.context.currentText
                    }
                }

                Text {
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    font.family: root.fontBody
                    font.pixelSize: 15
                    font.italic: true
                    color: root.textMuted
                    text: "Enter password..."
                    visible: passwordBox.text.length === 0
                }
            }
        }

        // Botones de sistema
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 28
            spacing: 20

            Repeater {
                model: [
                    { label: "Suspend", cmd: "systemctl suspend"  },
                    { label: "Reboot",  cmd: "systemctl reboot"   },
                    { label: "Power Off", cmd: "systemctl poweroff" }
                ]

                delegate: Rectangle {
                    required property var modelData
                    width: 80; height: 28; radius: 1
                    color: ma.containsMouse ? root.bgSurface : "transparent"
                    border.width: 1
                    border.color: ma.containsMouse ? root.accentPrimary : root.bgBorder
                    Behavior on color        { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }
                    scale: ma.pressed ? 0.95 : 1.0
                    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutBack } }

                    Text {
                        anchors.centerIn: parent
                        font.family: root.fontDisplay
                        font.pixelSize: 9
                        font.letterSpacing: 2
                        color: ma.containsMouse ? root.textPrimary : root.textMuted
                        text: modelData.label
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Qt.createQmlObject(
                            `import Quickshell; Process { command: ["bash","-c","${modelData.cmd}"]; running: true }`,
                            root
                        )
                    }
                }
            }
        }

        // Divisor inferior
        Row {
            Layout.alignment: Qt.AlignHCenter
            spacing: 0
            Rectangle { width: 120; height: 1; color: root.bgBorderInner; anchors.verticalCenter: parent.verticalCenter }
            Rectangle { width: 6; height: 6; rotation: 45; color: root.accentPrimary; anchors.verticalCenter: parent.verticalCenter }
            Rectangle { width: 120; height: 1; color: root.bgBorderInner; anchors.verticalCenter: parent.verticalCenter }
        }
    }

    // ── Footer ──
    Item {
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 32
        }
        width: footerRow.implicitWidth
        height: footerRow.implicitHeight

        Row {
            id: footerRow
            spacing: 8

            Text {
                text: root.context.showFailure ? "Wrong password, partner" : "Van der Linde Gang"
                color: root.textMuted
                font.family: root.fontDisplay
                font.pixelSize: 8
                font.letterSpacing: 3
                anchors.verticalCenter: parent.verticalCenter
                Behavior on text {}
            }
            Rectangle {
                width: 4; height: 4; rotation: 45
                color: root.bgBorder
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: "1899"
                color: root.textMuted
                font.family: root.fontDisplay
                font.pixelSize: 8
                font.letterSpacing: 3
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
