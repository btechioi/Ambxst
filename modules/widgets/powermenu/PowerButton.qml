import QtQuick
import qs.modules.components
import qs.modules.theme
import qs.modules.services
import qs.config

ToggleButton {
    id: powerButton
    buttonIcon: Icons.shutdown
    tooltipText: "Power Menu"
    iconTint: Config.tintIcons
    iconFullTint: false
    onToggle: function () {
        if (Visibilities.currentActiveModule === "powermenu") {
            Visibilities.setActiveModule("");
        } else {
            Visibilities.setActiveModule("powermenu");
        }
    }
}
