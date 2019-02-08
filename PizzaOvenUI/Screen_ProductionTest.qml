import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: thisScreen

    implicitHeight: screenHeight
    implicitWidth: screenWidth

    property int spacing: 10
    property int smallButtonWidth: ((thisScreen.width - thisScreen.spacing) / 4) - thisScreen.spacing
    property int smallButtonHeight: ((thisScreen.height - thisScreen.spacing) / 6) - thisScreen.spacing
    property int columnWidth: smallButtonWidth
    property int textSize: 24

    function screenEntry() {
        appSettings.backlightOff = false;

        // Initialize Off percents
        backEnd.sendMessage("Set UF OffPercent 100");
        backEnd.sendMessage("Set UR OffPercent 100");
        backEnd.sendMessage("Set LF OffPercent 49");
        backEnd.sendMessage("Set LR OffPercent 100");

        console.log("Small button height: " + smallButtonHeight);
        console.log("Screen height: " + screenHeight);
    }

    // a reference rectangle
//    Rectangle {
//        x: 0
//        y: 0
//        width: parent.width
//        height: parent.height
//        color: appBackgroundColor
//        border.color: "red"
//        border.width: 1
//    }

    Column {
        id: dataColumn
        z: 1
        spacing: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        width: screenWidth

        Text {
            text: "PRODUCTION TESTING"
            width: screenWidth
            height: smallButtonHeight
            color: appForegroundColor
            font.family: localFont.name
            font.pointSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Rectangle {
            id: buttonContainer
//            border.color: "blue"
//            border.width: 1
            width: screenWidth - spacing * 2
            height: smallButtonHeight * 3
            color: appBackgroundColor
            anchors.horizontalCenter: parent.horizontalCenter
            Row {
                spacing: 10
                TestToggle {
                    id: upperFrontToggle
                    heater: upperFront
                    height: buttonContainer.height
                    width: buttonContainer.width / 4 - 3 * parent.spacing / 4
                }
                TestToggle {
                    id: upperRearToggle
                    heater: upperRear
                    height: buttonContainer.height
                    width: buttonContainer.width / 4 - 3 * parent.spacing / 4
                }
                TestToggle {
                    heater: lowerFront
                    height: buttonContainer.height
                    width: buttonContainer.width / 4 - 3 * parent.spacing / 4
                }
                TestToggle {
                    heater: lowerRear
                    height: buttonContainer.height
                    width: buttonContainer.width / 4 - 3 * parent.spacing / 4
                }
            }
        }


    }

    Row {
        spacing: 10
        //width: parent.width
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 15
        MyButton {
            id: idStartStopButton
            text: (ovenState == "Standby") || (ovenState == "Cooldown") ? "Start" : "Stop"
            width: smallButtonWidth
            height: smallButtonHeight
            borderWidth: 3
            borderColor: getButtonColor()
            function getButtonColor () {
                console.log("Oven state: <" + ovenState + ">");
                var color = "orange"
                if (powerSwitch==0) {
                    console.log("Setting color to gray.");
                    color = "gray"
                } else {
                    switch (ovenState) {
                    case "Standby":
                    case "Cooldown":
                        console.log("Setting color to green.");
                        color = "green"
                        break;
                    default:
                        console.log("Setting color to red.");
                        color = "red"
                    }
                }

                return color;
            }
            onClicked: {
                switch (ovenState) {
                case "Standby":
                case "Cooldown":
                    if (powerSwitch == 1) {
                        backEnd.sendMessage("StartOven ");
                        autoShutoff.start();
                    }
                    break;
                default:
                    backEnd.sendMessage("StopOven ");
                    break;
                }
            }
        }
        GearButton {
            id: mainMenuGearButton
            height: idStartStopButton.height
            width: idStartStopButton.width
            x: 0
            y: 0
            onClicked: {
                stackView.push({item: Qt.resolvedUrl("Screen_Settings2.qml"), immediate:immediateTransitions});
            }
        }
        MyButton {
            id: idRefreshData
            z: 1
            text: "Refresh"
            width: smallButtonWidth
            height: smallButtonHeight
            borderWidth: 1
            borderColor: appForegroundColor
            onClicked: {
                backEnd.sendMessage("Get UF");
                backEnd.sendMessage("Get UR");
                backEnd.sendMessage("Get LF");
                backEnd.sendMessage("Get LR");
            }
        }
    }
    TempEntryWithKeys {
        id: tempEntry
        enabled: false
        visible: false
        z: 1
    }
}

