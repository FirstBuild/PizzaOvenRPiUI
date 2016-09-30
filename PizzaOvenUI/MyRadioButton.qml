import QtQuick 2.0

Item {
    id: radioButton

    width: 30
    height: 30
    property bool state: true
    signal clicked()

    Rectangle {
        width: 19
        height: width
        radius: width/2
        anchors.centerIn: parent
        color: appBackgroundColor
        border.color: appGrayText
        border.width: 2
    }
    Rectangle {
        width: 11
        height: width
        radius: width/2
        anchors.centerIn: parent
        color: {radioButton.state ? appForegroundColor : appBackgroundColor}
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            sounds.touch.play();
            radioButton.clicked();
        }
    }
}
