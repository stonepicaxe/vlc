/*****************************************************************************
 * VideoSettings.qml : Video preferences card view
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
            title: qsTr("Hardware Acceleration and Display")
            description: qsTr("GPU acceleration and video output surface drivers.")

            PreferenceCombo {
                title: qsTr("Video Output Module")
                description: qsTr("Select display rendering API.")
                configKey: "vout"
                model: [
                    { text: qsTr("Automatic (Recommended)"), value: "any" },
                    { text: "OpenGL", value: "gl" },
                    { text: "Direct3D 11", value: "d3d11" },
                    { text: "Wayland", value: "wl" },
                    { text: "XCB", value: "xcb" },
                    { text: "Metal / Cocoa", value: "caopengllayer" }
                ]
            }

            PreferenceCombo {
                title: qsTr("Hardware-accelerated Decoding")
                description: qsTr("Offload video decoding to dedicated GPU hardware.")
                configKey: "avcodec-hw"
                model: [
                    { text: qsTr("Automatic"), value: "any" },
                    { text: "VA-API", value: "vaapi" },
                    { text: "VDPAU", value: "vdpau" },
                    { text: "D3D11VA", value: "d3d11va" },
                    { text: "DXVA2", value: "dxva2" },
                    { text: "VideoToolbox", value: "videotoolbox" },
                    { text: qsTr("Disable"), value: "none" }
                ]
            }

            PreferenceToggle {
                title: qsTr("HDR Tone Mapping")
                description: qsTr("Apply color tone curve mapping for HDR10 videos on SDR displays.")
                configKey: "hdr-tone-mapping"
                checked: true
            }
        }

        PreferenceCard {
            title: qsTr("Deinterlacing and Quality")
            description: qsTr("Scanline processing and broadcast video quality.")

            PreferenceCombo {
                title: qsTr("Deinterlacing")
                description: qsTr("Deinterlace interlaced broadcast television streams.")
                configKey: "deinterlace"
                model: [
                    { text: qsTr("Automatic"), value: -1 },
                    { text: qsTr("On"), value: 1 },
                    { text: qsTr("Off"), value: 0 }
                ]
            }

            PreferenceCombo {
                title: qsTr("Deinterlace Algorithm")
                description: qsTr("Reconstruction algorithm for scanline frames.")
                configKey: "deinterlace-mode"
                model: [
                    { text: "Yadif (2x)", value: "yadif2x" },
                    { text: "Yadif", value: "yadif" },
                    { text: "Blend", value: "blend" },
                    { text: "Bob", value: "bob" },
                    { text: "Discard", value: "discard" }
                ]
            }
        }

        PreferenceCard {
            title: qsTr("Video Snapshots")
            description: qsTr("Destination directory and file format for frame captures.")

            PreferenceInput {
                title: qsTr("Snapshot Directory")
                description: qsTr("Directory where video snapshot screenshots are saved.")
                configKey: "snapshot-path"
                placeholderText: qsTr("System Pictures folder")
            }

            PreferenceCombo {
                title: qsTr("Snapshot Format")
                description: qsTr("Image format for saved video snapshots.")
                configKey: "snapshot-format"
                model: [
                    { text: "PNG (Lossless)", value: "png" },
                    { text: "JPEG (Compressed)", value: "jpg" }
                ]
            }
        }
    }
}
