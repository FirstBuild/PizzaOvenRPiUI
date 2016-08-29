import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    implicitWidth: parent.width
    implicitHeight: parent.height

    CircleScreenTemplate {
        id: dataCircle
        circleValue: 0
        titleText: "PREHEATING"
    }

    HomeButton {
        id: preheatingHomeButton
        onClicked: SequentialAnimation {
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
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
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
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
        }
    }

    CircleContent {
        id: circleContent
        topString: tempToString(upperFront.setTemp)
        middleString: tempToString(lowerFront.setTemp)
        bottomString: tempToString(currentTemp)
    }

    Timer {
        id: animateTimer
        interval: 250; running: true; repeat: true
        onTriggered: {
            var val = 0;
            if (demoModeIsActive) {
                val = dataCircle.circleValue + 10;
                if (val > 100) {
                    val = 0;
                    animateTimer.stop();
                    screenExitAnimation.start();
                }
                dataCircle.circleValue = val;

                val = 80 + (lowerFront.setTemp - 80) * val / 100
                circleContent.bottomString = tempToString(val);
            } else {
                val = 100 * currentTemp / lowerFront.setTemp;
                if (val >= 100) {
                    val = 0;
                    animateTimer.stop();
                    screenExitAnimation.start();
                }
                dataCircle.circleValue = val;
            }
        }
        SequentialAnimation {
            id: screenExitAnimation
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    stackView.push({item:Qt.resolvedUrl("Screen_Start.qml"), immediate:immediateTransitions});
                }
            }
        }
    }
}

