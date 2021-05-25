import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: thisScreen
    color: appBackgroundColor
    width: screenWidth
    height: screenHeight
    anchors.centerIn: parent
    property string screenName: "Screen_CallService"
    property color messageColor: "yellow"
    property int margin: 10
    property int boxHeight: height - serviceGearButton.y - serviceGearButton.height - (2 * margin)
    property int boxWidth: parent.width - (margin * 2)

    function screenEntry() {
        console.log("Entering call service screen");
    }

    SequentialAnimation {
        id: gearActionAnimation
        OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
        ScriptAction {
            script: {
                stackView.push({item: Qt.resolvedUrl("Screen_Settings2.qml"), immediate:immediateTransitions});
            }
        }
    }

    GearButton {
        id: serviceGearButton
        onClicked: gearActionAnimation.start()
    }

    // center circle
    Item {
        id: centerCircle
        //        height: 206
        //        width: 206
        height: 272
        width: 272
        x: (parent.width - width) / 2
        //        y: 96
        y: 127

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
//            width: 45
//            height: 50
            width: 59
            height: 66

            color: appBackgroundColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
//            anchors.topMargin: 10
            anchors.topMargin: 13
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
                font.pointSize: 33
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
            anchors.topMargin: 13
            width: messageCircle.width
            height: messageCircle.height
            spacing: 0
            Text {
                text: "Shut Off"
                wrapMode: Text.Wrap
                font.family: localFont.name
                font.pointSize: 26
                color: appForegroundColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                text: "Please Call Service"
                wrapMode: Text.Wrap
                font.family: localFont.name
                font.pointSize: 21
                color: appForegroundColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                text: "800-432-2737"
                wrapMode: Text.Wrap
                font.family: localFont.name
                font.pointSize: 26
                color: appForegroundColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
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
    }

    Rectangle {
        id: failureMessages
        z: 100
        visible: false
        width: boxWidth
        height: boxHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: serviceGearButton.bottom
        anchors.topMargin: margin
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
            font.pointSize: 26
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
        width: boxWidth
        height: boxHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: serviceGearButton.bottom
        anchors.topMargin: margin
        color: appBackgroundColor

        Text {
            id: titleText
            text: "TEMPERATURES"
            color: appForegroundColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: localFont.name
            font.pointSize: 18
            anchors.bottom: tempColumn.top
            anchors.horizontalCenter: tempColumn.horizontalCenter
            anchors.bottomMargin: 13
        }

        Column {
            id: tempColumn
            anchors.centerIn: parent
            Row {
                FaultText {text: "Location"}
                FaultText {text: "Current"}
                FaultText {text: "Fault"}
            }
            Row {
                FaultText {text: "Upper Front"}
                FaultText {
                    text: upperFront.currentTemp.toString()
                }
                FaultText {
                    text: upperFront.failTemp.toString()
                }
            }
            Row {
                FaultText {text: "Upper Rear"}
                FaultText {
                    text: upperRear.currentTemp.toString()
                }
                FaultText {
                    text: upperRear.failTemp.toString()
                }
                visible: rootWindow.originalConfiguration
            }
            Row {
                FaultText {text: "Lower Front"}
                FaultText {
                    text: lowerFront.currentTemp.toString()
                }
                FaultText {
                    text: lowerFront.failTemp.toString()
                }
            }
            Row {
                FaultText {text: "Lower Rear"}
                FaultText {
                    text: lowerRear.currentTemp.toString()
                }
                FaultText {
                    text: lowerRear.failTemp.toString()
                }
                visible: rootWindow.originalConfiguration
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                idTemperatures.visible = false;
            }
        }
    }
}
