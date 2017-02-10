import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: thisScreen

    implicitHeight: screenHeight
    implicitWidth: screenWidth

    property int spacing: 10
    property int smallButtonWidth: ((thisScreen.width - thisScreen.spacing) / 4) - thisScreen.spacing
    property int smallButtonHeight: ((thisScreen.height - thisScreen.spacing) / 4) - thisScreen.spacing

    function screenEntry() {
        appSettings.backlightOff = false;
    }

    Column {
        id: dataColumn
        z: 1
        spacing: 10
        anchors.centerIn: parent

        Row {
            spacing: 10

            HeaterBankVisual {
                id: upperFrontData
                heater: upperFront
                width: smallButtonWidth
                buttonWidth: smallButtonWidth
                buttonHeight: smallButtonHeight
                borderColor: (upperFront.elementRelay == 0) ? "blue" : "red"
            }
            HeaterBankVisual {
                id: upperRearData
                heater: upperRear
                width: smallButtonWidth
                buttonWidth: smallButtonWidth
                buttonHeight: smallButtonHeight
                borderColor: (upperRear.elementRelay == 0) ? "blue" : "red"
            }
            HeaterBankVisual {
                id: lowerFrontData
                heater: lowerFront
                width: smallButtonWidth
                buttonWidth: smallButtonWidth
                buttonHeight: smallButtonHeight
                borderColor: (lowerFront.elementRelay == 0) ? "blue" : "red"
            }
            HeaterBankVisual {
                id: lowerRearData
                heater: lowerRear
                width: smallButtonWidth
                buttonWidth: smallButtonWidth
                buttonHeight: smallButtonHeight
                borderColor: (lowerRear.elementRelay == 0) ? "blue" : "red"
            }
        }
        Row {
            id: idDutyCycleRow
            property int textSize: 12
            Text {
                color: appForegroundColor
                font.family: localFont.name
                font.pointSize: idDutyCycleRow.textSize
                text: "Duty Cycles:"
                width: screenWidth/6
            }
            Text {
                color: appForegroundColor
                font.family: localFont.name
                font.pointSize: idDutyCycleRow.textSize
                text: " UF: " + upperFront.elementDutyCycle.toLocaleString(Qt.locale("C"), 'f', 3)
                width: screenWidth/6
            }
            Text {
                color: appForegroundColor
                font.family: localFont.name
                font.pointSize: idDutyCycleRow.textSize
                text: " UR: " + upperRear.elementDutyCycle.toLocaleString(Qt.locale("C"), 'f', 3)
                width: screenWidth/6
            }
            Text {
                color: appForegroundColor
                font.family: localFont.name
                font.pointSize: idDutyCycleRow.textSize
                text: " LF: " + lowerFront.elementDutyCycle.toLocaleString(Qt.locale("C"), 'f', 3)
                width: screenWidth/6
            }
            Text {
                color: appForegroundColor
                font.family: localFont.name
                font.pointSize: idDutyCycleRow.textSize
                text: " LR: " + lowerRear.elementDutyCycle.toLocaleString(Qt.locale("C"), 'f', 3)
                width: screenWidth/6
            }
            GearButton {
                id: mainMenuGearButton
                height: 20
                width: screenWidth/6
                x: screenWidth/6 - 20
                y: 0
                onClicked: {
                    stackView.push({item: Qt.resolvedUrl("Screen_Settings2.qml"), immediate:immediateTransitions});
                }
            }
        }

        Row {
            spacing: 10
            MyButton {
                id: idStartStopButton
                text: (ovenState == "Standby") || (ovenState == "Cooldown") ? "Start" : "Stop"
                width: smallButtonWidth
                height: smallButtonHeight*.6
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
            Column {
                Row {
                    spacing: 10
                    Text {
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 14
                        text: ovenState
                    }
                    Text {
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 14
                        text: "Power: " + (powerSwitch == 0 ? "Off" : "On")
                    }
                    Text {
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 14
                        text: "DLB: " + (dlb == 0 ? "Off" : "On")
                    }
                }
                Row {
                    spacing: 10
                    Text {
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 14
                        text: "Door: " + doorStatus
                    }
                    Text {
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 14
                        text: "Count: " + doorCount
                    }
                    Text {
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 14
                        text: "TCO: " + (tco == 0 ? "Off" : "On")
                    }
                }
            }
        }
    }
    MyButton {
        id: idRefreshData
        z: 1
        text: "Refresh"
        width: smallButtonWidth
        height: smallButtonHeight*.6
        borderWidth: 1
        borderColor: appForegroundColor
        onClicked: {
            backEnd.sendMessage("Get UF");
            backEnd.sendMessage("Get UR");
            backEnd.sendMessage("Get LF");
            backEnd.sendMessage("Get LR");
        }
        anchors.right: dataColumn.right
        anchors.bottom: dataColumn.bottom
    }
    TempEntryWithKeys {
        id: tempEntry
        enabled: false
        visible: false
        z: 1
    }
}

