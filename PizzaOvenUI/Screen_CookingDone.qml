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
    }

    HomeButton {
        id: homeButton
    }

    EditButton {
        id: editButton
    }


    CircleContent {
        id: circleContent
        topString: tempToString(upperFront.setTemp)
        middleString: tempToString(lowerFront.setTemp)
        bottomString: "DONE"
    }

    ButtonRight {
        id: startButton
        text: "START"
        onClicked: SequentialAnimation {
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {script: {
                    stackView.clear();
                    if (demoModeIsActive) {
                        lowerFront.currentTemp = 75;
                    }

                    stackView.push({item:Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
                }
            }

        }

    }

    function screenEntry() {
        sounds.cycleComplete.play();
    }
}
