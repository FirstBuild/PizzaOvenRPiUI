import QtQuick 2.0

Item {
    id: screenRotatePizza
    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 10

    BackButton {
        id: backbutton
        anchors.margins: myMargins
        x: myMargins
        y: myMargins
        onClicked: {
            stackView.pop();
        }
    }

    Text {
        id: screenLabel
        font.family: localFont.name
        font.pointSize: 24
        text: "COOKING"
        anchors.margins: myMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backbutton.verticalCenter
    }

    Item {
        id: centerCircle
        implicitWidth: parent.height * 0.7;
        implicitHeight: width
        anchors.margins: myMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40

        ProgressCircle {
            id: progress
            currentValue: 100 * currentTime/cookTime
        }
        Text {
            text: "Rotate"
            font.family: localFont.name
            font.pointSize: 20
            anchors.bottomMargin: myMargins/2
            anchors.horizontalCenter: centerCircle.horizontalCenter
            anchors.bottom: centerCircle.verticalCenter
        }
        Text {
            text: "Pizza"
            font.family: localFont.name
            font.pointSize: 20
            anchors.topMargin: myMargins/2
            anchors.horizontalCenter: centerCircle.horizontalCenter
            anchors.top: centerCircle.verticalCenter
        }
    }

    SideButton {
        id: cancelButton
        buttonText: "CANCEL"
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.margins: myMargins
        anchors.right: centerCircle.left
        onClicked: {
            console.log("The cancel button was clicked.");
        }
    }
    SideButton {
        id: starttButton
        buttonText: "CONTINUE"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.left: centerCircle.right
        onClicked: {
            console.log("Stoping countdown timer in rotate.");
            countdownTimer.stop();
            stackView.push(Qt.resolvedUrl("Screen_CookingSecondHalf.qml"));
        }
    }

    Timer {
        id: countdownTimer
        interval: 1000; running: true; repeat: true
        onTriggered: {
            currentTime++;
            if (currentTime <= cookTime) {
                var val = 100 * currentTime/cookTime;
                if (val > 100) {
                    val = 0;
                    countdownTimer.stop();
                    stackView.push(Qt.resolvedUrl("Screen_Start.qml"));
                }
                progress.currentValue = val;
            } else {
                console.log("Stoping countdown timer in rotate.");
                countdownTimer.stop();
            }
        }
    }
}

