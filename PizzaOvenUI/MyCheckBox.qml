import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: checkbox
    height: 30
    width: 150

    property string text: "Label"
    property bool checked: false
    signal checkChanged()

    Row {
        spacing: 10
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: tick
            width: 30
            height: 30
            border.width: 2
            border.color: appGrayColor
            color: appBackgroundColor

            Rectangle {
                width: parent.width - 10
                height: width
                color: checkbox.checked ? appForegroundColor : appBackgroundColor
                anchors.centerIn: parent
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
            sounds.touch.play();
            checkbox.checked = !checkbox.checked;
            checkChanged();
        }
    }
}
