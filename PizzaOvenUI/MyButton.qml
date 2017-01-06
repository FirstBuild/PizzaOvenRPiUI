import QtQuick 2.0

Item {
    id: button
    signal clicked()

    width: 40
    height: 40

    property string text: "Button"
    property color backgroundColor: appBackgroundColor
    property color borderColor: appForegroundColor
    property int borderWidth: 0
    property string textColor: appForegroundColor

    Rectangle {
        id: buttonBackround
//        color: appBackgroundColor
        color: button.backgroundColor
        width: button.width
        height: button.height
        border.color: button.borderColor
        border.width: button.borderWidth

        Text {
            id: idText
            font.family: localFont.name
            font.pointSize: 24
            text: button.text
            anchors.centerIn: parent
            color: button.textColor
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                autoShutoff.reset();
                sounds.touch.play();
                button.clicked();
            }
            onPressed: {
                idText.color = appBackgroundColor;
                buttonBackround.color = appForegroundColor;
            }
            onReleased: {
                idText.color = appForegroundColor;
                buttonBackround.color = button.backgroundColor;
            }
        }
    }
}

