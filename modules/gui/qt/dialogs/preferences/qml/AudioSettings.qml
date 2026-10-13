/*****************************************************************************
 * AudioSettings.qml : Audio preferences card view
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
            title: qsTr("Audio Output")
            description: qsTr("Configure audio output module and device routing.")

            PreferenceCombo {
                title: qsTr("Output Module")
                description: qsTr("Select audio driver backend.")
                configKey: "aout"
                model: [
                    { text: qsTr("Automatic (Recommended)"), value: "any" },
                    { text: "PulseAudio", value: "pulse" },
                    { text: "PipeWire", value: "pipewire" },
                    { text: "ALSA", value: "alsa" },
                    { text: "WASAPI", value: "wasapi" },
                    { text: "CoreAudio", value: "auhal" }
                ]
            }

            PreferenceSlider {
                title: qsTr("Default Audio Volume")
                description: qsTr("Starting volume level when launching VLC.")
                configKey: "volume"
                from: 0
                to: 125
                stepSize: 5
                value: 100
                unit: "%"
            }

            PreferenceToggle {
                title: qsTr("Remember last volume across sessions")
                description: qsTr("Store volume level upon exit and restore on next launch.")
                configKey: "volume-save"
                checked: true
            }
        }

        PreferenceCard {
            title: qsTr("Dynamics and Equalization")
            description: qsTr("Digital signal processing, replay gain and normalization.")

            PreferenceCombo {
                title: qsTr("ReplayGain Mode")
                description: qsTr("Match volume across tracks according to metadata.")
                configKey: "audio-replay-gain-mode"
                model: [
                    { text: qsTr("None"), value: "none" },
                    { text: qsTr("Track"), value: "track" },
                    { text: qsTr("Album"), value: "album" }
                ]
            }

            PreferenceToggle {
                title: qsTr("Normalize volume")
                description: qsTr("Prevent sudden loudness jumps across tracks and movie scenes.")
                configKey: "norm-buff-size"
                checked: false
            }

            PreferenceToggle {
                title: qsTr("Enable audio spatializer by default")
                description: qsTr("Simulate room acoustic reflections for headphones.")
                configKey: "spatializer"
                checked: false
            }
        }
    }
}
