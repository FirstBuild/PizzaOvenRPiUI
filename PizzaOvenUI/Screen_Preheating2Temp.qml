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

    property real upperExitValue: 100 * upperFront.currentTemp / upperFront.setTemp
    property real lowerExitValue: 100 * lowerFront.currentTemp / lowerFront.setTemp

    property string targetScreen: ""

    property bool needsAnimation: false

    function screenEntry() {
        console.log("Entering preheat screen");
        screenSwitchInProgress = false;
        if (opacity < 1.0) {
            screenFadeIn.start();
        }
        if (demoModeIsActive) {
            if (lowerFrontAnimation.paused) lowerFrontAnimation.resume();
            if (upperFrontAnimation.paused) upperFrontAnimation.resume();
            if (!lowerFrontAnimation.running) lowerFrontAnimation.start();
            if (!upperFrontAnimation.running) upperFrontAnimation.start();
        }
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
        onCircleValueChanged: {
            doExitCheck();
        }
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
        line2String: utility.tempToString(upperFront.currentTemp)
        line3String: utility.tempToString(lowerFront.setTemp)
        line4String: utility.tempToString(lowerFront.currentTemp)
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
        id: lowerFrontAnimation
        target: lowerFront;
        property: "currentTemp";
        from: 75;
        to: lowerFront.setTemp;
        duration: 4000
        running: demoModeIsActive
    }
    NumberAnimation {
        id: upperFrontAnimation
        target: upperFront;
        property: "currentTemp";
        from: 75;
        to: upperFront.setTemp;
        duration: 1000
        running: demoModeIsActive
    }

    function doExitCheck() {
        if (screenSwitchInProgress) return;
        if (dataCircle.circleValue >= 100) {
            preheatComplete = true
            screenSwitchInProgress = true;
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

