import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.1

Item {
    id: screenStoneTempEntry
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
            text: "Select stone temp"
            anchors.margins: myMargins
            color: appForegroundColor
        }

        Tumbler {
            id: temperatureEntry
            height: parent.height - screenTitle.height - parent.spacing * 3

            Component.onCompleted: {
                var hunds = ((lowerFront.setTemp - lowerFront.setTemp%100)/100).toFixed(0);
                var tens = ((lowerFront.setTemp%100 - lowerFront.setTemp%10)/10).toFixed(0);
                var ones = (lowerFront.setTemp%10).toFixed(0);
                temperatureEntry.setCurrentIndexAt(0, hunds);
                temperatureEntry.setCurrentIndexAt(1, tens);
                temperatureEntry.setCurrentIndexAt(2, ones);
                console.log("Set temp is " + lowerFront.setTemp);
                console.log("hunds: " + hunds);
                console.log("tens: " + tens);
                console.log("ones: " + ones);
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

            if (temp > 800) {
                messageDialog.open();
            } else {
                lowerFront.setTemp = temp;
                lowerRear.setTemp = lowerFront.setTemp - lowerTempDifferential;

                console.log("Lower front set temp is now " + lowerFront.setTemp);
                console.log("Lower rear set temp is now " + lowerRear.setTemp);

                sendWebSocketMessage("Set LF SetPoint " +
                                     (lowerFront.setTemp - 0.5 * lowerFront.temperatureDeadband) + " " +
                                     (lowerFront.setTemp + 0.5 * lowerFront.temperatureDeadband));
                sendWebSocketMessage("Set LR SetPoint " +
                                     (lowerRear.setTemp - 0.5 * lowerRear.temperatureDeadband) + " " +
                                     (lowerRear.setTemp + 0.5 * lowerRear.temperatureDeadband));

                stackView.push({item:Qt.resolvedUrl("Screen_EnterDomeTemp.qml"), immediate:immediateTransitions});
            }

        }
    }
    MessageDialog {
        id: messageDialog
        title: "Limit Exceeded"
        text: "Stone temp max is 800F"
    }
}

