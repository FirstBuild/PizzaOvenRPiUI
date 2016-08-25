import QtQuick 2.0

Item {
    id: radioButton

    width: 30
    height: 30
    property bool state: true
    signal clicked()

    Rectangle {
        width: 17
        height: 17
        radius: width/2
        anchors.centerIn: parent
        color: appBackgroundColor
        border.color: appForegroundColor
        border.width: 1
    }
    Rectangle {
        width: 13
        height: 13
        radius: width/2
        anchors.centerIn: parent
        color: {radioButton.state ? appForegroundColor : appBackgroundColor}
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            radioButton.clicked();
        }
    }
}
