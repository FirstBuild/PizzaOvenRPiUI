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
        z: 1
        spacing: 10
        anchors.centerIn: parent

        Row {
            spacing: 10

            HeaterBankData {
                id: upperFrontData
                bank: "UF"
                width: smallButtonWidth
                buttonWidth: smallButtonWidth
                buttonHeight: smallButtonHeight
                currentTemp: upperFrontCurrentTemp
                setTemp: upperFrontSetTemp
                onPercent: upperFrontOnPercent
                offPercent: upperFrontOffPercent
                borderColor: (upperFrontRelay == 0) ? "blue" : "red"
            }
            HeaterBankData {
                id: upperRearData
                bank: "UR"
                width: smallButtonWidth
                buttonWidth: smallButtonWidth
                buttonHeight: smallButtonHeight
                currentTemp: upperRearCurrentTemp
                setTemp: upperRearSetTemp
                onPercent: upperRearOnPercent
                offPercent: upperRearOffPercent
                borderColor: (upperRearRelay == 0) ? "blue" : "red"
            }
            HeaterBankData {
                id: lowerFrontData
                bank: "LF"
                width: smallButtonWidth
                buttonWidth: smallButtonWidth
                buttonHeight: smallButtonHeight
                currentTemp: lowerFrontCurrentTemp
                setTemp: lowerFrontSetTemp
                onPercent: lowerFrontOnPercent
                offPercent: lowerFrontOffPercent
                borderColor: (lowerFrontRelay == 0) ? "blue" : "red"
            }
            HeaterBankData {
                id: lowerRearData
                bank: "LR"
                width: smallButtonWidth
                buttonWidth: smallButtonWidth
                buttonHeight: smallButtonHeight
                currentTemp: lowerRearCurrentTemp
                setTemp: lowerRearSetTemp
                onPercent: lowerRearOnPercent
                offPercent: lowerRearOffPercent
                borderColor: (lowerRearRelay == 0) ? "blue" : "red"
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
                text: " UF: " + upperFrontDutyCycle
            }
            Text {
                color: appForegroundColor
                font.family: localFont.name
                font.pointSize: idDutyCycleRow.textSize
                text: " UR: " + upperRearDutyCycle
            }
            Text {
                color: appForegroundColor
                font.family: localFont.name
                font.pointSize: idDutyCycleRow.textSize
                text: " LF: " + lowerFrontDutyCycle
            }
            Text {
                color: appForegroundColor
                font.family: localFont.name
                font.pointSize: idDutyCycleRow.textSize
                text: " LR: " + lowerRearDutyCycle
            }
        }

        Row {
            spacing: 10
            MyButton {
                id: idStartStopButton
                text: ovenState == "Cooking" ? "Stop" : "Start"
//                textColor: ovenState == "Cooking" ? "red" : (powerSwitch==0 ? "gray" : "green")
                width: smallButtonWidth
                height: smallButtonHeight*.6
                borderWidth: 2
                borderColor: ovenState == "Cooking" ? "red" : (powerSwitch==0 ? "gray" : "green")
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
}

