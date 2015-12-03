import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenPizzaType
    width: rootWindow.width
    height: rootWindow.height

    BackButton {
        id: pizzaTypeBackButton
        anchors.margins: 20
        x: 20
        y: 20
        onClicked: {
            stackView.pop();
        }
    }

    Text {
        font.family: localFont.name
        font.pointSize: 24
        text: "Pizza Type"
        anchors.margins: 20
        anchors.right: screenPizzaType.right
        anchors.top: pizzaTypeBackButton.top
    }

    ListModel {
        id: listModel

        ListElement {
            name: "NEW YORK STYLE"
        }
        ListElement {
            name: "NEOPOLITAN"
        }
        ListElement {
            name: "CALIFORNIA STYLE"
        }
        ListElement {
            name: "CHICAGO DEEP DISH"
        }
        ListElement {
            name: "CHICAGO THIN CRUST"
        }
        ListElement {
            name: "SICILIAN"
        }
        ListElement {
            name: "DETROIT STYLE"
        }
        ListElement {
            name: "COAL FIRED"
        }
        ListElement {
            name: "BAR STYLE"
        }
        ListElement {
            name: "FROZEN PIZZA"
        }
        ListElement {
            name: "TAKE N' BAKE"
        }
        ListElement {
            name: "FOCACCIA"
        }
        ListElement {
            name: "PIZZA BIANCA"
        }
    }

    property int tumblerWidth: rootWindow.width*0.55;

    Tumbler {
        id: foodType
        anchors.top: pizzaTypeBackButton.bottom
        anchors.topMargin: 20
        height: rootWindow.height - y - 20
        width: tumblerWidth
        x: rootWindow.width * 0.33

        style:  MyTumblerStyle {
            onClicked: {
                // See if the current selection was clicked
                if (name === theColumn.model.get(theColumn.currentIndex).name) {
                    stackView.push(Qt.resolvedUrl("Screen_AwaitStart.qml"));
                }
            }
            visibleItemCount: 9
            textHeight:foodType.height/visibleItemCount
            textWidth: foodType.width
        }
        TumblerColumn {
            id: theColumn
            width: tumblerWidth
            model: listModel
        }
    }
}

