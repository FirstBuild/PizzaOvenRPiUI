import QtQuick 2.0

Item {
    id: screenFinalCheck
    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 15

//    BackButton {
//        id: backbutton
//        anchors.margins: myMargins
//        x: myMargins
//        y: myMargins
//        onClicked: {
//            stackView.pop({immediate:immediateTransitions});
//        }
//    }

    HomeButton {
        id: homeButton
        anchors.margins: myMargins
        x: 5
        y: 5
        onClicked: {
            countdownTimer.stop();
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
        }
    }

    function screenEntry() {
        console.log("Playing the sound.");
        sounds.alarmUrgent.play();
    }

    Text {
        id: screenLabel
        font.family: localFont.name
        font.pointSize: 24
        text: "COOKING"
        anchors.margins: myMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: homeButton.verticalCenter
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
            width: centerCircle.width
            height: centerCircle.height
        }
        Text {
            text: "Final"
            font.family: localFont.name
            font.pointSize: 20
            anchors.bottomMargin: myMargins/2
            anchors.horizontalCenter: centerCircle.horizontalCenter
            anchors.bottom: centerCircle.verticalCenter
            color: appForegroundColor
        }
        Text {
            text: "Check"
            font.family: localFont.name
            font.pointSize: 20
            anchors.topMargin: myMargins/2
            anchors.horizontalCenter: centerCircle.horizontalCenter
            anchors.top: centerCircle.verticalCenter
            color: appForegroundColor
        }
    }

//    SideButton {
//        id: cancelButton
//        buttonText: "CANCEL"
//        anchors.verticalCenter: centerCircle.verticalCenter
//        anchors.margins: myMargins
//        anchors.right: centerCircle.left
//        onClicked: {
//            console.log("The cancel button was clicked.");
//            countdownTimer.stop();
//            stackView.clear();
//            stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
//        }
//    }
    SideButton {
        id: editButton
        buttonText: "EDIT"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.right: centerCircle.left
        onClicked: {
            countdownTimer.stop();
            console.log("The edit button was clicked.");
            console.log("Current item: " + stackView.currentItem);
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
            stackView.completeTransition();
            screenBookmark = stackView.currentItem;
            if (twoTempEntryModeIsActive) {
                stackView.push({item:Qt.resolvedUrl("Screen_EnterDomeTemp.qml"), immediate:immediateTransitions});
            } else {
                stackView.push({item:Qt.resolvedUrl("Screen_TemperatureEntry.qml"), immediate:immediateTransitions});
            }
        }
    }
    SideButton {
        id: continueButton
        buttonText: "CONTINUE"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.left: centerCircle.right
        onClicked: {
            console.log("Stoping countdown timer in final check.");
            countdownTimer.stop();
            stackView.push({item:Qt.resolvedUrl("Screen_CookingFinal.qml"), immediate:immediateTransitions});
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
                console.log("Stoping countdown timer in final check.");
                countdownTimer.stop();
                stackView.push({item:Qt.resolvedUrl("Screen_CookingDone.qml"), immediate:immediateTransitions});
            }
        }
    }
}

