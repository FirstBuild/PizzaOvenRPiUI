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
        id: timeEntryBackButton
        anchors.margins: myMargins
        x: 5
        y: 5
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    Text {
        id: screenTitle
        font.family: localFont.name
        font.pointSize: 24
        text: "Select cook time"
        anchors.margins: myMargins
        anchors.left: minutesEntry.left
        anchors.top: timeEntryBackButton.top
        color: appForegroundColor
    }

    property int tumblerWidth: parent.width / 4;
    property int columnWidth: tumblerWidth *0.35;
    property int tumblerHeight: parent.height - screenTitle.y - screenTitle.height - myMargins*2

    Tumbler {
        id: minutesEntry
        height: tumblerHeight
        anchors.top: screenTitle.bottom
        anchors.topMargin: myMargins
        anchors.margins: myMargins
        anchors.right: colonText.left

        Component.onCompleted: {
            var minutes = cookTime - (cookTime%60);
            var tensOfMinutes = minutes;
            minutes = minutes %10;
            tensOfMinutes = ((tensOfMinutes - minutes)/10).toFixed(0)

            minutesEntry.setCurrentIndexAt(0, tensOfMinutes);
            minutesEntry.setCurrentIndexAt(1, minutes);
        }

        style:  MyTumblerStyle {
            onClicked: {
                console.log("The tumbler was clicked.");
                console.log(minutesTensColumn.currentIndex);
                console.log(minutesOnesColumn.currentIndex);
            }
            visibleItemCount: itemsPerTumbler
            textHeight:minutesEntry.height/visibleItemCount
            textWidth: columnWidth
            textAlignment: Text.AlignHCenter
        }
        TumblerColumn {
            id: minutesTensColumn
            width: columnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
        TumblerColumn {
            id: minutesOnesColumn
            width: columnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
    }

    Text {
        id: colonText
        anchors.margins: myMargins
        anchors.right: secondsEntry.left
        anchors.verticalCenter: minutesEntry.verticalCenter
        font.family: localFont.name
        font.pointSize: 24
        color: appForegroundColor
        horizontalAlignment: Text.AlignLeft
        text: ":"
    }

    Tumbler {
        id: secondsEntry
        height: tumblerHeight
        anchors.top: screenTitle.bottom
        anchors.topMargin: myMargins
        anchors.margins: myMargins
        anchors.right: nextButton.left

        Component.onCompleted: {
            var seconds = (cookTime%60).toFixed(0);
            var tensOfSeconds = seconds;
            seconds = seconds %10;
            tensOfSeconds = ((tensOfSeconds - seconds)/10).toFixed(0)
            secondsEntry.setCurrentIndexAt(0, tensOfSeconds);
            secondsEntry.setCurrentIndexAt(1, seconds);
        }

        style:  MyTumblerStyle {
            onClicked: {
                console.log("The tumbler was clicked.");
                console.log(secondsTensColumn.currentIndex);
                console.log(secondsOnesColumn.currentIndex);
            }
            visibleItemCount: itemsPerTumbler
            textHeight:secondsEntry.height/visibleItemCount
            textWidth: columnWidth
            textAlignment: Text.AlignHCenter
        }
        TumblerColumn {
            id: secondsTensColumn
            width: columnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
        TumblerColumn {
            id: secondsOnesColumn
            width: columnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
    }

    SideButton {
        id: nextButton
        buttonText: "NEXT"
        anchors.margins: 20
        anchors.verticalCenter: minutesEntry.verticalCenter
        anchors.right: parent.right
        onClicked: {
            console.log("The next button was clicked.");
            var minutes = minutesTensColumn.currentIndex*10 + minutesOnesColumn.currentIndex;
            var seconds = secondsTensColumn.currentIndex*10 + secondsOnesColumn.currentIndex;
            cookTime = minutes * 60 + seconds;
            console.log("Cook time is now " + minutes + ":" + seconds + " (" + cookTime + ")");
            sendWebSocketMessage("CookTime " + cookTime);
            finalCheckTime = cookTime * 0.9
            stackView.push({item:Qt.resolvedUrl("Screen_FinalCheckTimeEntry.qml"), immediate:immediateTransitions});
        }
    }
}

