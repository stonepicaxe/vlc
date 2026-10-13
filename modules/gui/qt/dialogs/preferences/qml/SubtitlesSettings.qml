/*****************************************************************************
 * SubtitlesSettings.qml : Subtitle preferences card view
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
            title: qsTr("Subtitles Language and Detection")
            description: qsTr("Preferred subtitle languages and automated track matching.")

            PreferenceInput {
                title: qsTr("Preferred Subtitle Language")
                description: qsTr("ISO-639 two or three letter language codes, comma separated (e.g. en, fr, de).")
                configKey: "sub-language"
                placeholderText: "en, fr"
            }

            PreferenceToggle {
                title: qsTr("Auto-detect subtitle files with matching video name")
                description: qsTr("Automatically load .srt, .sub, .ass, and .vtt files matching movie names.")
                configKey: "sub-autodetect-file"
                checked: true
            }
        }

        PreferenceCard {
            title: qsTr("Typography and Formatting")
            description: qsTr("Font rendering, sizing, and color styling for text subtitles.")

            PreferenceCombo {
                title: qsTr("Font Size")
                description: qsTr("Relative size of rendered on-screen subtitles.")
                configKey: "freetype-rel-fontsize"
                model: [
                    { text: qsTr("Smaller"), value: 24 },
                    { text: qsTr("Small"), value: 20 },
                    { text: qsTr("Normal"), value: 16 },
                    { text: qsTr("Large"), value: 13 },
                    { text: qsTr("Larger"), value: 10 }
                ]
            }

            PreferenceCombo {
                title: qsTr("Text Color")
                description: qsTr("Color of rendered subtitle glyphs.")
                configKey: "freetype-color"
                model: [
                    { text: qsTr("White"), value: 0x00FFFFFF },
                    { text: qsTr("Yellow"), value: 0x00FFFF00 },
                    { text: qsTr("Cyan"), value: 0x0000FFFF },
                    { text: qsTr("Green"), value: 0x0000FF00 }
                ]
            }

            PreferenceToggle {
                title: qsTr("Text Outline Shadow")
                description: qsTr("Render high contrast outline shadow around text glyphs.")
                configKey: "freetype-outline-thickness"
                checked: true
            }

            PreferenceToggle {
                title: qsTr("Render background box behind subtitles")
                description: qsTr("Display semi-translucent rectangle box behind text lines for legibility.")
                configKey: "freetype-background-opacity"
                checked: false
            }
        }
    }
}
