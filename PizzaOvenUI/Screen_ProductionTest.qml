import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: thisScreen
    property string screenName: "Screen_ProductionTest"

    implicitHeight: screenHeight
    implicitWidth: screenWidth

    property int spacing: 10
    property int smallButtonWidth: ((thisScreen.width - thisScreen.spacing) / 4) - thisScreen.spacing
    property int smallButtonHeight: ((thisScreen.height - thisScreen.spacing) / 6) - thisScreen.spacing
    property int textSize: 24
    property int controlCount: rootWindow.originalConfiguration ? 4 : 2
    property int controlWidth: (thisScreen.width - thisScreen.spacing * (controlCount - 1)) / controlCount

    function screenEntry() {
        console.log("Entering production test screen");
        appSettings.backlightOff = false;

        // Initialize Off percents
        if (rootWindow.originalConfiguration) {
            backEnd.sendMessage("Set UF OffPercent 100");
            backEnd.sendMessage("Set UR OffPercent 100");
            backEnd.sendMessage("Set LF OffPercent 49");
            backEnd.sendMessage("Set LR OffPercent 100");
        } else {
            backEnd.sendMessage("Set UF OffPercent 100");
            backEnd.sendMessage("Set LF OffPercent 100");
        }
    }

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
            border.color: "blue"
            border.width: 1
            width: thisScreen.width
            height: smallButtonHeight * 3
            color: appBackgroundColor
            anchors.horizontalCenter: parent.horizontalCenter
            Row {
                spacing: 10

                TestToggle {
                    id: upperFrontToggle
                    heater: upperFront
                    height: buttonContainer.height
                    width: controlWidth
                }
                TestToggle {
                    id: upperRearToggle
                    heater: upperRear
                    height: buttonContainer.height
                    width: controlWidth
                    visible: rootWindow.originalConfiguration
                }
                TestToggle {
                    heater: lowerFront
                    height: buttonContainer.height
                    width: controlWidth
                }
                TestToggle {
                    heater: lowerRear
                    height: buttonContainer.height
                    width: controlWidth
                    visible: rootWindow.originalConfiguration
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
                    color = "gray"
                } else {
                    switch (ovenState) {
                    case "Standby":
                    case "Cooldown":
                        color = "green"
                        break;
                    default:
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
                backEnd.sendMessage("Get LF");
                if (rootWindow.originalConfiguration) {
                    backEnd.sendMessage("Get UR");
                    backEnd.sendMessage("Get LR");
                }
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

