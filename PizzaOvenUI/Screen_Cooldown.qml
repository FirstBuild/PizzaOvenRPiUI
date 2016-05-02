import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenCooldown

    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 10

    Text {
        id: timeLabel
        font.family: localFont.name
        font.pointSize: 24
        text: timeOfDay
        anchors.margins: myMargins
        anchors.right: screenCooldown.right
        anchors.top: screenCooldown.top
        color: appForegroundColor
    }

    Text {
        anchors.centerIn: parent
        anchors.margins: myMargins
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        font.family: localFont.name
        font.pointSize: 24
        text: "CAUTION: The pizza oven is hot."
        color: "red"
    }
}
