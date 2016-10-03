import QtQuick 2.3

Item {
    id: thisScreen
    implicitWidth: parent.width
    implicitHeight: parent.height

    property bool screenSwitchInProgress: false

    function screenEntry() {
        sounds.alarmMid.play();
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


    Rectangle {
        width: 100
        height: 40
        x: 231
        y: 160
        color: appBackgroundColor
        Text {
            text: "Rotate"
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
            text: "pizza"
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
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    screenSwitchInProgress = true;
                    stackView.push({item:Qt.resolvedUrl("Screen_CookingSecondHalf.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    function doExitCheck() {
        if (screenSwitchInProgress) return;
//        if (dataCircle.circleValue >= 100) {
//            screenSwitchInProgress = true;
//            screenExitAnimation.start();
//        }
        if (cookTime * dataCircle.circleValue / 100 >= finalCheckTime) {
            screenSwitchInProgress = true;
            screenExitAnimation.start();
        }
    }

    SequentialAnimation {
        id: screenExitAnimation
        OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
        ScriptAction {
            script: {
//                stackView.push({item:Qt.resolvedUrl("Screen_CookingDone.qml"), immediate:immediateTransitions});
                stackView.push({item:Qt.resolvedUrl("Screen_CookingFinalCheck.qml"), immediate:immediateTransitions});
            }
        }
    }
}

