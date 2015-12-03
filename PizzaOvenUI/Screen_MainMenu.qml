import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: screenMainMenu
    height: rootWindow.height*0.8

    Rectangle {
        id: mainMenuGearButton
        anchors.margins: 20
        width: 40
        height: 40
        x: 20
        y: 20
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
        anchors.margins: 20
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

    property int tumblerWidth: rootWindow.width*0.55;

    Tumbler {
        id: foodType
        anchors.top: mainMenuGearButton.bottom
        anchors.topMargin: 20
        height: rootWindow.height*0.66
        width: tumblerWidth
        x: rootWindow.width * 0.33

        style:  MyTumblerStyle {
            onClicked: {
                console.log("Name clicked: " + name + " model: " + theColumn.model.get(theColumn.currentIndex).name);
                if (name === theColumn.model.get(theColumn.currentIndex).name) {
                    console.log("The names did match.");
                    stackView.push(Qt.resolvedUrl("Screen_PizzaType.qml"));
                }
            }
            visibleItemCount: 5
            textHeight:foodType.height/visibleItemCount
            textWidth: foodType.width
        }
        TumblerColumn {
            id: theColumn
            width: tumblerWidth
            model: foodTypeListModel
        }
    }
}
