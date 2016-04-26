import QtQuick 2.0

Item {
    id: heaterBankData

    height: (buttonHeight + spacing)*3
    implicitWidth: screenWidth

    property string bank: "BANK"
    property int buttonWidth: 100
    property int buttonHeight: 100
    property int currentTemp: 1000
    property int setTemp: 990
    property int onPercent: 25
    property int offPercent: 75
    property int deadband: 12
    property int spacing: 10
    property color borderColor: appForegroundColor

    Column {
        z: 1
        spacing: heaterBankData.spacing

        TwoValueBox {
            id: tempBox
            upperLabel: heaterBankData.bank
            upperValue: heaterBankData.currentTemp
            lowerLabel: "Set"
            lowerValue: heaterBankData.setTemp
            width: heaterBankData.buttonWidth
            height: heaterBankData.buttonHeight
            borderColor: heaterBankData.borderColor

            onClicked: {
                function handleCanceled() {
                    tempEntry.dialogCanceled.disconnect(handleCanceled);
                    tempEntry.enabled = false;
                    tempEntry.visible = false;
                }
                function handleCompleted() {
                    tempEntry.dialogCompleted.disconnect(handleCompleted);
                    heaterBankData.setTemp = tempEntry.value;
                    handleCanceled();
                    sendWebSocketMessage("Set " + bank + " SetPoint " +
                                         (heaterBankData.setTemp - 0.5 * deadband) + " " +
                                         (heaterBankData.setTemp + 0.5 * deadband));
                }
                onClicked: {
                    tempEntry.value = heaterBankData.setTemp;
                    tempEntry.dialogCanceled.connect(handleCanceled);
                    tempEntry.dialogCompleted.connect(handleCompleted);
                    tempEntry.header = bank + " Setpoint Deg. F"
                    tempEntry.visible = true;
                    tempEntry.enabled = true;
                }
            }
        }
        TwoValueBox {
            id: onPercentBox
            upperLabel: heaterBankData.bank + " On"
            upperValue: ""
            lowerLabel: heaterBankData.onPercent
            lowerValue: "%"
            width: heaterBankData.buttonWidth
            height: heaterBankData.buttonHeight
            borderColor: heaterBankData.borderColor

            onClicked: {
                function handleCanceled() {
                    tempEntry.dialogCanceled.disconnect(handleCanceled);
                    tempEntry.enabled = false;
                    tempEntry.visible = false;
                }
                function handleCompleted() {
                    tempEntry.dialogCompleted.disconnect(handleCompleted);
                    heaterBankData.onPercent = tempEntry.value;
                    handleCanceled();
                    sendWebSocketMessage("Set "+ bank + " OnPercent " + heaterBankData.onPercent);
                }
                onClicked: {
                    tempEntry.value = heaterBankData.onPercent;
                    tempEntry.dialogCanceled.connect(handleCanceled);
                    tempEntry.dialogCompleted.connect(handleCompleted);
                    tempEntry.header = bank + " On Percent"
                    tempEntry.visible = true;
                    tempEntry.enabled = true;
                }
            }
        }
        TwoValueBox {
            id: offPercentBox
            upperLabel: heaterBankData.bank + " Off"
            upperValue: ""
            lowerLabel: heaterBankData.offPercent
            lowerValue: "%"
            width: heaterBankData.buttonWidth
            height: heaterBankData.buttonHeight
            borderColor: heaterBankData.borderColor

            onClicked: {
                function handleCanceled() {
                    tempEntry.dialogCanceled.disconnect(handleCanceled);
                    tempEntry.enabled = false;
                    tempEntry.visible = false;
                }
                function handleCompleted() {
                    tempEntry.dialogCompleted.disconnect(handleCompleted);
                    heaterBankData.offPercent = tempEntry.value;
                    handleCanceled();
                    sendWebSocketMessage("Set " + bank + " OffPercent " + heaterBankData.offPercent);
                }
                onClicked: {
                    tempEntry.value = heaterBankData.offPercent;
                    tempEntry.dialogCanceled.connect(handleCanceled);
                    tempEntry.dialogCompleted.connect(handleCompleted);
                    tempEntry.header = bank + " Off Percent"
                    tempEntry.visible = true;
                    tempEntry.enabled = true;
                }
            }
        }
    }
}

