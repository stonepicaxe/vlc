/*****************************************************************************
 * Copyright (C) 2019 VLC authors and VideoLAN
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * ( at your option ) any later version.
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
import QtQuick.Templates as T
import QtQuick.Layouts
import QtQml.Models
import QtQuick.Window


import VLC.MainInterface
import VLC.Style
import VLC.Playlist
import VLC.Widgets as Widgets
import VLC.Menus as Menus
import VLC.Util

T.ToolBar {
    id: root

    Accessible.name: qsTr("Local top bar")
    AccessibleCompat.id: "localTopbar"

    property bool useAcrylic: true

    // For now, used for d&d functionality
    // Not strictly necessary to set
    property Item plListView

    property bool _showCSD: MainCtx.clientSideDecoration
        && !(MainCtx.intfMainWindow.visibility === Window.FullScreen)
        && !MainCtx.hasToolbarMenu

    //whether the navigation pannel is actually visible or not
    property alias navigationVisible: navigationVisibilty.checked
    property alias playqueueVisible: playlistBtn.checked

    property alias navigationButton: navigationVisibilty

    signal toggleNavigationVisibility()
    signal togglePlayqueueVisibility()

    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                             implicitContentWidth + leftPadding + rightPadding + (_showCSD ? csdButtons.implicitWidth : 0))

    readonly property ColorContext colorContext: ColorContext {
        id: theme
        colorSet: ColorContext.Window
    }

    background: Rectangle {
        color: VLCStyle.darkBgA3Transparent
        border.width: VLCStyle.border
        border.color: VLCStyle.vlcBorderBright

        layer.enabled: true
        layer.effect: Widgets.FrostedGlassEffect {
            tint: VLCStyle.darkBgA3Transparent
        }
    }

    contentItem: Item {

        implicitHeight: VLCStyle.globalToolbar_height
        implicitWidth: navigationButtons.implicitWidth
                     + playqueueButtonsTop.implicitWidth
                     + VLCStyle.margin_xsmall * 2

        Item {
            id: navigationButtons

            implicitWidth: navigationButtonsRow.implicitWidth

            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                leftMargin: VLCStyle.margin_xsmall
            }

            Navigation.parentItem: root

            Row {
                id: navigationButtonsRow

                anchors.verticalCenter: parent.verticalCenter
                spacing: VLCStyle.margin_normal

                Navigation.parentItem: root
                Navigation.rightItem: playqueueButtonsTop

                Widgets.IconToolButton {
                    id: navigationVisibilty

                    focus: true

                    text: VLCIcons.panel_left
                    description: qsTr("Show navigation menu")

                    AccessibleCompat.id: "sidebarToggleButton"

                    font.pixelSize: VLCStyle.icon_banner
                    height: VLCStyle.bannerButton_height
                    width: VLCStyle.bannerButton_width

                    onClicked: root.toggleNavigationVisibility()

                    Navigation.parentItem: navigationButtons
                    Navigation.rightItem: historyBack
                }

                Widgets.IconToolButton {
                    id: historyBack

                    font.pixelSize: VLCStyle.icon_banner
                    text: VLCIcons.back
                    description: qsTr("Previous")

                    AccessibleCompat.id: "historyBackButton"

                    height: VLCStyle.bannerButton_height
                    width: VLCStyle.bannerButton_width

                    onClicked: History.previous()
                    enabled: !History.previousEmpty

                    onEnabledChanged: {
                        if (historyBack.activeFocus)
                            navigationVisibilty.focus = true
                    }

                    Navigation.parentItem: navigationButtons
                    Navigation.leftItem: navigationVisibilty
                    Navigation.rightItem: playlistBtn
                }

                Widgets.BannerCone {
                    id: logo

                    sourceSize.width: VLCStyle.bannerButton_height
                    sourceSize.height: VLCStyle.bannerButton_height
                    color: theme.accent
                }
            }
        }

        Item {
            id: playqueueButtonsTop

            implicitWidth: playqueueButtonsTopRow.implicitWidth

            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                //put the buttons below the CSD if we have enough space
                rightMargin: VLCStyle.margin_xsmall
                    + ((root._showCSD && root.topPadding < csdButtons.height)
                        ? Math.max(csdButtons.width - root.rightPadding, 0)
                        : 0)
            }

            Navigation.parentItem: root

            Row {
                id: playqueueButtonsTopRow

                anchors.verticalCenter: parent.verticalCenter
                spacing: VLCStyle.margin_normal

                Navigation.parentItem: root
                Navigation.leftItem: navigationButtons

                PlaylistPane.PlaylistToggleButton {
                    id: playlistBtn

                    plListView: root.plListView

                    Navigation.parentItem: playqueueButtonsTop
                    Navigation.rightItem: menuBtn
                    Navigation.leftItem: historyBack

                    onClicked:  root.togglePlayqueueVisibility()
                }

                Widgets.IconToolButton {
                    id: menuBtn

                    visible: !MainCtx.hasToolbarMenu
                    font.pixelSize: VLCStyle.icon_banner
                    text: VLCIcons.more
                    description: qsTr("Menu")
                    width: VLCStyle.bannerButton_width
                    height: VLCStyle.bannerButton_height
                    checked: contextMenu.shown

                    Navigation.parentItem: playqueueButtonsTop
                    Navigation.leftItem: playlistBtn

                    onClicked: contextMenu.popup(this.mapToGlobal(0, height))

                    Menus.QmlGlobalMenu {
                        id: contextMenu
                        ctx: MainCtx
                    }
                }
            }
        }

        Rectangle {
            id: searchBarPill
            anchors.centerIn: parent
            width: Math.min(Math.max(parent.width - navigationButtons.implicitWidth - playqueueButtonsTop.implicitWidth - VLCStyle.margin_large * 2, 0), VLCStyle.dp(340, VLCStyle.scale))
            height: VLCStyle.dp(32, VLCStyle.scale)
            visible: width > VLCStyle.dp(160, VLCStyle.scale)

            radius: VLCStyle.pill_radius
            color: searchMouseArea.containsMouse ? VLCStyle.darkBgB2Transparent : VLCStyle.darkBgB1Transparent
            border.width: VLCStyle.border
            border.color: searchMouseArea.containsMouse ? VLCStyle.vlcOrange : VLCStyle.vlcBorderBright

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: VLCStyle.margin_normal
                anchors.rightMargin: VLCStyle.margin_small
                spacing: VLCStyle.margin_xsmall

                Widgets.IconLabel {
                    text: VLCIcons.search
                    color: VLCStyle.darkFgSecondary
                    font.pixelSize: VLCStyle.icon_normal
                }

                Text {
                    Layout.fillWidth: true
                    text: qsTr("Search media...")
                    color: VLCStyle.darkFgMuted
                    font.pixelSize: VLCStyle.fontSize_normal
                    elide: Text.ElideRight
                }

                Rectangle {
                    radius: VLCStyle.chip_radius
                    color: VLCStyle.darkBgA2Transparent
                    border.width: VLCStyle.border
                    border.color: VLCStyle.vlcBorderSubtle
                    implicitWidth: shortcutBadgeText.implicitWidth + VLCStyle.margin_xsmall * 2
                    implicitHeight: VLCStyle.dp(20, VLCStyle.scale)

                    Text {
                        id: shortcutBadgeText
                        anchors.centerIn: parent
                        text: "Ctrl+F"
                        color: VLCStyle.darkFgMuted
                        font.pixelSize: VLCStyle.fontSize_small
                    }
                }
            }

            MouseArea {
                id: searchMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: MainCtx.search.askShow()
            }
        }

        Loader {
            z: -1

            anchors.fill: parent
            active: root._showCSD
            sourceComponent: Widgets.CSDTitlebarTapNDrapHandler {
            }
        }
    }

    Loader {
        id: csdButtons

        //csd button are
        parent:  root
        anchors {
            right: parent.right
            top: parent.top
        }

        height: VLCStyle.globalToolbar_height
        active: root._showCSD
        source: VLCStyle.palette.hasCSDImage
                  ? "qrc:///qt/qml/VLC/Widgets/CSDThemeButtonSet.qml"
                  : "qrc:///qt/qml/VLC/Widgets/CSDWindowButtonSet.qml"
    }
}
