import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.1

Item {
    id: screenTemperatureEntry
    width: parent.width
    height: parent.height

    property int myMargins: 10

    BackButton {
        id: backButton
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    property int tumblerColumns: 4
    property int tumblerHeight: 250
    property int columnHeight: tumblerHeight

    Text {
        text: "Select Dome Temperature"
        font.family: localFont.name
        font.pointSize: 18
        color: appGrayText
        width: 400
        height: 30
        anchors.right: nextButton.right
        y: 41
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
    }

    Tumbler {
        id: temperatureEntry
        height: tumblerHeight
        anchors.verticalCenter: nextButton.verticalCenter
        anchors.right: nextButton.left
        anchors.rightMargin: 20

        Component.onCompleted: {
            var thous = ((upperFront.setTemp - upperFront.setTemp%1000)/1000).toFixed(0);
            var hunds = ((upperFront.setTemp%1000 - upperFront.setTemp%100)/100).toFixed(0);
            var tens = ((upperFront.setTemp%100 - upperFront.setTemp%10)/10).toFixed(0);
            var ones = (upperFront.setTemp%10).toFixed(0);
            temperatureEntry.setCurrentIndexAt(0, thous);
            temperatureEntry.setCurrentIndexAt(1, hunds);
            temperatureEntry.setCurrentIndexAt(2, tens);
            temperatureEntry.setCurrentIndexAt(3, ones);

            console.log("upperFront.setTemp" + upperFront.setTemp);
            console.log("Thous: " + thous);
            console.log("Hunds: " + hunds);
            console.log("Tens: " + tens);
            console.log("Ones: "+ ones);
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
            textWidth: appColumnWidth
            textAlignment: Text.AlignHCenter
        }
        TumblerColumn {
            id: thousandsColumn
            width: appColumnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
        TumblerColumn {
            id: hundredsColumn
            width: appColumnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
        TumblerColumn {
            id: tensColumn
            width: appColumnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
        TumblerColumn {
            id: onesColumn
            width: appColumnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
    }

    ButtonRight {
        id: nextButton
        text: "NEXT"
        onClicked: {
            var temp = thousandsColumn.currentIndex * 1000;
            temp += hundredsColumn.currentIndex * 100;
            temp += tensColumn.currentIndex * 10;
            temp += onesColumn.currentIndex;

            if (temp > upperMaxTemp) {
                sounds.alarmUrgent.play();
                messageDialog.visible = true;
            } else {
                upperFront.setTemp = temp;
                upperRear.setTemp = upperFront.setTemp - 100;

                sendWebSocketMessage("Set UF SetPoint " +
                                     (upperFront.setTemp - 0.5 * upperFront.temperatureDeadband) + " " +
                                     (upperFront.setTemp + 0.5 * upperFront.temperatureDeadband));
                sendWebSocketMessage("Set UR SetPoint " +
                                     (upperRear.setTemp - 0.5 * upperRear.temperatureDeadband) + " " +
                                     (upperRear.setTemp + 0.5 * upperRear.temperatureDeadband));

                //                stackView.push({item:Qt.resolvedUrl("Screen_TimeEntry.qml"), immediate:immediateTransitions});
                stackView.push({item:Qt.resolvedUrl("Screen_EnterStoneTemp.qml"), immediate:immediateTransitions});
            }
        }
    }

    DialogWithCheckbox {
        id: messageDialog
        dialogMessage: "You Must Select A Temperature Below " + tempToString(upperMaxTemp)
    }
}


