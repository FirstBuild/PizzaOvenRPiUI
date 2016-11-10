import QtQuick 2.0

Item {
    id: dialogWithCheckbox
    implicitWidth: parent.width
    implicitHeight: parent.height
    visible: false
    property alias dialogMessage: msg.text
    property alias pointSize: msg.font.pointSize

    Rectangle {
        width: parent.width
        height: parent.height
        color: appBackgroundColor
        opacity: 0.75
        MouseArea {
            anchors.fill: parent
        }
    }

    Item {
        x: (parent.width - width) / 2
        y: 96
        height: 206
        width: 206

        Rectangle {
            id: messageCircle
            height: parent.height
            width: parent.width
            radius: width/2
            color: appBackgroundColor
            border.width: 1
            border.color: appForegroundColor
        }

        Text {
            id: msg
            text: "Dialog Message"
            wrapMode: Text.Wrap
            font.family: localFont.name
            font.pointSize: 18
            color: appForegroundColor
            width: parent.width / 1.4142
            height: parent.height
            y: 36
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: okLabel
            text: "OK"
            y: parent.height - 50
            anchors.rightMargin: 5
            anchors.right: parent.horizontalCenter
            font.family: localFont.name
            font.pointSize: 18
            color: appForegroundColor
        }

        Rectangle {
            width: 28
            height: width
            color: appBackgroundColor
            border.color: appForegroundColor
            border.width: 3
            anchors.verticalCenter: okLabel.verticalCenter
            anchors.leftMargin: 5
            anchors.left: parent.horizontalCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    sounds.select.play();
                    dialogWithCheckbox.visible = false;
                }
            }
        }
    }
}
