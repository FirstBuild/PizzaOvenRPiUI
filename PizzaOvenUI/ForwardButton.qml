import QtQuick 2.3

Rectangle {
    id: forwardButton
    signal clicked()
    implicitWidth: 14
    implicitHeight: 26
    color: appBackgroundColor
    x: 48
    y: 45
    property int segmentThickness: 2
    property color segmentColor: appForegroundColor

    property real maxOpacity: 1.0

    NumberAnimation on opacity { from: 0; to: maxOpacity; easing.type: Easing.InCubic }

    Canvas {
        id: drawing
        width: parent.width
        height: parent.height
        antialiasing: true
        anchors.centerIn: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.save();

            ctx.clearRect(0, 0, width, height);

            ctx.beginPath();
            ctx.lineWidth = segmentThickness;
            ctx.strokeStyle = segmentColor;
            ctx.moveTo(1, 1);
            ctx.lineTo(width-1, height/2);
            ctx.lineTo(1, height-1);
            ctx.stroke();

            ctx.restore();
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            autoShutoff.reset();
            sounds.touch.play();
            forwardButton.clicked();
        }
    }
}

