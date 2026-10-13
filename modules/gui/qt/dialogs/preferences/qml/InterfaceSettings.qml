/*****************************************************************************
 * InterfaceSettings.qml : Interface and visual theme preferences card view
 *****************************************************************************
 * Copyright (C) 2026 VLC authors and VideoLAN
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
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
import QtQuick.Controls

import VLC.Style
import VLC.Dialogs

ScrollView {
    id: root

    contentWidth: availableWidth

    ColumnLayout {
        width: root.availableWidth
        spacing: VLCStyle.margin_normal

        PreferenceCard {
            title: qsTr("Visual Effects and Rendering")
            description: qsTr("Frosted glass effects, acrylic blur, and window compositing.")

            PreferenceToggle {
                title: qsTr("Enable frosted glass blur effects")
                description: qsTr("Renders real-time multi-pass GPU blur beneath control bars and navigation panels.")
                checked: VLCStyle.acrylicBlurEnabled
                onToggled: (checked) => {
                    VLCStyle.acrylicBlurEnabled = checked
                }
            }

            PreferenceCombo {
                title: qsTr("Interface Theme")
                description: qsTr("Dark, Light, or follow Operating System theme.")
                configKey: "qt-theme"
                model: [
                    { text: qsTr("Dark (Figma Redesign)"), value: "dark" },
                    { text: qsTr("Follow System"), value: "system" },
                    { text: qsTr("Light"), value: "light" }
                ]
            }
        }

        PreferenceCard {
            title: qsTr("Accent Color")
            description: qsTr("Highlight color applied to active tabs, sliders, and badges.")

            RowLayout {
                Layout.fillWidth: true
                spacing: VLCStyle.margin_normal

                Repeater {
                    model: [
                        { name: "VLC Orange", color: "#D37918" },
                        { name: "Sky Blue", color: "#0284C7" },
                        { name: "Emerald", color: "#10B981" },
                        { name: "Purple", color: "#8B5CF6" },
                        { name: "Amber", color: "#F59E0B" }
                    ]

                    Rectangle {
                        id: colorChip
                        width: VLCStyle.dp(36, VLCStyle.scale)
                        height: VLCStyle.dp(36, VLCStyle.scale)
                        radius: width / 2
                        color: modelData.color
                        border.width: VLCStyle.vlcOrange === modelData.color ? 3 : 1
                        border.color: VLCStyle.vlcOrange === modelData.color ? VLCStyle.darkFgPrimary : VLCStyle.vlcBorderSubtle

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                VLCStyle.vlcOrange = modelData.color
                            }
                        }
                    }
                }
            }
        }

        PreferenceCard {
            title: qsTr("Player Behavior")
            description: qsTr("Fullscreen controls and floating player bar.")

            PreferenceToggle {
                title: qsTr("Show controls when entering fullscreen")
                description: qsTr("Display floating pill control bar on mouse movement in fullscreen mode.")
                configKey: "qt-fs-controller"
                checked: true
            }

            PreferenceToggle {
                title: qsTr("Pause playback when window is minimized")
                description: qsTr("Automatically pause video playback upon window minimization.")
                configKey: "qt-pause-minimized"
                checked: false
            }
        }
    }
}
