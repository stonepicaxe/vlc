/*****************************************************************************
 * AccountSettings.qml : Connected accounts and scrobbling card view
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
            title: qsTr("VideoLAN Sync Profile")
            description: qsTr("Sync playlists and media library across devices.")

            RowLayout {
                Layout.fillWidth: true
                spacing: VLCStyle.margin_normal

                Rectangle {
                    width: VLCStyle.dp(48, VLCStyle.scale)
                    height: VLCStyle.dp(48, VLCStyle.scale)
                    radius: width / 2
                    color: VLCStyle.darkBgB2Transparent
                    border.width: VLCStyle.border
                    border.color: VLCStyle.vlcBorderSubtle

                    Text {
                        anchors.centerIn: parent
                        text: "👤"
                        font.pixelSize: VLCStyle.fontSize_large
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: qsTr("Not Connected")
                        color: VLCStyle.darkFgPrimary
                        font.pixelSize: VLCStyle.fontSize_normal
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: qsTr("Sign in to sync your playback history and favorites.")
                        color: VLCStyle.darkFgMuted
                        font.pixelSize: VLCStyle.fontSize_small
                    }
                }

                Button {
                    text: qsTr("Sign In")
                    Layout.preferredHeight: VLCStyle.dp(32, VLCStyle.scale)

                    background: Rectangle {
                        radius: VLCStyle.control_radius
                        color: VLCStyle.vlcOrange
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "#FFFFFF"
                        font.pixelSize: VLCStyle.fontSize_normal
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        PreferenceCard {
            title: qsTr("Music Scrobbling")
            description: qsTr("Submit listened tracks to music profile services.")

            PreferenceToggle {
                title: qsTr("Last.fm Scrobbler")
                description: qsTr("Submit listening history to Last.fm.")
                configKey: "lastfm-scrobbler"
                checked: false
            }

            PreferenceInput {
                title: qsTr("Last.fm Username")
                configKey: "lastfm-username"
                placeholderText: "username"
            }

            PreferenceInput {
                title: qsTr("Last.fm Password")
                configKey: "lastfm-password"
                echoMode: TextInput.Password
                placeholderText: "••••••••"
            }
        }

        PreferenceCard {
            title: qsTr("Subtitle Services")
            description: qsTr("OpenSubtitles.org authentication for automated subtitle downloads.")

            PreferenceInput {
                title: qsTr("OpenSubtitles Username")
                configKey: "opensubtitles-username"
                placeholderText: "username"
            }

            PreferenceInput {
                title: qsTr("OpenSubtitles Password")
                configKey: "opensubtitles-password"
                echoMode: TextInput.Password
                placeholderText: "••••••••"
            }
        }
    }
}
