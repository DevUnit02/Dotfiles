import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// Scope agrupa toda la lógica del launcher sin crear una ventana.
// El estado vive acá arriba, separado de la UI.
Scope {
    id: root

    // Tema central — todos los colores y fuentes vienen de acá.
    // Para cambiar la estética del launcher, solo tocás DefaultTheme.qml.
    property var theme: DefaultTheme {}

    // IpcHandler expone toggle() al sistema operativo.
    // Se llama desde Hyprland con:
    //   quickshell ipc call launcher toggle
    IpcHandler {
        target: "launcher"

        function toggle(): void {
            launcherPanel.visible = !launcherPanel.visible
            if (launcherPanel.visible) {
                searchInput.text = ""
                root.selectedIndex = 0
                searchInput.forceActiveFocus()
            }
        }
    }

    // Índice del ítem seleccionado en la lista de resultados.
    property int selectedIndex: 0

    // ScriptModel filtra y ordena las apps en tiempo real.
    // Se recalcula automáticamente cada vez que searchInput.text cambia.
    ScriptModel {
        id: filteredApps
        objectProp: "id"
        values: {
            const all = [...DesktopEntries.applications.values];
            const q = searchInput.text.trim().toLowerCase();

            // Sin búsqueda: todas las apps ordenadas alfabéticamente
            if (q === "") return all.sort((a, b) => a.name.localeCompare(b.name));

            // Con búsqueda: filtra por nombre, nombre genérico, keywords y categorías.
            // Prioriza las apps cuyo nombre empieza con el texto buscado.
            return all.filter(d =>
                (d.name && d.name.toLowerCase().includes(q)) ||
                (d.genericName && d.genericName.toLowerCase().includes(q)) ||
                (d.keywords && d.keywords.some(k => k.toLowerCase().includes(q))) ||
                (d.categories && d.categories.some(c => c.toLowerCase().includes(q)))
            ).sort((a, b) => {
                const an = a.name.toLowerCase();
                const bn = b.name.toLowerCase();
                const aStarts = an.startsWith(q);
                const bStarts = bn.startsWith(q);
                if (aStarts && !bStarts) return -1;
                if (!aStarts && bStarts) return 1;
                return an.localeCompare(bn);
            });
        }
    }

    // Lanza la app seleccionada y cierra el launcher.
    function launchApp(entry) {
        entry.execute();
        launcherPanel.visible = false;
    }

    // ─── Ventana principal ────────────────────────────────────────────────────

    PanelWindow {
        id: launcherPanel
        visible: false
        focusable: true
        color: "transparent"

        // Layer Overlay: flota sobre todas las ventanas.
        // Exclusive: captura todo el teclado mientras está visible.
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        WlrLayershell.namespace: "quickshell-launcher"

        // Ignore: no desplaza barras ni otras ventanas.
        exclusionMode: ExclusionMode.Ignore

        // Ocupa toda la pantalla para capturar clicks fuera del launcher.
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        // Click fuera del launcher lo cierra.
        MouseArea {
            anchors.fill: parent
            onClicked: launcherPanel.visible = false

            // Overlay semitransparente sobre el escritorio.
            Rectangle {
                anchors.fill: parent
                color: root.theme.bgOverlay
            }
        }

        // ─── Caja central del launcher ────────────────────────────────────────

        Rectangle {
            id: launcherBox
            anchors.centerIn: parent
            width: 580
            height: 480
            radius: 2
            color: root.theme.bgBase
            border.color: root.theme.bgBorder
            border.width: 1
	    
	    Rectangle {
	        anchors.fill: parent
		anchors.margins: 5
		radius: 1
		color: "transparent"
		border.color: root.theme.bgBorderInner
		border.width: 1
	    }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                // ─── Header ──────────────────────────────────────────────────

                Row {
		    Layout.alignment: Qt.AlignHCenter
		    spacing: 8

		    Text {
			text: "★"
			color: root.theme.bgBorder
			font.pixelSize: 10
			anchors.verticalCenter: parent.verticalCenter
		    }

		    Text {
			text: "Outlaws for Life"
			color: root.theme.accentPrimary
			font.pixelSize: 11
			font.family: root.theme.fontDisplay
			font.letterSpacing: 4
		    }

		    Text {
			text: "★"
			color: root.theme.bgBorder
			font.pixelSize: 10
			anchors.verticalCenter: parent.verticalCenter
		    }
		} 
		
		// ─── Divisor ─────────────────────────────────────────────────

		Row {
		    Layout.fillWidth: true
		    spacing: 0

		    Rectangle {
		        width: (launcherBox.width - 36) / 2
			height: 1
			color: root.theme.bgBorderInner
		    }

		    Rectangle {
			width: 6
			height: 6
			rotation: 45
			color: root.theme.accentPrimary
			anchors.verticalCenter: parent.verticalCenter
		    }
		    
		    Rectangle {
			width: (launcherBox.width - 36) / 2
			height: 1
			color: root.theme.bgBorderInner
		    }

		}

                // ─── Barra de búsqueda ────────────────────────────────────────

                Rectangle {
                    Layout.fillWidth: true
                    height: 44
                    radius: 10
                    color: root.theme.bgSurface
                    border.color: searchInput.activeFocus
                        ? root.theme.accentPrimary
                        : root.theme.bgBorder
                    border.width: 1

                    Behavior on border.color {
                        ColorAnimation { duration: 150 }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 10

                        Text {
                            text: ""
                            color: root.theme.textMuted
                            font.pixelSize: 16
                            font.family: root.theme.fontDisplay
                            Layout.alignment: Qt.AlignVCenter
                        }

                        TextInput {
                            id: searchInput
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            color: root.theme.textPrimary
                            font.pixelSize: 15
                            font.family: root.theme.fontDisplay
                            clip: true
                            focus: true
                            Accessible.role: Accessible.EditableText
                            Accessible.name: "Search applications"

                            // Placeholder visible cuando no hay texto ni foco
                            Text {
                                anchors.fill: parent
                                text: "Type to search..."
                                color: root.theme.textMuted
				font.family: root.theme.fontBody
				font.pixelSize: 20
				font.italic: true
                                visible: !parent.text
                                verticalAlignment: Text.AlignVCenter
                            }

                            onTextChanged: root.selectedIndex = 0

                            Keys.onEscapePressed: launcherPanel.visible = false

                            Keys.onPressed: event => {
                                if (event.key === Qt.Key_Down) {
                                    event.accepted = true;
                                    root.selectedIndex = Math.min(root.selectedIndex + 1, resultsList.count - 1);
                                    resultsList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                                } else if (event.key === Qt.Key_Up) {
                                    event.accepted = true;
                                    root.selectedIndex = Math.max(root.selectedIndex - 1, 0);
                                    resultsList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    event.accepted = true;
                                    if (resultsList.count > 0) {
                                        const entry = filteredApps.values[root.selectedIndex];
                                        if (entry) root.launchApp(entry);
                                    }
                                } else if (event.key === Qt.Key_Tab) {
                                    event.accepted = true;
                                    root.selectedIndex = Math.min(root.selectedIndex + 1, resultsList.count - 1);
                                    resultsList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
                                }
                            }
                        }
                    }
                }

                // ─── Contador de resultados ───────────────────────────────────

                Text {
                    text: resultsList.count + " application" + (resultsList.count !== 1 ? "s" : "")
                    color: root.theme.textMuted
                    font.pixelSize: 11
                    font.family: root.theme.fontDisplay
                }

                // ─── Lista de apps ────────────────────────────────────────────

                ListView {
                    id: resultsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: filteredApps
                    clip: true
                    spacing: 2
                    boundsBehavior: Flickable.StopAtBounds
                    currentIndex: root.selectedIndex
                    highlightMoveDuration: 150
                    highlightMoveVelocity: -1

                    // Resaltado del ítem seleccionado
                    highlight: Rectangle {
                        radius: 1
                        color: root.theme.bgSelected

                        Rectangle {
                            width: 2
                            height: parent.height - 8
                            radius: 0
                            color: root.theme.accentPrimary
                            anchors.left: parent.left
                            anchors.leftMargin: 0
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // Cada ítem de la lista
                    delegate: Rectangle {
                        id: delegateRoot
                        required property var modelData
                        required property int index

                        Accessible.role: Accessible.Button
                        Accessible.name: (modelData.name ?? "Application") +
                            (modelData.genericName ? " - " + modelData.genericName : "")

                        width: resultsList.width
                        height: 52
                        radius: 8
                        color: hoverArea.containsMouse && root.selectedIndex !== index
                            ? root.theme.bgHover
                            : "transparent"

                        Behavior on color {
                            ColorAnimation { duration: 100 }
                        }

                       RowLayout {
		           anchors.fill: parent
			   anchors.leftMargin: 12
			   anchors.rightMargin: 12
			   spacing: 10

			   // Diamante indicador
			   Rectangle {
			       width: 5
			       height: 5
			       rotation: 45
			       color: root.selectedIndex === delegateRoot.index
			           ? root.theme.accentPrimary
				   : "transparent"
			       border.color: root.theme.bgBorder
			       border.width: 1
			       Layout.alignment: Qt.AlignVCenter
		           }

			   ColumnLayout {
			       Layout.fillWidth: true
			       Layout.alignment: Qt.AlignVCenter
			       spacing: 1

			       // Nombre de la app
			       Text {
			           text: delegateRoot.modelData.name ?? ""
				   color: root.selectedIndex === delegateRoot.index
				       ? root.theme.textPrimary
				       : root.theme.textSecondary
				   font.pixelSize: 13
				   font.family: root.theme.fontDisplay
				   font.letterSpacing: 1
				   elide: Text.ElideRight
				   Layout.fillWidth: true
			       }

			       // Descripción — visible solo si existe
			       Text {
			           text: delegateRoot.modelData.genericName ??
				       delegateRoot.modelData.comment ?? ""
				   color: root.theme.textMuted
				   font.pixelSize: 10
				   font.family: root.theme.fontBody
				   font.italic: true
				   elide: Text.ElideRight
				   Layout.fillWidth: true
				   visible: text !== ""
			       }
			    }
		        } 

                        MouseArea {
                            id: hoverArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.launchApp(delegateRoot.modelData)
                            onEntered: root.selectedIndex = delegateRoot.index
                        }
                    }

                    // Estado vacío cuando no hay resultados
                    Text {
                        anchors.centerIn: parent
                        text: "  No applications found"
                        color: root.theme.textMuted
                        font.pixelSize: 14
                        font.family: root.theme.fontBody
                        visible: resultsList.count === 0 && searchInput.text !== ""
                    }
	    	}

		// ─── Divisor ─────────────────────────────────────────────────
		
		Row {
		    Layout.fillWidth: true
		    spacing: 0

		    Rectangle {
			width: (launcherBox.width - 36) / 2
			height: 1 
			color: root.theme.bgBorderInner
		    }
		   
		    Rectangle {
			width: 6
			height: 6
			rotation: 46
			color: root.theme.accentPrimary
			anchors.verticalCenter: parent.verticalCenter
		    }

		    Rectangle {
			width: (launcherBox.width - 36) / 2
			height: 1
			color: root.theme.bgBorderInner
		    }
		}

		// ─── Footer ──────────────────────────────────────────────────		
		
		Item {
		    Layout.fillWidth: true
		    height: 20

		    Row {
		    	spacing: 8
		    	anchors.horizontalCenter: parent.horizontalCenter

		    	Text {
			    text: "Van der Linde Gang"
			    color: root.theme.textMuted
			    font.pixelSize: 8
			    font.family: root.theme.fontDisplay
			    font.letterSpacing: 3
			    anchors.verticalCenter: parent.verticalCenter
		        }
		    
		        Rectangle {
			    width: 4
			    height: 4
			    rotation: 45
			    color: root.theme.bgBorder
			    anchors.verticalCenter: parent.verticalCenter
		        }
		    
		    	Text {
			    text: "1899"
			    color: root.theme.textMuted
			    font.pixelSize: 8
			    font.family: root.theme.fontDisplay
			    font.letterSpacing: 3
			    anchors.verticalCenter: parent.verticalCenter
		        }
		    }
		}
            }
        }
    }
}
