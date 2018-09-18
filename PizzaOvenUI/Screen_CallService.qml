import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    color: appBackgroundColor
    width: screenWidth
    height: screenHeight
    anchors.centerIn: parent

    property color messageColor: "yellow"

    // center circle
    Item {
        id: centerCircle
        height: 206
        width: 206
        x: (parent.width - width) / 2
        y: 96

        Rectangle {
            id: messageCircle
            height: parent.height
            width: parent.width
            radius: width/2
            color: appBackgroundColor
            border.width: 4
            border.color: messageColor
        }

        Rectangle {
            id: warningTriangle
            width: 45
            height: 50

            color: appBackgroundColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
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

                    // roof
                    ctx.beginPath();
                    ctx.lineWidth = 2;
                    ctx.strokeStyle = messageColor;
                    ctx.moveTo(1, height);
                    ctx.lineTo(width/2, 1);
                    ctx.lineTo(width, height);
                    ctx.stroke();

                    ctx.beginPath();
                    ctx.lineWidth = 4;
                    ctx.strokeStyle = messageColor;
                    ctx.moveTo(width, height);
                    ctx.lineTo(1, height);
                    ctx.stroke();

                    ctx.restore();
                }
            }
            Text {
                text: "!"
                font.family: localFont.name
                font.pointSize: 25
                color: messageColor
                width: parent.width
                anchors.bottom: parent.bottom
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignBottom
            }
        }
        Column{
            anchors.top: warningTriangle.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 10
            width: messageCircle.width
            height: messageCircle.height
            spacing: 0
            Text {
                text: "Shut Off"
                wrapMode: Text.Wrap
                font.family: localFont.name
                font.pointSize: 20
                color: appForegroundColor
                width: parent.width
//                height: 40
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                text: "Please Call Service"
                wrapMode: Text.Wrap
                font.family: localFont.name
                font.pointSize: 16
                color: appForegroundColor
                width: parent.width
//                height: 40
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                text: "800-432-2737"
                wrapMode: Text.Wrap
                font.family: localFont.name
                font.pointSize: 20
                color: appForegroundColor
                width: parent.width
//                height: 40
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("Service screen clicked.");
            failureMessages.failureText = "FAILURES:\r\n" + failures.getFailureText();
            failureMessages.visible = true;
        }
    }

    Rectangle {
        id: failureMessages
        z: 100
        visible: false
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        color: appBackgroundColor
        property string failureText: ""

        Text {
            id: idFailureText
            text: parent.failureText
            width: parent.width
            height:parent.height
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: localFont.name
            font.pointSize: 20
            color: appForegroundColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                idTemperatures.visible = true;
                failureMessages.visible = false;
            }
        }
    }

    Rectangle {
        id: idTemperatures
        z: 200
        visible: false
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        color: appBackgroundColor
        property string temperatures: ""

        Text {
            text: "TEMPERATURES\r\n" +
                  "UPPER FRONT: " + upperFront.currentTemp + "\r\n" +
                  "UPPER REAR: " + upperRear.currentTemp + "\r\n" +
                  "LOWER FRONT: " + lowerFront.currentTemp + "\r\n" +
                  "LOWER REAR: " + lowerRear.currentTemp
            width: parent.width
            height:parent.height
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: localFont.name
            font.pointSize: 20
            color: appForegroundColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                idTemperatures.visible = false;
            }
        }
    }
}
