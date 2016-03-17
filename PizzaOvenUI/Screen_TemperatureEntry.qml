import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenTemperatureEntry
    width: parent.width
    height: parent.height

    property int myMargins: 10

    BackButton {
        id: temperatureEntryBackButton
        anchors.margins: myMargins
        x: 5
        y: 5
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    Text {
        font.family: localFont.name
        font.pointSize: 24
        text: "SELECT TEMPERATURE"
        anchors.margins: myMargins
        anchors.right: screenTemperatureEntry.right
        anchors.top: temperatureEntryBackButton.top
        color: appForegroundColor
    }

    property int tumblerWidth: parent.width*0.55/5;

    Tumbler {
        id: temperatureEntry
        anchors.top: temperatureEntryBackButton.bottom
        anchors.topMargin: myMargins
        height: parent.height - y - myMargins
        width: tumblerWidth
        x: parent.width * 0.33

        Component.onCompleted: {
            var hunds = ((targetTemp - targetTemp%100)/100).toFixed(0);
            var tens = ((targetTemp%100 - targetTemp%10)/10).toFixed(0);
            var ones = (targetTemp%10).toFixed(0);
            temperatureEntry.setCurrentIndexAt(0, hunds);
            temperatureEntry.setCurrentIndexAt(1, tens);
            temperatureEntry.setCurrentIndexAt(2, ones);
        }

        style:  MyTumblerStyle {
            onClicked: {
                console.log("The tumbler was clicked.");
                console.log(hundredsColumn.currentIndex);
                console.log(tensColumn.currentIndex);
                console.log(onesColumn.currentIndex);
//                stackView.push(Qt.resolvedUrl("Screen_AwaitStart.qml"));
            }
            visibleItemCount: 5
            textHeight:temperatureEntry.height/visibleItemCount
            textWidth: temperatureEntry.width
        }
        TumblerColumn {
            id: hundredsColumn
            width: tumblerWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
        TumblerColumn {
            id: tensColumn
            width: tumblerWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
        TumblerColumn {
            id: onesColumn
            width: tumblerWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
    }
    SideButton {
        id: nextButton
        buttonText: "NEXT"
        anchors.margins: myMargins
        anchors.verticalCenter: temperatureEntry.verticalCenter
        x: temperatureEntry.x + tumblerWidth * 4
        onClicked: {
            console.log("The next button was clicked.");
            var temp = hundredsColumn.currentIndex * 100;
            temp += tensColumn.currentIndex * 10;
            temp += onesColumn.currentIndex;
            console.log("Temp is now " + temp);
            targetTemp = temp;
            sendWebSocketMessage("SetTemp " + targetTemp);
            stackView.push({item:Qt.resolvedUrl("Screen_TimeEntry.qml"), immediate:immediateTransitions});
        }
    }
}

