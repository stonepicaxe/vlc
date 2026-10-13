/*****************************************************************************
 * NewPlaylistDialog.qml : Native modal for creating playlists
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

    title: qsTr("New Playlist")
    flags: Qt.Dialog | Qt.WindowCloseButtonHint

    width: VLCStyle.dp(460, VLCStyle.scale)
    height: VLCStyle.dp(340, VLCStyle.scale)
    minimumWidth: VLCStyle.dp(400, VLCStyle.scale)
    minimumHeight: VLCStyle.dp(300, VLCStyle.scale)

    color: "transparent"

    property string selectedType: "mixed"

    signal playlistCreated(string name, string type)

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
                    text: qsTr("Create New Playlist")
                    color: VLCStyle.darkFgPrimary
                    font.pixelSize: VLCStyle.fontSize_large
                    font.weight: Font.DemiBold
                }

                Item { Layout.fillWidth: true }

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

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: qsTr("Playlist Name")
                    color: VLCStyle.darkFgSecondary
                    font.pixelSize: VLCStyle.fontSize_small
                }

                TextField {
                    id: nameField
                    Layout.fillWidth: true
                    Layout.preferredHeight: VLCStyle.dp(36, VLCStyle.scale)
                    placeholderText: qsTr("My Playlist")
                    color: VLCStyle.darkFgPrimary
                    font.pixelSize: VLCStyle.fontSize_normal

                    background: Rectangle {
                        radius: VLCStyle.control_radius
                        color: VLCStyle.darkBgA1Transparent
                        border.width: VLCStyle.border
                        border.color: nameField.activeFocus ? VLCStyle.vlcOrange : VLCStyle.vlcBorderSubtle
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: qsTr("Playlist Type")
                    color: VLCStyle.darkFgSecondary
                    font.pixelSize: VLCStyle.fontSize_small
                }

                RowLayout {
                    spacing: VLCStyle.margin_small

                    Repeater {
                        model: [
                            { id: "mixed", label: qsTr("Mixed Media") },
                            { id: "audio", label: qsTr("Music Only") },
                            { id: "video", label: qsTr("Video Only") }
                        ]

                        Rectangle {
                            radius: VLCStyle.chip_radius
                            color: (root.selectedType === modelData.id) ? VLCStyle.vlcOrange : VLCStyle.darkBgA1Transparent
                            border.width: VLCStyle.border
                            border.color: (root.selectedType === modelData.id) ? VLCStyle.vlcOrange : VLCStyle.vlcBorderSubtle
                            implicitWidth: typeLabel.implicitWidth + VLCStyle.margin_normal * 2
                            implicitHeight: VLCStyle.dp(28, VLCStyle.scale)

                            Text {
                                id: typeLabel
                                anchors.centerIn: parent
                                text: modelData.label
                                color: (root.selectedType === modelData.id) ? "#FFFFFF" : VLCStyle.darkFgPrimary
                                font.pixelSize: VLCStyle.fontSize_small
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.selectedType = modelData.id
                            }
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }

            RowLayout {
                Layout.fillWidth: true
                spacing: VLCStyle.margin_normal

                Item { Layout.fillWidth: true }

                Button {
                    text: qsTr("Cancel")
                    Layout.preferredHeight: VLCStyle.dp(34, VLCStyle.scale)

                    background: Rectangle {
                        radius: VLCStyle.control_radius
                        color: parent.down ? VLCStyle.darkBgB2Transparent : VLCStyle.darkBgB1Transparent
                        border.width: VLCStyle.border
                        border.color: VLCStyle.vlcBorderSubtle
                    }

                    contentItem: Text {
                        text: parent.text
                        color: VLCStyle.darkFgPrimary
                        font.pixelSize: VLCStyle.fontSize_normal
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: root.close()
                }

                Button {
                    text: qsTr("Create Playlist")
                    Layout.preferredHeight: VLCStyle.dp(34, VLCStyle.scale)
                    enabled: nameField.text.trim().length > 0

                    background: Rectangle {
                        radius: VLCStyle.control_radius
                        color: parent.enabled ? (parent.down ? VLCStyle.vlcOrangeLight : VLCStyle.vlcOrange) : VLCStyle.darkBgB1Transparent
                        opacity: parent.enabled ? 1.0 : 0.5
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "#FFFFFF"
                        font.pixelSize: VLCStyle.fontSize_normal
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        root.playlistCreated(nameField.text.trim(), root.selectedType)
                        root.close()
                    }
                }
            }
        }
    }
}
