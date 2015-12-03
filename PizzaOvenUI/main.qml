import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Window {
    id: rootWindow
    visible: true
    width: 800
    height: 600
    color: "white"

    FontLoader { id: localFont; source: "fonts/FreeSans.ttf"; name: "FreeSans" }

    StackView {
        id: stackView
        width: parent.width
        height: parent.height
        anchors.fill: parent
        focus: true
        initialItem: Qt.resolvedUrl("Screen_MainMenu.qml")
//        initialItem: Qt.resolvedUrl("Screen_PizzaType.qml")
//        initialItem: Qt.resolvedUrl("Screen_AwaitStart.qml")
//        initialItem: Qt.resolvedUrl("Screen_Preheating.qml")
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

