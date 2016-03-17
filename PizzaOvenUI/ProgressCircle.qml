import QtQuick 2.0

Item {
    id: progressCircle
    implicitWidth: parent.width + 3
    implicitHeight: width

    property real currentValue: 0
    onCurrentValueChanged: progress.requestPaint()

    // draws two arcs (portion of a circle)
    // fills the circle with a lighter secondary color
    // when pressed
    Canvas {
        id: progress
        implicitWidth: parent.width + 3
        height: width
        antialiasing: true
        anchors.centerIn: parent

        property color primaryColor: appForegroundColor
        property color secondaryColor: appForegroundColor

        property real centerWidth: width / 2
        property real centerHeight: height / 2
        property real radius: Math.min(parent.width, parent.height) / 2

        property real minimumValue: 0
        property real maximumValue: 100

        // this is the angle that splits the circle in two arcs
        // first arc is drawn from 0 radians to angle radians
        // second arc is angle radians to 2*PI radians
        property real angle: (currentValue - minimumValue) / (maximumValue - minimumValue) * 2 * Math.PI

        // we want both circle to start / end at 12 o'clock
        // without this offset we would start / end at 9 o'clock
        property real angleOffset: -Math.PI / 2

        property string text: "Text"

        signal clicked()

        onMinimumValueChanged: requestPaint()
        onMaximumValueChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d");
            ctx.save();

            ctx.clearRect(0, 0, progress.width, progress.height);

            // First, thinner arc
            // From angle to 2*PI

            ctx.beginPath();
            ctx.lineWidth = 1;
            ctx.strokeStyle = primaryColor;
            ctx.arc(progress.centerWidth,
                    progress.centerHeight,
                    progress.radius,
                    angleOffset + progress.angle,
                    angleOffset + 2*Math.PI);
            ctx.stroke();


            // Second, thicker arc
            // From 0 to angle

            ctx.beginPath();
            ctx.lineWidth = 3;
            ctx.strokeStyle = progress.secondaryColor;
            ctx.arc(progress.centerWidth,
                    progress.centerHeight,
                    progress.radius,
                    progress.angleOffset,
                    progress.angleOffset + progress.angle);
            ctx.stroke();

            ctx.restore();
        }
    }
}

