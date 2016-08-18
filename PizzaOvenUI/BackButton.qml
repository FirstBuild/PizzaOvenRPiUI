import QtQuick 2.0

Rectangle {
    id: backButton
    signal clicked()
    implicitWidth: 12
    implicitHeight: 24
    color: appBackgroundColor
    x: 48
    y: 45

    Rectangle {
        id: line1
        width: parent.width * 1.414
        height: 1
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: appForegroundColor
        transform: Rotation { origin.x: 0; origin.y: 0; angle: -45}
    }
    Rectangle {
        id: line2
        width: parent.width * 1.414
        height: 1
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: appForegroundColor
        transform: Rotation { origin.x: 0; origin.y: 0; angle: 45}
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            sounds.touch.play();
            console.log("Back clicked");
            backButton.clicked();
        }
        onPressed: {
            line1.color = appBackgroundColor;
            line2.color = appBackgroundColor;
            backButton.color = appForegroundColor;
        }
        onReleased: {
            line1.color = appForegroundColor;
            line2.color = appForegroundColor;
            backButton.color = appBackgroundColor;
        }
    }
}

