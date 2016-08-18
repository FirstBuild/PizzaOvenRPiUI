import QtQuick 2.0

Rectangle {
    id: gearButton

    signal clicked()

    x: 32
    y: 35

    width: 40
    height: 40
    color: appBackgroundColor

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


