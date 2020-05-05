import QtQuick 2.3
import QtWebSockets 1.0

Item {

    // The reset line is active high on the Pi and active low on the control board.
    property bool resetLineState: false

    function start() {
        webSocketConnectionTimer.start();
    }

    function sendMessage(msg) {
        if (socket.status == WebSocket.Open) {
            socket.sendTextMessage(msg);
        }
    }

    function checkDifferentials() {
        if (upperFrontRelayParametersReceived &&
                upperRearRelayParametersReceived &&
                lowerFrontRelayParametersReceived &&
                lowerRearRelayParametersReceived) {
            if (Math.abs(upperFront.setTemp - upperRear.setTemp) > 500) {
                utility.setUpperTemps(upperFront.setTemp);
            }
            if (Math.abs(lowerFront.setTemp - lowerRear.setTemp) > 250) {
                utility.setLowerTemps(lowerFront.setTemp);
            }
        }
    }

    property bool upperFrontRelayParametersReceived: false
    property bool upperRearRelayParametersReceived: false
    property bool lowerFrontRelayParametersReceived: false
    property bool lowerRearRelayParametersReceived: false

    WebSocket {
        id: socket
        url: "ws://localhost:8080"
        onTextMessageReceived: {
            //            console.log("Received message: " + message);
            handleWebSocketMessage(message);
        }
        onStatusChanged: if (socket.status == WebSocket.Error) {
                             //                             console.log("Error: " + socket.errorString)
                             webSocketConnectionTimer.start();
                         } else if (socket.status == WebSocket.Open) {
                             socket.sendTextMessage("Hello World")
                             sendMessage("Get UF");
                             sendMessage("Get LF");
                             if (rootWindow.originalConfiguration) {
                                sendMessage("Get UR");
                                sendMessage("Get LR");
                             }
                         } else if (socket.status == WebSocket.Closed) {
                             //                             console.log("Socket closed");
                             webSocketConnectionTimer.start();
                         }
        active: false
    }

    WebSocket {
        id: secureWebSocket
        url: "wss://localhost"
        onTextMessageReceived: {
            console.log("Received secure message: " + message);
        }
        onStatusChanged: if (secureWebSocket.status == WebSocket.Error) {
                             //                             console.log("Error: " + secureWebSocket.errorString)
                         } else if (secureWebSocket.status == WebSocket.Open) {
                             secureWebSocket.sendTextMessage("Hello Secure World")
                         } else if (secureWebSocket.status == WebSocket.Closed) {
                             console.log("Secure socket closed");
                         }
        active: false
    }

    Timer {
        id: webSocketConnectionTimer
        interval: 1000; running: false; repeat: true
        onTriggered: {
            switch(socket.status) {
            case WebSocket.Closed:
                console.log("Web socket is closed.");
                socket.active = false;
                socket.active = true;
                break;
            case WebSocket.Connecting:
                console.log("Web socket is connecting.");
                break;
            case WebSocket.Open:
                webSocketConnectionTimer.stop();
                wifiDataRequestor.start();
                break;
            case WebSocket.Closing:
                console.log("Web socket is closing.");
                break;
            case WebSocket.Error:
                //                console.log("Web socket is error.");
                socket.active = false;
                socket.active = true;
                break;
            }
        }
    }

    readonly property int commFailResetCount: 3
    property int commFailCount: commFailResetCount
    Timer {
        id: commPresentTimer
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            if (commFailCount > 0) commFailCount--;
            controlBoardCommsFailed = commFailCount == 0;
        }
    }

    WifiDataRequestor {
        id: wifiDataRequestor
    }

    function recordFailTemps() {
        var banks = [upperFront, upperRear, lowerFront, lowerRear];
        banks.map(function(bank) {
            if (bank.currentTemp > bank.failTemp) bank.failTemp = bank.currentTemp;
        });
    }

    function handleWebSocketMessage(_msg) {
        var  msg = JSON.parse(_msg);
        switch (msg.id){
        case "Temp":
            if (msg.data.UF){
                upperFront.currentTemp = msg.data.UF;
                commFailCount = commFailResetCount;
            }
            if (msg.data.UR){
                upperRear.currentTemp = msg.data.UR;
                commFailCount = commFailResetCount;
            }
            if (msg.data.LF){
                lowerFront.currentTemp = msg.data.LF;
                commFailCount = commFailResetCount;
            }
            if (msg.data.LR){
                lowerRear.currentTemp = msg.data.LR;
                commFailCount = commFailResetCount;
            }
            break;
        case "Reset":
            if (msg.data.pin) {
                if (msg.data.pin == 1) {
                    resetLineState = true;
                } else {
                    resetLineState = true;
                }
            }
            break;
        case "SetTemp":
            console.log("Got a set temp message: " + _msg);
            break;
        case "CookTime":
            console.log("Got a cook time message: " + _msg);
            break;
        case "Power":
            //console.log("Power message: " + JSON.stringify(msg));
            if (msg.data.ac) {
                acPowerIsPresent = msg.data.ac*1;
            }
            if (msg.data.powerSwitch && msg.data.l2DLB) {
                dlb = msg.data.l2DLB*1;
                powerSwitch = msg.data.powerSwitch*1;
            }
            if (msg.data.tco) {
                tco = msg.data.tco*1;
            }
            break;
        case "RelayParameters":
            console.log("Received relay parameters: " + _msg);
            if (msg.data) {
                if (msg.data.relay && msg.data.onTemp && msg.data.offTemp && msg.data.onPercent && msg.data.offPercent) {
                    switch(msg.data.relay) {
                    case "UF":
                        console.log("Setting the data for UF.");
                        upperFront.setTemp = (parseInt(msg.data.onTemp) + parseInt(msg.data.offTemp)) / 2;
                        upperFront.onPercent = parseInt(msg.data.onPercent);
                        upperFront.offPercent = parseInt(msg.data.offPercent);
                        upperFrontRelayParametersReceived = true;
                        break;
                    case "UR":
                        console.log("Setting the data for UR.");
                        upperRear.setTemp = (parseInt(msg.data.onTemp) + parseInt(msg.data.offTemp)) / 2;
                        upperRear.onPercent = parseInt(msg.data.onPercent);
                        upperRear.offPercent = parseInt(msg.data.offPercent);
                        upperRearRelayParametersReceived = true;
                        break;
                    case "LF":
                        console.log("Setting the data for LF.");
                        lowerFront.setTemp = (parseInt(msg.data.onTemp) + parseInt(msg.data.offTemp)) / 2;
                        lowerFront.onPercent = parseInt(msg.data.onPercent);
                        lowerFront.offPercent = parseInt(msg.data.offPercent);
                        lowerFront.setTemp = lowerFront.setTemp;
                        lowerFrontRelayParametersReceived = true;
                        break;
                    case "LR":
                        console.log("Setting the data for LR.");
                        lowerRear.setTemp = (parseInt(msg.data.onTemp) + parseInt(msg.data.offTemp)) / 2;
                        lowerRear.onPercent = parseInt(msg.data.onPercent);
                        lowerRear.offPercent = parseInt(msg.data.offPercent);
                        lowerRearRelayParametersReceived = true;
                        break;
                    }
                }
            }
            break;
        case "OvenState":
            ovenState = msg.data;
            console.log("Oven state message: " + ovenState);
            if (stackView.currentItem.handleOvenStateMsg)
            {
                stackView.currentItem.handleOvenStateMsg(ovenState);
            }

            break;
        case "PidDutyCycles":
            if(msg.data.UF) upperFront.elementDutyCycle = msg.data.UF;
            if(msg.data.UR) upperRear.elementDutyCycle = msg.data.UR;
            if(msg.data.LF) lowerFront.elementDutyCycle = msg.data.LF;
            if(msg.data.LR) lowerRear.elementDutyCycle = msg.data.LR;
            break;
        case "RelayStates":
            if(msg.data.UF) upperFront.elementRelay = msg.data.UF;
            if(msg.data.UR) upperRear.elementRelay = msg.data.UR;
            if(msg.data.LF) lowerFront.elementRelay = msg.data.LF;
            if(msg.data.LR) lowerRear.elementRelay = msg.data.LR;
            break;
        case "Failure":
            recordFailTemps();
            failures.logFailure(msg.data.event);
            callServiceFailure = true;
            checkDifferentials();
            break;
        case "Warning":
            failures.logFailure(msg.data.event);
            break;
        case "Door":
            doorStatus = msg.data.Status;
            doorCount = msg.data.Count;
            break;
        case "ControlVersion":
            controlVersion = msg.data.ovenFirmwareVersion + "." + msg.data.ovenFirmwareBugfixVersion;
            break;
        case "BackendVersion":
            backendVersion = msg.data.backendVersion;
            break;
        case "InterfaceVersion":
            interfaceVersion = msg.data.interfaceVersion;
            break;
        case "ControlBoardProgrammingState":
            console.log("Control board programming state: " + msg.data.state);
            if (msg.data.state === "idle") {
                controlBoardProgrammingInProgress = false;
            }
            if (msg.data.state === "programming") {
                controlBoardProgrammingInProgress = true;
            }
            break;
        case "WifiMacAddress":
            wifiMacId = msg.data;
            break;
        case "WifiConnectionState":
            wifiConnectionState = msg.data;
            break;
        case "WifiSsid":
            wifiSsid = msg.data;
            break;
        case "WifiPassphrase":
            wifiPassphrase = msg.data;
            break;
        case "RequestTempDisplayUnits":
            sendMessage("TempDisplayUnitsResponse id " + msg.data.id + " units " + (tempDisplayInF ? 0 : 1));
            break;
        case "WriteTempDisplayUnits":
            if (msg.data.units && msg.data.units < 2) {
                tempDisplayInF = msg.data.units == 0 ? 1 : 0;
                appSettings.tempDisplayInF = tempDisplayInF;
                sendMessage("WriteTempDisplayUnitsResponse id " + msg.data.id + " result success");
            } else {
                console.log("Got a message to set the temp display units, but request is invalid: " + JSON.stringify(msg.data));
                sendMessage("WriteTempDisplayUnitsResponse id " + msg.data.id + " result failure");
            }
            break;
        case "RequestDisplayedTemps":
            sendMessage("DisplayedTempsResponse id " + msg.data.id + " dome " + rootWindow.displayedDomeTemp + " stone " + rootWindow.displayedStoneTemp);
            break;
        case "RequestVolumeLevel": {
            var volumeResponse = "VolumeLevelResponse id " + msg.data.id + " units ";
            console.log("Received a request for the volume level." + JSON.stringify(msg));
            switch (volumeSetting) {
            case 7:
                volumeResponse += "1";
                break;
            case 8:
                volumeResponse += "2";
                break;
            case 9:
                volumeResponse += "3";
                break;
            default:
                volumeResponse += "0";
                break;
            }
            console.log("Sending response: " + volumeResponse);
            sendMessage(volumeResponse);
        }
            break;
        case "WriteVolumeLevel":
            if (msg.data.level && msg.data.level>=0 && msg.data.level<=3) {
                var level = [0, 7, 8, 9];
                volumeSetting = level[msg.data.level];
                appSettings.volumeSetting = volumeSetting;
                sendMessage("WriteVolumeLevelResponse id " + msg.data.id + " result success");
            } else {
                console.log("Got a message to set the volume level, but request is invalid: " + JSON.stringify(msg.data));
                sendMessage("WriteVolumeLevelResponse id " + msg.data.id + " result failure");
            }
            break;
        case "DoorLatchState":
            console.log("Latch state is " + msg.data);
            rootWindow.doorLatchState = msg.data == 1 ? 1 : 0;
            break;
        case "FanSpeedSettings":
            console.log("Fan speed settings received");
            if (msg.data.preheat) {
                console.log("Preheat fan speed = " + msg.data.preheat);
                preheatFanSetting = msg.data.preheat;
            }
            if (msg.data.cooking) {
                console.log("Cooking fan speed = " + msg.data.cooking);
                cookingFanSetting = msg.data.cooking;
            }
            break;
        case "DomeState":
            if (msg.data == "Off") {
                rootWindow.domeState.actual = false;
            } else {
                rootWindow.domeState.actual = true;
            }
            break;
        case "RequestTimerSetting":
            sendMessage("TimerSettingResponse id " + msg.data.id + " time " + cookTime);
            break;
        case "WriteTimerSetting":
            if (msg.data.time && msg.data.time>=0 && msg.data.time<=65535) {
                cookTime = msg.data.time;
                sendMessage("WriteTimerSettingResponse id " + msg.data.id + " result success");
                utility.findPizzaTypeFromSettings();
            } else {
                console.log("Got a message to set the timer setting, but request is invalid: " + JSON.stringify(msg.data));
                sendMessage("WriteTimerSettingResponse id " + msg.data.id + " result failure");
            }
            break;
        case "RequestTimerState":
            console.log("Got RequestTimerState");
            if (cookTimer.running) {
                sendMessage("TimerStateResponse id " + msg.data.id + " state 1");
            } else if (cookTimer.value < 100.0) {
                sendMessage("TimerStateResponse id " + msg.data.id + " state 0");
            } else {
                sendMessage("TimerStateResponse id " + msg.data.id + " state 2");
            }
            break;
        case "WriteTimerState":
            function handleWriteTimerState(msg) {
                console.log("Got WriteTimerState and ovenState is " + ovenState);
                console.log("The cook timer running state is " + cookTimer.running);
                console.log("The cook timer paused state is " + cookTimer.paused);
                console.log("The timer value is " + cookTimer.value);
                console.log("Type of state is " + typeof(msg.data.state));
                /*
                  Before running, running is false, paused is false, and value is zero.
                  When running, running is true, paused is false, and value is not zero.
                  When paused, running is faluse, paused is true, and value is not zero.
                  When resumed, running is true, paused is false, and value is not zero.
                  When expired, running is false, paused is false, and value is 100.
                  */
                var state = parseInt(msg.data.state);
                if (state>=0 && state<=2) {
                    sendMessage("WriteTimerStateResponse id " + msg.data.id + " result success");
                    switch(state) {
                    case 0:
                        console.log("Stopping the cook timer.");
                        cookTimer.stop();
                        break;
                    case 1:
                        if (!cookTimer.running && !cookTimer.paused) {
                            console.log("Starting the cook timer.");
                            cookTimer.start();
                        } else if (!cookTimer.running && cookTimer.paused) {
                            console.log("Resuming the cook timer.");
                            cookTimer.resume();
                        } else {
                            console.log("Doing nothing for the cook timer.");
                        }
                        break;
                    case 2:
                        if (cookTimer.running) {
                            console.log("Pausing the cook timer.");
                            cookTimer.pause();
                        } else {
                            console.log("Doing nothing for the cook timer.");
                        }
                        break;
                    }
                } else {
                    console.log("Cook timer state is out of range: " + msg.data.state);
                    sendMessage("WriteTimerStateResponse id " + msg.data.id + " result failure");
                }
            }
            if (msg.data.state && ovenState=="Cooking") {
                handleWriteTimerState(msg);
            } else {
                console.log("Got a message to set the timer state, but request is invalid: " + JSON.stringify(msg.data));
                sendMessage("WriteTimerStateResponse id " + msg.data.id + " result failure");
            }
            break;
        case "RequestTimeRemaining":
            sendMessage("TimeRemainingResponse id " + msg.data.id + " time " + cookTimer.timeRemaining);
            break;
        case "RequestReminderSettings":
            sendMessage("ReminderSettingsResponse id " + msg.data.id +
                        " rotatePizza " + (halfTimeRotateAlertEnabled ? 1 : 0) +
                        " finalCheck " + (finalCheckAlertEnabled ? 1 : 0) +
                        " done " + (pizzaDoneAlertEnabled ? 1 : 0)
                        );
            break;
        case "WriteReminderSettings":
            if (msg.data && msg.data.rotatePizza && msg.data.finalCheck && msg.data.done &&
                    (msg.data.rotatePizza === "0" || msg.data.rotatePizza === "1") &&
                    (msg.data.finalCheck === "0" || msg.data.finalCheck === "1") &&
                    (msg.data.done === "0" || msg.data.done === "1")) {
                halfTimeRotateAlertEnabled = msg.data.rotatePizza === "1";
                finalCheckAlertEnabled = msg.data.finalCheck === "1";
                pizzaDoneAlertEnabled = msg.data.done === "1";
                appSettings.rotatePizzaAlertEnabled = halfTimeRotateAlertEnabled;
                appSettings.finalCheckAlertEnabled = finalCheckAlertEnabled;
                appSettings.doneAlertEnabled = rootWindow.pizzaDoneAlertEnabled;
                sendMessage("WriteReminderSettingsResponse id " + msg.data.id + " result success");
            } else {
                console.log("Got a message to set the reminder settings, but the request is invalid: " + JSON.stringify(msg.data));
                sendMessage("WriteReminderSettingsResponse id " + msg.data.id + " result failure");
            }
            utility.updateReminderSettingsOnBackend();
            break;
        case "RequestPizzaStyle":
            if (foodNameString == "CUSTOM") {
                sendMessage("PizzaStyleResponse id " + msg.data.id + " style 4");
            } else {
                sendMessage("PizzaStyleResponse id " + msg.data.id + " style " + foodIndex);
            }
            break;
        case "WritePizzaStyle":
            function handleWritePizzaStyle(msg) {
                var style = parseInt(msg.data.style);
                var menuItems = menuSettings.json.menuItems;

                if (style >= 0 && style <= menuItems.length - 1) {
                    foodIndex = style;
                    var settings = menuItems[foodIndex];
                    backEnd.sendMessage("StopOven ");
                    autoShutoff.stop();
                    preheatComplete = false;
                    appSettings.backlightOff = false;
                    utility.setUpperTemps(settings.domeTemp)
                    utility.setLowerTemps(settings.stoneTemp)
                    cookTime = settings.cookTime;
                    backEnd.sendMessage("CookTime " + cookTime);
                    finalCheckTime = settings.finalCheckTime
                    console.log("Setting pizza type to index " + foodIndex);
                    console.log("Food name is set to " + foodNameString);
                    sendMessage("WritePizzaStyleResponse id " + msg.data.id + " result success");
                    forceScreenTransition(Qt.resolvedUrl("Screen_AwaitStart.qml"));
                } else {
                    console.log("Got a message to set the pizza style, but the index is out of range: " + JSON.stringify(msg.data));
                    sendMessage("WritePizzaStyleResponse id " + msg.data.id + " result failure");
                }
            }
            if (msg.data && msg.data.style) {
                handleWritePizzaStyle(msg);
            } else {
                console.log("Got a message to set the pizza style, but the request is invalid: " + JSON.stringify(msg.data));
                sendMessage("WritePizzaStyleResponse id " + msg.data.id + " result failure");
            }
            break;
        case "WriteSetpoints":
            if (msg.data.UF && msg.data.LF) {
                if (parseInt(msg.data.UF) <= upperMaxTemp && parseInt(msg.data.LF) <= lowerMaxTemp) {
                    utility.setLowerTemps(parseInt(msg.data.LF));
                    utility.setUpperTemps(parseInt(msg.data.UF));
                    utility.findPizzaTypeFromSettings();
                    console.log("Setpoints were written and the current machine state is " + ovenState);
                    switch(ovenState) {
                        case "Standby":
                        case "Cooldown":
                            console.log("Transitioning to the start screen.");
                            autoShutoff.stop();
                            preheatComplete = false;
                            appSettings.backlightOff = false;
                            forceScreenTransition(Qt.resolvedUrl("Screen_AwaitStart.qml"));
                            break;
                        default:
                            console.log("We are already running, so don't return to the start screen.");
                    }

                }
            }
            break;
        case "WriteDomeState":
            console.log("Got WriteDomeState and data is: " + JSON.stringify(msg.data));
            if (msg.data.state === "1") {
                console.log("Setting dome start on.");
                rootWindow.domeState.set(true);
            }
            if (msg.data.state === "0") {
                rootWindow.domeState.set(false);
                console.log("Setting dome start off.");
            }
            break;
        case "RequestRotatePizzaState":
            sendMessage("RotatePizzaStateResponse id " + msg.data.id +
                        " state " + (halfTimeRotateAlertOccurred ? 1 : 0)
                        );
            break;
        case "RequestFinalCheckState":
            sendMessage("FinalCheckStateResponse id " + msg.data.id +
                        " state " + (finalCheckAlertOccurred ? 1 : 0)
                        );
            break;
        case "RequestPizzaDoneState":
            sendMessage("PizzaDoneStateResponse id " + msg.data.id +
                        " state " + (pizzaDoneAlertOccurred ? 1 : 0)
                        );
            break;
        default:
            console.log("Unknown message received: " + _msg);
            break
        }
    }
}
