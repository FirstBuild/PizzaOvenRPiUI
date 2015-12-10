import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Window {
    id: rootWindow
    visible: true
    width: 800
    height: 480
    color: "white"

    FontLoader { id: localFont; source: "fonts/FreeSans.ttf"; name: "FreeSans" }

    property int currentTemp: 80
    property int targetTemp: 725
    property int cookTime: 10
    property int currentTime: 0

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

    Rectangle {
        color: "white"
        width: 560
        height: 366
        anchors.centerIn: parent
        border.color: "red"
        border.width: 1
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

