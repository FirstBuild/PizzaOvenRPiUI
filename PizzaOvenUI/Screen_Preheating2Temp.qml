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

    property real upperTemp: demoModeIsActive ? upperTempDemoValue : upperFront.currentTemp
    property real lowerTemp: demoModeIsActive ? lowerTempDemoValue : lowerFront.currentTemp

    property bool preheatMaxTimerRunning: rootWindow.maxPreheatTimer.running

    property int ovenStateCount: 3

    onPreheatMaxTimerRunningChanged: {
        if (!rootWindow.maxPreheatTimer.running) {
            doExitCheck();
        }
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
        }
    }

    EditButton {
        id: editButton
        needsAnimation: false
    }

    CircleContentTwoTemp {
        id: circleContent
        needsAnimation: true
        line1String: utility.tempToString(upperFront.setTemp)
        line2String: utility.tempToString(upperTempLocked ? upperFront.setTemp : upperTemp)
        line3String: utility.tempToString(lowerFront.setTemp)
        line4String: utility.tempToString(lowerTempLocked ? lowerFront.setTemp : lowerTemp)
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

    onUpperTempChanged: {
        if (upperTemp >= upperFront.setTemp) {
            if (!upperTempLocked) {
                console.log("Locking upper temp");
                upperTempLocked = true;
                doExitCheck();
            }
        }
    }

    onLowerTempChanged: {
        if (lowerTemp >= lowerFront.setTemp) {
            if (!lowerTempLocked) {
                console.log("Locking lower temp");
                lowerTempLocked = true;
                doExitCheck();
            }
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
        console.log("In doExitCheck");
        console.log("Upper lock: " + upperTempLocked);
        console.log("Lower lock: " + lowerTempLocked);
        if (screenSwitchInProgress) return;
        if ((upperTempLocked && lowerTempLocked) || !rootWindow.maxPreheatTimer.running) {
            screenSwitchInProgress = true;
            preheatComplete = true
            rootWindow.maxPreheatTimer.stop();
            if (demoModeIsActive) {
                upperFrontAnimation.stop();
                lowerFrontAnimation.stop();
            }
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

