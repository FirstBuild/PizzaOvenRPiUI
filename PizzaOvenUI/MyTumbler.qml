/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Labs Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.6
import Qt.labs.controls 1.0
import Qt.labs.templates 1.0 as T

T.Tumbler {
    id: control
    implicitWidth: 60
    implicitHeight: 200
    property color foregroundColor: appForegroundColor
    property int pointSize: 24
    property int horizontalAlignment: Text.AlignLeft
    property int verticalAlignment: Text.AlignVCenter
    signal clicked(string name)

    //! [delegate]
    delegate:
        Text {
        id: label
        text: modelData
        color: foregroundColor
        font.pointSize: pointSize
        font.family: localFont.name
        opacity: Math.pow(2.7183, -Math.abs(Tumbler.displacement))
        horizontalAlignment: control.horizontalAlignment
        verticalAlignment: control.verticalAlignment
        height: control.height / control.visibleItemCount
        width: control.width
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                control.clicked(text);
                if (name !== listView.currentItem.text) {
                    for (var i=0; i<control.count; i++) {
                        if (control.model.get(i).name === name) {
                            listView.positionViewAtIndex(i, ListView.Center);
                            return;
                        }
                    }
                } else {
                    console.log(name + " was clicked.");
                }
            }
        }
    }
    //! [delegate]

    contentItem: ListView {
        id: listView
        model: control.model
        snapMode: ListView.SnapToItem
        anchors.fill: parent
        delegate: control.delegate
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: height / 2 - (height / control.visibleItemCount / 2)
        preferredHighlightEnd: height / 2  + (height / control.visibleItemCount / 2)
        clip: true
    }

    //! [contentItem]
//    contentItem: PathView {
//        id: pathView
//        model: control.model
//        delegate: control.delegate
//        clip: true
//        pathItemCount: control.visibleItemCount + 1
//        preferredHighlightBegin: 0.5
//        preferredHighlightEnd: 0.5
//        dragMargin: width / 2

//        path: Path {
//            startX: pathView.width / 2
//            startY: -pathView.delegateHeight / 2
//            PathLine {
//                x: pathView.width / 2
//                y: pathView.pathItemCount * pathView.delegateHeight - pathView.delegateHeight / 2
//            }
//        }

//        property real delegateHeight: control.availableHeight / control.visibleItemCount
//    }
    //! [contentItem]

    Canvas {
        id:canvas
        width:control.width
        height:control.height
        property color strokeStyle:  fillStyle
        property color fillStyle: appGrayColor
        property bool fill: true
        property bool stroke: true
        property real alpha: 1.0
        property int lineWidth: 1
        antialiasing: true
        z: 10

        onFillChanged:requestPaint();
        onStrokeChanged:requestPaint();
        onScaleChanged:requestPaint();

        onPaint: {
            var ctx = canvas.getContext('2d');
            var originX = 0
            var originY = 0
            ctx.save();

            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.translate(originX, originX);
            ctx.globalAlpha = canvas.alpha;
            ctx.strokeStyle = canvas.strokeStyle;
            ctx.fillStyle = canvas.fillStyle;
            ctx.lineWidth = canvas.lineWidth;

            ctx.translate(originX, originY)
            ctx.scale(canvas.scale, canvas.scale);
            //            ctx.rotate(canvas.rotate);
            ctx.translate(-originX, -originY)

            ctx.beginPath();
            //            ctx.moveTo(75,40);
            var y1 = control.height/2 - (lineSpacing/2);
            var y2 = control.height/2 + (lineSpacing/2);
            ctx.moveTo(0, y1);
            ctx.lineTo(control.width, y1);
            ctx.moveTo(0, y2);
            ctx.lineTo(control.width, y2);

            // Draw an X across the viewport
//            ctx.moveTo(0, 0);
//            ctx.lineTo(control.width, control.height);
//            ctx.moveTo(0, control.height);
//            ctx.lineTo(control.width, 0);
            // Draw a border around the viewport
//            ctx.moveTo(0, 0);
//            ctx.lineTo(control.width, 0);
//            ctx.moveTo(0, control.height);
//            ctx.lineTo(control.width, control.height);
//            ctx.moveTo(0, 0);
//            ctx.lineTo(0, control.height);
//            ctx.moveTo(control.width, 0);
//            ctx.lineTo(control.width, control.height);

            ctx.closePath();
            if (canvas.fill)
                ctx.fill();
            if (canvas.stroke)
                ctx.stroke();
            ctx.restore();
        }
    }
}
