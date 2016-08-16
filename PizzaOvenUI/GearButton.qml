import QtQuick 2.0

Rectangle {
    id: gearButton

    signal clicked()

    property int myMargins: 15

    anchors.margins: gearButton.myMargins
    width: 40
    height: 40
    color: appBackgroundColor

//    border.color: "red"
//    border.width: 1

    Image {
        id: mainMenuGearIcon
        source: gearIconSource
        anchors.centerIn: parent
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            gearButton.clicked();
        }
    }
}


