import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import QtMultimedia 5.0

Item {
    id: thisScreen
    height: parent.height
    width: parent.width

    property int myMargins: 10

    function screenEntry() {
        if (demoModeIsActive) {
            sounds.powerOn.play();
            demoTimeoutTimer.restart();
            altDingTimer.restart();
        }
    }

    Timer {
        id: demoTimeoutTimer
        interval: 3*60*1000; running: false; repeat: false
        onTriggered: SequentialAnimation {
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    altDingTimer.stop();
                    sounds.powerOff.play();
                    stackView.clear();
                    stackView.push({item: Qt.resolvedUrl("Screen_Off.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    Timer {
        id: altDingTimer
        interval: 2000; running: false; repeat: true
        onTriggered: {
            sounds.off.play();
        }
    }

    GearButton {
        id: mainMenuGearButton
        onClicked: SequentialAnimation {
            ScriptAction {
                script: {
                    if (demoModeIsActive) {
                        demoTimeoutTimer.stop();
                    }
                }
            }
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    stackView.push({item: Qt.resolvedUrl("Screen_Settings.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    Text {
        text: "Select"
        font.family: localFont.name
        font.pointSize: 18
        color: appGrayText
        width: 400
        height: 30
        anchors.right: foodType.right
        y: 41
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
    }

    ListModel {
        id: foodTypeListModel
        ListElement {
            name: "NEW YORK STYLE"
        }
        ListElement {
            name: "NEOPOLITAN"
        }
        ListElement {
            name: "DETROIT STYLE"
        }
        ListElement {
            name: "FLAT BREADS"
        }
    }

    property int tumblerWidth: parent.width*0.55;

    Tumbler {
        id: foodType
        height: 225
        width: 300
        x: 180
        y: 85

        style:  MyTumblerStyle {
            onClicked: {
                sounds.select.play();
                demoTimeoutTimer.stop();
                screenExitAnimation.start();
            }
            visibleItemCount: 3
            textHeight:100
            textWidth: parent.width
            padding.top: 0
            padding.bottom: 0
            padding.left: 0
            padding.right: 0
        }
        TumblerColumn {
            id: theColumn
            width: tumblerWidth
            model: foodTypeListModel
        }
    }

    SequentialAnimation {
        id: screenExitAnimation
        OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
        ScriptAction {script: {
                foodNameString = foodTypeListModel.get(theColumn.currentIndex).name;
                stackView.push({item: Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
            }
        }
    }

    Rectangle {
        width: 75
        height: 50
        border.color: "orange"
        border.width: 4
        color: "black"
        x: 20;
        anchors.verticalCenter: parent.verticalCenter
        Text {
            text: "ALT"
            font.family: localFont.name
            font.pointSize: 24
            color: "yellow"
            anchors.centerIn: parent
        }
    }
}
