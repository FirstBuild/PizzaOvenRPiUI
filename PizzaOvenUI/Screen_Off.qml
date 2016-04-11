import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenOff

    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 10

    Image {
        id: mainMenuGearIcon
        source: "pizza_oven_blank_screen.jpg"
        anchors.centerIn: parent
    }

//    Text {
//        font.family: localFont.name
//        font.pointSize: 24
//        text: "This is not the off screen you are looking for."
//        color: appForegroundColor
//    }
}

