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
        font.family: localFont.name
        font.pointSize: 24
        text: "The pizza oven is cooling down."
//        anchors.margins: myMargins
//        anchors.right: screenMainMenu.right
//        anchors.top: mainMenuGearButton.top
        color: appForegroundColor
    }
}
