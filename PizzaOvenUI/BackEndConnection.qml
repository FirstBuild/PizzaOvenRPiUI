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
                             sendMessage("Get UR");
                             sendMessage("Get LF");
                             sendMessage("Get LR");
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

    function handleWebSocketMessage(_msg) {
        var  msg = JSON.parse(_msg);
        switch (msg.id){
        case "Temp":
            if (msg.data.LF && msg.data.LR){
                upperFront.currentTemp = msg.data.UF;
                upperRear.currentTemp = msg.data.UR;
                lowerFront.currentTemp = msg.data.LF;
                lowerRear.currentTemp = msg.data.LR;
                commFailCount = commFailResetCount;
            } else {
                console.log("Temp data missing.");
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

            if (developmentModeIsActive) {
                forceScreenTransition(Qt.resolvedUrl("Screen_Development.qml"));
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
            if (stackView.currentItem.handleOvenStateMsg)
            {
                stackView.currentItem.handleOvenStateMsg(ovenState);
            }

            break;
        case "PidDutyCycles":
            upperFront.elementDutyCycle = msg.data.UF;
            upperRear.elementDutyCycle = msg.data.UR;
            lowerFront.elementDutyCycle = msg.data.LF;
            lowerRear.elementDutyCycle = msg.data.LR;
            break;
        case "RelayStates":
            upperFront.elementRelay = msg.data.UF;
            upperRear.elementRelay = msg.data.UR;
            lowerFront.elementRelay = msg.data.LF;
            lowerRear.elementRelay = msg.data.LR;
            break;
        case "Failure":
            callServiceFailure = true;
            checkDifferentials();
            break;
        case "Door":
            doorStatus = msg.data.Status;
            doorCount = msg.data.Count;
            //console.log("Got a door message: " + JSON.stringify(msg));
            break;
        case "ControlVersion":
            controlVersion = msg.data.ovenFirmwareVersion + "." + msg.data.ovenFirmwareBugfixVersion;
            //console.log("Version: " + controlVersion);
            break;
        case "BackendVersion":
            console.log("Backend Version: " + msg.data.backendVersion);
            backendVersion = msg.data.backendVersion;
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
        default:
            console.log("Unknown message received: " + _msg);
            break
        }
    }
}
