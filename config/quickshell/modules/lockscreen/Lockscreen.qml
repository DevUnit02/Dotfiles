import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

Scope {
    id: root
    
    // Cambia a 'false' para el bloqueo real
    property bool debugMode: false 

    LockContext {
        id: lockContext
        onUnlocked: {
            // Desbloqueamos el objeto interno si existe y cerramos el loader
            if (lockLoader.item && !debugMode) {
                lockLoader.item.locked = false
            }
            lockLoader.active = false
        }
    }

    Loader {
        id: lockLoader
        active: false
        // FloatingWindow es el tipo correcto para modo test
        sourceComponent: debugMode ? testComp : realComp
    }

    // --- COMPONENTES DE CARGA ---
    Component {
        id: testComp
        FloatingWindow {
            width: 1280
            height: 720
            visible: true
            color: "black"
            
            LockSurface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }

    Component {
        id: realComp
        WlSessionLock {
            locked: true
            WlSessionLockSurface {
                LockSurface {
                    anchors.fill: parent
                    context: lockContext
                }
            }
        }
    } 

    IpcHandler {
        target: "lockscreen"
        function lock(): void {
            console.log("Comando IPC 'lock' recibido")
            lockContext.currentText = ""
	    lockContext.showFailure = false
	    lockLoader.active = true // Reinicia la instancia (soluciona el bind) 
        }
    }
}

