import QtQuick 2.0

Item {
    id: sideButton

    property string buttonText: "BUTTON"
    signal clicked()
    property alias pointSize: idButtonText.font.pointSize
    property alias enabled: mouseArea.enabled

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
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            autoShutoff.reset();
            sounds.select.play();
            sideButton.clicked();
        }
        onPressed: {
            //buttonBackground.color = appForegroundColor;
            animatePressedColor.start();
            idButtonText.color = appBackgroundColor;
        }
        onReleased: {
            //buttonBackground.color = appBackgroundColor;
            animateReleasedColor.start();
            idButtonText.color = appForegroundColor;
        }
    }

    PropertyAnimation {
        id: animatePressedColor
        target: buttonBackground
        properties: "color"
        to: appForegroundColor
    }
    PropertyAnimation {
        id: animateReleasedColor
        target: buttonBackground
        properties: "color"
        to: appBackgroundColor
    }
}
