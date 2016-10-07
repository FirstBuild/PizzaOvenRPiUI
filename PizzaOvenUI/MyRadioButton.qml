import QtQuick 2.0

Item {
    id: radioButton

    width: 50
    height: lineSpacing
    property bool state: true
    signal clicked()
    property string text: "LABEL"

    Rectangle {
        id: background
        width: parent.width
        height: parent.height
        color: appBackgroundColor
        MouseArea {
            anchors.fill: parent
            onClicked: {
                sounds.touch.play();
                radioButton.clicked();
            }
            onPressed: {
                background.color = appForegroundColor;
                label.color = appBackgroundColor;
            }
            onReleased: {
                background.color = appBackgroundColor;
                label.color = appForegroundColor;
            }
        }
    }

    Row {
        height: parent.height
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        Rectangle {
            width: 19
            height: width
            radius: width/2
            anchors.verticalCenter: parent.verticalCenter
//            anchors.centerIn: parent
            color: appBackgroundColor
            border.color: appGrayText
            border.width: 2
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
                onPressed: {
                    background.color = appForegroundColor;
                    label.color = appBackgroundColor;
                }
                onReleased: {
                    background.color = appBackgroundColor;
                    label.color = appForegroundColor;
                }
            }
        }
        Text {
            id: label
            text: radioButton.text
            color: appForegroundColor
            font.family: localFont.name
            font.pointSize: 18
            verticalAlignment: Text.AlignVCenter
            height: radioButton.height
        }
    }

}
