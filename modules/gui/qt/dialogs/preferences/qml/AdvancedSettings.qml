/*****************************************************************************
 * AdvancedSettings.qml : Raw configuration tree and search card view
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

    property var searchResults: []

    Component.onCompleted: {
        updateSearch("")
    }

    function updateSearch(text) {
        searchResults = ConfigModel.searchConfig(text)
    }

    ColumnLayout {
        width: root.availableWidth
        spacing: VLCStyle.margin_normal

        PreferenceCard {
            title: qsTr("Advanced Variable Inspector")
            description: qsTr("Search and modify low-level VLC engine options.")

            TextField {
                id: searchBar
                Layout.fillWidth: true
                Layout.preferredHeight: VLCStyle.dp(34, VLCStyle.scale)
                placeholderText: qsTr("Type variable or module name to search...")
                color: VLCStyle.darkFgPrimary
                font.pixelSize: VLCStyle.fontSize_normal

                background: Rectangle {
                    radius: VLCStyle.control_radius
                    color: VLCStyle.darkBgA1Transparent
                    border.width: VLCStyle.border
                    border.color: searchBar.activeFocus ? VLCStyle.vlcOrange : VLCStyle.vlcBorderSubtle
                }

                onTextChanged: root.updateSearch(text)
            }

            ListView {
                Layout.fillWidth: true
                implicitHeight: Math.min(contentHeight, VLCStyle.dp(500, VLCStyle.scale))
                clip: true
                spacing: VLCStyle.margin_xsmall

                model: root.searchResults

                delegate: Rectangle {
                    width: ListView.view.width
                    height: VLCStyle.dp(52, VLCStyle.scale)
                    radius: VLCStyle.control_radius
                    color: VLCStyle.darkBgA1Transparent
                    border.width: VLCStyle.border
                    border.color: VLCStyle.vlcBorderSubtle

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: VLCStyle.margin_small
                        anchors.rightMargin: VLCStyle.margin_small
                        spacing: VLCStyle.margin_small

                        Rectangle {
                            radius: VLCStyle.chip_radius
                            color: VLCStyle.darkBgB2Transparent
                            implicitWidth: modLabel.implicitWidth + VLCStyle.margin_small * 2
                            implicitHeight: VLCStyle.dp(22, VLCStyle.scale)

                            Text {
                                id: modLabel
                                anchors.centerIn: parent
                                text: modelData.module
                                color: VLCStyle.vlcOrange
                                font.pixelSize: VLCStyle.fontSize_small
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            Text {
                                text: modelData.name
                                color: VLCStyle.darkFgPrimary
                                font.pixelSize: VLCStyle.fontSize_normal
                                font.weight: Font.DemiBold
                                elide: Text.ElideRight
                            }

                            Text {
                                text: modelData.text
                                color: VLCStyle.darkFgMuted
                                font.pixelSize: VLCStyle.fontSize_small
                                elide: Text.ElideRight
                            }
                        }

                        Rectangle {
                            radius: VLCStyle.chip_radius
                            color: VLCStyle.darkBgB1Transparent
                            border.width: VLCStyle.border
                            border.color: VLCStyle.vlcBorderSubtle
                            implicitWidth: typeLabel.implicitWidth + VLCStyle.margin_small * 2
                            implicitHeight: VLCStyle.dp(22, VLCStyle.scale)

                            Text {
                                id: typeLabel
                                anchors.centerIn: parent
                                text: modelData.type
                                color: VLCStyle.darkFgMuted
                                font.pixelSize: VLCStyle.fontSize_small
                            }
                        }

                        TextField {
                            Layout.preferredWidth: VLCStyle.dp(140, VLCStyle.scale)
                            Layout.preferredHeight: VLCStyle.dp(28, VLCStyle.scale)
                            text: String(modelData.value !== undefined ? modelData.value : "")
                            color: VLCStyle.darkFgPrimary
                            font.pixelSize: VLCStyle.fontSize_small

                            background: Rectangle {
                                radius: VLCStyle.control_radius
                                color: VLCStyle.darkBgA2Transparent
                                border.width: VLCStyle.border
                                border.color: parent.activeFocus ? VLCStyle.vlcOrange : VLCStyle.vlcBorderSubtle
                            }

                            onEditingFinished: {
                                ConfigModel.set(modelData.name, text)
                            }
                        }
                    }
                }
            }
        }
    }
}
