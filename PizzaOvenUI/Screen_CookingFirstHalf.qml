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
        onCircleValueChanged: {
            doExitCheck();
        }
    }

    HomeButton {
        id: homeButton
    }

    EditButton {
        id: editButton
    }

    CircleContent {
        id: circleContent
        topString: utility.tempToString(upperFront.setTemp)
        middleString: utility.tempToString(lowerFront.setTemp)
        bottomString: utility.timeToString(cookTime * dataCircle.circleValue / 100)
    }

    PauseButton {
        id: pauseButton
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
        OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
        ScriptAction {script: {
                if (halfTimeRotate)
                {
                    stackView.push({item:Qt.resolvedUrl("Screen_RotatePizza.qml"), immediate:immediateTransitions});
                }
                else
                {
                    stackView.push({item:Qt.resolvedUrl("Screen_CookingSecondHalf.qml"), immediate:immediateTransitions});
                }

            }
        }
    }
}

