import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenStart
    implicitWidth: parent.width
    implicitHeight: parent.height

    CircleScreenTemplate {
        circleValue: 0
        titleText: "READY"
    }

    HomeButton {
        id: awaitStartHomeButton
        onClicked: {
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
        }
    }

    ButtonLeft {
        id: editButton
        text: "EDIT"
        onClicked: {
            console.log("The edit button was clicked.");
            console.log("Current item: " + stackView.currentItem);
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
            stackView.completeTransition();
            screenBookmark = stackView.currentItem;
            if (twoTempEntryModeIsActive) {
                stackView.push({item:Qt.resolvedUrl("Screen_EnterDomeTemp.qml"), immediate:immediateTransitions});
            } else {
                stackView.push({item:Qt.resolvedUrl("Screen_TemperatureEntry.qml"), immediate:immediateTransitions});
            }
        }
    }

    ButtonRight {
        id: startButton
        text: "START"
        onClicked: {
            console.log("The start button was clicked.");
            currentTime = 0;
            stackView.push({item:Qt.resolvedUrl("Screen_CookingFirstHalf.qml"), immediate:immediateTransitions});
        }
    }

    CircleContent {
        id: dataCircle
        topString: tempToString(upperFront.setTemp)
        middleString: tempToString(lowerFront.setTemp)
        bottomString: timeToString(cookTime)
    }

    function screenEntry() {
        sounds.notification.play();
    }
}

