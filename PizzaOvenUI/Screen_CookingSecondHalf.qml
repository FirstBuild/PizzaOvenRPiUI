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
        topString: tempToString(upperFront.setTemp)
        middleString: tempToString(lowerFront.setTemp)
        bottomString: timeToString(cookTime * dataCircle.circleValue / 100)
    }

    PauseButton {
        id: pauseButton
    }

    function doExitCheck() {
        if (screenSwitchInProgress) return;
        if (cookTime * dataCircle.circleValue / 100 >= finalCheckTime) {
            screenSwitchInProgress = true;
            screenExitAnimator.start();
        }
    }

    SequentialAnimation {
        id: screenExitAnimator
        OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
        ScriptAction {
            script: {
                stackView.push({item:Qt.resolvedUrl("Screen_CookingFinalCheck.qml"), immediate:immediateTransitions});
            }
        }
    }
}
