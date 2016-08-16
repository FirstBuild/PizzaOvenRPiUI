import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenAwaitStart
    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 15

    HomeButton {
        id: preheatingHomeButton
        anchors.margins: myMargins
        x: 5
        y: 5
        onClicked: {
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
        }
    }

    Text {
        id: screenLabel
        font.family: localFont.name
        font.pointSize: 24
        text: "PREHEATING"
        anchors.margins: myMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: preheatingHomeButton.verticalCenter
        color: appForegroundColor
    }

    Item {
        id: centerCircle
        implicitWidth: parent.height * 0.7;
        implicitHeight: width
        anchors.margins: myMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40

        CircleAsymmetrical {
            id: dataCircle
            height: parent.height;
            width: parent.width
            topText: tempToString(upperFront.setTemp)
            middleText: tempToString(lowerFront.setTemp)
            bottomText: tempToString(currentTemp)
        }
    }

//    SideButton {
//        id: cancelButton
//        buttonText: "CANCEL"
//        anchors.margins: myMargins
//        anchors.verticalCenter: centerCircle.verticalCenter
//        anchors.right: centerCircle.left
//        onClicked: {
//            console.log("The cancel button was clicked.");
//            stackView.clear();
//            stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
//        }
//    }

    SideButton {
        id: editButton
        buttonText: "EDIT"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.right: centerCircle.left
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

    Timer {
        id: animateTimer
        interval: 250; running: true; repeat: true
        onTriggered: {
            var val = 0;
            if (demoModeIsActive) {
                val = dataCircle.currentValue + 10;
                if (val > 100) {
                    val = 0;
                    animateTimer.stop();
                    stackView.push({item:Qt.resolvedUrl("Screen_Start.qml"), immediate:immediateTransitions});
                }
                dataCircle.currentValue = val;

                val = 80 + (lowerFront.setTemp - 80) * val / 100
                dataCircle.bottomText = tempToString(val);
            } else {
                val = 100 * currentTemp / lowerFront.setTemp;
                if (val >= 100) {
                    val = 0;
                    animateTimer.stop();
                    stackView.push({item:Qt.resolvedUrl("Screen_Start.qml"), immediate:immediateTransitions});
                }
                dataCircle.currentValue = val;
            }
        }
    }

    Rectangle {
        id: hiddenPauseButton
        height: 75
        width: parent.width*.2
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.left: centerCircle.right
        color: appBackgroundColor

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                if (demoModeIsActive) {
                    console.log("Pause clicked");
                    sounds.touch.play();
                    if (animateTimer.running) {
                        animateTimer.stop();
                    } else {
                        animateTimer.start();
                    }
                }
            }
        }

    }
}

