import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenPreheating2Temp
    implicitWidth: parent.width
    implicitHeight: parent.height

//    Image {
//        id: pizzaOvenOffImage
//        //            source: "pizza_oven_blank_screen.jpg"
//        source: "TwoTempPreheat.png"
//        //        source: "TwoTemps.png"
//        //        source: "BackArrow.png"
//        //anchors.centerIn: parent
//        x: 1
//        y: 26
//    }

    CircleScreenTemplate {
        id: dataCircle
        circleValue: 0
        titleText: "PREHEATING"
        opacity: 0.5
    }

    HomeButton {
        id: preheatingHomeButton
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

    CircleContentTwoTemp {
        id: circleContent
        line1String: tempToString(upperFront.setTemp)
        line2String: tempToString(upperFront.currentTemp)
        line3String: tempToString(lowerFront.setTemp)
        line4String: tempToString(currentTemp)
    }

    Timer {
        id: animateTimer
        interval: 250; running: true; repeat: true
        onTriggered: {
            var val = 0;
            if (demoModeIsActive) {
                val = dataCircle.circleValue + 10;
                if (val > 100) {
                    val = 0;
                    animateTimer.stop();
                    stackView.push({item:Qt.resolvedUrl("Screen_Start.qml"), immediate:immediateTransitions});
                }
                dataCircle.circleValue = val;

                val = 80 + (lowerFront.setTemp - 80) * val / 100;
                circleContent.line4String = tempToString(val);

                val = dataCircle.circleValue
                val = 100 + (upperFront.setTemp - 100) * val / 100;
                circleContent.line2String = tempToString(val);
            } else {
                val = 100 * currentTemp / lowerFront.setTemp;
                if (val >= 100) {
                    val = 0;
                    animateTimer.stop();
                    stackView.push({item:Qt.resolvedUrl("Screen_Start.qml"), immediate:immediateTransitions});
                }
                dataCircle.circleValue = val;
            }
        }
    }
}

