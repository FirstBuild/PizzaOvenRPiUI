import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    implicitWidth: parent.width
    implicitHeight: parent.height

    property string targetScreen: ""

    function screenEntry() {
        if (opacity < 1.0) screenEntryAnimation.start();
    }

    function startExitToScreen(screen) {
        targetScreen = screen;
        singleSettingOnly = true;
        bookmarkCurrentScreen();
        screenFadeOut.start();
    }

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0; easing.type: Easing.InCubic; running: false}

    OpacityAnimator {id: screenFadeOut; target: thisScreen; from: 1.0; to: 0.0;  easing.type: Easing.OutCubic;
        onStopped: {
            stackView.push({item:Qt.resolvedUrl(targetScreen), immediate:immediateTransitions});
        }
        running: false
    }

    CircleScreenTemplate {
        circleValue: 0
        titleText: "READY"
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

    ButtonRight {
        id: startButton
        text: "START"
        needsAnimation: false
        onClicked: {
            rootWindow.cookTimer.start();
            forceScreenTransition(Qt.resolvedUrl("Screen_Cooking.qml"));
        }
    }

    CircleContent {
        id: dataCircle
        topString: utility.tempToString(upperFront.setTemp)
        middleString: utility.tempToString(lowerFront.setTemp)
        bottomString: utility.timeToString(cookTime)
        needsAnimation: false
        onTopStringClicked: {
            startExitToScreen("Screen_EnterDomeTemp.qml");
        }
        onMiddleStringClicked: {
            startExitToScreen("Screen_EnterStoneTemp.qml");
        }
        onBottomStringClicked: {
            startExitToScreen("Screen_EnterTime.qml");
        }
    }
}

