import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    width: parent.width
    height: parent.height
    property string screenName: "Screen_AwaitStart"

    property bool needsAnimation: true

    CircleScreenTemplate {
        id: theCircle
        circleValue: 0
        titleText: foodNameString
        fadeInTitle: false
    }

    opacity: 0.0

    function screenEntry() {
        console.log("Entering await start screen");
        editButton.animate();
        preheatButton.animate();
        theCircle.animate();
        circleContent.animate();
        screenEntryAnimation.start();
        rootWindow.displayedDomeTemp = rootWindow.upperFront.setTemp;
        rootWindow.displayedStoneTemp = rootWindow.lowerFront.setTemp;
    }

    function cleanUpOnExit() {
        console.log("Exiting await start screen");
        console.log("Stopping all animations");
        screenEntryAnimation.stop();
        screenFadeOut.stop();
        exitToPreheatAnimation.stop();
    }

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0; easing.type: Easing.InCubic;}

    property string targetScreen: ""

    OpacityAnimator {id: screenFadeOut; target: thisScreen; from: 1.0; to: 0.0;  easing.type: Easing.OutCubic;
        onStopped: {
            stackView.push({item:Qt.resolvedUrl(targetScreen), immediate:immediateTransitions});
        }
        running: false
    }

    function startExitToScreen(screen) {
        targetScreen = screen;
        screenFadeOut.start();
    }

    HomeButton {
        id: homeButton
    }

    EditButton {
        id: editButton
    }

    SequentialAnimation {
        id: exitToPreheatAnimation
        running: false
        ScriptAction {
            script: {
                theCircle.fadeOutTitleText();
            }
        }
        OpacityAnimator {target: circleContent; from: 1.0; to: 0.0}
        ScriptAction {
            script: {
                rootWindow.maxPreheatTimer.restart();
                if (!demoModeIsActive) {
                    backEnd.sendMessage("StartOven ");
                    autoShutoff.start();
                } else {
                    lowerFront.currentTemp = 75;
                }

                console.log("Exiting to preheat following exit animation in await start")
                stackView.clear();
                stackView.push({item:Qt.resolvedUrl("Screen_Preheating2Temp.qml"), immediate:immediateTransitions});
            }
        }
    }

    ButtonRight {
        id: preheatButton
        text: "PREHEAT"
        onClicked: {
            if((powerSwitch == 1) || (demoModeIsActive)){
                exitToPreheatAnimation.running = true;
                stoneIsPreheated = false;
            } else {
                pressPowerDialog.visible = true;
            }
        }
    }

    CircleContent {
        id: circleContent
        topString: utility.tempToString(upperFront.setTemp)
        middleString: utility.tempToString(lowerFront.setTemp)
        bottomString: utility.timeToString(cookTime)
        onTopStringClicked: {
            singleSettingOnly = true;
            bookmarkCurrentScreen();
            thisScreen.needsAnimation = true;
            startExitToScreen("Screen_EnterDomeTemp.qml");
        }
        onMiddleStringClicked: {
            singleSettingOnly = true;
            bookmarkCurrentScreen();
            thisScreen.needsAnimation = true;
            startExitToScreen("Screen_EnterStoneTemp.qml");
        }
        onBottomStringClicked: {
            singleSettingOnly = true;
            bookmarkCurrentScreen();
            thisScreen.needsAnimation = true;
            startExitToScreen("Screen_EnterTime.qml");
        }
    }

    DialogWithCheckbox {
        id: pressPowerDialog
        dialogMessage: "Press power button to continue"
    }

    DomeToggle {
        id: domeToggle;
        text: "DOME"
        needsAnimation: false
        onClicked: {
            console.log("Dome toggle clicked.");
        }
    }
}

