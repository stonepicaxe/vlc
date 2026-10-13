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
import VLC.Dialogs

Item {
    id: root

    implicitWidth: VLCStyle.dp(540, VLCStyle.scale)
    implicitHeight: drawerLayout.implicitHeight + VLCStyle.margin_large * 2

    signal closeRequested()

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
                text: qsTr("Subtitles")
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

        // Subtitle Delay Scrubber Section
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: delayCol.implicitHeight + VLCStyle.margin_normal * 2
            radius: VLCStyle.card_radius
            color: VLCStyle.darkBgB1Transparent
            border.width: VLCStyle.border
            border.color: VLCStyle.vlcBorderDim

            ColumnLayout {
                id: delayCol
                anchors.fill: parent
                anchors.margins: VLCStyle.margin_normal
                spacing: VLCStyle.margin_small

                RowLayout {
                    Layout.fillWidth: true

                    Widgets.CaptionLabel {
                        text: qsTr("Timing Synchronization")
                        font.weight: Font.DemiBold
                        color: theme.fg.primary
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        implicitWidth: delayValueText.implicitWidth + VLCStyle.margin_normal
                        implicitHeight: VLCStyle.dp(24, VLCStyle.scale)
                        radius: VLCStyle.chip_radius
                        color: (Player.subtitleDelayMS !== 0) ? VLCStyle.vlcOrange : VLCStyle.vlcBorderBright

                        Text {
                            id: delayValueText
                            anchors.centerIn: parent
                            text: {
                                const d = Player.subtitleDelayMS
                                return (d > 0 ? "+" : "") + d + " ms"
                            }
                            font.pixelSize: VLCStyle.fontSize_small
                            font.weight: Font.Bold
                            color: (Player.subtitleDelayMS !== 0) ? Qt.black : theme.fg.primary
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: VLCStyle.margin_small

                    Widgets.ButtonExt {
                        text: "-50 ms"
                        onClicked: Player.setSubtitleDelayMS(Player.subtitleDelayMS - 50)
                    }

                    Widgets.SliderExt {
                        id: delaySlider
                        Layout.fillWidth: true
                        from: -5000
                        to: 5000
                        stepSize: 50
                        value: Player.subtitleDelayMS
                        onMoved: Player.setSubtitleDelayMS(Math.round(value))
                    }

                    Widgets.ButtonExt {
                        text: "+50 ms"
                        onClicked: Player.setSubtitleDelayMS(Player.subtitleDelayMS + 50)
                    }

                    Widgets.ButtonExt {
                        text: qsTr("Reset")
                        enabled: Player.subtitleDelayMS !== 0
                        onClicked: Player.setSubtitleDelayMS(0)
                    }
                }
            }
        }

        // Active Subtitle Tracks Section
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: tracksCol.implicitHeight + VLCStyle.margin_normal * 2
            radius: VLCStyle.card_radius
            color: VLCStyle.darkBgB1Transparent
            border.width: VLCStyle.border
            border.color: VLCStyle.vlcBorderDim

            ColumnLayout {
                id: tracksCol
                anchors.fill: parent
                anchors.margins: VLCStyle.margin_normal
                spacing: VLCStyle.margin_small

                Widgets.CaptionLabel {
                    text: qsTr("Tracks")
                    font.weight: Font.DemiBold
                    color: theme.fg.primary
                }

                ListView {
                    id: tracksList
                    Layout.fillWidth: true
                    implicitHeight: Math.min(contentHeight, VLCStyle.dp(160, VLCStyle.scale))
                    clip: true
                    model: Player.subtitleTracks

                    delegate: Widgets.CheckedDelegate {
                        width: tracksList.width
                        height: VLCStyle.dp(36, VLCStyle.scale)
                        text: model.display
                        checked: model.checked
                        onClicked: {
                            model.checked = true
                        }
                    }
                }
            }
        }

        // Subtitle Actions
        RowLayout {
            Layout.fillWidth: true
            spacing: VLCStyle.margin_small

            Widgets.ButtonExt {
                Layout.fillWidth: true
                text: qsTr("Load from Computer...")
                onClicked: {
                    DialogsProvider.loadSubtitlesFile()
                }
            }
        }
    }
}
