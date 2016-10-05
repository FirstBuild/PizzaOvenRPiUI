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
        circleValue: 0
        titleText: "READY"
    }

    HomeButton {
        id: homeButton
    }

    EditButton {
        id: editButton
        needsAnimation: false
    }

    ButtonRight {
        id: startButton
        text: "START"
        onClicked: SequentialAnimation {
            ScriptAction {
                script: {
                    rootWindow.cookTimer.start();
                }
            }
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    stackView.push({item:Qt.resolvedUrl("Screen_CookingFirstHalf.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    CircleContent {
        id: dataCircle
        topString: utility.tempToString(upperFront.setTemp)
        middleString: utility.tempToString(lowerFront.setTemp)
        bottomString: utility.timeToString(cookTime)
    }

    function screenEntry() {
        sounds.notification.play();
    }
}

