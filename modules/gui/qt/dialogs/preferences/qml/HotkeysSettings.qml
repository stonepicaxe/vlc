/*****************************************************************************
 * HotkeysSettings.qml : Hotkeys and keyboard shortcuts preferences card view
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
import VLC.Widgets as Widgets

ScrollView {
    id: root

    contentWidth: availableWidth

    property string searchQuery: ""

    readonly property var shortcutsList: [
        { action: qsTr("Play / Pause"), key: "key-play-pause", defaultBinding: "Space" },
        { action: qsTr("Toggle Fullscreen"), key: "key-fullscreen", defaultBinding: "F" },
        { action: qsTr("Mute Audio"), key: "key-vol-mute", defaultBinding: "M" },
        { action: qsTr("Volume Up"), key: "key-vol-up", defaultBinding: "Ctrl+Up" },
        { action: qsTr("Volume Down"), key: "key-vol-down", defaultBinding: "Ctrl+Down" },
        { action: qsTr("Next Playlist Item"), key: "key-next", defaultBinding: "N" },
        { action: qsTr("Previous Playlist Item"), key: "key-prev", defaultBinding: "P" },
        { action: qsTr("Cycle Subtitle Track"), key: "key-subtitle-track", defaultBinding: "V" },
        { action: qsTr("Cycle Audio Track"), key: "key-audio-track", defaultBinding: "B" },
        { action: qsTr("Audio & Video Effects"), key: "key-extended", defaultBinding: "Ctrl+E" },
        { action: qsTr("Jump 10 Seconds Forward"), key: "key-jump+short", defaultBinding: "Shift+Right" },
        { action: qsTr("Jump 10 Seconds Backward"), key: "key-jump-short", defaultBinding: "Shift+Left" },
        { action: qsTr("Take Video Snapshot"), key: "key-snapshot", defaultBinding: "Shift+S" },
        { action: qsTr("Preferences"), key: "key-preferences", defaultBinding: "Ctrl+P" },
        { action: qsTr("Quit VLC"), key: "key-quit", defaultBinding: "Ctrl+Q" }
    ]

    ColumnLayout {
        width: root.availableWidth
        spacing: VLCStyle.margin_normal

        PreferenceCard {
            title: qsTr("Keyboard Shortcuts")
            description: qsTr("Search and customize keyboard hotkeys for playback controls.")

            TextField {
                id: filterInput
                Layout.fillWidth: true
                Layout.preferredHeight: VLCStyle.dp(34, VLCStyle.scale)
                placeholderText: qsTr("Filter hotkey actions...")
                color: VLCStyle.darkFgPrimary
                font.pixelSize: VLCStyle.fontSize_normal

                background: Rectangle {
                    radius: VLCStyle.control_radius
                    color: VLCStyle.darkBgA1Transparent
                    border.width: VLCStyle.border
                    border.color: filterInput.activeFocus ? VLCStyle.vlcOrange : VLCStyle.vlcBorderSubtle
                }

                onTextChanged: root.searchQuery = text.toLowerCase()
            }

            ListView {
                Layout.fillWidth: true
                implicitHeight: contentHeight
                interactive: false
                spacing: VLCStyle.margin_xxsmall

                model: root.shortcutsList.filter(item => {
                    if (root.searchQuery.length === 0)
                        return true
                    return item.action.toLowerCase().includes(root.searchQuery) ||
                           item.defaultBinding.toLowerCase().includes(root.searchQuery)
                })

                delegate: Rectangle {
                    width: ListView.view.width
                    height: VLCStyle.dp(38, VLCStyle.scale)
                    radius: VLCStyle.control_radius
                    color: itemMouseArea.containsMouse ? VLCStyle.darkBgB2Transparent : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: VLCStyle.margin_small
                        anchors.rightMargin: VLCStyle.margin_small

                        Text {
                            text: modelData.action
                            color: VLCStyle.darkFgPrimary
                            font.pixelSize: VLCStyle.fontSize_normal
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }

                        Rectangle {
                            radius: VLCStyle.chip_radius
                            color: VLCStyle.darkBgA2Transparent
                            border.width: VLCStyle.border
                            border.color: VLCStyle.vlcBorderSubtle
                            implicitWidth: keyLabel.implicitWidth + VLCStyle.margin_normal * 2
                            implicitHeight: VLCStyle.dp(24, VLCStyle.scale)

                            Text {
                                id: keyLabel
                                anchors.centerIn: parent
                                text: modelData.defaultBinding
                                color: VLCStyle.vlcOrange
                                font.pixelSize: VLCStyle.fontSize_small
                                font.weight: Font.DemiBold
                            }
                        }
                    }

                    MouseArea {
                        id: itemMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }
            }
        }
    }
}
