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
        needsAnimation: false
    }

    HomeButton {
        id: homeButton
        needsAnimation: false
    }

    EditButton {
        id: editButton
        needsAnimation: false
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
            ScriptAction {
                script: {
                    screenSwitchInProgress = true;
                    stackView.push({item:Qt.resolvedUrl("Screen_CookingSecondHalf.qml"), immediate:immediateTransitions});
                }
            }
        }
        needsAnimation: false
    }

    function doExitCheck() {
        if (screenSwitchInProgress) return;
        if (cookTime * dataCircle.circleValue / 100 >= finalCheckTime) {
            screenSwitchInProgress = true;
            screenExitAnimation.start();
        }
    }

    SequentialAnimation {
        id: screenExitAnimation
        ScriptAction {
            script: {
                stackView.push({item:Qt.resolvedUrl("Screen_CookingFinalCheck.qml"), immediate:immediateTransitions});
            }
        }
    }
}

