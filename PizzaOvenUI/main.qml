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
    property int targetTemp: 725
    property int cookTime: 20
    property int currentTime: 0
    property int finalCheckTime: cookTime * 0.9
    property bool halfTimeRotate: true
    property int powerSwitch: 0
    property int dlb: 0

    // Things related to how the app looks and operates
    property bool demoModeIsActive: false
    property bool developmentModeIsActive: true
    property color appBackgroundColor: "black"
    property color appForegroundColor: "white"
    property string gearIconSource: "Gear-Icon-white.svg"
    property Item screenBookmark
    property bool immediateTransitions: true
    property int screenWidth: 559
    property int screenHeight: 355
    property int screenOffsetX: 60
    property int screenOffsetY: 25

    // Parameters of the oven
    property int upperFrontCurrentTemp: 100
    property int upperFrontSetTemp: 1250
    property int upperFrontDutyCycle: 10
    property int upperFrontRelay: 0
    property int upperRearCurrentTemp: 200
    property int upperRearSetTemp: 1150
    property int upperRearDutyCycle: 20
    property int upperRearRelay: 0
    property int lowerFrontCurrentTemp: 300
    property int lowerFrontSetTemp: 650
    property int lowerFrontDutyCycle: 30
    property int lowerFrontRelay: 0
    property int lowerRearCurrentTemp: 400
    property int lowerRearSetTemp: 600
    property int lowerRearDutyCycle: 40
    property int lowerRearRelay: 0

    property int upperFrontOnPercent: 0
    property int upperFrontOffPercent: 49
    property int upperRearOnPercent: 51
    property int upperRearOffPercent: 100
    property int lowerFrontOnPercent: 0
    property int lowerFrontOffPercent: 49
    property int lowerRearOnPercent: 51
    property int lowerRearOffPercent: 100
    property int upperElementTemperatureDeadband: 100
    property int lowerElementTemperatureDeadband: 50

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
                currentTemp = (msg.data.LF*1 + msg.data.LR*1)/2;
                console.log("Current temp: " + currentTemp);
                upperFrontCurrentTemp = msg.data.UF;
                upperRearCurrentTemp = msg.data.UR;
                lowerFrontCurrentTemp = msg.data.LF;
                lowerRearCurrentTemp = msg.data.LR;
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

            if (developmentModeIsActive) return;

            switch(oldState) {
            case 00: // off
                switch(newState) {
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
                    forceScreenTransition(Qt.resolvedUrl("Screen_Off.qml"));
                    break;
                case 10:
                    forceScreenTransition(Qt.resolvedUrl("Screen_Cooldown.qml"));
                    break;
                }
                break;
            case 10: // cooling
                switch(newState) {
                case 00:
                    forceScreenTransition(Qt.resolvedUrl("Screen_Off.qml"));
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
                    forceScreenTransition(Qt.resolvedUrl("Screen_Off.qml"));
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
                        upperFrontSetTemp = (parseInt(msg.data.onTemp) + parseInt(msg.data.offTemp)) / 2;
                        upperFrontOnPercent = parseInt(msg.data.onPercent);
                        upperFrontOffPercent = parseInt(msg.data.offPercent);
                        break;
                    case "UR":
                        console.log("Setting the data for UR.");
                        upperRearSetTemp = (parseInt(msg.data.onTemp) + parseInt(msg.data.offTemp)) / 2;
                        upperRearOnPercent = parseInt(msg.data.onPercent);
                        upperRearOffPercent = parseInt(msg.data.offPercent);
                        break;
                    case "LF":
                        console.log("Setting the data for LF.");
                        lowerFrontSetTemp = (parseInt(msg.data.onTemp) + parseInt(msg.data.offTemp)) / 2;
                        lowerFrontOnPercent = parseInt(msg.data.onPercent);
                        lowerFrontOffPercent = parseInt(msg.data.offPercent);
                        break;
                    case "LR":
                        console.log("Setting the data for LR.");
                        lowerRearSetTemp = (parseInt(msg.data.onTemp) + parseInt(msg.data.offTemp)) / 2;
                        lowerRearOnPercent = parseInt(msg.data.onPercent);
                        lowerRearOffPercent = parseInt(msg.data.offPercent);
                        break;
                    }
                }
            }
            break;
        case "OvenState":
            ovenState = msg.data;
            break;
        case "PidDutyCycles":
            upperFrontDutyCycle = msg.data.UF;
            upperRearDutyCycle = msg.data.UR;
            lowerFrontDutyCycle = msg.data.LF;
            lowerRearDutyCycle = msg.data.LR;
            break;
        case "RelayStates":
            upperFrontRelay = msg.data.UF;
            upperRearRelay = msg.data.UR;
            lowerFrontRelay = msg.data.LF;
            lowerRearRelay = msg.data.LR;
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
        border.width: 1
        StackView {
            id: stackView
            width: parent.width
            height: parent.height
            anchors.fill: parent
            focus: true
            initialItem: Qt.resolvedUrl("Screen_Development.qml")
//            initialItem: Qt.resolvedUrl("TempEntryWithKeys.qml")
//            initialItem: Qt.resolvedUrl("Keyboard.qml")
//            initialItem: Qt.resolvedUrl("Screen_Off.qml")
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
            Component.onCompleted: {
//                if (demoModeIsActive) {
//                    console.log("Stack view onCompleted received.");
//                    stackView.push({item: Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
//                }
            }
        }
        Component.onCompleted: {
            console.log("Rectangle is loaded.");
            if (!demoModeIsActive) {
                console.log("Starting web socket connection timer.");
                webSocketConnectionTimer.start();
            }

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

