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

    property int tumblerColumns: 3
    property int tumblerHeight: 250
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
        text: "Select Stone Temperature"
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
                var temp = tempDisplayInF ? lowerFront.setTemp : utility.f2c(lowerFront.setTemp);
                var hunds = ((temp - temp%100)/100).toFixed(0);
                var tens = ((temp%100 - temp%10)/10).toFixed(0);
                var ones = (temp%10).toFixed(0);
                temperatureEntry.setCurrentIndexAt(0, hunds);
                temperatureEntry.setCurrentIndexAt(1, tens);
                temperatureEntry.setCurrentIndexAt(2, ones);
                anim.start();
            }

            style:  MyTumblerStyle {
                visibleItemCount: tumblerRows
                textHeight:temperatureEntry.height/visibleItemCount
                textWidth: appColumnWidth
                textAlignment: Text.AlignHCenter
                showKeypress: false
                padding.top: 0
                padding.bottom: 0
                padding.left: 0
                padding.right: 0
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
        text: singleSettingOnly ? "DONE" : "NEXT"
        onClicked: SequentialAnimation {
            id: screenExitAnimation
            ScriptAction {
                script: {
                    var temp = hundredsColumn.currentIndex * 100;
                    temp += tensColumn.currentIndex * 10;
                    temp += onesColumn.currentIndex;

                    if (!tempDisplayInF)
                    {
                        console.log("Temp in C is " + temp);
                        temp = utility.c2f(temp);
                        console.log("Temp in F is " + temp);
                        console.log("Max temp is " + lowerMaxTemp);
                    }

                    if (temp > lowerMaxTemp) {
                        sounds.alarmUrgent.play();
                        screenExitAnimation.stop();
                        tempWarningDialog.visible = true;
                    } else {
                        if (temp !== lowerFront.setTemp) {
                            if (temp > lowerFront.setTemp) {
                                preheatComplete = false;
                                stoneIsPreheated = false;
                            }
                            foodNameString = "CUSTOM"
                            utility.setLowerTemps(temp)
                            utility.saveCurrentSettingsAsCustom();
                        }
                    }

                }
            }
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    if (singleSettingOnly) {
                        if (!preheatComplete && ovenIsRunning()) {
                            rootWindow.maxPreheatTimer.restart();
                            stackView.clear();
                            stackView.push({item:Qt.resolvedUrl("Screen_Preheating2Temp.qml"), immediate:immediateTransitions});
                        } else {
                            restoreBookmarkedScreen();
                        }
                    } else {
                        stackView.push({item:Qt.resolvedUrl("Screen_EnterTime.qml"), immediate:immediateTransitions});
                    }
                }
            }
        }
    }

    DialogWithCheckbox {
        id: tempWarningDialog
        visible: false
        dialogMessage: "You Must Select A Temperature Below " + utility.tempToString(lowerMaxTemp)
    }
}

