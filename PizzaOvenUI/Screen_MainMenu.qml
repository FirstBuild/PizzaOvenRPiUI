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

    Image {
        id: pizzaOvenOffImage
//            source: "pizza_oven_blank_screen.jpg"
//        source: "PizzaOvenAwaitPreheat.png"
//        source: "TwoTemps.png"
        source: "MainMenu.png"
        anchors.centerIn: parent
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
        onClicked: {
            stackView.push({item: Qt.resolvedUrl("Screen_Settings.qml"), immediate:immediateTransitions});
        }
    }

    Text {
        text: "Select"
        font.family: localFont.name
        font.pointSize: 18
        color: appGrayText
        x: 440
        y: 40
    }

    ListModel {
        id: foodTypeListModel
        ListElement {
            name: "NEW YORK STYLE"
        }
        ListElement {
            name: "NEOPOLITAN"
        }
        ListElement {
            name: "DETROIT STYLE"
        }
        ListElement {
            name: "FLAT BREADS"
        }
    }

    property int tumblerWidth: parent.width*0.55;

    Tumbler {
        opacity: 0.5
        id: foodType
        height: 225
        width: 300
        x: 180
        y: 100

        style:  MyTumblerStyle {
            onClicked: {
                sounds.select.play();
                demoTimeoutTimer.stop();
//                stackView.push({item: Qt.resolvedUrl("Screen_PizzaType.qml"), immediate:immediateTransitions});
                stackView.push({item: Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
                console.log("Food type index: " + theColumn.currentIndex);
                foodNameString = foodTypeListModel.get(theColumn.currentIndex).name;
            }
            visibleItemCount: 5
            textHeight:100
            textWidth: parent.width
        }
        TumblerColumn {
            id: theColumn
            width: tumblerWidth
            model: foodTypeListModel
        }
    }

    Rectangle {
        width: screenWidth
        height: 1
        color: "yellow"
        x: 0
        y: 165
    }
    Rectangle {
        width: screenWidth
        height: 1
        color: "yellow"
        x: 0
        y: 228
    }

    ButtonLeft {

    }

}
