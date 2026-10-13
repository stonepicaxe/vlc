/*****************************************************************************
 * Copyright (C) 2026 VLC authors and VideoLAN
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * ( at your option ) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

import QtQuick
import QtQuick.Layouts
import QtQuick.Templates as T

import VLC.MainInterface
import VLC.Style
import VLC.Player
import VLC.Widgets as Widgets
import VLC.Util

Item {
    id: root

    implicitWidth: VLCStyle.dp(600, VLCStyle.scale)
    implicitHeight: drawerLayout.implicitHeight + VLCStyle.margin_large * 2

    signal closeRequested()

    property int currentTab: 0 // 0: Essential, 1: Crop & Aspect, 2: Colors

    // Video adjustment values
    property real contrastValue: 1.0
    property real brightnessValue: 1.0
    property real saturationValue: 1.0
    property real gammaValue: 1.0
    property real hueValue: 0.0

    // Crop / Aspect presets
    readonly property var aspectPresets: ["Default", "1:1", "4:3", "16:9", "16:10", "21:9"]
    property string currentAspect: "Default"

    readonly property var cropPresets: ["Default", "16:9", "4:3", "1:1", "2.35:1"]
    property string currentCrop: "Default"

    // Color filter state
    property bool colorFilterEnabled: false
    property real colorRed: 1.0
    property real colorGreen: 1.0
    property real colorBlue: 1.0

    ColorContext {
        id: theme
        colorSet: ColorContext.Window
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: VLCStyle.panel_radius
        color: VLCStyle.darkBgA3Transparent
        border.width: VLCStyle.border
        border.color: VLCStyle.vlcBorderBright

        layer.enabled: true
        layer.effect: Widgets.FrostedGlassEffect {
            tint: VLCStyle.darkBgA3Transparent
        }
    }

    ColumnLayout {
        id: drawerLayout
        anchors.fill: parent
        anchors.margins: VLCStyle.margin_large
        spacing: VLCStyle.margin_normal

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: VLCStyle.margin_small

            Widgets.SubtitleLabel {
                text: qsTr("Video Adjustments & Filters")
                font.pixelSize: VLCStyle.fontSize_xlarge
                font.weight: Font.Bold
                color: theme.fg.primary
                Layout.fillWidth: true
            }

            Widgets.IconToolButton {
                iconTxt: VLCIcons.close
                size: VLCStyle.icon_normal
                onClicked: root.closeRequested()
            }
        }

        // Sub-tabs
        RowLayout {
            Layout.fillWidth: true
            spacing: VLCStyle.margin_xsmall

            Repeater {
                model: [qsTr("Essential"), qsTr("Crop & Aspect"), qsTr("Colors")]

                delegate: Rectangle {
                    implicitWidth: tabLabel.implicitWidth + VLCStyle.margin_normal * 2
                    implicitHeight: VLCStyle.dp(32, VLCStyle.scale)
                    radius: VLCStyle.chip_radius
                    color: root.currentTab === index ? VLCStyle.vlcOrange : VLCStyle.darkBgB1Transparent
                    border.width: VLCStyle.border
                    border.color: root.currentTab === index ? VLCStyle.vlcOrange : VLCStyle.vlcBorderDim

                    Text {
                        id: tabLabel
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: VLCStyle.fontSize_normal
                        font.weight: root.currentTab === index ? Font.Bold : Font.Normal
                        color: root.currentTab === index ? Qt.black : theme.fg.primary
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.currentTab = index
                    }
                }
            }
        }

        // Tab Content
        StackLayout {
            Layout.fillWidth: true
            currentIndex: root.currentTab

            // Tab 0: Essential Adjustments
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: essCol.implicitHeight + VLCStyle.margin_normal * 2
                radius: VLCStyle.card_radius
                color: VLCStyle.darkBgB1Transparent
                border.width: VLCStyle.border
                border.color: VLCStyle.vlcBorderDim

                ColumnLayout {
                    id: essCol
                    anchors.fill: parent
                    anchors.margins: VLCStyle.margin_normal
                    spacing: VLCStyle.margin_small

                    // Contrast Slider
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: qsTr("Contrast"); color: theme.fg.primary; implicitWidth: VLCStyle.dp(90, VLCStyle.scale) }
                        Widgets.SliderExt {
                            Layout.fillWidth: true
                            from: 0.0; to: 2.0; stepSize: 0.05
                            value: root.contrastValue
                            onMoved: root.contrastValue = value
                        }
                        Text { text: root.contrastValue.toFixed(2); color: VLCStyle.vlcOrange; implicitWidth: VLCStyle.dp(40, VLCStyle.scale) }
                        Widgets.ButtonExt { text: "1.0"; onClicked: root.contrastValue = 1.0 }
                    }

                    // Brightness Slider
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: qsTr("Brightness"); color: theme.fg.primary; implicitWidth: VLCStyle.dp(90, VLCStyle.scale) }
                        Widgets.SliderExt {
                            Layout.fillWidth: true
                            from: 0.0; to: 2.0; stepSize: 0.05
                            value: root.brightnessValue
                            onMoved: root.brightnessValue = value
                        }
                        Text { text: root.brightnessValue.toFixed(2); color: VLCStyle.vlcOrange; implicitWidth: VLCStyle.dp(40, VLCStyle.scale) }
                        Widgets.ButtonExt { text: "1.0"; onClicked: root.brightnessValue = 1.0 }
                    }

                    // Saturation Slider
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: qsTr("Saturation"); color: theme.fg.primary; implicitWidth: VLCStyle.dp(90, VLCStyle.scale) }
                        Widgets.SliderExt {
                            Layout.fillWidth: true
                            from: 0.0; to: 3.0; stepSize: 0.05
                            value: root.saturationValue
                            onMoved: root.saturationValue = value
                        }
                        Text { text: root.saturationValue.toFixed(2); color: VLCStyle.vlcOrange; implicitWidth: VLCStyle.dp(40, VLCStyle.scale) }
                        Widgets.ButtonExt { text: "1.0"; onClicked: root.saturationValue = 1.0 }
                    }

                    // Gamma Slider
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: qsTr("Gamma"); color: theme.fg.primary; implicitWidth: VLCStyle.dp(90, VLCStyle.scale) }
                        Widgets.SliderExt {
                            Layout.fillWidth: true
                            from: 0.1; to: 5.0; stepSize: 0.05
                            value: root.gammaValue
                            onMoved: root.gammaValue = value
                        }
                        Text { text: root.gammaValue.toFixed(2); color: VLCStyle.vlcOrange; implicitWidth: VLCStyle.dp(40, VLCStyle.scale) }
                        Widgets.ButtonExt { text: "1.0"; onClicked: root.gammaValue = 1.0 }
                    }

                    // Hue Slider
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: qsTr("Hue"); color: theme.fg.primary; implicitWidth: VLCStyle.dp(90, VLCStyle.scale) }
                        Widgets.SliderExt {
                            Layout.fillWidth: true
                            from: -180; to: 180; stepSize: 1
                            value: root.hueValue
                            onMoved: root.hueValue = Math.round(value)
                        }
                        Text { text: root.hueValue + "°"; color: VLCStyle.vlcOrange; implicitWidth: VLCStyle.dp(40, VLCStyle.scale) }
                        Widgets.ButtonExt { text: "0°"; onClicked: root.hueValue = 0 }
                    }

                    // Reset All
                    RowLayout {
                        Layout.fillWidth: true
                        Item { Layout.fillWidth: true }
                        Widgets.ButtonExt {
                            text: qsTr("Reset All Adjustments")
                            onClicked: {
                                root.contrastValue = 1.0
                                root.brightnessValue = 1.0
                                root.saturationValue = 1.0
                                root.gammaValue = 1.0
                                root.hueValue = 0
                            }
                        }
                    }
                }
            }

            // Tab 1: Crop & Aspect Ratio
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: cropCol.implicitHeight + VLCStyle.margin_normal * 2
                radius: VLCStyle.card_radius
                color: VLCStyle.darkBgB1Transparent
                border.width: VLCStyle.border
                border.color: VLCStyle.vlcBorderDim

                ColumnLayout {
                    id: cropCol
                    anchors.fill: parent
                    anchors.margins: VLCStyle.margin_normal
                    spacing: VLCStyle.margin_normal

                    Widgets.CaptionLabel {
                        text: qsTr("Aspect Ratio")
                        font.weight: Font.DemiBold
                        color: theme.fg.primary
                    }

                    RowLayout {
                        spacing: VLCStyle.margin_xsmall
                        Repeater {
                            model: root.aspectPresets
                            delegate: Rectangle {
                                implicitWidth: aText.implicitWidth + VLCStyle.margin_normal * 2
                                implicitHeight: VLCStyle.dp(30, VLCStyle.scale)
                                radius: VLCStyle.chip_radius
                                color: root.currentAspect === modelData ? VLCStyle.vlcOrange : VLCStyle.vlcBorderDim
                                Text {
                                    id: aText
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.pixelSize: VLCStyle.fontSize_small
                                    color: root.currentAspect === modelData ? Qt.black : theme.fg.primary
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.currentAspect = modelData
                                }
                            }
                        }
                    }

                    Widgets.CaptionLabel {
                        text: qsTr("Crop Ratio")
                        font.weight: Font.DemiBold
                        color: theme.fg.primary
                    }

                    RowLayout {
                        spacing: VLCStyle.margin_xsmall
                        Repeater {
                            model: root.cropPresets
                            delegate: Rectangle {
                                implicitWidth: cText.implicitWidth + VLCStyle.margin_normal * 2
                                implicitHeight: VLCStyle.dp(30, VLCStyle.scale)
                                radius: VLCStyle.chip_radius
                                color: root.currentCrop === modelData ? VLCStyle.vlcOrange : VLCStyle.vlcBorderDim
                                Text {
                                    id: cText
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.pixelSize: VLCStyle.fontSize_small
                                    color: root.currentCrop === modelData ? Qt.black : theme.fg.primary
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.currentCrop = modelData
                                }
                            }
                        }
                    }
                }
            }

            // Tab 2: Color Filters
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: colCol.implicitHeight + VLCStyle.margin_normal * 2
                radius: VLCStyle.card_radius
                color: VLCStyle.darkBgB1Transparent
                border.width: VLCStyle.border
                border.color: VLCStyle.vlcBorderDim

                ColumnLayout {
                    id: colCol
                    anchors.fill: parent
                    anchors.margins: VLCStyle.margin_normal
                    spacing: VLCStyle.margin_small

                    RowLayout {
                        Layout.fillWidth: true
                        Widgets.CaptionLabel {
                            text: qsTr("Color Filter")
                            font.weight: Font.DemiBold
                            color: theme.fg.primary
                            Layout.fillWidth: true
                        }

                        Widgets.CheckButton {
                            checked: root.colorFilterEnabled
                            onToggled: root.colorFilterEnabled = checked
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        enabled: root.colorFilterEnabled
                        opacity: enabled ? 1.0 : 0.4
                        Text { text: qsTr("Red Tint"); color: "#FF4444"; implicitWidth: VLCStyle.dp(90, VLCStyle.scale) }
                        Widgets.SliderExt { Layout.fillWidth: true; from: 0.0; to: 2.0; value: root.colorRed; onMoved: root.colorRed = value }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        enabled: root.colorFilterEnabled
                        opacity: enabled ? 1.0 : 0.4
                        Text { text: qsTr("Green Tint"); color: "#44FF44"; implicitWidth: VLCStyle.dp(90, VLCStyle.scale) }
                        Widgets.SliderExt { Layout.fillWidth: true; from: 0.0; to: 2.0; value: root.colorGreen; onMoved: root.colorGreen = value }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        enabled: root.colorFilterEnabled
                        opacity: enabled ? 1.0 : 0.4
                        Text { text: qsTr("Blue Tint"); color: "#4488FF"; implicitWidth: VLCStyle.dp(90, VLCStyle.scale) }
                        Widgets.SliderExt { Layout.fillWidth: true; from: 0.0; to: 2.0; value: root.colorBlue; onMoved: root.colorBlue = value }
                    }
                }
            }
        }
    }
}
