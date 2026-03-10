pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.modules.services
import qs.modules.components
import qs.modules.theme
import qs.modules.globals
import qs.config

Item {
    id: root

    required property var bar

    property bool vertical: bar.orientation === "vertical"
    property bool isHovered: false
    property bool layerEnabled: true
    
    property real radius: 0
    property real startRadius: radius
    property real endRadius: radius

    // Popup visibility state (tracks intent, not animation)
    property bool popupOpen: layoutPopup.isOpen

    Layout.preferredWidth: 36
    Layout.preferredHeight: 36
    Layout.maximumWidth: 36
    Layout.maximumHeight: 36
    Layout.fillWidth: vertical
    Layout.fillHeight: !vertical

    HoverHandler {
        onHoveredChanged: root.isHovered = hovered
    }

    function getLayoutIcon(layout) {
        switch (layout) {
        case "dwindle":
            return Icons.dwindle;
        case "master":
            return Icons.master;
        case "scrolling":
            return Icons.scrolling;
        default:
            return Icons.dwindle;
        }
    }

    function getLayoutDisplayName(layout) {
        switch (layout) {
        case "dwindle":
            return "Dwindle";
        case "master":
            return "Master";
        case "scrolling":
            return "Scrolling";
        default:
            return layout;
        }
    }

    // Main button
    StyledRect {
        id: buttonBg
        variant: root.popupOpen ? "primary" : "bg"
        anchors.fill: parent
        enableShadow: root.layerEnabled

        topLeftRadius: root.vertical ? root.startRadius : root.startRadius
        topRightRadius: root.vertical ? root.startRadius : root.endRadius
        bottomLeftRadius: root.vertical ? root.endRadius : root.startRadius
        bottomRightRadius: root.vertical ? root.endRadius : root.endRadius

        Rectangle {
            anchors.fill: parent
            color: Styling.srItem("overprimary")
            opacity: root.popupOpen ? 0 : (root.isHovered ? 0.25 : 0)
            radius: parent.radius ?? 0

            Behavior on opacity {
                enabled: Config.animDuration > 0
                NumberAnimation {
                    duration: Config.animDuration / 2
                }
            }
        }

        Item {
            id: iconContainer
            anchors.centerIn: parent
            width: 18
            height: 18

            Text {
                id: layoutIcon
                anchors.fill: parent
                text: root.getLayoutIcon(GlobalStates.hyprlandLayout)
                font.family: Icons.font
                font.pixelSize: 18
                color: root.popupOpen ? buttonBg.item : Styling.srItem("overprimary")
            }

            Tinted {
                anchors.fill: parent
                sourceItem: layoutIcon
                active: Config.tintIcons
                fullTint: false
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: false
            cursorShape: Qt.PointingHandCursor
            onClicked: layoutPopup.toggle()
        }

        StyledToolTip {
            visible: root.isHovered && !root.popupOpen
            tooltipText: "Layout: " + root.getLayoutDisplayName(GlobalStates.hyprlandLayout)
        }
    }

    // Layout popup
    BarPopup {
        id: layoutPopup
        anchorItem: buttonBg
        bar: root.bar

        contentWidth: layoutRow.implicitWidth + popupPadding * 2
        contentHeight: 36 + popupPadding * 2

        Row {
            id: layoutRow
            anchors.centerIn: parent
            spacing: 4

            readonly property int currentIndex: {
                for (let i = 0; i < GlobalStates.availableLayouts.length; i++) {
                    if (GlobalStates.availableLayouts[i] === GlobalStates.hyprlandLayout) {
                        return i;
                    }
                }
                return 0;
            }

            Repeater {
                model: GlobalStates.availableLayouts

                delegate: StyledRect {
                    id: layoutButton
                    required property string modelData
                    required property int index

                    readonly property bool isSelected: layoutRow.currentIndex === index
                    readonly property bool isFirst: index === 0
                    readonly property bool isLast: index === GlobalStates.availableLayouts.length - 1
                    property bool buttonHovered: false

                    readonly property real defaultRadius: Styling.radius(0)
                    readonly property real selectedRadius: Styling.radius(0) / 2

                    variant: isSelected ? "primary" : (buttonHovered ? "focus" : "common")
                    enableShadow: false
                    width: layoutLabel.implicitWidth + 48
                    height: 36

                    topLeftRadius: isSelected ? (isFirst ? defaultRadius : selectedRadius) : defaultRadius
                    bottomLeftRadius: isSelected ? (isFirst ? defaultRadius : selectedRadius) : defaultRadius
                    topRightRadius: isSelected ? (isLast ? defaultRadius : selectedRadius) : defaultRadius
                    bottomRightRadius: isSelected ? (isLast ? defaultRadius : selectedRadius) : defaultRadius

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8

                        Item {
                            width: 14
                            height: 14

                            Text {
                                id: layoutIcon
                                anchors.fill: parent
                                text: root.getLayoutIcon(layoutButton.modelData)
                                font.family: Icons.font
                                font.pixelSize: 14
                                color: layoutButton.item
                            }

                            Tinted {
                                anchors.fill: parent
                                sourceItem: layoutIcon
                                active: Config.tintIcons
                                fullTint: false
                            }
                        }

                        Text {
                            id: layoutLabel
                            text: root.getLayoutDisplayName(layoutButton.modelData)
                            font.family: Styling.defaultFont
                            font.pixelSize: Styling.fontSize(0)
                            font.bold: true
                            color: layoutButton.item
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onEntered: layoutButton.buttonHovered = true
                        onExited: layoutButton.buttonHovered = false

                        onClicked: {
                            GlobalStates.setHyprlandLayout(layoutButton.modelData);
                        }
                    }
                }
            }
        }
    }
}
