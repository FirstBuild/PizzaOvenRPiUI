import QtQuick 2.0

Item {
    id: screenCookingDone
    implicitWidth: parent.width
    implicitHeight: parent.height


    CircleScreenTemplate {
        id: dataCircle
        circleValue: 100
        titleText: "COOKING"
    }

    HomeButton {
        id: homeButton
        onClicked: {
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
        }
    }

    ButtonLeft {
        id: editButton
        text: "EDIT"
        onClicked: {
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

    CircleContent {
        id: circleContent
        topString: tempToString(upperFront.setTemp)
        middleString: tempToString(lowerFront.setTemp)
        bottomString: "DONE"
    }

    ButtonRight {
        id: startButton
        text: "START"
        onClicked: {
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
        }
    }

    function screenEntry() {
        sounds.cycleComplete.play();
    }
}

