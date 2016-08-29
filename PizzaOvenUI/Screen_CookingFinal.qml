import QtQuick 2.3

Item {
    id: screenCookingFinal
    implicitWidth: parent.width
    implicitHeight: parent.height

    CircleScreenTemplate {
        id: dataCircle
        circleValue: 100 * currentTime/cookTime
        titleText: "COOKING"
    }

    HomeButton {
        id: homeButton
        onClicked: SequentialAnimation {
            OpacityAnimator {target: screenCookingFinal; from: 1.0; to: 0.0;}
            ScriptAction {script:{
                    countdownTimer.stop();
                    stackView.clear();
                    stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    ButtonLeft {
        id: editButton
        text: "EDIT"
        onClicked: SequentialAnimation {
            OpacityAnimator {target: screenCookingFinal; from: 1.0; to: 0.0;}
            ScriptAction {script:{
                    countdownTimer.stop();
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

        }
    }

    CircleContent {
        id: circleContent
        topString: tempToString(upperFront.setTemp)
        middleString: tempToString(lowerFront.setTemp)
        bottomString: timeToString(cookTime - currentTime)
    }

    ButtonRight {
        id: pauseButton
        text: "PAUSE"
        onClicked: {
            if (countdownTimer.running) {
                countdownTimer.stop();
                pauseButton.text = "RESUME";
            } else {
                countdownTimer.start();
                pauseButton.text = "PAUSE";
            }
        }
    }

    Timer {
        id: countdownTimer
        interval: 1000; running: true; repeat: true
        onTriggered: {
            currentTime++;
            if (currentTime < cookTime) {
                var val = 100 * currentTime/cookTime;
                if (val > 100) {
                    val = 0;
                    countdownTimer.stop();
//                    stackView.push({item:Qt.resolvedUrl("Screen_CookingDone.qml"), immediate:immediateTransitions});
                    screenExitAnimation.start();
                } else {
                    dataCircle.circleValue = val;
                }
            } else {
                countdownTimer.stop();
//                stackView.push({item:Qt.resolvedUrl("Screen_CookingDone.qml"), immediate:immediateTransitions});
                screenExitAnimation.start();
            }
        }
    }

    SequentialAnimation {
        id: screenExitAnimation
        OpacityAnimator {target: screenCookingFinal; from: 1.0; to: 0.0;}
        ScriptAction {script:{
                stackView.push({item:Qt.resolvedUrl("Screen_CookingDone.qml"), immediate:immediateTransitions});
            }
        }
    }
}

