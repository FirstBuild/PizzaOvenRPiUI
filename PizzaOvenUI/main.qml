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

    property int currentTemp: 80
    property int targetTemp: 725
    property int cookTime: 20
    property int finalCheckTime: cookTime * 0.9
    property int currentTime: 0
    property bool halfTimeRotate: true
    property int powerSwitch: 0
    property int dlb: 0
    property bool demoModeIsActive: true
    property color appBackgroundColor: "black"
    property color appForegroundColor: "white"
    property string gearIconSource: "Gear-Icon-white.svg"
    property Item screenBookmark
    property bool immediateTransitions: true

    property int screenWidth: 559
    property int screenHeight: 355
    property int screenOffsetX: 60
    property int screenOffsetY: 25

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
        default:
            console.log("Unknown message received: " + JSON.parse(msg));
            break
        }
    }

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
            initialItem: Qt.resolvedUrl("Screen_Off.qml")
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

