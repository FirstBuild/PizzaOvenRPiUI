import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    width: parent.width
    height: parent.height

    property bool needsAnimation: (opacity < 1.0) ? true : false

    CircleScreenTemplate {
        id: theCircle
        circleValue: 0
        titleText: "STONE TEMP HOLDING"
        fadeInTitle: true
        needsAnimation: false
    }

    opacity: 1.0

    function screenEntry() {
        if (thisScreen.opacity < 1.0)
        {
            editButton.animate();
            preheatButton.animate();
            theCircle.animate();
            circleContent.animate();
            screenEntryAnimation.start();
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
        needsAnimation: false
    }

    EditButton {
        id: editButton
        needsAnimation: false
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
                    autoShutoff.start();
                } else {
                    lowerFront.currentTemp = 75;
                }

                rootWindow.maxPreheatTimer.restart();
                stackView.clear();
                stackView.push({item:Qt.resolvedUrl("Screen_Preheating2Temp.qml"), immediate:immediateTransitions});
            }
        }
    }

    function preheatClicked() {
        if((powerSwitch == 1) || (demoModeIsActive)){
            exitToPreheatAnimation.running = true;
        }
    }

    ButtonRight {
        id: preheatButton
        text: "CONTINUE"
        onClicked: {
            rootWindow.domeState.set(true);
            preheatClicked();
        }
        needsAnimation: false
    }

    CircleContent {
        id: circleContent
        topString: "OFF"
        middleString: utility.tempToString(lowerFront.setTemp)
        bottomString: ""
        needsAnimation: false
        onTopStringClicked: {
            singleSettingOnly = true;
            bookmarkCurrentScreen();
            thisScreen.needsAnimation = false;
            startExitToScreen("Screen_EnterDomeTemp.qml");
        }
        onMiddleStringClicked: {
            singleSettingOnly = true;
            bookmarkCurrentScreen();
            thisScreen.needsAnimation = false;
            startExitToScreen("Screen_EnterStoneTemp.qml");
        }
        onBottomStringClicked: {
            singleSettingOnly = true;
            bookmarkCurrentScreen();
            thisScreen.needsAnimation = false;
            startExitToScreen("Screen_EnterTime.qml");
        }
    }

    DomeToggle {
        id: domeToggle;
        text: "DOME"
        needsAnimation: false
        onStateChanged: domeToggle.clicked()
        onClicked: {
            console.log("Idle: Dome toggle was clicked.");
            preheatClicked();
        }
    }
}

