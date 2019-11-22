import QtQuick 2.0

Item {
    width: (screenWidth / 3) - 10
    height: 40
    property alias text: textBox.text

    Rectangle {
        width: parent.width
        height: parent.height
        border.color: 'white'
        border.width: 1
        color: appBackgroundColor
        Text {
            id: textBox
            text: 'Text'
            color: appForegroundColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: localFont.name
            font.pointSize: 18
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
        }
    }
}
