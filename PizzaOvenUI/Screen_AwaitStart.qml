import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    width: parent.width
    height: parent.height

    property bool needsAnimation: true

    CircleScreenTemplate {
        id: theCircle
        circleValue: 0
        titleText: foodNameString
        fadeInTitle: false
    }

    opacity: 0.0

    function screenEntry() {
        editButton.animate();
        preheatButton.animate();
        theCircle.animate();
        circleContent.animate();
        screenEntryAnimation.start();
    }

    function handlePowerSwitchStateChanged() {
        if (powerSwitch == 0) {
            forceScreenTransition(Qt.resolvedUrl("Screen_Off.qml"));
        }
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
}

