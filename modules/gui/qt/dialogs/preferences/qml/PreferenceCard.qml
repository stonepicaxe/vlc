/*****************************************************************************
 * PreferenceCard.qml : Styled card container for preference items
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

Rectangle {
    id: root

    property string title: ""
    property string description: ""
    default property alias contentData: contentColumn.data

    Layout.fillWidth: true
    implicitHeight: mainLayout.implicitHeight + VLCStyle.margin_normal * 2

    radius: VLCStyle.card_radius
    color: VLCStyle.darkBgB1Transparent
    border.width: VLCStyle.border
    border.color: VLCStyle.vlcBorderSubtle

    ColumnLayout {
        id: mainLayout
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: VLCStyle.margin_normal
        }
        spacing: VLCStyle.margin_small

        Text {
            visible: root.title.length > 0
            text: root.title
            color: VLCStyle.darkFgPrimary
            font.pixelSize: VLCStyle.fontSize_normal
            font.weight: Font.DemiBold
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

        ColumnLayout {
            id: contentColumn
            Layout.fillWidth: true
            spacing: VLCStyle.margin_small
        }
    }
}
