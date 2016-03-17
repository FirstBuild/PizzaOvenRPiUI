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
        text: "SELECT TIME"
        anchors.margins: myMargins
        anchors.left: timeEntryBackButton.right
        anchors.top: timeEntryBackButton.top
        color: appForegroundColor
    }

//    property int tumblerWidth: parent.width*0.55/5;
    property int tumblerWidth: parent.width / 2;

    Tumbler {
        id: minutesEntry
        anchors.top: timeEntryBackButton.bottom
        anchors.topMargin: myMargins
        height: parent.height - y - myMargins
//        width: tumblerWidth
        anchors.left: screenTitle.left

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
//                stackView.push(Qt.resolvedUrl("Screen_AwaitStart.qml"));
            }
            visibleItemCount: itemsPerTumbler
            textHeight:minutesEntry.height/visibleItemCount
            textWidth: minutesEntry.width
            textAlignment: Text.AlignHCenter
        }
        TumblerColumn {
            id: minutesTensColumn
//            width: tumblerWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
        TumblerColumn {
            id: minutesOnesColumn
//            width: tumblerWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
    }

    Text {
        id: colonText
        anchors.left: minutesEntry.right
        anchors.verticalCenter: minutesEntry.verticalCenter
        font.family: localFont.name
        font.pointSize: 24
        color: appForegroundColor
        text: ":"
    }

    Tumbler {
        id: secondsEntry
        anchors.top: timeEntryBackButton.bottom
        anchors.topMargin: myMargins
        height: parent.height - y - myMargins
//        width: tumblerWidth
        anchors.left: colonText.right
//        x: minutesEntry.x + minutesEntry.width

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
//                stackView.push(Qt.resolvedUrl("Screen_AwaitStart.qml"));
            }
            visibleItemCount: itemsPerTumbler
            textHeight:secondsEntry.height/visibleItemCount
            textWidth: secondsEntry.width
            textAlignment: Text.AlignHCenter
        }
        TumblerColumn {
            id: secondsTensColumn
//            width: tumblerWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
        TumblerColumn {
            id: secondsOnesColumn
//            width: tumblerWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
    }
    SideButton {
        id: nextButton
        buttonText: "DONE"
        anchors.margins: myMargins
        anchors.verticalCenter: minutesEntry.verticalCenter
        anchors.left: secondsEntry.right
        onClicked: {
            console.log("The next button was clicked.");
            var minutes = minutesTensColumn.currentIndex*10 + minutesOnesColumn.currentIndex;
            var seconds = secondsTensColumn.currentIndex*10 + secondsOnesColumn.currentIndex;
            cookTime = minutes * 60 + seconds;
            console.log("Cook time is now " + minutes + ":" + seconds + " (" + cookTime + ")");
            sendWebSocketMessage("CookTime " + cookTime);
            stackView.pop({item:screenBookmark, immediate:immediateTransitions});
        }
    }
}

