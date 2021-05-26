import QtQuick 2.0

Rectangle {
    id: gearButton

    signal clicked()

    x: 37 * screenScale
    y: 37 * screenScale

    width: 40
    height: 40
    color: appBackgroundColor

    Rectangle {
        height: parent.width
        width: parent.height
        anchors.centerIn: parent
        color: gearButton.color
//        border.color: "orange"
//        border.width: 1
        MouseArea {
            anchors.fill: parent
            onClicked: {
                autoShutoff.reset();
                sounds.touch.play();
                bookmarkCurrentScreen();
                gearButton.clicked();
            }
        }
    }

    Image {
        id: mainMenuGearIcon
        source: gearIconSource
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        fillMode: Image.Stretch
    }
}


