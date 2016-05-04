import QtQuick 2.0

Item {
    id: screenCookingSecondHalf
    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 10

    BackButton {
        id: backbutton
        anchors.margins: myMargins
        x: myMargins
        y: myMargins
//        onClicked: {
//            stackView.pop({immediate:immediateTransitions});
//        }
    }

    Text {
        id: screenLabel
        font.family: localFont.name
        font.pointSize: 24
        text: "COOKING"
        anchors.margins: myMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backbutton.verticalCenter
        color: appForegroundColor
    }

    Item {
        id: centerCircle
        implicitWidth: parent.height * 0.7;
        implicitHeight: width
        anchors.margins: myMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40

        CircleAsymmetrical {
            id: dataCircle
            height: parent.height;
            width: parent.width
            topText: tempToString(upperFront.setTemp)
            middleText: tempToString(lowerFront.setTemp)
            bottomText: timeToString(cookTime - currentTime)
            currentValue: 100 * currentTime/cookTime
        }
    }

    CancelButton {
        id: cancelButton
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.right: centerCircle.left
        onClicked: {
            console.log("The cancel button was clicked.");
            countdownTimer.stop();
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
        }
    }
    SideButton {
        id: pauseButton
        buttonText: "PAUSE"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.left: centerCircle.right
        onClicked: {
            console.log("The pause button was clicked.");
            if (countdownTimer.running) {
                countdownTimer.stop();
            } else {
                countdownTimer.start();
            }
        }
    }
    Timer {
        id: countdownTimer
        interval: 1000; running: true; repeat: true
        onTriggered: {
            currentTime++;
            if (currentTime < finalCheckTime) {
                var val = 100 * currentTime/cookTime;
                dataCircle.currentValue = val;

                val = cookTime - currentTime;
                dataCircle.bottomText = timeToString(val);

            } else {
                countdownTimer.stop();
                stackView.push({item:Qt.resolvedUrl("Screen_CookingFinalCheck.qml"), immediate:immediateTransitions});
            }
        }
    }
}

