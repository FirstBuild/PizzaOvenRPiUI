import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: checkbox
    height: 30
    width: 150

    property string text: "Label"
    property bool checked: false

    Row {
        spacing: 10

        Rectangle {
            id: tick
            width: 30
            height: 30
            border.width: 2
            border.color: appForegroundColor
            color: appBackgroundColor

            Text {
                text: checkbox.checked ? "X" : ""
                anchors.centerIn: parent
                color: appForegroundColor
                font.family: localFont.name
                font.pointSize: 18
                font.bold: true
            }
        }
        Text {
            text: checkbox.text
            color: appForegroundColor
            font.family: localFont.name
            font.pointSize: 18
            anchors.verticalCenter: tick.verticalCenter
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked:{
            checkbox.checked = !checkbox.checked;
        }
    }
}
