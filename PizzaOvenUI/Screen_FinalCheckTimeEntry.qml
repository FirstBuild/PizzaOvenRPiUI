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
//        onClicked: {
//            stackView.pop({immediate:immediateTransitions});
//        }
    }

    property int tumblerWidth: parent.width / 4;
    property int columnWidth: tumblerWidth *0.35;

    Column {
        id: centerControlColumn
        anchors.margins: myMargins
        anchors.left: timeEntryBackButton.right
        anchors.top: timeEntryBackButton.top
        anchors.leftMargin: 50
        height: parent.height - myMargins * 2
        spacing: 10

        Text {
            id: screenTitle
            font.family: localFont.name
            font.pointSize: 24
            text: "Select final check time"
            color: appForegroundColor
        }

        Row {
            height: parent.height - screenTitle.height - parent.spacing * 3
            spacing: 2
            Tumbler {
                id: minutesEntry
                height: parent.height

                Component.onCompleted: {
                    var minutes = finalCheckTime - (finalCheckTime%60);
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
                anchors.verticalCenter: minutesEntry.verticalCenter
                font.family: localFont.name
                font.pointSize: 24
                color: appForegroundColor
                horizontalAlignment: Text.AlignLeft
                text: ":"
            }

            Tumbler {
                id: secondsEntry
                height: minutesEntry.height

                Component.onCompleted: {
                    var seconds = (finalCheckTime%60).toFixed(0);
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
        }
    }

    SideButton {
        id: nextButton
        buttonText: "DONE"
        anchors.margins: 20
        anchors.verticalCenter: centerControlColumn.verticalCenter
        anchors.right: parent.right
        onClicked: {
            console.log("The next button was clicked.");
            var minutes = minutesTensColumn.currentIndex*10 + minutesOnesColumn.currentIndex;
            var seconds = secondsTensColumn.currentIndex*10 + secondsOnesColumn.currentIndex;
            finalCheckTime = minutes * 60 + seconds;
            console.log("Final check time is now " + minutes + ":" + seconds + " (" + finalCheckTime + ")");
            sendWebSocketMessage("FinalCheckTime " + finalCheckTime);
            stackView.pop({item:screenBookmark, immediate:immediateTransitions});
        }
    }
}

