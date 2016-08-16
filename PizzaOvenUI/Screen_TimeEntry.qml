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

    Column {
        id: centerControlColumn
        anchors.margins: myMargins
        anchors.top: backButton.bottom
        anchors.horizontalCenter: screenTitle.horizontalCenter
        spacing: 10

//        TimeEntryTumbler {
//            id: timeEntryTumbler
//            timeValue: cookTime
//            height: parent.height - screenTitle.height - checkbox.height - parent.spacing * 3
//        }

//        Item {
//            id: checkbox
//            height: 30
//            width: screenTitle.width

//            Row {
//                spacing: 10

//                Rectangle {
//                    id: tick
//                    width: 30
//                    height: 30
//                    border.width: 2
//                    border.color: appForegroundColor
//                    color: appBackgroundColor

//                    Text {
//                        text: halfTimeRotate ? "X" : ""
//                        anchors.centerIn: parent
//                        color: appForegroundColor
//                    }
//                }
//                Text {
//                    text: "Half time rotate"
//                    color: appForegroundColor
//                    font.family: localFont.name
//                    font.pointSize: 18
//                    anchors.verticalCenter: tick.verticalCenter
//                }
//            }
//            MouseArea {
//                anchors.fill: parent
//                onClicked:{
//                    halfTimeRotate = !halfTimeRotate;
//                }
//            }
//        }
    }


    SideButton {
        id: nextButton
        buttonText: "NEXT"
        anchors.margins: 20
        anchors.verticalCenter: centerControlColumn.verticalCenter
        anchors.right: parent.right
        onClicked: {
//            var minutes = minutesTensColumn.currentIndex*10 + minutesOnesColumn.currentIndex;
//            var seconds = secondsTensColumn.currentIndex*10 + secondsOnesColumn.currentIndex;
//            cookTime = minutes * 60 + seconds;
            cookTime = timeEntryTumbler.getTime();
            console.log("Cook time is now " + timeEntryTumbler.getMinutes() + ":" + timeEntryTumbler.getSeconds() +
                        " (" + cookTime + ")");
            sendWebSocketMessage("CookTime " + cookTime);
            finalCheckTime = cookTime * 0.9
            stackView.push({item:Qt.resolvedUrl("Screen_FinalCheckTimeEntry.qml"), immediate:immediateTransitions});
        }
    }
}

