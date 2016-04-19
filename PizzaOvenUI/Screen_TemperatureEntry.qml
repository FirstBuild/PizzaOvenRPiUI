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

    property int tumblerWidth: parent.width / 3;
    property int columnWidth: tumblerWidth * 0.4;
    property int tumblerHeight: parent.height - screenTitle.y - screenTitle.height - myMargins*2
    property int columnHeight: parent.height

    Column {
        id: centerControlColumn
        anchors.margins: myMargins
        anchors.left: temperatureEntryBackButton.right
        anchors.top: temperatureEntryBackButton.top
        anchors.leftMargin: 50
        height: parent.height - myMargins * 2
        spacing: 10

        Text {
            id: screenTitle
            font.family: localFont.name
            font.pointSize: 24
            text: "Select oven temp"
            anchors.margins: myMargins
            color: appForegroundColor
        }

        Tumbler {
            id: temperatureEntry
            height: parent.height - screenTitle.height - parent.spacing * 3

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
                }
                visibleItemCount: 5
                textHeight:temperatureEntry.height/visibleItemCount
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
    }
    SideButton {
        id: nextButton
        buttonText: "NEXT"
        anchors.margins: myMargins
        anchors.verticalCenter: centerControlColumn.verticalCenter
        anchors.right: parent.right
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

