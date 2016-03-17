import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenMainMenu
    height: parent.height
    width: parent.width

    property int myMargins: 10

    Rectangle {
        id: mainMenuGearButton
        anchors.margins: myMargins
        width: 40
        height: 40
        x: 5
        y: 5
        color: appBackgroundColor
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
        color: appForegroundColor
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
