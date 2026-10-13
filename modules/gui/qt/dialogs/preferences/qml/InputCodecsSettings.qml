/*****************************************************************************
 * InputCodecsSettings.qml : Input and demuxer codecs preferences card view
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
            title: qsTr("Optical Drives and Media Discs")
            description: qsTr("Default drive letters and mount paths for DVD and Audio CD playback.")

            PreferenceInput {
                title: qsTr("Default DVD Device")
                description: qsTr("Path or drive letter for optical DVD video drives.")
                configKey: "dvd"
                placeholderText: "/dev/dvd or D:"
            }

            PreferenceInput {
                title: qsTr("Default Audio CD Device")
                description: qsTr("Path or drive letter for Audio CD playback.")
                configKey: "cd-audio"
                placeholderText: "/dev/cdrom or D:"
            }
        }

        PreferenceCard {
            title: qsTr("Local File Caching and Demuxing")
            description: qsTr("Buffer sizes for disk reads and seek accuracy.")

            PreferenceSlider {
                title: qsTr("File Caching")
                description: qsTr("Read-ahead cache for local media files in milliseconds.")
                configKey: "file-caching"
                from: 100
                to: 3000
                stepSize: 100
                value: 1000
                unit: "ms"
            }

            PreferenceSlider {
                title: qsTr("Disc Caching")
                description: qsTr("Read-ahead buffer for optical discs in milliseconds.")
                configKey: "disc-caching"
                from: 100
                to: 3000
                stepSize: 100
                value: 1000
                unit: "ms"
            }

            PreferenceToggle {
                title: qsTr("Fast seek (keyframe seeking)")
                description: qsTr("Jump to nearest I-frame instead of exact timestamp for faster seeks.")
                configKey: "fast-seek"
                checked: true
            }
        }
    }
}
