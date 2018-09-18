import QtQuick 2.0

Item {
    id: symbol

    width: 40
    height: 40

    property color color: appForegroundColor
    property color iconColor: color
    property bool blinking: false
    property bool state: false

    onIconColorChanged: bars.requestPaint()
    onColorChanged: bars.requestPaint()

    onBlinkingChanged: {
        if (!blinking) iconColor = color;
    }

    Timer {
        id: iconBlinkTimer
        interval: 500
        repeat: true
        running: blinking
        onTriggered: {
            if (state) {
                console.log("Setting the icon color to black.");
                iconColor = appBackgroundColor;
            } else {
                console.log("Setting the icon color to color.");
                iconColor = color;
            }
            state = !state;
        }
    }

    Canvas {
        id: bars
        width: parent.width
        height: width
        antialiasing: true
        anchors.centerIn: parent

        property real originX: width / 2
        property real originY: 3 * height / 4
        property real lineWidth: 6
        property real radius1: 4
        property real radius2: height/3
        property real radius3: 2 * height / 3
        property real startAngle: Math.PI + Math.PI / 4
        property real endAngle: 7 * Math.PI / 4

        onPaint: {
            var ctx = getContext("2d");
            ctx.save();

            ctx.clearRect(0, 0, bars.width, bars.height);

            ctx.beginPath();
            ctx.lineWidth = 1;
            ctx.strokeStyle = symbol.iconColor;
            ctx.fillStyle = symbol.iconColor;
            ctx.arc(bars.originX,
                    bars.originY,
                    bars.radius1,
                    0,
                    2 * Math.PI,
                    false);
            ctx.stroke();
            ctx.fill();

            ctx.beginPath();
            ctx.lineWidth = bars.lineWidth;
            ctx.strokeStyle = symbol.iconColor;
            ctx.arc(bars.originX,
                    bars.originY,
                    bars.radius2,
                    bars.startAngle,
                    bars.endAngle,
                    false);
            ctx.stroke();

            ctx.beginPath();
            ctx.lineWidth = bars.lineWidth;
            ctx.strokeStyle = symbol.iconColor;
            ctx.arc(bars.originX,
                    bars.originY,
                    bars.radius3,
                    bars.startAngle,
                    bars.endAngle,
                    false);
            ctx.stroke();

            ctx.restore();
        }
    }
}
