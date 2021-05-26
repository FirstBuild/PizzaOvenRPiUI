import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: thisScreen
    property string screenName: "Screen_Development"

    implicitHeight: screenHeight
    implicitWidth: screenWidth

    property int spacing: 10 * screenScale
    property int smallButtonWidth: (thisScreen.width - 3 * thisScreen.spacing) / 4
    property int smallButtonHeight: ((thisScreen.height - thisScreen.spacing) / 4) - thisScreen.spacing

    function screenEntry() {
        console.log("Entering development screen");
        appSettings.backlightOff = false;
    }

    Column {
        id: dataColumn
        z: 1
        spacing: thisScreen.spacing
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width

        Row {
            spacing: thisScreen.spacing

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
                visible: rootWindow.originalConfiguration
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
                visible: rootWindow.originalConfiguration
            }
        }
        Row {
            id: idDutyCycleRow
            property int textSize: 12 * screenScale
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
                visible: rootWindow.originalConfiguration
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
                visible: rootWindow.originalConfiguration
            }
            GearButton {
                id: mainMenuGearButton
                height: 20 * screenScale
                width: height
                x: screenWidth/6 - 20
                y: 0
                onClicked: {
                    stackView.push({item: Qt.resolvedUrl("Screen_Settings2.qml"), immediate:immediateTransitions});
                }
            }
        }

        Row {
            spacing: thisScreen.spacing
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
                    spacing: thisScreen.spacing
                    Text {
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 12 * screenScale
                        text: ovenState
                    }
                    Text {
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 12 * screenScale
                        text: "Power: " + (powerSwitch == 0 ? "Off" : "On")
                    }
                    Text {
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 12 * screenScale
                        text: "DLB: " + (dlb == 0 ? "Off" : "On")
                    }
                }
                Row {
                    spacing: thisScreen.spacing
                    Text {
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 12 * screenScale
                        text: "Door: " + doorStatus
                    }
                    Text {
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 12 * screenScale
                        text: "Count: " + doorCount
                    }
                    Text {
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 12 * screenScale
                        text: "TCO: " + (tco == 0 ? "Off" : "On")
                    }
                    Text {
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 12 * screenScale
                        text: "AC: " + (acPowerIsPresent == 0 ? "Off" : "On")
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
            backEnd.sendMessage("Get LF");
            if (rootWindow.originalConfiguration) {
                backEnd.sendMessage("Get UR");
                backEnd.sendMessage("Get LR");
            }
        }
        anchors.right: dataColumn.right
//        anchors.right: parent.right
        anchors.bottom: dataColumn.bottom
    }
    TempEntryWithKeys {
        id: tempEntry
        enabled: false
        visible: false
        z: 1
    }
}

