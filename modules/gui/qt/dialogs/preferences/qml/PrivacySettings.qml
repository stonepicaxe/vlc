/*****************************************************************************
 * PrivacySettings.qml : Privacy and security preferences card view
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

    ColumnLayout {
        width: root.availableWidth
        spacing: VLCStyle.margin_normal

        PreferenceCard {
            title: qsTr("Media Network Access and Metadata")
            description: qsTr("Control internet requests initiated for album covers and media info.")

            PreferenceToggle {
                title: qsTr("Allow network access for media metadata")
                description: qsTr("Download album art covers, artist details, and track information from the web.")
                configKey: "qt-privacy-ask"
                checked: true
            }

            PreferenceToggle {
                title: qsTr("Fetch missing subtitle files automatically")
                description: qsTr("Search online subtitle providers when playing videos without subtitles.")
                configKey: "sub-autosearch"
                checked: false
            }
        }

        PreferenceCard {
            title: qsTr("Playback History and Retention")
            description: qsTr("Manage recent media history and private playback sessions.")

            PreferenceToggle {
                title: qsTr("Save recently played media items")
                description: qsTr("Keep a list of recently opened files in the Media Library.")
                configKey: "qt-recentplay"
                checked: true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: VLCStyle.margin_normal

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: qsTr("Clear Playback History")
                        color: VLCStyle.darkFgPrimary
                        font.pixelSize: VLCStyle.fontSize_normal
                    }

                    Text {
                        text: qsTr("Remove all recently played files and bookmarks.")
                        color: VLCStyle.darkFgMuted
                        font.pixelSize: VLCStyle.fontSize_small
                    }
                }

                Button {
                    text: qsTr("Clear History")
                    Layout.preferredHeight: VLCStyle.dp(32, VLCStyle.scale)

                    background: Rectangle {
                        radius: VLCStyle.control_radius
                        color: parent.down ? VLCStyle.darkBgB2Transparent : VLCStyle.darkBgA1Transparent
                        border.width: VLCStyle.border
                        border.color: VLCStyle.vlcBorderSubtle
                    }

                    contentItem: Text {
                        text: parent.text
                        color: VLCStyle.vlcOrange
                        font.pixelSize: VLCStyle.fontSize_normal
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        PreferenceCard {
            title: qsTr("Crash Reports and Diagnostics")
            description: qsTr("Anonymous crash traces helping VideoLAN developers fix bugs.")

            PreferenceToggle {
                title: qsTr("Send anonymous crash reports")
                description: qsTr("Submit stack traces to VideoLAN upon an unexpected application crash.")
                configKey: "qt-send-crash-reports"
                checked: false
            }
        }
    }
}
