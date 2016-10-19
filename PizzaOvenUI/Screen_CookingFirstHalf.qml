import QtQuick 2.3

Item {
    id: thisScreen
    implicitWidth: parent.width
    implicitHeight: parent.height

    property bool screenSwitchInProgress: false

    function screenEntry() {
        screenSwitchInProgress = false;
    }

    CircleScreenTemplate {
        id: dataCircle
        circleValue: rootWindow.cookTimer.value
        titleText: "COOKING"
        needsAnimation: false
        onCircleValueChanged: {
            doExitCheck();
        }
    }

    HomeButton {
        id: homeButton
        needsAnimation: false
    }

    EditButton {
        id: editButton
        needsAnimation: false
    }

    CircleContent {
        id: circleContent
        needsAnimation: false
        topString: utility.tempToString(upperFront.setTemp)
        middleString: utility.tempToString(lowerFront.setTemp)
        bottomString: utility.timeToString(rootWindow.cookTimer.timerValue)
    }

    PauseButton {
        id: pauseButton
        needsAnimation: false
    }

    function doExitCheck() {
        if (screenSwitchInProgress) return;
        if (dataCircle.circleValue >= 50) {
            screenSwitchInProgress = true;
            screenExitAnimation.start();
        }
    }

    SequentialAnimation {
        id: screenExitAnimation
        ScriptAction {script: {
                if (halfTimeRotateAlertEnabled)
                {
                    forceScreenTransition(Qt.resolvedUrl("Screen_RotatePizza.qml"));
                }
                else
                {
                    forceScreenTransition(Qt.resolvedUrl("Screen_CookingSecondHalf.qml"));
                }
            }
        }
    }
}

