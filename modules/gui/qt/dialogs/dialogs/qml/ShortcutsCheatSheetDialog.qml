/*****************************************************************************
 * ShortcutsCheatSheetDialog.qml : Visual cheat sheet modal for keyboard shortcuts
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
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

import VLC.Style
import VLC.Dialogs
import VLC.Widgets as Widgets

Window {
    id: root

    title: qsTr("Keyboard Shortcuts Cheat Sheet")
    flags: Qt.Dialog | Qt.WindowCloseButtonHint

    width: VLCStyle.dp(720, VLCStyle.scale)
    height: VLCStyle.dp(560, VLCStyle.scale)
    minimumWidth: VLCStyle.dp(600, VLCStyle.scale)
    minimumHeight: VLCStyle.dp(440, VLCStyle.scale)

    color: "transparent"

    property string searchQuery: ""

    readonly property var sections: [
        {
            category: qsTr("Playback Controls"),
            items: [
                { action: qsTr("Play / Pause"), key: "Space" },
                { action: qsTr("Stop Playback"), key: "S" },
                { action: qsTr("Toggle Fullscreen"), key: "F" },
                { action: qsTr("Jump 3 Seconds Back"), key: "Shift + Left" },
                { action: qsTr("Jump 3 Seconds Forward"), key: "Shift + Right" },
                { action: qsTr("Jump 10 Seconds Back"), key: "Alt + Left" },
                { action: qsTr("Jump 10 Seconds Forward"), key: "Alt + Right" },
                { action: qsTr("Jump 1 Minute Back"), key: "Ctrl + Left" },
                { action: qsTr("Jump 1 Minute Forward"), key: "Ctrl + Right" }
            ]
        },
        {
            category: qsTr("Audio & Video"),
            items: [
                { action: qsTr("Volume Up"), key: "Ctrl + Up" },
                { action: qsTr("Volume Down"), key: "Ctrl + Down" },
                { action: qsTr("Mute Audio"), key: "M" },
                { action: qsTr("Audio & Video Effects (Equalizer)"), key: "Ctrl + E" },
                { action: qsTr("Cycle Audio Track"), key: "B" },
                { action: qsTr("Audio Delay (-50ms)"), key: "J" },
                { action: qsTr("Audio Delay (+50ms)"), key: "K" },
                { action: qsTr("Take Video Snapshot"), key: "Shift + S" }
            ]
        },
        {
            category: qsTr("Subtitles & Navigation"),
            items: [
                { action: qsTr("Cycle Subtitle Track"), key: "V" },
                { action: qsTr("Subtitle Delay (-50ms)"), key: "G" },
                { action: qsTr("Subtitle Delay (+50ms)"), key: "H" },
                { action: qsTr("Next Playlist Item"), key: "N" },
                { action: qsTr("Previous Playlist Item"), key: "P" },
                { action: qsTr("Open Preferences"), key: "Ctrl + P" },
                { action: qsTr("Open Media File"), key: "Ctrl + O" },
                { action: qsTr("Open Network Stream"), key: "Ctrl + N" },
                { action: qsTr("Quit VLC"), key: "Ctrl + Q" }
            ]
        }
    ]

    Rectangle {
        anchors.fill: parent
        radius: VLCStyle.panel_radius
        color: VLCStyle.darkBgA3Transparent
        border.width: VLCStyle.border
        border.color: VLCStyle.vlcBorderBright

        layer.enabled: true
        layer.effect: Widgets.FrostedGlassEffect {
            tint: VLCStyle.darkBgA3Transparent
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: VLCStyle.margin_large
            spacing: VLCStyle.margin_normal

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: qsTr("Keyboard Shortcuts Cheat Sheet")
                    color: VLCStyle.darkFgPrimary
                    font.pixelSize: VLCStyle.fontSize_large
                    font.weight: Font.DemiBold
                }

                Item { Layout.fillWidth: true }

                TextField {
                    id: searchField
                    Layout.preferredWidth: VLCStyle.dp(200, VLCStyle.scale)
                    Layout.preferredHeight: VLCStyle.dp(30, VLCStyle.scale)
                    placeholderText: qsTr("Search shortcut...")
                    color: VLCStyle.darkFgPrimary
                    font.pixelSize: VLCStyle.fontSize_small

                    background: Rectangle {
                        radius: VLCStyle.pill_radius
                        color: VLCStyle.darkBgA1Transparent
                        border.width: VLCStyle.border
                        border.color: searchField.activeFocus ? VLCStyle.vlcOrange : VLCStyle.vlcBorderSubtle
                    }

                    onTextChanged: root.searchQuery = text.toLowerCase()
                }

                Rectangle {
                    width: VLCStyle.dp(26, VLCStyle.scale)
                    height: VLCStyle.dp(26, VLCStyle.scale)
                    radius: width / 2
                    color: closeArea.containsMouse ? VLCStyle.darkBgB2Transparent : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: VLCIcons.close
                        font.family: VLCIcons.fontFamily
                        color: VLCStyle.darkFgSecondary
                        font.pixelSize: VLCStyle.icon_small
                    }

                    MouseArea {
                        id: closeArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.close()
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: VLCStyle.border
                color: VLCStyle.vlcBorderSubtle
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: availableWidth

                ColumnLayout {
                    width: parent.width
                    spacing: VLCStyle.margin_large

                    Repeater {
                        model: root.sections

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: VLCStyle.margin_small

                            Text {
                                text: modelData.category
                                color: VLCStyle.vlcOrange
                                font.pixelSize: VLCStyle.fontSize_normal
                                font.weight: Font.DemiBold
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                radius: VLCStyle.card_radius
                                color: VLCStyle.darkBgB1Transparent
                                border.width: VLCStyle.border
                                border.color: VLCStyle.vlcBorderSubtle
                                implicitHeight: sectionCol.implicitHeight + VLCStyle.margin_small * 2

                                ColumnLayout {
                                    id: sectionCol
                                    anchors.fill: parent
                                    anchors.margins: VLCStyle.margin_small
                                    spacing: VLCStyle.margin_xxsmall

                                    Repeater {
                                        model: modelData.items.filter(item => {
                                            if (root.searchQuery.length === 0)
                                                return true
                                            return item.action.toLowerCase().includes(root.searchQuery) ||
                                                   item.key.toLowerCase().includes(root.searchQuery)
                                        })

                                        RowLayout {
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: VLCStyle.dp(28, VLCStyle.scale)

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
                                                implicitWidth: keyTxt.implicitWidth + VLCStyle.margin_normal * 2
                                                implicitHeight: VLCStyle.dp(22, VLCStyle.scale)

                                                Text {
                                                    id: keyTxt
                                                    anchors.centerIn: parent
                                                    text: modelData.key
                                                    color: VLCStyle.darkFgPrimary
                                                    font.pixelSize: VLCStyle.fontSize_small
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
