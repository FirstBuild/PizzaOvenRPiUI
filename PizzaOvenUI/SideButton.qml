import QtQuick 2.0

Item {
    id: sideButton

    property string buttonText: "BUTTON"
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
        text: buttonText
        font.family: localFont.name
        font.pointSize: 16
        anchors.centerIn: parent
        color: appForegroundColor
    }
    Rectangle {
        id: idTopLine
        width: parent.width
        height: 1
        anchors.top: parent.top
        color: appGrayColor
    }
    Rectangle {
        id: idBottomLine
        width: parent.width
        height: 1
        anchors.bottom: parent.bottom
        color: appGrayColor
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            sounds.select.play();
            sideButton.clicked();
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
