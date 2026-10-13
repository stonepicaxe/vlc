/*****************************************************************************
 * PreferenceCombo.qml : Styled combo box preference row
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
    property var model: []
    property var currentValue

    signal activated(var value)

    Layout.fillWidth: true
    implicitHeight: Math.max(textCol.implicitHeight, comboControl.implicitHeight) + VLCStyle.margin_xxsmall * 2

    Component.onCompleted: {
        if (configKey.length > 0) {
            let val = ConfigModel.get(configKey)
            if (val !== undefined)
                currentValue = val
            let choices = ConfigModel.getChoices(configKey)
            if (choices && choices.length > 0 && (!model || model.length === 0))
                model = choices
        }
        updateSelectedIndex()
    }

    function updateSelectedIndex() {
        if (!model || model.length === 0)
            return
        for (let i = 0; i < model.length; ++i) {
            let itemVal = (typeof model[i] === 'object' && model[i] !== null) ? model[i].value : model[i]
            if (itemVal == currentValue) {
                comboControl.currentIndex = i
                return
            }
        }
    }

    onCurrentValueChanged: updateSelectedIndex()

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

        ComboBox {
            id: comboControl
            Layout.preferredWidth: VLCStyle.dp(200, VLCStyle.scale)
            Layout.preferredHeight: VLCStyle.dp(32, VLCStyle.scale)

            model: root.model
            textRole: "text"

            displayText: {
                if (currentIndex >= 0 && currentIndex < count) {
                    let item = root.model[currentIndex]
                    if (typeof item === 'object' && item !== null && item.text !== undefined)
                        return item.text
                    return String(item)
                }
                return ""
            }

            delegate: ItemDelegate {
                width: comboControl.width
                height: VLCStyle.dp(32, VLCStyle.scale)

                contentItem: Text {
                    text: {
                        let item = root.model[index]
                        if (typeof item === 'object' && item !== null && item.text !== undefined)
                            return item.text
                        return String(item)
                    }
                    color: highlighted ? VLCStyle.vlcOrange : VLCStyle.darkFgPrimary
                    font.pixelSize: VLCStyle.fontSize_normal
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    color: highlighted ? VLCStyle.darkBgB2Transparent : VLCStyle.darkBgB1Transparent
                }
            }

            background: Rectangle {
                radius: VLCStyle.control_radius
                color: VLCStyle.darkBgA1Transparent
                border.width: VLCStyle.border
                border.color: comboControl.activeFocus ? VLCStyle.vlcOrange : VLCStyle.vlcBorderSubtle
            }

            contentItem: Text {
                leftPadding: VLCStyle.margin_small
                rightPadding: VLCStyle.margin_large
                text: comboControl.displayText
                font.pixelSize: VLCStyle.fontSize_normal
                color: VLCStyle.darkFgPrimary
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            onActivated: (index) => {
                let item = root.model[index]
                let val = (typeof item === 'object' && item !== null && item.value !== undefined) ? item.value : item
                root.currentValue = val
                if (root.configKey.length > 0)
                    ConfigModel.set(root.configKey, val)
                root.activated(val)
            }
        }
    }
}
