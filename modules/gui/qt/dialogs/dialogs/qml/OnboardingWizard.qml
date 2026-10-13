/*****************************************************************************
 * OnboardingWizard.qml : 5-step native QML first run setup wizard
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

    title: qsTr("Welcome to VLC")
    flags: Qt.Dialog | Qt.WindowCloseButtonHint

    width: VLCStyle.dp(780, VLCStyle.scale)
    height: VLCStyle.dp(560, VLCStyle.scale)
    minimumWidth: VLCStyle.dp(680, VLCStyle.scale)
    minimumHeight: VLCStyle.dp(480, VLCStyle.scale)

    color: "transparent"

    property int currentStep: 0
    readonly property int totalSteps: 5

    Rectangle {
        id: bgPanel
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

            // Top Header: Step Indicator Dots
            RowLayout {
                Layout.fillWidth: true
                spacing: VLCStyle.margin_small

                Text {
                    text: qsTr("Setup Wizard")
                    color: VLCStyle.darkFgMuted
                    font.pixelSize: VLCStyle.fontSize_small
                    font.weight: Font.DemiBold
                }

                Item { Layout.fillWidth: true }

                Row {
                    spacing: VLCStyle.margin_xsmall

                    Repeater {
                        model: root.totalSteps

                        Rectangle {
                            width: (index === root.currentStep) ? VLCStyle.dp(24, VLCStyle.scale) : VLCStyle.dp(8, VLCStyle.scale)
                            height: VLCStyle.dp(8, VLCStyle.scale)
                            radius: height / 2
                            color: (index === root.currentStep)
                                   ? VLCStyle.vlcOrange
                                   : (index < root.currentStep ? VLCStyle.darkFgSecondary : VLCStyle.darkBgB2Transparent)

                            Behavior on width {
                                NumberAnimation { duration: VLCStyle.duration_short }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: VLCStyle.border
                color: VLCStyle.vlcBorderSubtle
            }

            // Step Content Pages
            StackLayout {
                id: stepStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: root.currentStep

                // Step 1: Welcome
                ColumnLayout {
                    spacing: VLCStyle.margin_normal
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    Widgets.BannerCone {
                        Layout.alignment: Qt.AlignHCenter
                        sourceSize.width: VLCStyle.dp(80, VLCStyle.scale)
                        sourceSize.height: VLCStyle.dp(80, VLCStyle.scale)
                        color: VLCStyle.vlcOrange
                    }

                    Text {
                        text: qsTr("Welcome to VLC media player")
                        color: VLCStyle.darkFgPrimary
                        font.pixelSize: VLCStyle.fontSize_xlarge
                        font.weight: Font.Bold
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: qsTr("Redesigned with frosted glass, floating controls, and audio DSP drawers.")
                        color: VLCStyle.darkFgMuted
                        font.pixelSize: VLCStyle.fontSize_normal
                        Layout.alignment: Qt.AlignHCenter
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: VLCStyle.margin_normal

                        Rectangle {
                            radius: VLCStyle.chip_radius
                            color: VLCStyle.darkBgB1Transparent
                            border.width: VLCStyle.border
                            border.color: VLCStyle.vlcBorderSubtle
                            implicitWidth: pillText1.implicitWidth + VLCStyle.margin_normal * 2
                            implicitHeight: VLCStyle.dp(28, VLCStyle.scale)

                            Text {
                                id: pillText1
                                anchors.centerIn: parent
                                text: qsTr("Floating HUD Bar")
                                color: VLCStyle.vlcOrange
                                font.pixelSize: VLCStyle.fontSize_small
                            }
                        }

                        Rectangle {
                            radius: VLCStyle.chip_radius
                            color: VLCStyle.darkBgB1Transparent
                            border.width: VLCStyle.border
                            border.color: VLCStyle.vlcBorderSubtle
                            implicitWidth: pillText2.implicitWidth + VLCStyle.margin_normal * 2
                            implicitHeight: VLCStyle.dp(28, VLCStyle.scale)

                            Text {
                                id: pillText2
                                anchors.centerIn: parent
                                text: qsTr("10-Band Equalizer")
                                color: VLCStyle.vlcOrange
                                font.pixelSize: VLCStyle.fontSize_small
                            }
                        }

                        Rectangle {
                            radius: VLCStyle.chip_radius
                            color: VLCStyle.darkBgB1Transparent
                            border.width: VLCStyle.border
                            border.color: VLCStyle.vlcBorderSubtle
                            implicitWidth: pillText3.implicitWidth + VLCStyle.margin_normal * 2
                            implicitHeight: VLCStyle.dp(28, VLCStyle.scale)

                            Text {
                                id: pillText3
                                anchors.centerIn: parent
                                text: qsTr("Native QML Settings")
                                color: VLCStyle.vlcOrange
                                font.pixelSize: VLCStyle.fontSize_small
                            }
                        }
                    }
                }

                // Step 2: Appearance
                ColumnLayout {
                    spacing: VLCStyle.margin_normal

                    Text {
                        text: qsTr("Personalize Appearance")
                        color: VLCStyle.darkFgPrimary
                        font.pixelSize: VLCStyle.fontSize_large
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: qsTr("Choose your preferred theme accent and visual effect settings.")
                        color: VLCStyle.darkFgMuted
                        font.pixelSize: VLCStyle.fontSize_normal
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: VLCStyle.dp(80, VLCStyle.scale)
                        radius: VLCStyle.card_radius
                        color: VLCStyle.darkBgB1Transparent
                        border.width: VLCStyle.border
                        border.color: VLCStyle.vlcBorderSubtle

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: VLCStyle.margin_normal

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: qsTr("Frosted Acrylic Blur")
                                    color: VLCStyle.darkFgPrimary
                                    font.pixelSize: VLCStyle.fontSize_normal
                                }

                                Text {
                                    text: qsTr("GPU-accelerated background blur beneath controls.")
                                    color: VLCStyle.darkFgMuted
                                    font.pixelSize: VLCStyle.fontSize_small
                                }
                            }

                            Switch {
                                checked: VLCStyle.acrylicBlurEnabled
                                onToggled: VLCStyle.acrylicBlurEnabled = checked
                            }
                        }
                    }

                    Text {
                        text: qsTr("Theme Accent Color")
                        color: VLCStyle.darkFgPrimary
                        font.pixelSize: VLCStyle.fontSize_normal
                    }

                    RowLayout {
                        spacing: VLCStyle.margin_normal

                        Repeater {
                            model: [
                                { name: "VLC Orange", color: "#D37918" },
                                { name: "Sky Blue", color: "#0284C7" },
                                { name: "Emerald", color: "#10B981" },
                                { name: "Purple", color: "#8B5CF6" },
                                { name: "Amber", color: "#F59E0B" }
                            ]

                            Rectangle {
                                width: VLCStyle.dp(36, VLCStyle.scale)
                                height: VLCStyle.dp(36, VLCStyle.scale)
                                radius: width / 2
                                color: modelData.color
                                border.width: VLCStyle.vlcOrange === modelData.color ? 3 : 1
                                border.color: VLCStyle.vlcOrange === modelData.color ? VLCStyle.darkFgPrimary : VLCStyle.vlcBorderSubtle

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: VLCStyle.vlcOrange = modelData.color
                                }
                            }
                        }
                    }
                }

                // Step 3: Media Library
                ColumnLayout {
                    spacing: VLCStyle.margin_normal

                    Text {
                        text: qsTr("Media Library Scan")
                        color: VLCStyle.darkFgPrimary
                        font.pixelSize: VLCStyle.fontSize_large
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: qsTr("Select which media folders VLC should automatically monitor.")
                        color: VLCStyle.darkFgMuted
                        font.pixelSize: VLCStyle.fontSize_normal
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: VLCStyle.dp(64, VLCStyle.scale)
                        radius: VLCStyle.card_radius
                        color: VLCStyle.darkBgB1Transparent
                        border.width: VLCStyle.border
                        border.color: VLCStyle.vlcBorderSubtle

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: VLCStyle.margin_normal

                            Text {
                                text: qsTr("🎬 Videos Folder")
                                color: VLCStyle.darkFgPrimary
                                font.pixelSize: VLCStyle.fontSize_normal
                                Layout.fillWidth: true
                            }

                            CheckBox { checked: true }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: VLCStyle.dp(64, VLCStyle.scale)
                        radius: VLCStyle.card_radius
                        color: VLCStyle.darkBgB1Transparent
                        border.width: VLCStyle.border
                        border.color: VLCStyle.vlcBorderSubtle

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: VLCStyle.margin_normal

                            Text {
                                text: qsTr("🎵 Music Folder")
                                color: VLCStyle.darkFgPrimary
                                font.pixelSize: VLCStyle.fontSize_normal
                                Layout.fillWidth: true
                            }

                            CheckBox { checked: true }
                        }
                    }
                }

                // Step 4: Privacy
                ColumnLayout {
                    spacing: VLCStyle.margin_normal

                    Text {
                        text: qsTr("Privacy and Network Policy")
                        color: VLCStyle.darkFgPrimary
                        font.pixelSize: VLCStyle.fontSize_large
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: qsTr("VLC does not collect or transmit personal data to third parties.")
                        color: VLCStyle.darkFgMuted
                        font.pixelSize: VLCStyle.fontSize_normal
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: VLCStyle.dp(70, VLCStyle.scale)
                        radius: VLCStyle.card_radius
                        color: VLCStyle.darkBgB1Transparent
                        border.width: VLCStyle.border
                        border.color: VLCStyle.vlcBorderSubtle

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: VLCStyle.margin_normal

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: qsTr("Fetch online album artwork & track details")
                                    color: VLCStyle.darkFgPrimary
                                    font.pixelSize: VLCStyle.fontSize_normal
                                }

                                Text {
                                    text: qsTr("Connects to online music databases to retrieve covers.")
                                    color: VLCStyle.darkFgMuted
                                    font.pixelSize: VLCStyle.fontSize_small
                                }
                            }

                            Switch { checked: true }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: VLCStyle.dp(70, VLCStyle.scale)
                        radius: VLCStyle.card_radius
                        color: VLCStyle.darkBgB1Transparent
                        border.width: VLCStyle.border
                        border.color: VLCStyle.vlcBorderSubtle

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: VLCStyle.margin_normal

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    text: qsTr("Auto-download matching subtitles")
                                    color: VLCStyle.darkFgPrimary
                                    font.pixelSize: VLCStyle.fontSize_normal
                                }

                                Text {
                                    text: qsTr("Fetches subtitle files for movies without embedded tracks.")
                                    color: VLCStyle.darkFgMuted
                                    font.pixelSize: VLCStyle.fontSize_small
                                }
                            }

                            Switch { checked: false }
                        }
                    }
                }

                // Step 5: Completed
                ColumnLayout {
                    spacing: VLCStyle.margin_normal
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: VLCStyle.dp(64, VLCStyle.scale)
                        height: VLCStyle.dp(64, VLCStyle.scale)
                        radius: width / 2
                        color: VLCStyle.vlcOrange

                        Text {
                            anchors.centerIn: parent
                            text: "✓"
                            color: "#FFFFFF"
                            font.pixelSize: VLCStyle.fontSize_xlarge
                            font.weight: Font.Bold
                        }
                    }

                    Text {
                        text: qsTr("You're all set!")
                        color: VLCStyle.darkFgPrimary
                        font.pixelSize: VLCStyle.fontSize_xlarge
                        font.weight: Font.Bold
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: qsTr("VLC media player is configured and ready to play your media.")
                        color: VLCStyle.darkFgMuted
                        font.pixelSize: VLCStyle.fontSize_normal
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: VLCStyle.border
                color: VLCStyle.vlcBorderSubtle
            }

            // Bottom Navigation Buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: VLCStyle.margin_normal

                Button {
                    visible: root.currentStep > 0
                    text: qsTr("Back")
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

                    onClicked: root.currentStep--
                }

                Item { Layout.fillWidth: true }

                Button {
                    visible: root.currentStep < root.totalSteps - 1
                    text: qsTr("Skip")
                    Layout.preferredHeight: VLCStyle.dp(34, VLCStyle.scale)

                    background: Rectangle {
                        radius: VLCStyle.control_radius
                        color: "transparent"
                    }

                    contentItem: Text {
                        text: parent.text
                        color: VLCStyle.darkFgMuted
                        font.pixelSize: VLCStyle.fontSize_normal
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: root.close()
                }

                Button {
                    text: (root.currentStep === root.totalSteps - 1) ? qsTr("Start Using VLC") : qsTr("Next")
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
                        if (root.currentStep < root.totalSteps - 1) {
                            root.currentStep++
                        } else {
                            ConfigModel.save()
                            root.close()
                        }
                    }
                }
            }
        }
    }
}
