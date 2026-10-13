/*****************************************************************************
 * PreferenceInput.qml : Text input preference row
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

Item {
    id: root

    property string title: ""
    property string description: ""
    property string configKey: ""
    property string text: ""
    property string placeholderText: ""
    property int echoMode: TextInput.Normal

    signal textEdited(string text)

    Layout.fillWidth: true
    implicitHeight: Math.max(textCol.implicitHeight, inputField.implicitHeight) + VLCStyle.margin_xxsmall * 2

    Component.onCompleted: {
        if (configKey.length > 0) {
            let val = ConfigModel.get(configKey)
            if (val !== undefined && val !== null)
                text = String(val)
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: VLCStyle.margin_small

        ColumnLayout {
            id: textCol
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: root.title
                color: VLCStyle.darkFgPrimary
                font.pixelSize: VLCStyle.fontSize_normal
                Layout.fillWidth: true
            }

            Text {
                visible: root.description.length > 0
                text: root.description
                color: VLCStyle.darkFgMuted
                font.pixelSize: VLCStyle.fontSize_small
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }

        TextField {
            id: inputField
            Layout.preferredWidth: VLCStyle.dp(240, VLCStyle.scale)
            Layout.preferredHeight: VLCStyle.dp(32, VLCStyle.scale)

            text: root.text
            placeholderText: root.placeholderText
            echoMode: root.echoMode
            color: VLCStyle.darkFgPrimary
            font.pixelSize: VLCStyle.fontSize_normal

            background: Rectangle {
                radius: VLCStyle.control_radius
                color: VLCStyle.darkBgA1Transparent
                border.width: VLCStyle.border
                border.color: inputField.activeFocus ? VLCStyle.vlcOrange : VLCStyle.vlcBorderSubtle
            }

            onTextEdited: {
                root.text = inputField.text
                if (root.configKey.length > 0)
                    ConfigModel.set(root.configKey, root.text)
                root.textEdited(root.text)
            }
        }
    }
}
