import QtQuick 2.0

Item {
    id: cancleButton

    signal clicked()

    implicitHeight: 75
    implicitWidth: parent.width*.2

    Rectangle {
        id: buttonBackground
        color: appBackgroundColor
        width: parent.width
        height: parent.height
    }

    Text {
        id: idButtonText
        text: "CANCEL"
        font.family: localFont.name
        font.pointSize: 16
        anchors.centerIn: parent
        color: appForegroundColor
    }
    Rectangle {
        id: idTopLine
        width: parent.width
        height: 2
        anchors.top: parent.top
        border.width: 1
        border.color: appForegroundColor
    }
    Rectangle {
        id: idBottomLine
        width: parent.width
        height: 2
        anchors.bottom: parent.bottom
        border.width: 1
        border.color: appForegroundColor
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            sounds.cancel.play();
            cancleButton.clicked();
        }
        onPressed: {
            buttonBackground.color = appForegroundColor;
            idButtonText.color = appBackgroundColor;
        }
        onReleased: {
            buttonBackground.color = appBackgroundColor;
            idButtonText.color = appForegroundColor;
        }
    }
}
