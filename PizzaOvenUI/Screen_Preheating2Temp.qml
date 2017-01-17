import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    implicitWidth: parent.width
    implicitHeight: parent.height

    property bool screenSwitchInProgress: false

    property real upperExitValue: 100 * (upperTempLocked ? upperFront.setTemp : upperTemp) / upperFront.setTemp
    property real lowerExitValue: 100 * (lowerTempLocked ? lowerFront.setTemp : lowerTemp) / lowerFront.setTemp

    property string targetScreen: ""

    property bool needsAnimation: false

    property bool upperTempLocked: false
    property bool lowerTempLocked: false

    property real upperTempDemoValue: 75.0
    property real lowerTempDemoValue: 75.0

    property real upperTemp: demoModeIsActive ? upperTempDemoValue : ((upperFront.currentTemp < upperFront.setTemp) ? upperFront.currentTemp : upperFront.setTemp)
    property real lowerTemp: demoModeIsActive ? lowerTempDemoValue : ((lowerFront.currentTemp < lowerFront.setTemp) ? lowerFront.currentTemp : lowerFront.setTemp)

    property int ovenStateCount: 3

    Timer {
        id: displayUpdateTimer
        interval: 1000
        repeat: true
        running: !demoModeIsActive
        onTriggered: {
            var currentDisplayTemp = upperTemp;
            if (upperFront.currentTemp < upperFront.setTemp) {
                if (upperFront.currentTemp > upperTemp) {
                    upperTemp = upperFront.currentTemp;
                } else {
                    upperTemp = currentDisplayTemp;
                }
            } else {
                upperTemp = upperFront.setTemp;
                upperTempLocked = true;
            }
            currentDisplayTemp = lowerTemp;
            if (lowerFront.currentTemp < lowerFront.setTemp) {
                if (lowerFront.currentTemp > lowerTemp) {
                    lowerTemp = lowerFront.currentTemp;
                } else {
                    lowerTemp = currentDisplayTemp;
                }
            } else {
                lowerTemp = lowerFront.setTemp;
                lowerTempLocked = true;
            }
            doExitCheck();
        }
    }

    function handleOvenStateMsg(state) {
        if (demoModeIsActive || (acPowerIsPresent == 0)) return;
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

    function handlePowerSwitchStateChanged() {
        if (powerSwitch == 1) {
            // restart cooking, if needed
            handleControlBoardCommsChanged();
        }
    }

    function handleControlBoardCommsChanged() {
        if (controlBoardCommsFailed) {
            console.log("In preheat and comms failed.");
            ovenStateCount = 5
        } else {
            console.log("In preheat and comms restored.");
            if (powerSwitch == 1) {
                console.log("Power switch is on.");
                ovenStateCount = 5
                if (!demoModeIsActive) {
                    console.log("We are not in demo mode so restarting oven.");
                    backEnd.sendMessage("StartOven ");
                }
            }
        }
    }

    function screenEntry() {
        console.log("Entering preheat screen");
        screenSwitchInProgress = false;
        upperTempLocked = false;
        lowerTempLocked = false;
        if (opacity < 1.0) {
            screenFadeIn.start();
        }
        if (demoModeIsActive) {
            if (lowerFrontAnimation.paused) lowerFrontAnimation.resume();
            if (upperFrontAnimation.paused) upperFrontAnimation.resume();
            if (!lowerFrontAnimation.running) lowerFrontAnimation.start();
            if (!upperFrontAnimation.running) upperFrontAnimation.start();
        } else {
            displayUpdateTimer.running = true;
        }

        ovenStateCount = 3;
    }

    OpacityAnimator {id: screenFadeOut; target: thisScreen; from: 1.0; to: 0.0;  easing.type: Easing.OutCubic;
        onStopped: {
            stackView.push({item:Qt.resolvedUrl(targetScreen), immediate:immediateTransitions});
        }
        running: false
    }
    OpacityAnimator {id: screenFadeIn; target: thisScreen; from: 0.1; to: 1.0;  easing.type: Easing.OutCubic;
        running: false
    }

    function startExitToScreen(screen) {
        if (lowerFrontAnimation.running) lowerFrontAnimation.pause();
        if (upperFrontAnimation.running) upperFrontAnimation.pause();
        displayUpdateTimer.stop();
        targetScreen = screen;
        singleSettingOnly = true;
        bookmarkCurrentScreen();
        needsAnimation = true;
        screenFadeOut.start();
    }

    CircleScreenTemplate {
        id: dataCircle
        needsAnimation: false
        circleValue: upperExitValue < lowerExitValue ? upperExitValue : lowerExitValue
        titleText: "PREHEATING"
        noticeText: ""
        fadeInTitle: true
    }

    HomeButton {
        id: preheatingHomeButton
        needsAnimation: false
        onClicked: {
            lowerFrontAnimation.stop();
            upperFrontAnimation.stop();
            displayUpdateTimer.stop();
        }
    }

    EditButton {
        id: editButton
        needsAnimation: false
        onClicked: {
            lowerFrontAnimation.stop();
            upperFrontAnimation.stop();
            displayUpdateTimer.stop();
        }
    }

    CircleContentTwoTemp {
        id: circleContent
        needsAnimation: true
        line1String: utility.tempToString(upperFront.setTemp)
        line2String: utility.tempToString(upperTemp)
        line3String: utility.tempToString(lowerFront.setTemp)
        line4String: utility.tempToString(lowerTemp)
        onTopStringClicked: {
            startExitToScreen("Screen_EnterDomeTemp.qml");
        }
        onCenterTopStringClicked: {
            startExitToScreen("Screen_EnterDomeTemp.qml");
        }
        onCenterBottomStringClicked: {
            startExitToScreen("Screen_EnterStoneTemp.qml");
        }
        onBottomStringClicked: {
            startExitToScreen("Screen_EnterStoneTemp.qml");
        }
    }

    NumberAnimation {
        id: upperFrontAnimation
        target: thisScreen;
        property: "upperTempDemoValue";
        from: 75;
        to: upperFront.setTemp;
        duration: 7000
        running: demoModeIsActive
    }
    NumberAnimation {
        id: lowerFrontAnimation
        target: thisScreen;
        property: "lowerTempDemoValue";
        from: 75;
        to: lowerFront.setTemp;
        duration: 10000
        running: demoModeIsActive
        onStopped: screenExitAnimator.start()
    }

    function doExitCheck() {
        if (screenSwitchInProgress) return;
        if ((upperTempLocked && lowerTempLocked) || !rootWindow.maxPreheatTimer.running) {
            screenSwitchInProgress = true;
            preheatComplete = true
            rootWindow.maxPreheatTimer.stop();
            if (demoModeIsActive) {
                upperFrontAnimation.stop();
                lowerFrontAnimation.stop();
            }
            displayUpdateTimer.stop();
            screenExitAnimator.start();
        }
    }

    SequentialAnimation {
        id: screenExitAnimator
        ScriptAction {
            script: {
                sounds.notification.play();
                rootWindow.cookTimer.stop();
                rootWindow.cookTimer.reset();
                stackView.push({item:Qt.resolvedUrl("Screen_Cooking.qml"), immediate:immediateTransitions});
            }
        }
    }
}

