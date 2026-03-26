import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    required property LockContext context

    // ── Colores — tocá solo este bloque para cambiar el tema ──
    readonly property color clrBackground:  "#0d0b09"
    readonly property color clrSurface:     Qt.rgba(1, 1, 1, 0.07)
    readonly property color clrBorder:      Qt.rgba(1, 1, 1, 0.14)
    readonly property color clrBorderFocus: Qt.rgba(1, 1, 1, 0.32)
    readonly property color clrText:        Qt.rgba(1, 1, 1, 0.88)
    readonly property color clrSubtext:     Qt.rgba(1, 1, 1, 0.40)
    readonly property color clrHint:        Qt.rgba(1, 1, 1, 0.18)
    readonly property color clrError:       Qt.rgba(0.86, 0.29, 0.29, 0.50)
    readonly property string fontFamily:    "JetBrains Mono"

    color: clrBackground

    // ── Reloj — esquina superior izquierda ──
    Item {
        id: clockCorner
        anchors {
            top: parent.top
            left: parent.left
            topMargin: 28
            leftMargin: 32
        }

        property var now: new Date()
        Timer {
            running: true; repeat: true; interval: 1000
            onTriggered: clockCorner.now = new Date()
        }

        Text {
            id: timeLabel
            font.family: root.fontFamily
            font.pixelSize: 28
            font.weight: Font.DemiBold
            color: Qt.rgba(1, 1, 1, 0.82)
            renderType: Text.NativeRendering
            text: {
                const h = clockCorner.now.getHours().toString().padStart(2, '0')
                const m = clockCorner.now.getMinutes().toString().padStart(2, '0')
                return `${h}:${m}`
            }
        }

        Text {
            anchors { top: timeLabel.bottom; topMargin: 4 }
            font.family: root.fontFamily
            font.pixelSize: 11
            color: root.clrSubtext
            renderType: Text.NativeRendering
            text: {
                const dias   = ["domingo","lunes","martes","miércoles","jueves","viernes","sábado"]
                const meses  = ["enero","febrero","marzo","abril","mayo","junio",
                                 "julio","agosto","septiembre","octubre","noviembre","diciembre"]
                const d = clockCorner.now
                return `${dias[d.getDay()]}, ${d.getDate()} de ${meses[d.getMonth()]}`
            }
        }
    }

    // ── Centro ──
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 0

        // Avatar
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 14
            width: 72; height: 72; radius: 36
            color: Qt.rgba(1, 1, 1, 0.08)
            border.color: root.clrBorder
            border.width: 2

            Canvas {
                anchors.fill: parent
                onPaint: {
                    const ctx = getContext("2d")
                    const cx = width / 2, cy = height / 2
                    ctx.fillStyle = "rgba(255,255,255,0.55)"
                    ctx.beginPath(); ctx.arc(cx, cy - 8, 12, 0, Math.PI * 2); ctx.fill()
                    ctx.beginPath(); ctx.arc(cx, cy + 26, 18, Math.PI, 0); ctx.fill()
                }
            }
        }

        // Nombre de usuario
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 28
            font.family: root.fontFamily
            font.pixelSize: 14
            color: root.clrSubtext
            text: Qt.application.name  // reemplazá con tu usuario si querés hardcodearlo
        }

        // Campo de contraseña
        Rectangle {
            id: inputPill
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 28
            width: 240; height: 38; radius: 999
            color: root.context.showFailure ? Qt.rgba(0.86, 0.29, 0.29, 0.10) : root.clrSurface
            border.width: 1
            border.color: root.context.showFailure ? root.clrError
                        : passwordBox.activeFocus   ? root.clrBorderFocus
                        :                             root.clrBorder

            Behavior on color        { ColorAnimation { duration: 200 } }
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
                anchors { fill: parent; leftMargin: 18; rightMargin: 40 }
                verticalAlignment: TextInput.AlignVCenter
                font.family: root.fontFamily
                font.pixelSize: 14
                color: root.clrText
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
                    font: passwordBox.font
                    color: root.clrHint
                    text: "contraseña..."
                    visible: passwordBox.text.length === 0
                }
            }

            // Ícono de candado
            Text {
                anchors { right: parent.right; rightMargin: 13; verticalCenter: parent.verticalCenter }
                font.family: "Symbols Nerd Font"
                font.pixelSize: 14
                color: root.clrHint
                text: ""
            }
        }

        // Botones de sistema
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 16

            Repeater {
                model: [
                    { icon: "󰒲", cmd: "systemctl suspend"  },
                    { icon: "󰜉", cmd: "systemctl reboot"   },
                    { icon: "",  cmd: "systemctl poweroff"  }
                ]

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: 36; height: 36; radius: 18
                    color: ma.containsMouse ? Qt.rgba(1,1,1,0.12) : root.clrSurface
                    border.width: 1
                    border.color: ma.containsMouse ? root.clrBorderFocus : root.clrBorder
                    Behavior on color        { ColorAnimation { duration: 150 } }
                    Behavior on border.color { ColorAnimation { duration: 150 } }
                    scale: ma.pressed ? 0.92 : 1.0
                    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutBack } }

                    Text {
                        anchors.centerIn: parent
                        font.family: "Symbols Nerd Font"
                        font.pixelSize: 15
                        color: Qt.rgba(1, 1, 1, 0.55)
                        text: modelData.icon
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
    }

    // ── Hint abajo ──
    Text {
        anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; bottomMargin: 20 }
        font.family: root.fontFamily
        font.pixelSize: 11
        color: root.clrHint
        text: root.context.showFailure ? "contraseña incorrecta" : "enter para confirmar"
        Behavior on text { }
    }
}
