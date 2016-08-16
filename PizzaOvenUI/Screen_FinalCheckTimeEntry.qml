import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenTimeEntry
    width: parent.width
    height: parent.height

    property int myMargins: 10
    property int itemsPerTumbler: 5

    BackButton {
        id: backButton
        anchors.margins: myMargins
        x: 5
        y: 5
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    property int tumblerWidth: parent.width / 4;
    property int columnWidth: tumblerWidth *0.35;
    property int tumblerHeight: (height *3/4) - screenTitle.height

    Text {
        id: screenTitle
        font.family: localFont.name
        font.pointSize: 24
        text: "Select final check time"
        color: appForegroundColor
        anchors.margins: myMargins
        anchors.leftMargin: 62
        anchors.left: backButton.right
        anchors.verticalCenter: backButton.verticalCenter
    }

    TimeEntryTumbler {
        id: timeEntryTumbler
        timeValue: finalCheckTime
        height: tumblerHeight
        width: screenTitle.width / 4
        anchors.horizontalCenter: screenTitle.horizontalCenter
        anchors.top: screenTitle.bottom
        anchors.margins: myMargins
    }

    SideButton {
        id: nextButton
        buttonText: "DONE"
        anchors.margins: 20
        anchors.verticalCenter: timeEntryTumbler.verticalCenter
        anchors.right: parent.right
        onClicked: {
            finalCheckTime = timeEntryTumbler.getTime();
            console.log("Final check time is now " + timeEntryTumbler.getMinutes() + ":" + timeEntryTumbler.getSeconds() +
                        " (" + finalCheckTime + ")");
            sendWebSocketMessage("FinalCheckTime " + finalCheckTime);
            stackView.pop({item:screenBookmark, immediate:immediateTransitions});
        }
    }
}

