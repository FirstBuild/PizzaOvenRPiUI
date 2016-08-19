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

//    Image {
//        id: pizzaOvenOffImage
//        //            source: "pizza_oven_blank_screen.jpg"
//        //        source: "PizzaOvenAwaitPreheat.png"
//        //        source: "TwoTemps.png"
//        // source: "MainMenu.png"
//        source: "MaxTemp.png"
//        y: 43
//    }

    BackButton {
        id: backButton
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    property int tumblerColumns: 3
    property int tumblerHeight: 250
    property int columnHeight: tumblerHeight

    Text {
        text: "Select Temperature"
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
            var hunds = ((lowerFront.setTemp - lowerFront.setTemp%100)/100).toFixed(0);
            var tens = ((lowerFront.setTemp%100 - lowerFront.setTemp%10)/10).toFixed(0);
            var ones = (lowerFront.setTemp%10).toFixed(0);
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
            textWidth: appColumnWidth
            textAlignment: Text.AlignHCenter
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
            var temp = hundredsColumn.currentIndex * 100;
            temp += tensColumn.currentIndex * 10;
            temp += onesColumn.currentIndex;

            if (temp > lowerMaxTemp) {
                sounds.alarmUrgent.play();
                tempWarningDialog.visible = true;
            } else {
                lowerFront.setTemp = temp;
                lowerRear.setTemp = temp - lowerTempDifferential;

                sendWebSocketMessage("Set LF SetPoint " +
                                     (lowerFront.setTemp - 0.5 * lowerFront.temperatureDeadband) + " " +
                                     (lowerFront.setTemp + 0.5 * lowerFront.temperatureDeadband));
                sendWebSocketMessage("Set LR SetPoint " +
                                     (lowerRear.setTemp - 0.5 * lowerRear.temperatureDeadband) + " " +
                                     (lowerRear.setTemp + 0.5 * lowerRear.temperatureDeadband));

                stackView.push({item:Qt.resolvedUrl("Screen_TimeEntry.qml"), immediate:immediateTransitions});
            }
        }
    }

    DialogWithCheckbox {
        id: tempWarningDialog
        visible: false
        dialogMessage: "You Must Select A Temperature Below " + tempToString(lowerMaxTemp)
    }
}

