import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen

    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 10

    function screenEntry() {
        autoShutoff.stop();
    }

    CircleScreenTemplate {
        circleValue: 0
        titleText: "COOLING DOWN"
    }

    HomeButton {
        id: homeButton
    }

    Text {
        id: screenMessage
        text: "CAUTION<br>OVEN IS HOT"
        height: 206
        width: height
        x: (parent.width - width) / 2
        y: 96 + (206 - height)/2
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: localFont.name
        font.pointSize: 18
        wrapMode: Text.Wrap
        color: appForegroundColor
    }
}
