import QtQuick
import qs.config
import qs.modules.theme
import qs.modules.components

Item {
    width: 20
    height: 20

    Text {
        id: clockIcon
        anchors.fill: parent
        text: Icons.clock
        color: Colors.overBackground
        font.pixelSize: 20
        font.family: Icons.font
    }

    Tinted {
        anchors.fill: parent
        sourceItem: clockIcon
        active: Config.tintIcons
        fullTint: false
    }
}
