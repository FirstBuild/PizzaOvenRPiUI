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

    function screenEntry() {
        screenSwitchInProgress = false;
    }

    CircleScreenTemplate {
        id: dataCircle
        circleValue: 100 * lowerFront.currentTemp / lowerFront.setTemp
        titleText: "PREHEATING"
        onCircleValueChanged: {
            doExitCheck();
        }
    }

    HomeButton {
        id: preheatingHomeButton
    }

    EditButton {
        id: editButton
    }

    CircleContent {
        id: circleContent
        topString: tempToString(upperFront.setTemp)
        middleString: tempToString(lowerFront.setTemp)
        bottomString: tempToString(lowerFront.currentTemp)
    }

    NumberAnimation {
        target: lowerFront;
        property: "currentTemp";
        from: 75;
        to: lowerFront.setTemp;
        duration: 4000
        running: demoModeIsActive
    }
    NumberAnimation {
        target: upperFront;
        property: "currentTemp";
        from: 75;
        to: upperFront.setTemp;
        duration: 4000
        running: demoModeIsActive
    }

    function doExitCheck() {
        if (screenSwitchInProgress) return;
        if (dataCircle.circleValue >= 100) {
            screenSwitchInProgress = true;
            screenExitAnimation.start();
        }
    }

    SequentialAnimation {
        id: screenExitAnimation
        OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
        ScriptAction {
            script: {
                stackView.push({item:Qt.resolvedUrl("Screen_Start.qml"), immediate:immediateTransitions});
            }
        }
    }
}

