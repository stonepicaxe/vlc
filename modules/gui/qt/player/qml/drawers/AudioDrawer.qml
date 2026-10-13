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

    implicitWidth: VLCStyle.dp(680, VLCStyle.scale)
    implicitHeight: drawerLayout.implicitHeight + VLCStyle.margin_large * 2

    signal closeRequested()

    property int currentTab: 0 // 0: Equalizer, 1: Compressor, 2: Spatializer, 3: Stereo Widener

    // Preset bands definitions
    readonly property var presets: [
        { name: qsTr("Flat"), preamp: 0.0, bands: [0,0,0,0,0,0,0,0,0,0] },
        { name: qsTr("Rock"), preamp: 0.0, bands: [4.8,3.2,1.6,-1.6,-3.2,-2.4,1.6,4.0,5.6,6.4] },
        { name: qsTr("Pop"), preamp: 0.0, bands: [-1.6,1.6,4.0,4.8,3.2,-1.6,-2.4,-2.4,-1.6,-1.6] },
        { name: qsTr("Full Bass"), preamp: 0.0, bands: [8.0,8.0,8.0,4.8,1.6,-3.2,-6.4,-8.0,-8.0,-8.0] },
        { name: qsTr("Classical"), preamp: 0.0, bands: [4.8,4.0,3.2,2.4,-1.6,-1.6,0.0,2.4,3.2,4.0] },
        { name: qsTr("Club"), preamp: 0.0, bands: [0.0,0.0,1.6,3.2,3.2,3.2,1.6,0.0,0.0,0.0] },
        { name: qsTr("Dance"), preamp: 0.0, bands: [8.0,5.6,2.4,0.0,1.6,3.2,4.8,4.0,2.4,0.0] },
        { name: qsTr("Live"), preamp: 0.0, bands: [-3.2,0.0,1.6,2.4,2.4,2.4,1.6,0.8,0.8,0.8] },
        { name: qsTr("Techno"), preamp: 0.0, bands: [6.4,4.8,0.0,-4.0,-3.2,0.0,6.4,7.2,7.2,6.4] }
    ]

    readonly property var bandFrequencies: [
        "60 Hz", "170 Hz", "310 Hz", "600 Hz",
        "1 kHz", "3 kHz", "6 kHz", "12 kHz",
        "14 kHz", "16 kHz"
    ]

    property real preampValue: 0.0
    property var bandValues: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

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
                text: qsTr("Audio Effects & Equalizer")
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
                model: [qsTr("Equalizer"), qsTr("Compressor"), qsTr("Spatializer"), qsTr("Stereo Widener")]

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

            // Tab 0: Equalizer
            ColumnLayout {
                spacing: VLCStyle.margin_normal

                // Preset selector & Preamp
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: presetRow.implicitHeight + VLCStyle.margin_normal * 2
                    radius: VLCStyle.card_radius
                    color: VLCStyle.darkBgB1Transparent
                    border.width: VLCStyle.border
                    border.color: VLCStyle.vlcBorderDim

                    RowLayout {
                        id: presetRow
                        anchors.fill: parent
                        anchors.margins: VLCStyle.margin_normal
                        spacing: VLCStyle.margin_normal

                        Widgets.CaptionLabel {
                            text: qsTr("Preset:")
                            color: theme.fg.primary
                        }

                        // Presets List
                        RowLayout {
                            spacing: VLCStyle.margin_xxsmall
                            Repeater {
                                model: root.presets
                                delegate: Rectangle {
                                    implicitWidth: pText.implicitWidth + VLCStyle.margin_small
                                    implicitHeight: VLCStyle.dp(26, VLCStyle.scale)
                                    radius: VLCStyle.chip_radius
                                    color: VLCStyle.vlcBorderDim
                                    Text {
                                        id: pText
                                        anchors.centerIn: parent
                                        text: modelData.name
                                        font.pixelSize: VLCStyle.fontSize_small
                                        color: theme.fg.primary
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            root.preampValue = modelData.preamp
                                            var newBands = []
                                            for (var b = 0; b < modelData.bands.length; b++)
                                                newBands.push(modelData.bands[b])
                                            root.bandValues = newBands
                                        }
                                    }
                                }
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Widgets.ButtonExt {
                            text: qsTr("Zero All")
                            onClicked: {
                                root.preampValue = 0.0
                                root.bandValues = [0,0,0,0,0,0,0,0,0,0]
                            }
                        }
                    }
                }

                // 10-Band Sliders Array Card
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: VLCStyle.dp(220, VLCStyle.scale)
                    radius: VLCStyle.card_radius
                    color: VLCStyle.darkBgB1Transparent
                    border.width: VLCStyle.border
                    border.color: VLCStyle.vlcBorderDim

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: VLCStyle.margin_normal
                        spacing: VLCStyle.margin_small

                        // Preamp Vertical Column
                        ColumnLayout {
                            Layout.fillHeight: true
                            implicitWidth: VLCStyle.dp(48, VLCStyle.scale)
                            spacing: VLCStyle.margin_xxsmall

                            Text {
                                text: root.preampValue.toFixed(1) + " dB"
                                font.pixelSize: VLCStyle.fontSize_xsmall
                                color: VLCStyle.vlcOrange
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Widgets.SliderExt {
                                Layout.fillHeight: true
                                Layout.alignment: Qt.AlignHCenter
                                orientation: Qt.Vertical
                                from: -20.0
                                to: 20.0
                                stepSize: 0.5
                                value: root.preampValue
                                onMoved: root.preampValue = value
                            }

                            Text {
                                text: qsTr("Preamp")
                                font.pixelSize: VLCStyle.fontSize_xsmall
                                font.weight: Font.Bold
                                color: theme.fg.primary
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        Rectangle {
                            implicitWidth: 1
                            Layout.fillHeight: true
                            color: VLCStyle.vlcBorderDim
                        }

                        // 10 Frequency Band Sliders
                        Repeater {
                            model: 10

                            delegate: ColumnLayout {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                spacing: VLCStyle.margin_xxsmall

                                Text {
                                    text: (root.bandValues[index] ?? 0).toFixed(1) + " dB"
                                    font.pixelSize: VLCStyle.fontSize_xsmall
                                    color: (root.bandValues[index] !== 0) ? VLCStyle.vlcOrange : theme.fg.secondary
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Widgets.SliderExt {
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignHCenter
                                    orientation: Qt.Vertical
                                    from: -20.0
                                    to: 20.0
                                    stepSize: 0.5
                                    value: root.bandValues[index] ?? 0
                                    onMoved: {
                                        var copy = root.bandValues.slice()
                                        copy[index] = value
                                        root.bandValues = copy
                                    }
                                }

                                Text {
                                    text: root.bandFrequencies[index]
                                    font.pixelSize: VLCStyle.fontSize_xsmall
                                    color: theme.fg.primary
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }
                    }
                }
            }

            // Tab 1: Compressor
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: compCol.implicitHeight + VLCStyle.margin_normal * 2
                radius: VLCStyle.card_radius
                color: VLCStyle.darkBgB1Transparent
                border.width: VLCStyle.border
                border.color: VLCStyle.vlcBorderDim

                ColumnLayout {
                    id: compCol
                    anchors.fill: parent
                    anchors.margins: VLCStyle.margin_normal
                    spacing: VLCStyle.margin_small

                    Widgets.CaptionLabel {
                        text: qsTr("Dynamic Range Compressor")
                        font.weight: Font.DemiBold
                        color: theme.fg.primary
                    }

                    GridLayout {
                        columns: 4
                        columnSpacing: VLCStyle.margin_normal
                        rowSpacing: VLCStyle.margin_small

                        Text { text: qsTr("Attack:"); color: theme.fg.secondary }
                        Widgets.SliderExt { from: 1.5; to: 400; value: 25; Layout.fillWidth: true }
                        Text { text: qsTr("Release:"); color: theme.fg.secondary }
                        Widgets.SliderExt { from: 2; to: 800; value: 100; Layout.fillWidth: true }

                        Text { text: qsTr("Threshold:"); color: theme.fg.secondary }
                        Widgets.SliderExt { from: -30; to: 0; value: -12; Layout.fillWidth: true }
                        Text { text: qsTr("Ratio:"); color: theme.fg.secondary }
                        Widgets.SliderExt { from: 1; to: 20; value: 4; Layout.fillWidth: true }
                    }
                }
            }

            // Tab 2: Spatializer
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: spatCol.implicitHeight + VLCStyle.margin_normal * 2
                radius: VLCStyle.card_radius
                color: VLCStyle.darkBgB1Transparent
                border.width: VLCStyle.border
                border.color: VLCStyle.vlcBorderDim

                ColumnLayout {
                    id: spatCol
                    anchors.fill: parent
                    anchors.margins: VLCStyle.margin_normal
                    spacing: VLCStyle.margin_small

                    Widgets.CaptionLabel {
                        text: qsTr("Room Spatializer")
                        font.weight: Font.DemiBold
                        color: theme.fg.primary
                    }

                    GridLayout {
                        columns: 4
                        columnSpacing: VLCStyle.margin_normal
                        rowSpacing: VLCStyle.margin_small

                        Text { text: qsTr("Room Size:"); color: theme.fg.secondary }
                        Widgets.SliderExt { from: 0; to: 100; value: 30; Layout.fillWidth: true }
                        Text { text: qsTr("Width:"); color: theme.fg.secondary }
                        Widgets.SliderExt { from: 0; to: 100; value: 70; Layout.fillWidth: true }

                        Text { text: qsTr("Wet Level:"); color: theme.fg.secondary }
                        Widgets.SliderExt { from: 0; to: 100; value: 20; Layout.fillWidth: true }
                        Text { text: qsTr("Dry Level:"); color: theme.fg.secondary }
                        Widgets.SliderExt { from: 0; to: 100; value: 80; Layout.fillWidth: true }
                    }
                }
            }

            // Tab 3: Stereo Widener
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: wideCol.implicitHeight + VLCStyle.margin_normal * 2
                radius: VLCStyle.card_radius
                color: VLCStyle.darkBgB1Transparent
                border.width: VLCStyle.border
                border.color: VLCStyle.vlcBorderDim

                ColumnLayout {
                    id: wideCol
                    anchors.fill: parent
                    anchors.margins: VLCStyle.margin_normal
                    spacing: VLCStyle.margin_small

                    Widgets.CaptionLabel {
                        text: qsTr("Stereo Sound Widener")
                        font.weight: Font.DemiBold
                        color: theme.fg.primary
                    }

                    GridLayout {
                        columns: 2
                        columnSpacing: VLCStyle.margin_normal
                        rowSpacing: VLCStyle.margin_small

                        Text { text: qsTr("Delay Time (ms):"); color: theme.fg.secondary }
                        Widgets.SliderExt { from: 0; to: 100; value: 20; Layout.fillWidth: true }

                        Text { text: qsTr("Crossfeed Level (%):"); color: theme.fg.secondary }
                        Widgets.SliderExt { from: 0; to: 100; value: 40; Layout.fillWidth: true }
                    }
                }
            }
        }
    }
}
