import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    width: parent.width
    height: parent.height

    CircleScreenTemplate {
        id: theCircle
        circleValue: 0
        titleText: foodNameString
    }

    opacity: 0.0

    function screenEntry() {
        console.log("Starting animations.");
        editButton.animate();
        preheatButton.animate();
        theCircle.animate();
        circleContent.animate();
        screenEntryAnimation.start();
    }

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0; easing.type: Easing.InCubic; /*duration: 2000*/}

    HomeButton {
        id: homeButton
    }

    EditButton {
        id: editButton
    }

    ButtonRight {
        id: preheatButton
        text: "PREHEAT"
        onClicked: SequentialAnimation {
            NumberAnimation {target: thisScreen; property: "opacity"; from: 1.0; to: 0.0; /*duration: 2000*/}
            ScriptAction {script: {
                    homeButton.opacity = 0.0;
                    editButton.opacity = 0.0;
                    preheatButton.opacity = 0.0;
                    circleContent.opacity = 0.0;
                    if (!demoModeIsActive) {
                        sendWebSocketMessage("StartOven ");
                    } else {
                        lowerFront.currentTemp = 75;
                    }

                    if (appSettings.twoTempMode) {
                        stackView.push({item:Qt.resolvedUrl("Screen_Preheating2Temp.qml"), immediate:immediateTransitions});
                    } else {
                        stackView.push({item:Qt.resolvedUrl("Screen_Preheating.qml"), immediate:immediateTransitions});
                    }
                }
            }
        }

    }

    CircleContent {
        id: circleContent
        topString: tempToString(upperFront.setTemp)
        middleString: tempToString(lowerFront.setTemp)
        bottomString: timeToString(cookTime)
    }
}

