import QtQuick 2.0

Item {
    id: screenCookingFinal
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

        ProgressCircle {
            id: progress
            currentValue: 100 * currentTime/cookTime
        }

        Rectangle {
            id: horizontalBar
            width: parent.width * 0.5
            height: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: -cancelButton.height/2
            anchors.top: parent.verticalCenter
            border.width: 1
            border.color: appForegroundColor
        }
        Text {
            id: setTemp
            text: tempToString(targetTemp)
            font.family: localFont.name
            font.pointSize: 18
            anchors.margins: myMargins
            anchors.bottom: horizontalBar.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: appForegroundColor
        }
        Text {
            id: setTime
            text: timeToString(cookTime - currentTime)
            font.family: localFont.name
            font.pointSize: 36
            anchors.topMargin: 40
            anchors.top: horizontalBar.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: appForegroundColor
        }
    }

    SideButton {
        id: cancelButton
        buttonText: "CANCEL"
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
            if (currentTime <= cookTime) {
                var val = 100 * currentTime/cookTime;
                if (val > 100) {
                    val = 0;
                    countdownTimer.stop();
                    stackView.push({item:Qt.resolvedUrl("Screen_CookingDone.qml"), immediate:immediateTransitions});
                }
                progress.currentValue = val;
            } else {
                console.log("Stoping countdown final cooking.");
                countdownTimer.stop();
                stackView.push({item:Qt.resolvedUrl("Screen_CookingDone.qml"), immediate:immediateTransitions});
            }
        }
    }
}

