import QtQuick 2.0

Item {
    id: sideButton

    property string buttonText: "BUTTON"
    signal clicked()

    implicitHeight: 75
    implicitWidth: parent.width*.2
    Text {
        text: buttonText
        font.family: localFont.name
        font.pointSize: 18
        anchors.centerIn: parent
    }
    Rectangle {
        width: parent.width
        height: 2
        anchors.top: parent.top
        border.width: 1
        border.color: "black"
    }
    Rectangle {
        width: parent.width
        height: 2
        anchors.bottom: parent.bottom
        border.width: 1
        border.color: "black"
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            sideButton.clicked();
        }
    }
}
