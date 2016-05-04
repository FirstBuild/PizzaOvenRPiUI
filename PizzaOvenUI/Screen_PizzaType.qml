import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenPizzaType
    width: parent.width
    height: parent.height

    property int myMargins: 10

    BackButton {
        id: pizzaTypeBackButton
        anchors.margins: myMargins
        x: 5
        y: 5
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    Text {
        font.family: localFont.name
        font.pointSize: 24
        text: "Pizza Type"
        anchors.margins: myMargins
        anchors.right: screenPizzaType.right
        anchors.top: pizzaTypeBackButton.top
        color: appForegroundColor
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

    property int tumblerWidth: parent.width*0.55;

    Tumbler {
        id: pizzaType
        anchors.top: pizzaTypeBackButton.bottom
        anchors.topMargin: myMargins
        height: parent.height - y - myMargins
        width: tumblerWidth
        x: parent.width * 0.33

        style:  MyTumblerStyle {
            onClicked: {
                sounds.select.play();
                stackView.push({item: Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
            }
            visibleItemCount: 5
            textHeight:pizzaType.height/visibleItemCount
            textWidth: pizzaType.width
        }
        TumblerColumn {
            id: theColumn
            width: tumblerWidth
            model: listModel
        }
    }
}

