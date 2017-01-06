import QtQuick 2.3

Item {
    id: thisScreen
    implicitWidth: parent.width
    implicitHeight: parent.height
    state: "start"

    property bool screenSwitchInProgress: false
    property string targetScreen: ""
    property real cookTimeValueShadow: rootWindow.cookTimer.value
    property int ovenStateCount: 3

    function screenEntry() {
        console.log("Entering cooking screen");
        screenSwitchInProgress = false;
        if (opacity < 1.0) screenEntryAnimation.start();
        if (!rootWindow.cookTimer.running) thisScreen.state = "start";
        ovenStateCount = 3;
        autoShutoff.start();
    }

    function startExitToScreen(screen) {
        targetScreen = screen;
        singleSettingOnly = true;
        bookmarkCurrentScreen();
        screenFadeOut.start();
    }

    function handleOvenStateMsg(state) {
        if (demoModeIsActive) return;
        if (ovenStateCount > 0) {
            ovenStateCount--;
            return;
        }
        switch(state) {
        case "Standby":
            forceScreenTransition(Qt.resolvedUrl("Screen_MainMenu.qml"));
            break;
        case "Cooldown":
            forceScreenTransition(Qt.resolvedUrl("Screen_MainMenu.qml"));
            break;
        }
    }

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0; easing.type: Easing.InCubic; running: false}

    OpacityAnimator {id: screenFadeOut; target: thisScreen; from: 1.0; to: 0.0;  easing.type: Easing.OutCubic;
        onStopped: {
            stackView.push({item:Qt.resolvedUrl(targetScreen), immediate:immediateTransitions});
        }
        running: false
    }

    states: [
        State {
            name: "start"
            PropertyChanges {target: dataCircle; showNotice: false; showTitle: true; newTitleText: "READY"}
            PropertyChanges {target: circleContent; bottomString: utility.timeToString(cookTime)}
            PropertyChanges {target: startButton; visible: true}
            PropertyChanges {target: pauseButton; visible: false}
        },
        State {
            name: "first-half"
            PropertyChanges {target: dataCircle; showNotice: false; showTitle: true; newTitleText: "COOKING"}
//            PropertyChanges {target: circleContent; bottomString: utility.timeToString(rootWindow.cookTimer.timerValue)}
            PropertyChanges {target: circleContent; bottomString: utility.timeToString(rootWindow.cookTimer.timeRemaining)}
            PropertyChanges {target: startButton; visible: false}
            PropertyChanges {target: pauseButton; visible: true}
        },
        State {
            name: "rotate-pizza"
            PropertyChanges {target: dataCircle; noticeText: "ROTATE PIZZA"; showTitle: false; showNotice: true}
        },
        State {
            name: "second-half"
            PropertyChanges {target: dataCircle; showNotice: false; showTitle: true}
        },
        State {
            name: "final-check"
            PropertyChanges {target: dataCircle; noticeText: "FINAL CHECK"; showTitle: false; showNotice: true}
        },
        State {
            name: "final"
            PropertyChanges {target: dataCircle; showNotice: false; showTitle: true}
        },
        State {
            name: "done"
            PropertyChanges {target: dataCircle; showNotice: false; showTitle: true}
            PropertyChanges {target: circleContent; bottomString: "DONE"}
            PropertyChanges {target: pauseButton; visible: false}
            PropertyChanges {target: startButton; visible: true}
        }
    ]

    onStateChanged: {
        console.log("State is now " + state);
        if (state === "rotate-pizza") sounds.alarmMid.play();
        if (state === "final-check") sounds.alarmUrgent.play();
        if (state === "done" && pizzaDoneAlertEnabled) {
            console.log("Done alert is enabled.");
            sounds.cycleComplete.play();
        }
    }

    onCookTimeValueShadowChanged: {
        switch (thisScreen.state) {
        case "start":
            break;
        case "first-half":
            if (dataCircle.circleValue >= 50) {
                if (halfTimeRotateAlertEnabled) {
                    thisScreen.state = "rotate-pizza";
                } else {
                    thisScreen.state = "second-half";
                }
            }
            break;
        case "rotate-pizza":
            if (dataCircle.circleValue >= 60) {
                thisScreen.state = "second-half";
            }
            break;
        case "second-half":
            if (dataCircle.circleValue >= 85) {
                if (finalCheckAlertEnabled) {
                    thisScreen.state = "final-check";
                } else {
                    thisScreen.state = "final";
                }
            }
            break;
        case "final-check":
            if (dataCircle.circleValue >= 95) {
                thisScreen.state = "final";
            }
            break;
        case "final":
            if (dataCircle.circleValue >= 100) {
                thisScreen.state = "done";
            }
            break;
        case "done":
            break;
        }
    }

    CircleScreenTemplate {
        id: dataCircle
        circleValue: rootWindow.cookTimer.value
        titleText: "PREHEATING"
        newTitleText: "COOKING"
        noticeText: ""
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

    CircleContent {
        id: circleContent
        needsAnimation: true
        topString: utility.tempToString(upperFront.setTemp)
        middleString: utility.tempToString(lowerFront.setTemp)
//        bottomString: utility.timeToString(rootWindow.cookTimer.timerValue)
        bottomString: utility.timeToString(rootWindow.cookTimer.timeRemaining)
        onTopStringClicked: {
            startExitToScreen("Screen_EnterDomeTemp.qml");
        }
        onMiddleStringClicked: {
            startExitToScreen("Screen_EnterStoneTemp.qml");
        }
        onBottomStringClicked: SequentialAnimation {
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;  easing.type: Easing.OutCubic;}
            ScriptAction {
                script: {
                    rootWindow.cookTimer.stop();
                }
            }
            ScriptAction {
                script: {
                    rootWindow.cookTimer.reset();
                    singleSettingOnly = true;
                    bookmarkCurrentScreen();
                    stackView.push({item:Qt.resolvedUrl("Screen_EnterTime.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    PauseButton {
        id: pauseButton
        needsAnimation: false
        visible: true
        enabled: true
    }

    ButtonRight {
        id: startButton
        text: "START"
        visible: false
        enabled: visible
        onClicked: {
            console.log("Starting cook timer.");
            rootWindow.cookTimer.start();
            thisScreen.state = "first-half"
        }
        needsAnimation: false
    }
}

