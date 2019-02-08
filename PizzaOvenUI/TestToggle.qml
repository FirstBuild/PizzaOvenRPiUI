import QtQuick 2.0

Item {
    id: testToggle

    implicitWidth: ((screenWidth - spacing) / 4) - spacing
    implicitHeight: (((screenHeight - spacing) / 4) - spacing) * 3

    property int spacing: 10
    property int textSize: 24
    property int itemWidth: testToggle.width
    property int itemHeight: testToggle.height / 3

    property HeaterBankData heater

    Rectangle {
        color: appBackgroundColor
        width: testToggle.width
        height: testToggle.height
        border.color: "white"
        border.width: 1

        Column {
            Text {
                color: appForegroundColor
                text: heater.bank
                font.family: localFont.name
                font.pointSize: textSize
                width: itemWidth
                height: itemHeight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                color: appForegroundColor
                text: heater.currentTemp
                font.family: localFont.name
                font.pointSize: textSize
                width: itemWidth
                height: itemHeight
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            MyButton {
                id: idEnableDisableButton
                text: (heater.onPercent === 101) ? "Enable" : "Disable"
                width: itemWidth
                height: itemHeight
                borderWidth: 3
                borderColor: getButtonColor()
                function getButtonColor () {
                    var color = "orange"
                    if (powerSwitch==0) {
                        color = "gray"
                    } else {
                        if (heater.onPercent === 101) {
                            color = "green"
                        } else {
                            color = "red"
                        }
                    }

                    return color;
                }
                onClicked: {
                    if (heater.onPercent === 101) {
                        switch(heater.bank) {
                        case 'UF':
                        case 'UR':
                        case 'LF':
                            backEnd.sendMessage("Set " + heater.bank + " OnPercent 0");
                            break;
                        case 'LR':
                            backEnd.sendMessage("Set " + heater.bank + " OnPercent 50");
                        }
                    } else {
                        backEnd.sendMessage("Set " + heater.bank + " OnPercent 101");
                    }
                }
            }
        }
    }
}
