import QtQuick 2.0

Rectangle {
    id: backButton
    signal clicked()
    implicitWidth: 40
    implicitHeight: 40
    color: appBackgroundColor
    Text {
        id: idText
        font.family: localFont.name
        font.pointSize: 24
        text: "<"
        anchors.centerIn: parent
        color: appForegroundColor
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            console.log("Back clicked");
            backButton.clicked();
        }
        onPressed: {
            idText.color = appBackgroundColor;
            backButton.color = appForegroundColor;
        }
        onReleased: {
            idText.color = appForegroundColor;
            backButton.color = appBackgroundColor;
        }
    }
}

