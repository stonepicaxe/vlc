/*****************************************************************************
 * OpenNetworkDialog.qml : Native modal for opening network streams
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

    title: qsTr("Open Network Stream")
    flags: Qt.Dialog | Qt.WindowCloseButtonHint

    width: VLCStyle.dp(540, VLCStyle.scale)
    height: VLCStyle.dp(380, VLCStyle.scale)
    minimumWidth: VLCStyle.dp(460, VLCStyle.scale)
    minimumHeight: VLCStyle.dp(320, VLCStyle.scale)

    color: "transparent"

    signal openUrl(string url, bool playImmediately)

    Rectangle {
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
            anchors.margins: VLCStyle.margin_large
            spacing: VLCStyle.margin_normal

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: qsTr("Open Network Stream")
                    color: VLCStyle.darkFgPrimary
                    font.pixelSize: VLCStyle.fontSize_large
                    font.weight: Font.DemiBold
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    width: VLCStyle.dp(26, VLCStyle.scale)
                    height: VLCStyle.dp(26, VLCStyle.scale)
                    radius: width / 2
                    color: closeArea.containsMouse ? VLCStyle.darkBgB2Transparent : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: VLCIcons.close
                        font.family: VLCIcons.fontFamily
                        color: VLCStyle.darkFgSecondary
                        font.pixelSize: VLCStyle.icon_small
                    }

                    MouseArea {
                        id: closeArea
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

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: qsTr("Network URL")
                    color: VLCStyle.darkFgSecondary
                    font.pixelSize: VLCStyle.fontSize_small
                }

                TextField {
                    id: urlField
                    Layout.fillWidth: true
                    Layout.preferredHeight: VLCStyle.dp(36, VLCStyle.scale)
                    placeholderText: "https://example.com/live/stream.m3u8"
                    color: VLCStyle.darkFgPrimary
                    font.pixelSize: VLCStyle.fontSize_normal

                    background: Rectangle {
                        radius: VLCStyle.control_radius
                        color: VLCStyle.darkBgA1Transparent
                        border.width: VLCStyle.border
                        border.color: urlField.activeFocus ? VLCStyle.vlcOrange : VLCStyle.vlcBorderSubtle
                    }
                }
            }

            // Protocol Helper Chips
            RowLayout {
                spacing: VLCStyle.margin_xsmall

                Repeater {
                    model: ["https://", "rtsp://", "rtmp://", "udp://@", "mms://"]

                    Rectangle {
                        radius: VLCStyle.chip_radius
                        color: protoMouseArea.containsMouse ? VLCStyle.darkBgB2Transparent : VLCStyle.darkBgA1Transparent
                        border.width: VLCStyle.border
                        border.color: VLCStyle.vlcBorderSubtle
                        implicitWidth: protoLabel.implicitWidth + VLCStyle.margin_small * 2
                        implicitHeight: VLCStyle.dp(24, VLCStyle.scale)

                        Text {
                            id: protoLabel
                            anchors.centerIn: parent
                            text: modelData
                            color: VLCStyle.vlcOrange
                            font.pixelSize: VLCStyle.fontSize_small
                        }

                        MouseArea {
                            id: protoMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                urlField.text = modelData
                                urlField.forceActiveFocus()
                            }
                        }
                    }
                }
            }

            // Buffer Cache Slider
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: qsTr("Network Caching")
                        color: VLCStyle.darkFgSecondary
                        font.pixelSize: VLCStyle.fontSize_small
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: Math.round(cacheSlider.value) + " ms"
                        color: VLCStyle.vlcOrange
                        font.pixelSize: VLCStyle.fontSize_small
                    }
                }

                Slider {
                    id: cacheSlider
                    Layout.fillWidth: true
                    from: 100
                    to: 5000
                    stepSize: 100
                    value: 1000

                    background: Rectangle {
                        x: cacheSlider.leftPadding
                        y: cacheSlider.topPadding + cacheSlider.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: 4
                        width: cacheSlider.availableWidth
                        height: implicitHeight
                        radius: 2
                        color: VLCStyle.darkBgA1Transparent

                        Rectangle {
                            width: cacheSlider.visualPosition * parent.width
                            height: parent.height
                            color: VLCStyle.vlcOrange
                            radius: 2
                        }
                    }

                    handle: Rectangle {
                        x: cacheSlider.leftPadding + cacheSlider.visualPosition * (cacheSlider.availableWidth - width)
                        y: cacheSlider.topPadding + cacheSlider.availableHeight / 2 - height / 2
                        implicitWidth: VLCStyle.dp(16, VLCStyle.scale)
                        implicitHeight: VLCStyle.dp(16, VLCStyle.scale)
                        radius: width / 2
                        color: cacheSlider.pressed ? VLCStyle.vlcOrangeLight : VLCStyle.vlcOrange
                    }
                }
            }

            Item { Layout.fillHeight: true }

            RowLayout {
                Layout.fillWidth: true
                spacing: VLCStyle.margin_normal

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
                    text: qsTr("Play Stream")
                    Layout.preferredHeight: VLCStyle.dp(34, VLCStyle.scale)
                    enabled: urlField.text.trim().length > 0

                    background: Rectangle {
                        radius: VLCStyle.control_radius
                        color: parent.enabled ? (parent.down ? VLCStyle.vlcOrangeLight : VLCStyle.vlcOrange) : VLCStyle.darkBgB1Transparent
                        opacity: parent.enabled ? 1.0 : 0.5
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
                        root.openUrl(urlField.text.trim(), true)
                        root.close()
                    }
                }
            }
        }
    }
}
