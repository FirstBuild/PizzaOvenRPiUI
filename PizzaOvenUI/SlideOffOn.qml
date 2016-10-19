import QtQuick 2.0

Item {
    id: toggle

    width: 110
    height: 40

    signal clicked()

    property int barHeight: 4
    property int barWidth: toggle.width * 0.4
    property color barColor: { toggle.state ? appForegroundColor : appGrayColor }
    property int ballRadius: 10
    property color ballColor: { toggle.state ? appForegroundColor : appGrayColor }
    property bool state: false
    property string trueText: "ON"
    property string falseText: "OFF"

    onStateChanged: drawing.requestPaint()

    Text {
        text: { toggle.state ? trueText : falseText }
        font.family: localFont.name
        font.pointSize: 18
        color: { toggle.state ? appForegroundColor : appGrayText }
        width: parent.width/2
        height: parent.height
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
    }

    Canvas {
        id: drawing
        width: toggle.barWidth
        height: parent.height
        antialiasing: true
        anchors.right: parent.right
        property int ballStart: toggle.state ? width - ballRadius - 1 : ballRadius

        onPaint: {
            var ctx = getContext("2d");
            ctx.save();

            ctx.clearRect(0, 0, width, height);

            ctx.strokeStyle = barColor;

            ctx.beginPath();
            ctx.strokeStyle = barColor;
            ctx.lineCap = "round";
            ctx.lineWidth = barHeight;
            ctx.moveTo(barHeight/2, height/2);
            ctx.lineTo(width - barHeight, height/2);
            ctx.stroke();

            ctx.beginPath();
            ctx.strokeStyle = barColor;
            ctx.fillStyle = barColor;
            ctx.lineWidth = 1;
            ctx.arc(ballStart, height/2, ballRadius, 0, 2 * Math.PI);
            ctx.fill();

            ctx.restore();
        }
    }


    MouseArea {
        anchors.fill: parent
        onClicked: {
            toggle.state = !toggle.state;
            sounds.touch.play();
            toggle.clicked();
        }
    }
}
