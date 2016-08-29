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
            ScriptAction { script: { animateTimer.stop(); }}
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
            ScriptAction { script: { animateTimer.stop(); }}
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
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

    CircleContentTwoTemp {
        id: circleContent
        line1String: tempToString(upperFront.setTemp)
        line2String: tempToString(upperFront.currentTemp)
        line3String: tempToString(lowerFront.setTemp)
        line4String: tempToString(currentTemp)
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
                    screenExitAnimator.start();
                }
                dataCircle.circleValue = val;

                val = 80 + (lowerFront.setTemp - 80) * val / 100;
                circleContent.line4String = tempToString(val);

                val = dataCircle.circleValue
                val = 100 + (upperFront.setTemp - 100) * val / 100;
                circleContent.line2String = tempToString(val);
            } else {
                val = 100 * currentTemp / lowerFront.setTemp;
                if (val >= 100) {
                    val = 0;
                    animateTimer.stop();
                    screenExitAnimator.start();
                }
                dataCircle.circleValue = val;
            }
        }
    }
    SequentialAnimation {
        id: screenExitAnimator
        OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
        ScriptAction {
            script: {
                stackView.push({item:Qt.resolvedUrl("Screen_Start.qml"), immediate:immediateTransitions});
            }
        }
    }
}

