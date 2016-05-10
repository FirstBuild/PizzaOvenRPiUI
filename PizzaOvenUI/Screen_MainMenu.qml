import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import QtMultimedia 5.0

Item {
    id: screenMainMenu
    height: parent.height
    width: parent.width

    property int myMargins: 10

    function screenEntry() {
        if (demoModeIsActive) {
            demoTimeoutTimer.restart();
        }
    }

    Timer {
        id: demoTimeoutTimer
        interval: 60000; running: false; repeat: false
        onTriggered: {
            stackView.clear();
            stackView.push({item: Qt.resolvedUrl("Screen_Off.qml"), immediate:immediateTransitions});
        }
    }

    GearButton {
        id: mainMenuGearButton
        x: 5
        y: 5
        onClicked: {
            stackView.push({item: Qt.resolvedUrl("Screen_Settings.qml"), immediate:immediateTransitions});
        }
    }

    Rectangle {
        id: todBox
        anchors.margins: myMargins
        anchors.right: screenMainMenu.right
        anchors.top: screenMainMenu.top
        width: timeLabel.width
        height: timeLabel.height
        color: appBackgroundColor

        Text {
            id: timeLabel
            font.family: localFont.name
            font.pointSize: 24
            text: timeOfDay
            color: appForegroundColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                stackView.push({item: Qt.resolvedUrl("Screen_SetTimeOfDay.qml"), immediate:immediateTransitions});
            }
            onPressed: {
                timeLabel.color = appBackgroundColor;
                todBox.color = appForegroundColor;
            }
            onReleased: {
                timeLabel.color = appForegroundColor;
                todBox.color = appBackgroundColor;
            }
        }
    }

    ListModel {
        id: foodTypeListModel

        ListElement {
            name: "PIZZA"
        }
        ListElement {
            name: "BAKE"
        }
        ListElement {
            name: "BROIL"
        }
        ListElement {
            name: "CASSEROLE"
        }
        ListElement {
            name: "ROAST"
        }
    }

    property int tumblerWidth: parent.width*0.55;

    Tumbler {
        id: foodType
        anchors.top: mainMenuGearButton.bottom
        anchors.topMargin: myMargins
        height: parent.height - y - myMargins
        width: tumblerWidth
        x: parent.width * 0.33

        style:  MyTumblerStyle {
            onClicked: {
                sounds.select.play();
                demoTimeoutTimer.stop();
                stackView.push({item: Qt.resolvedUrl("Screen_PizzaType.qml"), immediate:immediateTransitions});
            }
            visibleItemCount: 5
            textHeight:foodType.height/visibleItemCount
            textWidth: parent.width
        }
        TumblerColumn {
            id: theColumn
            width: tumblerWidth
            model: foodTypeListModel
        }
    }
}
