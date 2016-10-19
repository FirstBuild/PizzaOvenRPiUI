import QtQuick 2.0
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: timeEntryTumbler

//    color: appBackgroundColor

    property int timeValue: 0
    property int tumblerRows: 5
    property int columnWidth: appColumnWidth
    width: secondsEntry.x + secondsEntry.width - minutesEntry.x

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

    Tumbler {
        id: minutesEntry
        height: parent.height

        Component.onCompleted: {
            var minutes = (timeValue - (timeValue%60))/60;
            var tensOfMinutes = minutes;
            minutes = minutes % 10;
            tensOfMinutes = (tensOfMinutes - minutes)/10

            minutesEntry.setCurrentIndexAt(0, tensOfMinutes);
            minutesEntry.setCurrentIndexAt(1, minutes);
        }

        style:  MyTumblerStyle {
            visibleItemCount: tumblerRows
            textHeight:minutesEntry.height/visibleItemCount
            textWidth: columnWidth
            textAlignment: Text.AlignHCenter
            showKeypress: false
            padding.top: 0
            padding.bottom: 0
            padding.left: 0
            padding.right: 0
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
        anchors.left: minutesEntry.right
        horizontalAlignment: Text.AlignLeft
        text: ":"
    }

    Tumbler {
        id: secondsEntry
        height: parent.height
        anchors.left: colonText.right

        Component.onCompleted: {
            var seconds = (timeValue%60).toFixed(0);
            var tensOfSeconds = seconds;
            seconds = seconds %10;
            tensOfSeconds = ((tensOfSeconds - seconds)/10).toFixed(0)
            secondsEntry.setCurrentIndexAt(0, tensOfSeconds);
            secondsEntry.setCurrentIndexAt(1, seconds);
        }

        style:  MyTumblerStyle {
            visibleItemCount: tumblerRows
            textHeight:secondsEntry.height/visibleItemCount
            textWidth: columnWidth
            textAlignment: Text.AlignHCenter
            showKeypress: false
            padding.top: 0
            padding.bottom: 0
            padding.left: 0
            padding.right: 0
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
