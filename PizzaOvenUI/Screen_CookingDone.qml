import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    implicitWidth: parent.width
    implicitHeight: parent.height


    CircleScreenTemplate {
        id: dataCircle
        circleValue: 100
        titleText: "COOKING"
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


    CircleContent {
        id: circleContent
        topString: utility.tempToString(upperFront.setTemp)
        middleString: utility.tempToString(lowerFront.setTemp)
        bottomString: "DONE"
        needsAnimation: false
    }

    ButtonRight {
        id: startButton
        text: "START"
        onClicked: SequentialAnimation {
            ScriptAction {script: {
                    stackView.clear();
                    if (demoModeIsActive) {
                        lowerFront.currentTemp = 75;
                    }
                    rootWindow.cookTimer.start();
                    stackView.push({item:Qt.resolvedUrl("Screen_CookingFirstHalf.qml"), immediate:immediateTransitions});
                }
            }

        }
        needsAnimation: false
    }

    function screenEntry() {
        sounds.cycleComplete.play();
    }
}
