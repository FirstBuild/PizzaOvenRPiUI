import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.1

Item {
    id: thisScreen
    width: parent.width
    height: parent.height
    property string screenName: "Screen_TemperatureEntry"

    property int tumblerHeight: 1
    property int tumblerRows: 5
    property int columnHeight: tumblerHeight
    property int titleTextPointSize: 1
    property int titleTextToPointSize: 18

    function screenEntry() {
        console.log("Entering temperature entry screen");
        screenEntryAnimation.start();
        tumblerHeightAnim.start();
        titleTextAnim.start();
        nextButton.animate();
    }

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    BackButton {
        id: backButton
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    NumberAnimation on tumblerHeight {
        id: tumblerHeightAnim
        from: 1
        to: 250
    }

    NumberAnimation on titleTextPointSize {
        id: titleTextAnim
        from: 1
        to: titleTextToPointSize
    }

    Text {
        text: "Select Temperature"
        font.family: localFont.name
        font.pointSize: titleTextPointSize
        color: appGrayText
        width: 400
        height: 30
        x: screenWidth - width - 26
        y: 41
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
    }

    Item {
        width: 300
        height: tumblerHeight
        x:88
        anchors.verticalCenter: nextButton.verticalCenter
        Tumbler {
            id: temperatureEntry
            height: tumblerHeight
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right

            NumberAnimation on opacity {
                id: anim;
                from: 0.0;
                to: 1.0;
                easing.type: Easing.InCubic;
            }

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
                NumberAnimation on textPointSize {
                    from: 1
                    to: 24
                }
                showKeypress: false
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

                backEnd.sendMessage("Set LF SetPoint " +
                                     (lowerFront.setTemp - 0.5 * lowerFront.temperatureDeadband) + " " +
                                     (lowerFront.setTemp + 0.5 * lowerFront.temperatureDeadband));
                backEnd.sendMessage("Set LR SetPoint " +
                                     (lowerRear.setTemp - 0.5 * lowerRear.temperatureDeadband) + " " +
                                     (lowerRear.setTemp + 0.5 * lowerRear.temperatureDeadband));

                stackView.push({item:Qt.resolvedUrl("Screen_EnterTime.qml"), immediate:immediateTransitions});
            }
        }
    }

    DialogWithCheckbox {
        id: tempWarningDialog
        visible: false
        dialogMessage: "You Must Select A Temperature Below " + utility.tempToString(lowerMaxTemp)
    }
}

