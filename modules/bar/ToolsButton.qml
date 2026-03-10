import QtQuick
import qs.modules.components
import qs.modules.theme
import qs.modules.services
import qs.config

ToggleButton {
    id: toolsButton
    buttonIcon: Icons.toolbox
    tooltipText: "Tools"
    iconTint: Config.tintIcons
    iconFullTint: false
    onToggle: function () {
        if (Visibilities.currentActiveModule === "tools") {
            Visibilities.setActiveModule("");
        } else {
            Visibilities.setActiveModule("tools");
        }
    }
}
