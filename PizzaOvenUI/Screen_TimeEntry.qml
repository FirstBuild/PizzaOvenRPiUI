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
        text: "Select cook time"
        color: appForegroundColor
        anchors.margins: myMargins
        anchors.leftMargin: 62
        anchors.left: backButton.right
        anchors.verticalCenter: backButton.verticalCenter
    }

    TimeEntryTumbler {
        id: timeEntryTumbler
        timeValue: cookTime
        height: tumblerHeight
        width: screenTitle.width / 4
        anchors.horizontalCenter: screenTitle.horizontalCenter
        anchors.top: screenTitle.bottom
        anchors.margins: myMargins
    }


    Row {
        spacing: 10
        anchors.horizontalCenter: screenTitle.horizontalCenter
        anchors.top: timeEntryTumbler.bottom
        anchors.margins: myMargins

        Rectangle {
            id: tick
            width: 30
            height: 30
            border.width: 2
            border.color: appForegroundColor
            color: appBackgroundColor

            Text {
                text: halfTimeRotate ? "X" : ""
                anchors.centerIn: parent
                color: appForegroundColor
            }
            MouseArea {
                anchors.fill: parent
                onClicked:{
                    halfTimeRotate = !halfTimeRotate;
                }
            }
        }
        Text {
            text: "Half time rotate"
            color: appForegroundColor
            font.family: localFont.name
            font.pointSize: 18
            anchors.verticalCenter: tick.verticalCenter
        }
    }

    SideButton {
        id: nextButton
        buttonText: "NEXT"
        anchors.margins: 20
        anchors.verticalCenter: timeEntryTumbler.verticalCenter
        anchors.right: parent.right
        onClicked: {
            cookTime = timeEntryTumbler.getTime();
            console.log("Cook time is now " + timeEntryTumbler.getMinutes() + ":" + timeEntryTumbler.getSeconds() +
                        " (" + cookTime + ")");
            sendWebSocketMessage("CookTime " + cookTime);
            finalCheckTime = cookTime * 0.9
            stackView.push({item:Qt.resolvedUrl("Screen_FinalCheckTimeEntry.qml"), immediate:immediateTransitions});
        }
    }
}

