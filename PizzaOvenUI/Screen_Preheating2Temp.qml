import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    implicitWidth: parent.width
    implicitHeight: parent.height
    property string screenName: "Screen_Preheat2Temp"

    property real upperExitValue: 100 * (upperTempLocked ? upperFront.setTemp : upperTemp) / upperFront.setTemp
    property real lowerExitValue: 100 * (lowerTempLocked ? lowerFront.setTemp : lowerTemp) / lowerFront.setTemp
    property real preheatProgressValue: (rootWindow.domeState.actual) ? (upperExitValue * 0.1 + lowerExitValue * 0.9) : lowerExitValue

    property string targetScreen: ""

    property bool needsAnimation: false

    property bool upperTempLocked: false
    property bool lowerTempLocked: false

    property real upperTempDemoValue: 75.0
    property real lowerTempDemoValue: 75.0

    property real currentUpperMininumTemp: (upperFront.currentTemp < upperRear.currentTemp) ? upperFront.currentTemp : upperRear.currentTemp
    property real currentLowerMininumTemp: (lowerFront.currentTemp < lowerRear.currentTemp) ? lowerFront.currentTemp : lowerFront.currentTemp

    property real upperTemp: demoModeIsActive ? upperTempDemoValue : currentUpperMininumTemp
    property real lowerTemp: demoModeIsActive ? (stoneIsPreheated ? lowerFront.setTemp : lowerTempDemoValue) :
                                                (((currentLowerMininumTemp < lowerFront.setTemp) && !stoneIsPreheated) ? currentLowerMininumTemp : lowerFront.setTemp)

    property int ovenStateCount: 3

    property string localOvenState: "Preheat1"

    Timer {
        id: displayUpdateTimer
        interval: 1000
        repeat: true
        running: !demoModeIsActive
        onTriggered: {
            var currentDisplayTemp = upperTemp;
            var currentActualTemp = (upperFront.currentTemp < upperRear.currentTemp) ? upperFront.currentTemp : upperRear.currentTemp;
            console.log("Current upper actual temp = " + currentActualTemp);
            if (currentActualTemp < upperFront.setTemp) {
                if (currentActualTemp > upperTemp) {
                    upperTemp = currentActualTemp;
                } else {
                    upperTemp = currentDisplayTemp;
                }
            } else {
                upperTemp = upperFront.setTemp;
                upperTempLocked = true;
            }
            currentDisplayTemp = lowerTemp;
            currentActualTemp = (lowerFront.currentTemp < lowerRear.currentTemp) ? lowerFront.currentTemp : lowerRear.currentTemp;
            console.log("Current lower actual temp = " + currentActualTemp);
            if ((currentActualTemp < lowerFront.setTemp) && !stoneIsPreheated) {
                if (currentActualTemp > lowerTemp) {
                    lowerTemp = currentActualTemp;
                } else {
                    lowerTemp = currentDisplayTemp;
                }
            } else {
                lowerTemp = lowerFront.setTemp;
                lowerTempLocked = true;
                stoneIsPreheated = true;
            }
            doExitCheck();
            rootWindow.displayedDomeTemp = upperTemp;
            rootWindow.displayedStoneTemp = lowerTemp;
        }
    }

    function handleOvenStateMsg(state) {
        if (demoModeIsActive || (acPowerIsPresent == 0)) return;
        if (ovenStateCount > 0) {
            ovenStateCount--;
            return;
        }
        localOvenState = state;
        switch(state) {
        case "Standby":
            forceScreenTransition(Qt.resolvedUrl("Screen_MainMenu.qml"));
            break;
        case "Cooldown":
            forceScreenTransition(Qt.resolvedUrl("Screen_MainMenu.qml"));
            break;
        case "Idle":
            cleanUpOnExit();
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_Idle.qml"), immediate:immediateTransitions});
            break;
        case "Cooking":
            preheatComplete = true;
            doExitCheck();
            break;
        case "PreheatStoneOnly":
            upperTempLocked = false;
            upperTemp = currentUpperMininumTemp;
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
        upperTempLocked = false;
        lowerTempLocked = stoneIsPreheated;

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

    function cleanUpOnExit() {
        console.log("Exiting preheat screen and preheatComplete is " + preheatComplete);
        displayUpdateTimer.stop();
        screenFadeOut.stop();
        screenExitAnimator.stop();
    }

    OpacityAnimator {id: screenFadeOut; target: thisScreen; from: 1.0; to: 0.0;  easing.type: Easing.OutCubic;
        onStopped: {
            cleanUpOnExit();
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
        circleValue: preheatProgressValue
        titleText: (domeToggle.state) ? "PREHEATING" : "STONE PREHEATING"
        noticeText: ""
        fadeInTitle: true
    }

    HomeButton {
        id: preheatingHomeButton
        needsAnimation: false
        onClicked: {
            displayUpdateTimer.stop();
            lowerFrontAnimation.stop();
            upperFrontAnimation.stop();
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
        line2String: domeToggle.state ? utility.tempToString(upperTemp) : "OFF"
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
        onStopped: {
            if (stoneIsPreheated) {
                screenExitAnimator.start();
            }
        }
    }
    NumberAnimation {
        id: lowerFrontAnimation
        target: thisScreen;
        property: "lowerTempDemoValue";
        from: 75;
        to: lowerFront.setTemp;
        duration: 10000
        running: demoModeIsActive & !stoneIsPreheated
        onStopped: {
            stoneIsPreheated = true;
            screenExitAnimator.start();
        }
    }

    function doExitCheck() {
        if (screenExitAnimator.running) return;
          if ((upperTempLocked && lowerTempLocked) || !rootWindow.maxPreheatTimer.running || (localOvenState == "Cooking")) {
            if (ovenState == "Idle") {
                handleOvenStateMsg("Idle");
                return;
            }

            console.log("Starting transition out of preheat...");
            console.log("Upper temp locked is " + upperTempLocked);
            console.log("Lower temp locked is " + lowerTempLocked);
            console.log("Max preheat timer is running is " + rootWindow.maxPreheatTimer.running)
            console.log("Local oven state is " + localOvenState);
            console.log("Global oven state is " + ovenState);

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
                cleanUpOnExit();
                stackView.clear();
                if (rootWindow.domeState.displayed) {
                    stackView.push({item:Qt.resolvedUrl("Screen_Cooking.qml"), immediate:immediateTransitions});
                } else {
                    stackView.push({item:Qt.resolvedUrl("Screen_Idle.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    DomeToggle {
        id: domeToggle;
        text: "DOME"
        onStateChanged: {
            console.log("Dome toggle state changed.");
            if (state == false && lowerTempLocked) {
                handleOvenStateMsg("Idle");
            }
        }
        onClicked: {
            console.log("Dome toggle clicked.");
            if (state == false && lowerTempLocked) {
                handleOvenStateMsg("Idle");
            }
        }
    }
}

