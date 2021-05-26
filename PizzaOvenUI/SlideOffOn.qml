import QtQuick 2.0

Item {
    id: toggle

    width: 110 * screenScale
    height: 40 * screenScale

    signal clicked()

    property int barHeight: 4 * screenScale
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
        font.pointSize: 18 * screenScale
        color: { toggle.state ? appForegroundColor : appGrayText }
        width: parent.width/2
        height: parent.height
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.rightMargin: 5 * screenScale
    }

    Canvas {
        id: drawing
        width: parent.width/2
        height: parent.height
        antialiasing: true
        //anchors.right: parent.right
        anchors.left: parent.horizontalCenter
        property int ballStart: toggle.state ? width - ballRadius: ballRadius

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
            autoShutoff.reset();
            toggle.state = !toggle.state;
            sounds.touch.play();
            toggle.clicked();
        }
    }
}
