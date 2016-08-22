import QtQuick 2.0

Rectangle {
    id: backButton
    signal clicked()
    implicitWidth: 14
    implicitHeight: 26
    color: appBackgroundColor
    x: 48
    y: 45
    property int segmentThickness: 2
    property color segmentColor: appForegroundColor

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
            ctx.moveTo(width-1, height-1);
            ctx.lineTo(1, height/2);
            ctx.lineTo(width-1, 1);
            ctx.stroke();

            ctx.restore();
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            sounds.touch.play();
            backButton.clicked();
        }
        onPressed: {
            segmentColor = appBackgroundColor;
            backButton.color = appForegroundColor;
            drawing.requestPaint();
        }
        onReleased: {
            segmentColor = appForegroundColor;
            backButton.color = appBackgroundColor;
            drawing.requestPaint();
        }
    }
}

