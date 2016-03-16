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
    color: "white"

    FontLoader { id: localFont; source: "fonts/FreeSans.ttf"; name: "FreeSans" }

    property int currentTemp: 80
    property int targetTemp: 725
    property int cookTime: 20
    property int currentTime: 0
    property bool demoModeIsActive: false

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

    function handleWebSocketMessage(msg) {
        var msgPart = msg.split(" ");
        if (msgPart.length > 0) {
            switch (msgPart[0]){
            case "Temp":
                if (msgPart.length >=2){
                    currentTemp = 0 + msgPart[1];
                }
                break;
            case "SetTemp":
                if (msgPart.length >=2){
                    targetTemp = 0 + msgPart[1];
                    console.log("GOT A NEW SET TEMP: " + targetTemp);
                }
                break;
            default:
                console.log("Unknown message received: " + msg);
                break
            }
        }
    }

    Rectangle {
        color: "white"
        width: 559
        height: 355
        x: 60
        y: 25
//        border.color: "red"
//        border.width: 1
        StackView {
            id: stackView
            width: parent.width
            height: parent.height
            anchors.fill: parent
            focus: true
            initialItem: Qt.resolvedUrl("Screen_MainMenu.qml")
//            initialItem: Qt.resolvedUrl("Screen_Preheating.qml")
//            initialItem: Qt.resolvedUrl("Screen_AwaitStart.qml")
        }
        Component.onCompleted: {
            console.log("Rectangle is loaded.");
            console.log("Opening connection to websocket server.");
            socket.active = true;
        }
    }

    WebSocket {
        id: socket
        url: "ws://localhost:8080"
        onTextMessageReceived: {
            console.log("Received message: " + message);
            handleWebSocketMessage(message);
        }
        onStatusChanged: if (socket.status == WebSocket.Error) {
                             console.log("Error: " + socket.errorString)
                         } else if (socket.status == WebSocket.Open) {
                             socket.sendTextMessage("Hello World")
                         } else if (socket.status == WebSocket.Closed) {
                             console.log("Socket closed");
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



    Button {
        id: quitButton
        x: 10
        y: rootWindow.height - quitButton.height - 10
        height: width
        action: Action {
            onTriggered: {
                Qt.quit();
            }
        }
        Text {
            text: qsTr("Quit")
            font.family: localFont.name
            anchors.centerIn: parent
        }
    }
}

