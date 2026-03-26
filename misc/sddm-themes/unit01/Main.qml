import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SddmComponents 2.0
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    width: Screen.width
    height: Screen.height
    color: "#000000"

    // ── Propiedades del modelo de usuarios y sesiones ─────────────────
    property int currentUsersIndex: userModel.lastIndex
    property int currentSessionsIndex: sessionModel.lastIndex
    property int usernameRole: Qt.UserRole + 1

    // ── Wallpaper ─────────────────────────────────────────────────────
    Image {
        id: bg
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
    }

    // ── Overlay oscuro general ────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "#33000000"
    }

    // ── Contenedor central ────────────────────────────────────────────
    Column {
	anchors {
	    centerIn: parent
	    verticalCenterOffset: 60
	}
        spacing: 12

        // Avatar del usuario
        // Avatar circular
        Image {
            id: avatar
            width: 80
            height: 80
            anchors.horizontalCenter: parent.horizontalCenter
            source: "/var/lib/AccountsService/icons/" + userModel.data(userModel.index(currentUsersIndex, 0), usernameRole)
            fillMode: Image.PreserveAspectCrop
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: 80
                    height: 80
                    radius: 40
                    visible: false
                }
            }
        }

        // Nombre del usuario
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: userModel.data(userModel.index(currentUsersIndex, 0), usernameRole)
            color: "#ffffff"
            font.pixelSize: 14
            font.family: "monospace"
        }

        // Campo de contraseña + botón de login
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 0

            // Recuadro de contraseña
            Rectangle {
                width: 200
                height: 28
                color: "#22ffffff"
                border.color: "#66ffffff"
                border.width: 1
                radius: 3

                Row {
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 8
                    }
                    spacing: 6 

                    // Input de contraseña
                    TextInput {
                        id: passField
                        width: 155
                        height: 28
                        verticalAlignment: TextInput.AlignVCenter
                        color: "#ffffff"
                        font.pixelSize: 12
                        font.family: "monospace"
                        echoMode: TextInput.Password
                        passwordCharacter: "·"
                        focus: true

                        // Placeholder
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Password"
                            color: "#88ffffff"
                            font.pixelSize: 12
                            font.family: "monospace"
                            visible: passField.text.length === 0
                        }

                        // Login al presionar Enter
                        Keys.onReturnPressed: doLogin()
                        Keys.onEnterPressed: doLogin()
                    }
                }
            }
        }
    }

    // ── Botones de power — arriba a la derecha ────────────────────────
    Row {
        anchors {
            right: parent.right
            top: parent.top
            rightMargin: 30
            topMargin: 20
        }
        spacing: 16
	
	// Sesión actual — click para cambiar
        Text {
            id: sessionText
            text: sessionModel.data(sessionModel.index(currentSessionsIndex, 0), Qt.UserRole + 4)
            color: "#88ffffff"
            font.pixelSize: 11
            font.family: "monospace"
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: parent.color = "#ffffff"
                onExited: parent.color = "#88ffffff"
                onClicked: {
                    // Ciclar a la siguiente sesión
                    if (currentSessionsIndex >= sessionModel.rowCount() - 1) {
                        currentSessionsIndex = 0
                    } else {
                        currentSessionsIndex++
                    }
                    sessionText.text = sessionModel.data(sessionModel.index(currentSessionsIndex, 0), Qt.UserRole + 4)
                }
            }
        }

        // Separador
        Text {
            text: "|"
            color: "#33ffffff"
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
        }

        // Suspender
        Text {
            text: "⏾"
            color: "#88ffffff"
            font.pixelSize: 14
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: parent.color = "#ffffff"
                onExited: parent.color = "#88ffffff"
                onClicked: sddm.suspend()
            }
        }

        // Reiniciar
        Text {
            text: "↺"
            color: "#88ffffff"
            font.pixelSize: 14
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: parent.color = "#ffffff"
                onExited: parent.color = "#88ffffff"
                onClicked: sddm.reboot()
            }
        }

        // Apagar
        Text {
            text: "⏻"
            color: "#88ffffff"
            font.pixelSize: 14
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: parent.color = "#ffffff"
                onExited: parent.color = "#88ffffff"
                onClicked: sddm.powerOff()
            }
        }
    }

    // ── Función de login ──────────────────────────────────────────────
    function doLogin() {
        if (passField.text !== "") {
            sddm.login(
                userModel.data(userModel.index(currentUsersIndex, 0), usernameRole),
                passField.text,
                currentSessionsIndex
            )
        }
    }

    // ── Respuesta de SDDM al login ────────────────────────────────────
    Connections {
        target: sddm
        function onLoginFailed() {
            passField.text = ""
            passField.forceActiveFocus()
        }
        function onLoginSucceeded() {
            passField.text = ""
        }
    }

    // ── Forzar foco en el campo de contraseña al iniciar ─────────────
    Component.onCompleted: {
        passField.forceActiveFocus()
    }
}
