import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    required property var theme
    spacing: 8

    property var now: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.now = new Date()
    }

    // Diamante izquierdo
    Rectangle { width: 4; height: 4; rotation: 45; color: root.theme.bgBorder }

    // Mes
    Text {
        font.family: root.theme.fontDisplay
        font.pixelSize: root.theme.fontSize
        font.letterSpacing: 1
        color: root.theme.textSecondary
        text: {
            const meses = ["Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"]
            return meses[root.now.getMonth()]
        }
    }

    // Diamante separador
    Rectangle { width: 3; height: 3; rotation: 45; color: root.theme.bgBorderInner }

    // Día abreviado + número
    Text {
        font.family: root.theme.fontDisplay
        font.pixelSize: root.theme.fontSize
        font.letterSpacing: 1
        color: root.theme.textSecondary
        text: {
            const dias = ["Dom","Lun","Mar","Mié","Jue","Vie","Sáb"]
            return dias[root.now.getDay()] + " " + root.now.getDate()
        }
    }

    // Diamante separador
    Rectangle { width: 3; height: 3; rotation: 45; color: root.theme.bgBorderInner }

    // Hora
    Text {
        font.family: root.theme.fontDisplay
        font.pixelSize: 13
        font.letterSpacing: 2
        color: root.theme.textPrimary
        text: {
            const h = root.now.getHours().toString().padStart(2, '0')
            const m = root.now.getMinutes().toString().padStart(2, '0')
            return h + ":" + m
        }
    }

    // Diamante derecho
    Rectangle { width: 4; height: 4; rotation: 45; color: root.theme.bgBorder }
}
