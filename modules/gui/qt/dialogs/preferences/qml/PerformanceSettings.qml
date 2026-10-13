/*****************************************************************************
 * PerformanceSettings.qml : Performance and decoder threading card view
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
            title: qsTr("Multi-threading and CPU Utilization")
            description: qsTr("Parallel video decoding threads and core distribution.")

            PreferenceCombo {
                title: qsTr("Decoder Threads")
                description: qsTr("Number of CPU threads allocated to FFmpeg video decoding.")
                configKey: "avcodec-threads"
                model: [
                    { text: qsTr("Auto (Based on CPU cores)"), value: 0 },
                    { text: "1 Thread", value: 1 },
                    { text: "2 Threads", value: 2 },
                    { text: "4 Threads", value: 4 },
                    { text: "8 Threads", value: 8 },
                    { text: "16 Threads", value: 16 }
                ]
            }

            PreferenceToggle {
                title: qsTr("Drop late frames")
                description: qsTr("Discard frames that arrive past their PTS deadline to maintain audio synchronization.")
                configKey: "drop-late-frames"
                checked: true
            }

            PreferenceToggle {
                title: qsTr("Skip loop filter for H.264 / HEVC")
                description: qsTr("Speeds up decoding on low-end hardware at the cost of minor visual artifacts.")
                configKey: "avcodec-skiploopfilter"
                checked: false
            }
        }

        PreferenceCard {
            title: qsTr("Low-Latency and Buffering")
            description: qsTr("Tuning for gaming, monitoring, and live interaction.")

            PreferenceToggle {
                title: qsTr("Ultra Low Latency mode")
                description: qsTr("Minimizes playback pipeline buffers to reduce delay.")
                configKey: "low-delay"
                checked: false
            }

            PreferenceToggle {
                title: qsTr("Hardware-accelerated color conversion")
                description: qsTr("Uses GPU compute shaders for YUV to RGB matrix conversions.")
                configKey: "hw-colorspace"
                checked: true
            }
        }
    }
}
