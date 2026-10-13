/*****************************************************************************
 * GeneralSettings.qml : General preferences card view
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
            title: qsTr("Language and Locale")
            description: qsTr("Configure player language and locale preferences.")

            PreferenceCombo {
                title: qsTr("Interface Language")
                description: qsTr("Select interface language or use system default.")
                configKey: "language"
                model: [
                    { text: qsTr("System Default"), value: "auto" },
                    { text: "English (US)", value: "en" },
                    { text: "Français", value: "fr" },
                    { text: "Deutsch", value: "de" },
                    { text: "Español", value: "es" },
                    { text: "日本語", value: "ja" },
                    { text: "中文 (简体)", value: "zh_CN" }
                ]
            }
        }

        PreferenceCard {
            title: qsTr("Updates and Automation")
            description: qsTr("Manage automated checks and background tasks.")

            PreferenceToggle {
                title: qsTr("Check for updates automatically")
                description: qsTr("Periodically check VideoLAN servers for VLC updates.")
                configKey: "qt-auto-raise"
                checked: true
            }

            PreferenceToggle {
                title: qsTr("Start minimized in system tray")
                description: qsTr("Keep VLC running in the notification area when closed.")
                configKey: "qt-system-tray"
                checked: false
            }
        }

        PreferenceCard {
            title: qsTr("Playback and Playlist")
            description: qsTr("Behavior when opening files and continuing playback.")

            PreferenceCombo {
                title: qsTr("Continue playback")
                description: qsTr("Resume playback from the last stopped position.")
                configKey: "qt-continue"
                model: [
                    { text: qsTr("Ask every time"), value: 0 },
                    { text: qsTr("Always resume"), value: 1 },
                    { text: qsTr("Never resume"), value: 2 }
                ]
            }

            PreferenceToggle {
                title: qsTr("Allow only one running instance")
                description: qsTr("Send media to the existing VLC window instead of opening a new one.")
                configKey: "one-instance"
                checked: true
            }

            PreferenceToggle {
                title: qsTr("Enqueue items into playlist in one instance mode")
                description: qsTr("Append opened files to current playlist instead of playing immediately.")
                configKey: "playlist-enqueue"
                checked: false
            }
        }
    }
}
