import QtQuick 2.0

Item {
    id: screenCookingFirstHalf
    implicitWidth: parent.width
    implicitHeight: parent.height

    CircleScreenTemplate {
        id: dataCircle
        circleValue: 0
        titleText: "COOKING"
    }

    HomeButton {
        id: homeButton
        onClicked: {
            countdownTimer.stop();
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
        }
    }

    ButtonLeft {
        id: editButton
        text: "EDIT"
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

    CircleContent {
        id: circleContent
        topString: tempToString(upperFront.setTemp)
        middleString: tempToString(lowerFront.setTemp)
        bottomString: timeToString(cookTime)
    }

    ButtonRight {
        id: pauseButton
        text: "PAUSE"
        onClicked: {
            console.log("The pause button was clicked.");
            if (countdownTimer.running) {
                countdownTimer.stop();
                pauseButton.text = "RESUME"
            } else {
                countdownTimer.start();
                pauseButton.text = "PAUSE"
            }
        }
    }

    Timer {
        id: countdownTimer
        interval: 1000; running: true; repeat: true
        onTriggered: {
            currentTime++;
            if ((currentTime < cookTime/2) || ((halfTimeRotate == false) && (currentTime < finalCheckTime))) {
                var val = 100 * currentTime/cookTime;
                dataCircle.circleValue = val;

                val = cookTime - currentTime;
                circleContent.bottomString = timeToString(val);

            } else {
                console.log("Stoping countdown timer first half.");
                countdownTimer.stop();
                if (halfTimeRotate)
                {
                    stackView.push({item:Qt.resolvedUrl("Screen_RotatePizza.qml"), immediate:immediateTransitions});
                }
                else
                {
                    stackView.push({item:Qt.resolvedUrl("Screen_CookingFinalCheck.qml"), immediate:immediateTransitions});
                }
            }
        }
    }
}

