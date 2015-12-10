import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: screenMainMenu
    height: parent.height
    width: parent.width
    border.color: "blue"
    border.width: 1

    property int myMargins: 10

    Rectangle {
        id: mainMenuGearButton
        anchors.margins: myMargins
        width: 40
        height: 40
        x: 5
        y: 5
        Image {
            id: mainMenuGearIcon
            source: "Gear-Icon.svg"
            anchors.centerIn: parent
        }
    }

    Text {
        font.family: localFont.name
        font.pointSize: 24
        text: "10:04"
        anchors.margins: myMargins
        anchors.right: screenMainMenu.right
        anchors.top: mainMenuGearButton.top
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
//        height: parent.height - mainMenuGearButton.height - (myMargins * 3)
        height: parent.height - y - myMargins
        width: tumblerWidth
        x: parent.width * 0.33

        style:  MyTumblerStyle {
            onClicked: {
                console.log("Name clicked: " + name + " model: " + theColumn.model.get(theColumn.currentIndex).name);
                console.log("height: " + parent.height);
                if (name === theColumn.model.get(theColumn.currentIndex).name) {
                    console.log("The names did match.");
                    stackView.push(Qt.resolvedUrl("Screen_PizzaType.qml"));
                }
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
