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
        id: screenTitle
        font.family: localFont.name
        font.pointSize: 24
        text: "Select oven temp"
        anchors.margins: myMargins
        anchors.left: temperatureEntry.left
//        anchors.right: screenTemperatureEntry.right
        anchors.top: temperatureEntryBackButton.top
        color: appForegroundColor
    }

//    property int tumblerWidth: parent.width*0.55/5;
    property int tumblerWidth: parent.width / 3;
    property int columnWidth: tumblerWidth * 0.4;
    property int tumblerHeight: parent.height - screenTitle.y - screenTitle.height - myMargins*2

    Tumbler {
        id: temperatureEntry
        anchors.top: temperatureEntryBackButton.bottom
        anchors.topMargin: myMargins
        anchors.margins: myMargins
        height: tumblerHeight
//        height: parent.height - y - myMargins
//        width: tumblerWidth * 3
        anchors.right: nextButton.left
//        x: parent.width * 0.33

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
//            textWidth: temperatureEntry.width
            textWidth: columnWidth
            textAlignment: Text.AlignHCenter
        }
        TumblerColumn {
            id: hundredsColumn
            width: columnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
        TumblerColumn {
            id: tensColumn
            width: columnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
        TumblerColumn {
            id: onesColumn
            width: columnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
    }
    SideButton {
        id: nextButton
        buttonText: "NEXT"
        anchors.margins: myMargins
        anchors.verticalCenter: temperatureEntry.verticalCenter
        anchors.right: parent.right
//        x: temperatureEntry.x + tumblerWidth * 4
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

