import QtQuick 2.0

Item {
    id: heaterBankVisual

    height: (buttonHeight + spacing)*3
    implicitWidth: screenWidth

    property int buttonWidth: 100
    property int buttonHeight: 100
    property int spacing: 10
    property color borderColor: appForegroundColor

    property HeaterBankData heater

    Column {
        z: 1
        spacing: heaterBankVisual.spacing

        TwoValueBox {
            id: tempBox
            upperLabel: heater.bank
            upperValue: heater.currentTemp
            lowerLabel: "Set"
            lowerValue: heater.setTemp
            width: heaterBankVisual.buttonWidth
            height: heaterBankVisual.buttonHeight
            borderColor: heaterBankVisual.borderColor

            onClicked: {
                function disconnectAndDisable() {
                    tempEntry.dialogCanceled.disconnect(handleCanceled);
                    tempEntry.dialogCompleted.disconnect(handleCompleted);
                    tempEntry.enabled = false;
                    tempEntry.visible = false;
                }
                function handleCanceled() {
                    disconnectAndDisable();
                }
                function handleCompleted() {
                    console.log("Enter pressed and value is " + tempEntry.value);
                    heater.setTemp = tempEntry.value;
                    disconnectAndDisable();
                    console.log("New heater set temp: " + heater.setTemp);
                    var msg = "Set " + heater.bank + " SetPoint " +
                            (heater.setTemp - 0.5 * heater.temperatureDeadband) + " " +
                            (heater.setTemp + 0.5 * heater.temperatureDeadband);
                    console.log("Trying to set: " + msg);
                    sendWebSocketMessage("Set " + heater.bank + " SetPoint " +
                                         (heater.setTemp - 0.5 * heater.temperatureDeadband) + " " +
                                         (heater.setTemp + 0.5 * heater.temperatureDeadband));
                }
                onClicked: {
                    tempEntry.value = heater.setTemp;
                    tempEntry.dialogCanceled.connect(handleCanceled);
                    tempEntry.dialogCompleted.connect(handleCompleted);
                    tempEntry.header = heater.bank + " Setpoint Deg. F"
                    tempEntry.visible = true;
                    tempEntry.enabled = true;
                }
            }
        }
        TwoValueBox {
            id: onPercentBox
            upperLabel: heater.bank + " On"
            upperValue: ""
            lowerLabel: heater.onPercent
            lowerValue: "%"
            width: heaterBankVisual.buttonWidth
            height: heaterBankVisual.buttonHeight
            borderColor: heaterBankVisual.borderColor

            onClicked: {
                function disconnectAndDisable() {
                    tempEntry.dialogCanceled.disconnect(handleCanceled);
                    tempEntry.dialogCompleted.disconnect(handleCompleted);
                    tempEntry.enabled = false;
                    tempEntry.visible = false;
                }
                function handleCanceled() {
                    disconnectAndDisable();
                }
                function handleCompleted() {
                    heater.onPercent = tempEntry.value;
                    disconnectAndDisable();
                    var msg = "Set "+ heater.bank + " OnPercent " + heater.onPercent;
                    console.log("Setting on percent to " + msg);
                    sendWebSocketMessage("Set "+ heater.bank + " OnPercent " + heater.onPercent);
                }
                onClicked: {
                    tempEntry.value = heater.onPercent;
                    tempEntry.dialogCanceled.connect(handleCanceled);
                    tempEntry.dialogCompleted.connect(handleCompleted);
                    tempEntry.header = heater.bank + " On Percent"
                    tempEntry.visible = true;
                    tempEntry.enabled = true;
                }
            }
        }
        TwoValueBox {
            id: offPercentBox
            upperLabel: heater.bank + " Off"
            upperValue: ""
            lowerLabel: heater.offPercent
            lowerValue: "%"
            width: heaterBankVisual.buttonWidth
            height: heaterBankVisual.buttonHeight
            borderColor: heaterBankVisual.borderColor

            onClicked: {
                function disconnectAndDisable() {
                    tempEntry.dialogCanceled.disconnect(handleCanceled);
                    tempEntry.dialogCompleted.disconnect(handleCompleted);
                    tempEntry.enabled = false;
                    tempEntry.visible = false;
                }
                function handleCanceled() {
                    disconnectAndDisable();
                }
                function handleCompleted() {
                    heater.offPercent = tempEntry.value;
                    disconnectAndDisable();
                    var msg = "Set " + heater.bank + " OffPercent " + heater.offPercent;
                    console.log("Setting off percent to " + msg);
                    sendWebSocketMessage("Set " + heater.bank + " OffPercent " + heater.offPercent);
                }
                onClicked: {
                    tempEntry.value = heater.offPercent;
                    tempEntry.dialogCanceled.connect(handleCanceled);
                    tempEntry.dialogCompleted.connect(handleCompleted);
                    tempEntry.header = heater.bank + " Off Percent"
                    tempEntry.visible = true;
                    tempEntry.enabled = true;
                }
            }
        }
    }
}

