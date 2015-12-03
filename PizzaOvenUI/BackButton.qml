import QtQuick 2.0

Item {
    id: backButton
    signal clicked()
    implicitWidth: 40
    implicitHeight: 40
    Text {
        font.family: localFont.name
        font.pointSize: 24
        text: "<"
        anchors.centerIn: parent
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            console.log("Back clicked");
            backButton.clicked();
        }
    }
}

