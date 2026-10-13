/*****************************************************************************
 * PreferenceSlider.qml : Slider preference row with numeric value badge
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
    property real from: 0
    property real to: 100
    property real stepSize: 1
    property real value: 0
    property string unit: ""

    signal valueModified(real value)

    Layout.fillWidth: true
    implicitHeight: Math.max(textCol.implicitHeight, sliderRow.implicitHeight) + VLCStyle.margin_xxsmall * 2

    Component.onCompleted: {
        if (configKey.length > 0) {
            let val = ConfigModel.get(configKey)
            if (val !== undefined && val !== null)
                value = Number(val)
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

        RowLayout {
            id: sliderRow
            Layout.preferredWidth: VLCStyle.dp(240, VLCStyle.scale)
            spacing: VLCStyle.margin_small

            Slider {
                id: sliderControl
                Layout.fillWidth: true
                from: root.from
                to: root.to
                stepSize: root.stepSize
                value: root.value

                background: Rectangle {
                    x: sliderControl.leftPadding
                    y: sliderControl.topPadding + sliderControl.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: sliderControl.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: VLCStyle.darkBgA1Transparent

                    Rectangle {
                        width: sliderControl.visualPosition * parent.width
                        height: parent.height
                        color: VLCStyle.vlcOrange
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: sliderControl.leftPadding + sliderControl.visualPosition * (sliderControl.availableWidth - width)
                    y: sliderControl.topPadding + sliderControl.availableHeight / 2 - height / 2
                    implicitWidth: VLCStyle.dp(16, VLCStyle.scale)
                    implicitHeight: VLCStyle.dp(16, VLCStyle.scale)
                    radius: width / 2
                    color: sliderControl.pressed ? VLCStyle.vlcOrangeLight : VLCStyle.vlcOrange
                }

                onMoved: {
                    root.value = sliderControl.value
                    if (root.configKey.length > 0)
                        ConfigModel.set(root.configKey, root.value)
                    root.valueModified(root.value)
                }
            }

            Rectangle {
                Layout.preferredWidth: VLCStyle.dp(56, VLCStyle.scale)
                Layout.preferredHeight: VLCStyle.dp(24, VLCStyle.scale)
                radius: VLCStyle.chip_radius
                color: VLCStyle.darkBgA1Transparent
                border.width: VLCStyle.border
                border.color: VLCStyle.vlcBorderSubtle

                Text {
                    anchors.centerIn: parent
                    text: Math.round(sliderControl.value) + (root.unit.length > 0 ? " " + root.unit : "")
                    color: VLCStyle.darkFgSecondary
                    font.pixelSize: VLCStyle.fontSize_small
                }
            }
        }
    }
}
