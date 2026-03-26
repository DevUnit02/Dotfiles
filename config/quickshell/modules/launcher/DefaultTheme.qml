import QtQuick

QtObject {
    readonly property color bgBase: "#1a1410"
    readonly property color bgSurface: "#2a2018"
    readonly property color bgOverlay: "#aa0a0805"
    readonly property color bgHover: "#2e2010"
    readonly property color bgSelected: "#3a2a10"
    readonly property color bgBorder: "#5a4520"
    readonly property color bgBorderInner: "#3a2810"

    readonly property color textPrimary: "#d4b878"
    readonly property color textSecondary: "#8a7050"
    readonly property color textMuted: "#4a3820"

    readonly property color accentPrimary: "#b8922a"
    readonly property color accentCyan: "#c8a84a"
    readonly property color accentGreen: "#8a9a5a"
    readonly property color accentOrange: "#c87840"
    readonly property color accentRed: "#a84030"

    readonly property color urgencyLow: textMuted
    readonly property color urgencyNormal: accentPrimary
    readonly property color urgencyCritical: accentRed

    readonly property color batteryGood: accentGreen
    readonly property color batteryWarning: accentOrange
    readonly property color batteryCritical: accentRed

    readonly property string fontDisplay: "Cinzel"
    readonly property string fontBody: "IM FELL English"

}
