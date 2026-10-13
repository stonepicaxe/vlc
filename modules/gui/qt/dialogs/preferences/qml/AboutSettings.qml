/*****************************************************************************
 * AboutSettings.qml : About VLC, version, authors, and license card view
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
            title: ""

            RowLayout {
                Layout.fillWidth: true
                spacing: VLCStyle.margin_large

                Widgets.BannerCone {
                    sourceSize.width: VLCStyle.dp(64, VLCStyle.scale)
                    sourceSize.height: VLCStyle.dp(64, VLCStyle.scale)
                    color: VLCStyle.vlcOrange
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: "VLC media player"
                        color: VLCStyle.darkFgPrimary
                        font.pixelSize: VLCStyle.fontSize_xlarge
                        font.weight: Font.Bold
                    }

                    Text {
                        text: "Version 4.0.0-dev Otto Chriek (Figma Redesign)"
                        color: VLCStyle.vlcOrange
                        font.pixelSize: VLCStyle.fontSize_normal
                    }

                    Text {
                        text: "Copyright © 1996–2026 VideoLAN and VLC authors"
                        color: VLCStyle.darkFgMuted
                        font.pixelSize: VLCStyle.fontSize_small
                    }
                }
            }
        }

        PreferenceCard {
            title: qsTr("License Information")
            description: qsTr("Open source licensing and distribution rights.")

            Text {
                text: qsTr("VLC media player is a free and open source cross-platform multimedia player and framework that plays most multimedia files as well as DVDs, Audio CDs, VCDs, and various streaming protocols.\n\nVLC media player is distributed under the GNU General Public License, Version 2 or later (GPLv2+). You are free to copy, modify, and redistribute it under the terms of the GNU General Public License.")
                color: VLCStyle.darkFgSecondary
                font.pixelSize: VLCStyle.fontSize_normal
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }

        PreferenceCard {
            title: qsTr("VideoLAN Community and Contributors")
            description: qsTr("VLC is developed by an international community of volunteers.")

            Text {
                text: qsTr("VideoLAN is a non-profit organization based in Paris, France.\nOfficial website: https://www.videolan.org\nSource code repository: https://code.videolan.org/videolan/vlc")
                color: VLCStyle.darkFgSecondary
                font.pixelSize: VLCStyle.fontSize_normal
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }
}
