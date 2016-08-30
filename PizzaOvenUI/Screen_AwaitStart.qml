import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    width: parent.width
    height: parent.height

    CircleScreenTemplate {
        circleValue: 0
        titleText: foodNameString
    }

    function screenEntry() {
        screenEntryAnimation.start();
    }

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    HomeButton {
        id: homeButton
    }

    EditButton {
        id: editButton
    }

    ButtonRight {
        id: preheatButton
        text: "PREHEAT"
        onClicked: SequentialAnimation {
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {script: {
                    if (!demoModeIsActive) {
                        sendWebSocketMessage("StartOven ");
                    }
                    screenBookmark = stackView.currentItem;
                    if (appSettings.twoTempMode) {
                        stackView.push({item:Qt.resolvedUrl("Screen_Preheating2Temp.qml"), immediate:immediateTransitions});
                    } else {
                        stackView.push({item:Qt.resolvedUrl("Screen_Preheating.qml"), immediate:immediateTransitions});
                    }
                }
            }
        }

    }

    CircleContent {
        topString: tempToString(upperFront.setTemp)
        middleString: tempToString(lowerFront.setTemp)
        bottomString: timeToString(cookTime)
    }
}

