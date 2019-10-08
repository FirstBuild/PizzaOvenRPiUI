import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: thisScreen
    property string screenName: "Screen_TimeCycleTest"

    implicitHeight: screenHeight
    implicitWidth: screenWidth

    property int spacing: 10
    property int elementButtonWidth: screenWidth * 0.40 - spacing
    property int elementButtonHeight: 60
    property int textWidth: 100
    property int smallButtonWidth: ((thisScreen.width - thisScreen.spacing) / 3) - thisScreen.spacing
    property int smallButtonHeight: ((thisScreen.height - thisScreen.spacing) / 4) - thisScreen.spacing

    property int onTimeInterval: 3600
    property int offTimeInterval: 3600

    property bool testIsRunning: false

    function screenEntry() {
        console.log("Entering time cycle test screen");
        testIsRunning = false;
        appSettings.backlightOff = false;
    }

    function cleanUpOnExit() {
        console.log("Exiting time cycle test screen");
        testIsRunning = false;
        onTimeTimer.stop();
        offTimeTimer.stop();
        autoShutoff.stop();
        backEnd.sendMessage("StopOven ");
    }

    Rectangle {
        width: parent.width
        height: parent.height
        border.width: 1
        border.color: "red"
        color: appBackgroundColor
    }

    Text {
        id: header
        height: 50
        verticalAlignment: Text.AlignVCenter
        text: 'TIME CYCLE TEST'
        font.family: localFont.name
        font.pointSize: 17
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: appForegroundColor
    }

    function tempSettingClicked(heater) {
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
            if (tempEntry.value > heater.maxTemp) {
                sounds.alarmUrgent.play();
                messageDialog.dialogMessage = "Max temp is " + heater.maxTemp + "F";
                messageDialog.visible = true;
            } else {
                heater.setTemp = tempEntry.value;
                disconnectAndDisable();
                console.log("New heater set temp: " + heater.setTemp);
                var msg = "Set " + heater.bank + " SetPoint " +
                        (heater.setTemp - 0.5 * heater.temperatureDeadband) + " " +
                        (heater.setTemp + 0.5 * heater.temperatureDeadband);
                console.log("Trying to set: " + msg);
                backEnd.sendMessage("Set " + heater.bank + " SetPoint " +
                                     (heater.setTemp - 0.5 * heater.temperatureDeadband) + " " +
                                     (heater.setTemp + 0.5 * heater.temperatureDeadband));
            }
        }
        sounds.touch.play();
        tempEntry.value = heater.setTemp;
        tempEntry.dialogCanceled.connect(handleCanceled);
        tempEntry.dialogCompleted.connect(handleCompleted);
        tempEntry.header = heater.bank + " Setpoint Deg. F"
        tempEntry.visible = true;
        tempEntry.enabled = true;
    }

    function timeSettingClicked(timerInterval, name, callback) {
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
            if (callback) {
                callback(tempEntry.value)
            }
            disconnectAndDisable();
        }
        sounds.touch.play();
        tempEntry.value = timerInterval;
        tempEntry.dialogCanceled.connect(handleCanceled);
        tempEntry.dialogCompleted.connect(handleCompleted);
        tempEntry.header = name;
        tempEntry.visible = true;
        tempEntry.enabled = true;
    }

    Column {
        width: screenWidth
        y: header.y + header.height
        spacing: thisScreen.spacing

        Row {
            id: upperSettings
            spacing: thisScreen.spacing
            width: screenWidth

            Text {
                height: elementButtonHeight
                width: textWidth
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                text: 'Upper'
                font.family: localFont.name
                font.pointSize: 17
                color: appForegroundColor
            }

            TwoValueBox {
                id: tempBoxUF
                upperLabel: 'Front Current: '
                upperValue: upperFront.currentTemp
                lowerLabel: "      Set Temp: "
                lowerValue: upperFront.setTemp
                width: elementButtonWidth
                height: elementButtonHeight
                borderColor: (upperFront.elementRelay == 0) ? "blue" : "red"

                onClicked: {
                    tempSettingClicked(upperFront);
                }
            }

            TwoValueBox {
                id: tempBoxUR
                upperLabel: 'Rear Current: '
                upperValue: upperRear.currentTemp
                lowerLabel: '      Set Temp:'
                lowerValue: upperRear.setTemp
                width: elementButtonWidth
                height: elementButtonHeight
                borderColor: (upperRear.elementRelay == 0) ? "blue" : "red"
                onClicked: {
                    tempSettingClicked(upperRear);
                }
            }
        }

        Row {
            id: lowerSettings
            spacing: thisScreen.spacing
            width: screenWidth

            Text {
                height: elementButtonHeight
                width: textWidth
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                text: 'Lower'
                font.family: localFont.name
                font.pointSize: 17
                color: appForegroundColor
            }

            TwoValueBox {
                id: tempBoxLF
                upperLabel: 'Front Current: '
                upperValue: lowerFront.currentTemp
                lowerLabel: "      Set Temp: "
                lowerValue: lowerFront.setTemp
                width: elementButtonWidth
                height: elementButtonHeight
                borderColor: (lowerFront.elementRelay == 0) ? "blue" : "red"
                onClicked: {
                    tempSettingClicked(lowerFront);
                }
            }
            TwoValueBox {
                id: tempBoxLR
                upperLabel: 'Rear Current: '
                upperValue: lowerRear.currentTemp
                lowerLabel: "     Set Temp: "
                lowerValue: lowerRear.setTemp
                width: elementButtonWidth
                height: elementButtonHeight
                borderColor: (lowerRear.elementRelay == 0) ? "blue" : "red"
                onClicked: {
                    tempSettingClicked(lowerRear);
                }
            }
        }

        Row {
            id: timerSettings
            spacing: thisScreen.spacing
            width: screenWidth

            Text {
                height: elementButtonHeight
                width: textWidth
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                text: 'Timer'
                font.family: localFont.name
                font.pointSize: 17
                color: appForegroundColor
            }

            TwoValueBox {
                id: onTimeSetting
                upperLabel: '    On Time: '
                upperValue: onTimeInterval
                lowerLabel: 'Remaining: '
                lowerValue: onTimeTimer.timeRemaining.toFixed(0)
                width: elementButtonWidth
                height: elementButtonHeight
                borderColor: (!onTimeTimer.running) ? "blue" : "red"
                onClicked: {
                    function callback(value) {
                        onTimeInterval = value;
                    }
                    timeSettingClicked(onTimeInterval, "On Time", callback)
                }
            }
            TwoValueBox {
                id: offTimeSetting
                upperLabel: '    Off Time: '
                upperValue: offTimeInterval
                lowerLabel: 'Remaining: '
                lowerValue: offTimeTimer.timeRemaining.toFixed(0)
                width: elementButtonWidth
                height: elementButtonHeight
                borderColor: (!offTimeTimer.running) ? "blue" : "red"
                onClicked: {
                    function callback(value) {
                        offTimeInterval = value;
                    }
                    timeSettingClicked(offTimeInterval, "Off Time", callback)
                }
            }
        }

        MyButton {
            id: idStartStopButton
            text: testIsRunning ? 'Stop Test' : "Start Test"
            width: smallButtonWidth
            height: smallButtonHeight*.6
            borderWidth: 2
            borderColor: testIsRunning ? 'red' : 'green'
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                if (testIsRunning) {
                    backEnd.sendMessage("StopOven ");
                    onTimeTimer.stop()
                    offTimeTimer.stop()
                    autoShutoff.stop();
                } else {
                    if (powerSwitch == 1) {
                        backEnd.sendMessage("StartOven ");
                        rootWindow.domeState.set(true);
                        autoShutoff.start();
                        onTimeTimer.start();
                    }
                }
                testIsRunning = !testIsRunning;
            }
        }
    }

    GenericTimer {
        id: onTimeTimer
        interval: onTimeInterval
        onTimerExpired: {
            backEnd.sendMessage("StopOven ");
            autoShutoff.stop();
            offTimeTimer.start()
        }
    }

    GenericTimer {
        id: offTimeTimer
        interval: offTimeInterval
        onTimerExpired: {
            backEnd.sendMessage("StartOven ");
            autoShutoff.start();
            onTimeTimer.start();
        }
    }

    TempEntryWithKeys {
        id: tempEntry
        enabled: false
        visible: false
        z: 1
    }
}
