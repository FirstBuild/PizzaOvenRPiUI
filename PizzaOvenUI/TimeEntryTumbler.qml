import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle {
    id: timeEntryTumbler

    color: appBackgroundColor

    property int timeValue: 0
    property int myMargins: 10
    property int itemsPerTumbler: 5
    property int columnWidth: 50

    function getTime() {
        var minutes = minutesTensColumn.currentIndex*10 + minutesOnesColumn.currentIndex;
        var seconds = secondsTensColumn.currentIndex*10 + secondsOnesColumn.currentIndex;
        return minutes * 60 + seconds;
    }

    function getMinutes() {
        return minutesTensColumn.currentIndex*10 + minutesOnesColumn.currentIndex;
    }

    function getSeconds() {
        return secondsTensColumn.currentIndex*10 + secondsOnesColumn.currentIndex;
    }

    Row {
        id: tumblerRow
        height: parent.height
        spacing: 2
        anchors.centerIn: parent
        Tumbler {
            id: minutesEntry
            height: parent.height

            Component.onCompleted: {
                var minutes = (timeValue - (timeValue%60))/60;
                var tensOfMinutes = minutes;
                minutes = minutes % 10;
                tensOfMinutes = (tensOfMinutes - minutes)/10

                console.log("timeValue is " + timeValue);

                minutesEntry.setCurrentIndexAt(0, tensOfMinutes);
                minutesEntry.setCurrentIndexAt(1, minutes);
            }

            style:  MyTumblerStyle {
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
            font.family: localFont.name
            font.pointSize: 24
            color: appForegroundColor
            anchors.verticalCenter: minutesEntry.verticalCenter
            horizontalAlignment: Text.AlignLeft
            text: ":"
        }

        Tumbler {
            id: secondsEntry
            height: parent.height

            Component.onCompleted: {
                var seconds = (timeValue%60).toFixed(0);
                var tensOfSeconds = seconds;
                seconds = seconds %10;
                tensOfSeconds = ((tensOfSeconds - seconds)/10).toFixed(0)
                secondsEntry.setCurrentIndexAt(0, tensOfSeconds);
                secondsEntry.setCurrentIndexAt(1, seconds);
            }

            style:  MyTumblerStyle {
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

