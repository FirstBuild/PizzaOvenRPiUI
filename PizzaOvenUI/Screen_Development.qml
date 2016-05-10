import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: devScreen

    implicitHeight: screenHeight
    implicitWidth: screenWidth

    property int myMargins: 10
    property int spacing: 10
    property int smallButtonWidth: ((devScreen.width - devScreen.spacing) / 4) - devScreen.spacing
    property int smallButtonHeight: ((devScreen.height - devScreen.spacing) / 4) - devScreen.spacing

    TempEntryWithKeys {
        id: tempEntry
        enabled: false
        visible: false
        z: 10
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
            }
            Text {
                color: appForegroundColor
                font.family: localFont.name
                font.pointSize: idDutyCycleRow.textSize
                text: " UF: " + upperFront.elementDutyCycle.toLocaleString(Qt.locale("C"), 'f', 3)
            }
            Text {
                color: appForegroundColor
                font.family: localFont.name
                font.pointSize: idDutyCycleRow.textSize
                text: " UR: " + upperRear.elementDutyCycle.toLocaleString(Qt.locale("C"), 'f', 3)
            }
            Text {
                color: appForegroundColor
                font.family: localFont.name
                font.pointSize: idDutyCycleRow.textSize
                text: " LF: " + lowerFront.elementDutyCycle.toLocaleString(Qt.locale("C"), 'f', 3)
            }
            Text {
                color: appForegroundColor
                font.family: localFont.name
                font.pointSize: idDutyCycleRow.textSize
                text: " LR: " + lowerRear.elementDutyCycle.toLocaleString(Qt.locale("C"), 'f', 3)
            }
            GearButton {
                id: mainMenuGearButton
                height: 20
                onClicked: {
                    stackView.push({item: Qt.resolvedUrl("Screen_Settings.qml"), immediate:immediateTransitions});
                }
            }
        }

        Row {
            spacing: 10
            MyButton {
                id: idStartStopButton
                text: ovenState == "Cooking" ? "Stop" : "Start"
                width: smallButtonWidth
                height: smallButtonHeight*.6
                borderWidth: 3
                borderColor: getButtonColor()
                function getButtonColor () {
                    console.log("Oven state: <" + ovenState + ">");
                    var color = "orange"
                    if (ovenState == "Cooking") {
                        console.log("Setting color to red.");
                        color = "red"
                    } else {
                        if (powerSwitch==0) {
                            console.log("Setting color to gray.");
                            color = "gray"
                        } else {
                            console.log("Setting color to green.");
                            color = "green"
                        }
                    }
                    return color;
                }
                onClicked: {
                    switch (ovenState) {
                    case "Cooking":
                        sendWebSocketMessage("StopOven ");
                        break;
                    default:
                        if (powerSwitch == 1) {
                            sendWebSocketMessage("StartOven ");
                        }
                        break;
                    }
                }
            }
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
    }
    MyButton {
        id: idRefreshData
        text: "Refresh"
        width: smallButtonWidth
        height: smallButtonHeight*.6
        borderWidth: 1
        borderColor: appForegroundColor
        onClicked: {
            sendWebSocketMessage("Get UF");
            sendWebSocketMessage("Get UR");
            sendWebSocketMessage("Get LF");
            sendWebSocketMessage("Get LR");
        }
        anchors.right: dataColumn.right
        anchors.bottom: dataColumn.bottom
    }
}

