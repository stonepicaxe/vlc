/*****************************************************************************
 * NetworkSettings.qml : Network and streaming preferences card view
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
            title: qsTr("Network Buffering and Caching")
            description: qsTr("Buffer duration for network streams, HTTP live streams, and RTSP.")

            PreferenceSlider {
                title: qsTr("Network Caching")
                description: qsTr("Amount of network stream data buffered ahead in milliseconds.")
                configKey: "network-caching"
                from: 100
                to: 5000
                stepSize: 100
                value: 1000
                unit: "ms"
            }

            PreferenceSlider {
                title: qsTr("Live Stream Caching")
                description: qsTr("Buffer size for low latency live streams.")
                configKey: "live-caching"
                from: 50
                to: 2000
                stepSize: 50
                value: 300
                unit: "ms"
            }
        }

        PreferenceCard {
            title: qsTr("Proxy and Discovery")
            description: qsTr("Network proxy routing and local network discovery services.")

            PreferenceInput {
                title: qsTr("HTTP / HTTPS Proxy")
                description: qsTr("HTTP proxy URL in format http://[user:password@]proxy:port/")
                configKey: "http-proxy"
                placeholderText: "http://proxy.example.com:8080"
            }

            PreferenceToggle {
                title: qsTr("Enable UPnP / DLNA media server discovery")
                description: qsTr("Automatically discover local network media servers and NAS drives.")
                configKey: "services-discovery"
                checked: true
            }

            PreferenceInput {
                title: qsTr("SMB / Samba Workgroup")
                description: qsTr("Workgroup name used when querying Windows / Samba shares.")
                configKey: "smb-workgroup"
                placeholderText: "WORKGROUP"
            }
        }
    }
}
