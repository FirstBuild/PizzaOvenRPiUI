import QtQuick 2.3

Item {
    id: screenFinalCheck
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
            OpacityAnimator {target: screenFinalCheck; from: 1.0; to: 0.0;}
            ScriptAction {script: {
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
            OpacityAnimator {target: screenFinalCheck; from: 1.0; to: 0.0;}
            ScriptAction {script: {
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

    Rectangle {
        width: 100
        height: 40
        x: 231
        y: 160
        color: appBackgroundColor
        Text {
            text: "Final"
            font.family: localFont.name
            font.pointSize: 24
            color: appForegroundColor
            anchors.centerIn: parent
        }
    }

    Rectangle {
        width: 100
        height: 40
        x: 231
        y: 195
        color: appBackgroundColor
        Text {
            text: "check"
            font.family: localFont.name
            font.pointSize: 24
            color: appForegroundColor
            anchors.centerIn: parent
        }
    }

    ButtonRight {
        id: continueButton
        text: "CONTINUE"
        onClicked: SequentialAnimation {
            OpacityAnimator {target: screenFinalCheck; from: 1.0; to: 0.0;}
            ScriptAction {script: {
                    countdownTimer.stop();
                    stackView.push({item:Qt.resolvedUrl("Screen_CookingFinal.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    function screenEntry() {
        console.log("Playing the sound.");
        sounds.alarmUrgent.play();
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
//                    stackView.push({item:Qt.resolvedUrl("Screen_CookingDone.qml"), immediate:immediateTransitions});
                    screenExitAnimation.start();
                }
                dataCircle.circleValue = val;
            } else {
                countdownTimer.stop();
//                stackView.push({item:Qt.resolvedUrl("Screen_CookingDone.qml"), immediate:immediateTransitions});
                screenExitAnimation.start();
            }
        }
    }

    SequentialAnimation {
        id: screenExitAnimation
        OpacityAnimator {target: screenFinalCheck; from: 1.0; to: 0.0;}
        ScriptAction {script: {
                stackView.push({item:Qt.resolvedUrl("Screen_CookingDone.qml"), immediate:immediateTransitions});
            }
        }
    }

}

