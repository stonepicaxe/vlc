/*****************************************************************************
 * PreferencesWindow.qml : Native QML preferences window and category stack
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
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls

import VLC.Style
import VLC.Dialogs
import VLC.Widgets as Widgets

Window {
    id: root

    title: qsTr("Preferences")
    flags: Qt.Dialog | Qt.WindowCloseButtonHint

    width: VLCStyle.dp(980, VLCStyle.scale)
    height: VLCStyle.dp(680, VLCStyle.scale)
    minimumWidth: VLCStyle.dp(800, VLCStyle.scale)
    minimumHeight: VLCStyle.dp(550, VLCStyle.scale)

    color: "transparent"

    property int currentCategoryIndex: 0

    readonly property var categories: [
        { id: "general", name: qsTr("General"), icon: VLCIcons.settings, source: "GeneralSettings.qml" },
        { id: "audio", name: qsTr("Audio"), icon: VLCIcons.volume_high, source: "AudioSettings.qml" },
        { id: "video", name: qsTr("Video"), icon: VLCIcons.topbar_video, source: "VideoSettings.qml" },
        { id: "subtitles", name: qsTr("Subtitles"), icon: VLCIcons.audiosub, source: "SubtitlesSettings.qml" },
        { id: "hotkeys", name: qsTr("Hotkeys"), icon: VLCIcons.space, source: "HotkeysSettings.qml" },
        { id: "interface", name: qsTr("Interface"), icon: VLCIcons.grid, source: "InterfaceSettings.qml" },
        { id: "network", name: qsTr("Network"), icon: VLCIcons.topbar_network, source: "NetworkSettings.qml" },
        { id: "privacy", name: qsTr("Privacy"), icon: VLCIcons.history, source: "PrivacySettings.qml" },
        { id: "performance", name: qsTr("Performance"), icon: VLCIcons.faster, source: "PerformanceSettings.qml" },
        { id: "input", name: qsTr("Input & Codecs"), icon: VLCIcons.stream, source: "InputCodecsSettings.qml" },
        { id: "account", name: qsTr("Account"), icon: VLCIcons.profile_new, source: "AccountSettings.qml" },
        { id: "advanced", name: qsTr("Advanced"), icon: VLCIcons.effect_filter, source: "AdvancedSettings.qml" },
        { id: "about", name: qsTr("About"), icon: VLCIcons.info, source: "AboutSettings.qml" }
    ]

    Rectangle {
        id: windowBg
        anchors.fill: parent
        radius: VLCStyle.panel_radius
        color: VLCStyle.darkBgA3Transparent
        border.width: VLCStyle.border
        border.color: VLCStyle.vlcBorderBright

        layer.enabled: true
        layer.effect: Widgets.FrostedGlassEffect {
            tint: VLCStyle.darkBgA3Transparent
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: VLCStyle.margin_normal
            spacing: VLCStyle.margin_normal

            // Top Header Bar
            RowLayout {
                Layout.fillWidth: true
                spacing: VLCStyle.margin_normal

                Text {
                    text: qsTr("Preferences")
                    color: VLCStyle.darkFgPrimary
                    font.pixelSize: VLCStyle.fontSize_xlarge
                    font.weight: Font.Bold
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: VLCStyle.dp(30, VLCStyle.scale)
                    height: VLCStyle.dp(30, VLCStyle.scale)
                    radius: width / 2
                    color: closeMouseArea.containsMouse ? VLCStyle.darkBgB2Transparent : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: VLCIcons.close
                        font.family: VLCIcons.fontFamily
                        color: VLCStyle.darkFgSecondary
                        font.pixelSize: VLCStyle.icon_normal
                    }

                    MouseArea {
                        id: closeMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.close()
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: VLCStyle.border
                color: VLCStyle.vlcBorderSubtle
            }

            // Main Content: Sidebar + Stack View
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: VLCStyle.margin_normal

                // Category Sidebar
                Rectangle {
                    Layout.preferredWidth: VLCStyle.dp(210, VLCStyle.scale)
                    Layout.fillHeight: true
                    radius: VLCStyle.card_radius
                    color: VLCStyle.darkBgB1Transparent
                    border.width: VLCStyle.border
                    border.color: VLCStyle.vlcBorderSubtle

                    ListView {
                        id: categoryListView
                        anchors.fill: parent
                        anchors.margins: VLCStyle.margin_xsmall
                        clip: true
                        model: root.categories

                        delegate: Rectangle {
                            width: ListView.view.width
                            height: VLCStyle.dp(40, VLCStyle.scale)
                            radius: VLCStyle.control_radius
                            color: (index === root.currentCategoryIndex)
                                   ? VLCStyle.darkBgB2Transparent
                                   : (catMouseArea.containsMouse ? VLCStyle.darkBgA1Transparent : "transparent")

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: VLCStyle.margin_small
                                anchors.rightMargin: VLCStyle.margin_small
                                spacing: VLCStyle.margin_small

                                Rectangle {
                                    visible: index === root.currentCategoryIndex
                                    Layout.preferredWidth: VLCStyle.dp(3, VLCStyle.scale)
                                    Layout.preferredHeight: VLCStyle.dp(20, VLCStyle.scale)
                                    radius: VLCStyle.pill_radius
                                    color: VLCStyle.vlcOrange
                                }

                                Text {
                                    text: modelData.icon
                                    font.family: VLCIcons.fontFamily
                                    font.pixelSize: VLCStyle.icon_normal
                                    color: (index === root.currentCategoryIndex) ? VLCStyle.vlcOrange : VLCStyle.darkFgSecondary
                                }

                                Text {
                                    text: modelData.name
                                    color: (index === root.currentCategoryIndex) ? VLCStyle.darkFgPrimary : VLCStyle.darkFgSecondary
                                    font.pixelSize: VLCStyle.fontSize_normal
                                    font.weight: (index === root.currentCategoryIndex) ? Font.DemiBold : Font.Normal
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                            }

                            MouseArea {
                                id: catMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.currentCategoryIndex = index
                                }
                            }
                        }
                    }
                }

                // Category Content Pane
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: VLCStyle.card_radius
                    color: "transparent"

                    Loader {
                        id: contentLoader
                        anchors.fill: parent
                        source: root.categories[root.currentCategoryIndex].source
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: VLCStyle.border
                color: VLCStyle.vlcBorderSubtle
            }

            // Bottom Actions Bar
            RowLayout {
                Layout.fillWidth: true
                spacing: VLCStyle.margin_normal

                Button {
                    text: qsTr("Reset to Defaults")
                    Layout.preferredHeight: VLCStyle.dp(34, VLCStyle.scale)

                    background: Rectangle {
                        radius: VLCStyle.control_radius
                        color: parent.down ? VLCStyle.darkBgB2Transparent : VLCStyle.darkBgB1Transparent
                        border.width: VLCStyle.border
                        border.color: VLCStyle.vlcBorderSubtle
                    }

                    contentItem: Text {
                        text: parent.text
                        color: VLCStyle.darkFgMuted
                        font.pixelSize: VLCStyle.fontSize_normal
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        ConfigModel.reset()
                    }
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: qsTr("Cancel")
                    Layout.preferredHeight: VLCStyle.dp(34, VLCStyle.scale)

                    background: Rectangle {
                        radius: VLCStyle.control_radius
                        color: parent.down ? VLCStyle.darkBgB2Transparent : VLCStyle.darkBgB1Transparent
                        border.width: VLCStyle.border
                        border.color: VLCStyle.vlcBorderSubtle
                    }

                    contentItem: Text {
                        text: parent.text
                        color: VLCStyle.darkFgPrimary
                        font.pixelSize: VLCStyle.fontSize_normal
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: root.close()
                }

                Button {
                    text: qsTr("Save Changes")
                    Layout.preferredHeight: VLCStyle.dp(34, VLCStyle.scale)

                    background: Rectangle {
                        radius: VLCStyle.control_radius
                        color: parent.down ? VLCStyle.vlcOrangeLight : VLCStyle.vlcOrange
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "#FFFFFF"
                        font.pixelSize: VLCStyle.fontSize_normal
                        font.weight: Font.DemiBold
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        ConfigModel.save()
                        root.close()
                    }
                }
            }
        }
    }
}
