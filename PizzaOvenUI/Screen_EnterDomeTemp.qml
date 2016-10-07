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

    property int tumblerHeight: 1
    property int tumblerRows: 5
    property int titleTextPointSize: 1
    property int titleTextToPointSize: 18

    function screenEntry() {
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

    ClickableTextBox {
        text: "Select Dome Temperature"
        foregroundColor: appGrayText
        width: 275
        height: 30
        x: screenWidth - width - 26
        y: 41
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        onClicked: nextButton.clicked()
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
                var thous = ((upperFront.setTemp - upperFront.setTemp%1000)/1000).toFixed(0);
                var hunds = ((upperFront.setTemp%1000 - upperFront.setTemp%100)/100).toFixed(0);
                var tens = ((upperFront.setTemp%100 - upperFront.setTemp%10)/10).toFixed(0);
                var ones = (upperFront.setTemp%10).toFixed(0);
                temperatureEntry.setCurrentIndexAt(0, thous);
                temperatureEntry.setCurrentIndexAt(1, hunds);
                temperatureEntry.setCurrentIndexAt(2, tens);
                temperatureEntry.setCurrentIndexAt(3, ones);
                anim.start();
            }

            style:  MyTumblerStyle {
                visibleItemCount: tumblerRows
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
    }

    ButtonRight {
        id: nextButton
        text: "NEXT"
        height: lineSpacing
        onClicked: SequentialAnimation {
            id: screenExitAnimation
            ScriptAction {
                script: {
                    var temp = thousandsColumn.currentIndex * 1000;
                    temp += hundredsColumn.currentIndex * 100;
                    temp += tensColumn.currentIndex * 10;
                    temp += onesColumn.currentIndex;

                    if (temp > upperMaxTemp) {
                        screenExitAnimation.stop();
                        sounds.alarmUrgent.play();
                        messageDialog.visible = true;
                    } else {
                        if (temp !== upperFront.setTemp) {
                            foodNameString = "CUSTOM"
                        }
                        utility.setUpperTemps(temp)
                    }
                }
            }
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0; easing.type: Easing.InCubic}
            ScriptAction {script: {
                    //                stackView.push({item:Qt.resolvedUrl("Screen_EnterTime.qml"), immediate:immediateTransitions});
                    stackView.push({item:Qt.resolvedUrl("Screen_EnterStoneTemp.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    DialogWithCheckbox {
        id: messageDialog
        dialogMessage: "You Must Select A Temperature Below " + utility.tempToString(upperMaxTemp)
    }
}


