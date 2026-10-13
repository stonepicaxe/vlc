/*****************************************************************************
 * PreferenceToggle.qml : Toggle switch preference row
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

import VLC.Style
import VLC.Dialogs

Item {
    id: root

    property string title: ""
    property string description: ""
    property string configKey: ""
    property bool checked: false

    signal toggled(bool checked)

    Layout.fillWidth: true
    implicitHeight: Math.max(textCol.implicitHeight, switchPill.implicitHeight) + VLCStyle.margin_xxsmall * 2

    Component.onCompleted: {
        if (configKey.length > 0)
            checked = ConfigModel.get(configKey, checked)
    }

    Connections {
        target: ConfigModel
        function onConfigChanged(key, value) {
            if (key === root.configKey)
                root.checked = !!value
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

        Rectangle {
            id: switchPill
            Layout.preferredWidth: VLCStyle.dp(44, VLCStyle.scale)
            Layout.preferredHeight: VLCStyle.dp(24, VLCStyle.scale)
            radius: VLCStyle.pill_radius
            color: root.checked ? VLCStyle.vlcOrange : VLCStyle.darkBgA1Transparent
            border.width: VLCStyle.border
            border.color: root.checked ? VLCStyle.vlcOrange : VLCStyle.vlcBorderSubtle

            Behavior on color {
                ColorAnimation { duration: VLCStyle.duration_short }
            }

            Rectangle {
                id: switchKnob
                width: VLCStyle.dp(18, VLCStyle.scale)
                height: VLCStyle.dp(18, VLCStyle.scale)
                radius: width / 2
                anchors.verticalCenter: parent.verticalCenter
                x: root.checked ? parent.width - width - VLCStyle.dp(3, VLCStyle.scale) : VLCStyle.dp(3, VLCStyle.scale)
                color: VLCStyle.darkFgPrimary

                Behavior on x {
                    NumberAnimation { duration: VLCStyle.duration_short; easing.type: Easing.InOutQuad }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    root.checked = !root.checked
                    if (root.configKey.length > 0)
                        ConfigModel.set(root.configKey, root.checked)
                    root.toggled(root.checked)
                }
            }
        }
    }
}
