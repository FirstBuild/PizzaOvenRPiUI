import QtQuick 2.0

Rectangle {
    id: gearButton

    signal clicked()

    x: 37
    y: 37

    width: 40
    height: 40
    color: appBackgroundColor

    Rectangle {
        height: lineSpacing
        width: lineSpacing
        anchors.centerIn: parent
        color: gearButton.color
        MouseArea {
            anchors.fill: parent
            onClicked: {
                sounds.touch.play();
                bookmarkCurrentScreen();
                gearButton.clicked();
            }
        }
    }

    Image {
        id: mainMenuGearIcon
        source: gearIconSource
        anchors.centerIn: parent
    }
}


