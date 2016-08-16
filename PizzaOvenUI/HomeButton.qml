import QtQuick 2.0

Rectangle {
    id: homeButton
    signal clicked()
    implicitWidth: 40
    implicitHeight: 40
    color: appBackgroundColor

    // border.width: 1
    // border.color: "red"

    property int segmentThickness: 2
    property color segmentColor: appForegroundColor

    Rectangle {
        id: buttonBox
        width: 30
        height: 30
        anchors.centerIn: parent

        color: appBackgroundColor

        //border.color: "orange"
        //border.width: 1

        Rectangle {
            id: roofLeft
            width: 1.414 * parent.width/2
            height: segmentThickness
            anchors.top: parent.top
            anchors.right: parent.horizontalCenter
            color: segmentColor
            transform: Rotation { origin.x: roofLeft.width; origin.y: 0; angle: -45}
        }

        Rectangle {
            id: roofRight
            width: 1.414 * parent.width/2
            height: segmentThickness
            anchors.top: parent.top
            anchors.left: parent.horizontalCenter
            color: segmentColor
            transform: Rotation { origin.x: 0; origin.y: 0; angle: 45}
        }

        Rectangle {
            id: wallLeft
            width: segmentThickness
            height: parent.height * 4 / 6
            anchors.bottom: parent.bottom
            x: parent.width / 6
            color: segmentColor
        }

        Rectangle {
            id: wallRight
            width: segmentThickness
            height: parent.height * 4 / 6
            anchors.bottom: parent.bottom
            x: (parent.width * 5 / 6) - wallRight.width
            color: segmentColor
        }

        Rectangle {
            id: floor
            height: segmentThickness
            width: parent.height * 4 / 6
            anchors.bottom: parent.bottom
            x: parent.width  / 6
            color: segmentColor
        }

    }

    MouseArea {
        id: mouseArea
        anchors.fill: buttonBox
        onClicked: {
            console.log("Home clicked");
            sounds.touch.play();
            homeButton.clicked();
        }
        onPressed: {
            segmentColor = appBackgroundColor;
            buttonBox.color = appForegroundColor;
        }
        onReleased: {
            segmentColor = appForegroundColor;
            buttonBox.color = appBackgroundColor;
        }
    }
}
