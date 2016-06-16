import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtWebSockets 1.0

Window {
    id: rootWindow
    visible: true
    width: 800
    height: 480
    color: appBackgroundColor

    FontLoader { id: localFont; source: "fonts/FreeSans.ttf"; name: "FreeSans" }

    // Things related to the cooking of the oven
    property int currentTemp: 80
//    property int cookTime: 2 * 60
    property int cookTime: 30
    property int currentTime: 0
    property int finalCheckTime: cookTime * 0.9
    property bool halfTimeRotate: true
    property int powerSwitch: 0
    property int dlb: 0
    property int upperTempDifferential: 100
    property int lowerTempDifferential: 50
    property int upperMaxTemp: 1250
    property int lowerMaxTemp: 800
    property int doorStatus: 0
    property int doorCount: 0

    // Things related to how the app looks and operates
    property bool demoModeIsActive: true
    property bool developmentModeIsActive: false
    property bool twoTempEntryModeIsActive: true
    property color appBackgroundColor: "black"
    property color appForegroundColor: "white"
    property string gearIconSource: "Gear-Icon-white.svg"
    property Item screenBookmark
    property bool immediateTransitions: true
    property int screenWidth: 559
    property int screenHeight: 355
    property int screenOffsetX: appSettings.screenOffsetX
    property int screenOffsetY: appSettings.screenOffsetY
    property string timeOfDay: "10:04"
    property int smallTextSize: 24
    property int bigTextSize: 42

    // Parameters of the oven
    HeaterBankData {
        id: upperFront
        bank: "UF"
        currentTemp: 100
        setTemp: 1250
        elementDutyCycle: 10
        elementRelay: 0
        onPercent: 0
        offPercent: 90
        temperatureDeadband: 100
        maxTemp: upperMaxTemp
    }
    HeaterBankData {
        id: upperRear
        bank: "UR"
        currentTemp: 100
        setTemp: 1150
        elementDutyCycle: 10
        elementRelay: 0
        onPercent: 10
        offPercent: 90
        temperatureDeadband: 100
        maxTemp: upperMaxTemp
    }
    HeaterBankData {
        id: lowerFront
        bank: "LF"
        currentTemp: 100
        setTemp: 650
        elementDutyCycle: 10
        elementRelay: 0
        onPercent: 0
        offPercent: 49
//        temperatureDeadband: 50
        temperatureDeadband: 10
        maxTemp: lowerMaxTemp
    }
    HeaterBankData {
        id: lowerRear
        bank: "LR"
        currentTemp: 100
        setTemp: 625
        elementDutyCycle: 10
        elementRelay: 0
        onPercent: 51
        offPercent: 100
//        temperatureDeadband: 50
        temperatureDeadband: 10
        maxTemp: lowerMaxTemp
    }


    property string ovenState: "Standby"

    function timeToString(t) {
        var first = Math.floor(t/60).toString()
        if (first.length == 1) first = "0" + first
        var second = Math.floor(t%60).toString()
        if (second.length == 1) second = "0" + second
        return first + ":" + second
    }

    function tempToString(t) {
        return t.toFixed(0).toString() + String.fromCharCode(8457)
    }

    function sendWebSocketMessage(msg) {
        if (socket.status == WebSocket.Open) {
            socket.sendTextMessage(msg);
        }
    }

    function forceScreenTransition(newScreen) {
        if (stackView.currentItem.cleanUpOnExit)
        {
            console.log("Calling the exit function.");
            stackView.currentItem.cleanUpOnExit();
        } else {
            console.log("There is no exit function to call.");
        }
        stackView.clear();
        stackView.push({item: newScreen, immediate:immediateTransitions});
    }

    function handleWebSocketMessage(_msg) {
        var  msg = JSON.parse(_msg);
        switch (msg.id){
        case "Temp":
            if (msg.data.LF && msg.data.LR){
                currentTemp = msg.data.LF;
                console.log("Current temp: " + currentTemp);
                upperFront.currentTemp = msg.data.UF;
                upperRear.currentTemp = msg.data.UR;
                lowerFront.currentTemp = msg.data.LF;
                lowerRear.currentTemp = msg.data.LR;
                console.log("Development mode is " + developmentModeIsActive)
            } else {
                console.log("Temp data missing.");
            }
            break;
        case "SetTemp":
            console.log("Got a set temp message: " + _msg);
            break;
        case "CookTime":
            console.log("Got a cook time message: " + _msg);
            break;
        case "Power":
            var oldDlb = dlb;
            var oldPowerSwitch = powerSwitch;

            if (msg.data.powerSwitch && msg.data.l2DLB) {
                dlb = msg.data.l2DLB*1;
                powerSwitch = msg.data.powerSwitch*1;
            }

            var oldState = oldPowerSwitch + (oldDlb * 10);
            var newState = powerSwitch + (dlb * 10);

            if (oldDlb != dlb) {
                console.log("DLB state is now " + dlb);
            }
            if (oldPowerSwitch != powerSwitch) {
                console.log("Power switch state is now " + powerSwitch);
            }

            if (developmentModeIsActive) {
                return;
            }

            switch(oldState) {
            case 00: // off
                switch(newState) {
                case 00:
                    if (ovenState == "Standby") {
                        forceScreenTransition(Qt.resolvedUrl("Screen_Off.qml"));
                    }
                    if (ovenState == "Cooldown") {
                        forceScreenTransition(Qt.resolvedUrl("Screen_Cooldown.qml"));
                    }
                    break;
                case 01:
                    forceScreenTransition(Qt.resolvedUrl("Screen_MainMenu.qml"));
                    break;
                case 10:
                    forceScreenTransition(Qt.resolvedUrl("Screen_Cooldown.qml"));
                    break;
                case 11:
                    forceScreenTransition(Qt.resolvedUrl("Screen_MainMenu.qml"));
                    break;
                }
                break;
            case 01: // powered on
                switch(newState) {
                case 00:
                    if (ovenState == "Cooldown") {
                        forceScreenTransition(Qt.resolvedUrl("Screen_Cooldown.qml"));
                    } else {
                        forceScreenTransition(Qt.resolvedUrl("Screen_Off.qml"));
                    }
                    break;
                case 10:
                    forceScreenTransition(Qt.resolvedUrl("Screen_Cooldown.qml"));
                    break;
                }
                break;
            case 10: // cooling
                switch(newState) {
                case 00:
                    if (ovenState == "Cooldown") {
                        forceScreenTransition(Qt.resolvedUrl("Screen_Cooldown.qml"));
                    } else {
                        forceScreenTransition(Qt.resolvedUrl("Screen_Off.qml"));
                    }
                    break;
                case 01:
                    forceScreenTransition(Qt.resolvedUrl("Screen_MainMenu.qml"));
                    break;
                case 11:
                    forceScreenTransition(Qt.resolvedUrl("Screen_MainMenu.qml"));
                    break;
                }
                break;
            case 11: // cooking or other
                switch(newState) {
                case 00:
                    if (ovenState == "Cooldown") {
                        forceScreenTransition(Qt.resolvedUrl("Screen_Cooldown.qml"));
                    } else {
                        forceScreenTransition(Qt.resolvedUrl("Screen_Off.qml"));
                    }
                    break;
                case 01:
                    forceScreenTransition(Qt.resolvedUrl("Screen_MainMenu.qml"));
                    break;
                case 10:
                    forceScreenTransition(Qt.resolvedUrl("Screen_Cooldown.qml"));
                    break;
                }
                break;
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
                        break;
                    case "UR":
                        console.log("Setting the data for UR.");
                        upperRear.setTemp = (parseInt(msg.data.onTemp) + parseInt(msg.data.offTemp)) / 2;
                        upperRear.onPercent = parseInt(msg.data.onPercent);
                        upperRear.offPercent = parseInt(msg.data.offPercent);
                        break;
                    case "LF":
                        console.log("Setting the data for LF.");
                        lowerFront.setTemp = (parseInt(msg.data.onTemp) + parseInt(msg.data.offTemp)) / 2;
                        lowerFront.onPercent = parseInt(msg.data.onPercent);
                        lowerFront.offPercent = parseInt(msg.data.offPercent);
                        lowerFront.setTemp = lowerFront.setTemp;
                        break;
                    case "LR":
                        console.log("Setting the data for LR.");
                        lowerRear.setTemp = (parseInt(msg.data.onTemp) + parseInt(msg.data.offTemp)) / 2;
                        lowerRear.onPercent = parseInt(msg.data.onPercent);
                        lowerRear.offPercent = parseInt(msg.data.offPercent);
                        break;
                    }
                }
            }
            break;
        case "OvenState":
            ovenState = msg.data;
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
        case "Door":
            doorStatus = msg.data.Status;
            doorCount = msg.data.Count;
            console.log("Got a door message: " + JSON.stringify(msg));
            break;
        default:
            console.log("Unknown message received: " + _msg);
            break
        }
    }

    // Define the active screen area.  All screens live here.
    Rectangle {
        id: screenStackContainer
        color: appBackgroundColor
        width: screenWidth
        height: screenHeight
        x: screenOffsetX
        y: screenOffsetY
        border.color: "red"
        border.width: 0
        StackView {
            id: stackView
            width: parent.width
            height: parent.height
            anchors.fill: parent
            focus: true
//            initialItem: Qt.resolvedUrl("Screen_Development.qml")
//            initialItem: Qt.resolvedUrl("TempEntryWithKeys.qml")
//            initialItem: Qt.resolvedUrl("Keyboard.qml")
            initialItem: {
                if (appSettings.settingsInitialized) {
                    Qt.resolvedUrl("Screen_Off.qml");
                } else {
                    Qt.resolvedUrl("Screen_ShiftScreenPosition.qml");
                }
            }
//            initialItem: Qt.resolvedUrl("Screen_MainMenu.qml")
//            initialItem: Qt.resolvedUrl("Screen_Preheating.qml")
//            initialItem: Qt.resolvedUrl("Screen_AwaitStart.qml")
            onCurrentItemChanged: {
                if (currentItem) {
                    console.log("A new current item is current.");
                    if (currentItem.screenEntry) {
                        currentItem.screenEntry();
                    }
                }
            }
        }
        Component.onCompleted: {
            console.log("Rectangle is loaded.");
            console.log("Starting web socket connection timer.");
            webSocketConnectionTimer.start();
        }
    }

    WebSocket {
        id: socket
        url: "ws://localhost:8080"
        onTextMessageReceived: {
//            console.log("Received message: " + message);
            handleWebSocketMessage(message);
        }
        onStatusChanged: if (socket.status == WebSocket.Error) {
                             console.log("Error: " + socket.errorString)
                             webSocketConnectionTimer.start();
                         } else if (socket.status == WebSocket.Open) {
                             socket.sendTextMessage("Hello World")
                             sendWebSocketMessage("Get UF");
                             sendWebSocketMessage("Get UR");
                             sendWebSocketMessage("Get LF");
                             sendWebSocketMessage("Get LR");
                         } else if (socket.status == WebSocket.Closed) {
                             console.log("Socket closed");
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
                             console.log("Error: " + secureWebSocket.errorString)
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
                console.log("Web socket is error.");
                socket.active = false;
                socket.active = true;
                break;
            }
        }
    }

    Timer {
        id: timeOfDayClock
        interval: 1000; running: true; repeat: true
        onTriggered: {
            var now = new Date(Date.now() + appSettings.todOffset);
            var hours = now.getHours();
            if (hours > 12) hours -= 12;
            var mins = now.getMinutes();
            timeOfDay = hours + ":" + ((mins < 10) ? "0" : "") + mins;
        }
    }

    function setTimeOfDay(newTime) {
        var t = newTime.split(":");
        var newHours = t[0] * 3600 * 1000;
        var newSecs = t[1] * 60 * 1000;
        var newMillis = newHours + newSecs;

        var now = new Date();
        var hours = now.getHours();
        if (hours > 12) hours -= 12;
        var mins = now.getMinutes();
        var currentMillis = hours * 3600 * 1000 + mins * 60 * 1000;

        var offset = newMillis - currentMillis;

        appSettings.todOffset = offset;
    }

//    Button {
//        id: quitButton
//        x: 10
//        y: rootWindow.height - quitButton.height - 10
//        height: width
//        action: Action {
//            onTriggered: {
//                Qt.quit();
//            }
//        }
//        text: "Quit"
//    }
}

