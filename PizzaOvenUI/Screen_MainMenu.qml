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
    property bool ctrlPressed: false
    property bool altPressed: false
    property bool bsPressed: false

    function screenEntry() {
        appSettings.backlightOff = false;
        if (demoModeIsActive) {
            demoTimeoutTimer.restart();
        }
        keyhandler.focus = true;
    }

    function screenExit() {
        keyhandler.focus = false;
    }

    Timer {
        id: demoTimeoutTimer
        interval: 60000; running: false; repeat: false
//        interval: 15000; running: false; repeat: false
        onTriggered: SequentialAnimation {
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    screenExit();
                    stackView.clear();
                    stackView.push({item: Qt.resolvedUrl("Screen_Off.qml"), immediate:immediateTransitions});
                }
            }
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
                    screenExit();
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
                screenExit();
                stackView.push({item: Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
            }
        }
    }
    Item {
        id: keyhandler
        anchors.fill: parent
        focus: true
        Keys.onPressed: {
            switch (event.key) {
            case Qt.Key_Control:
                ctrlPressed = true;
                console.log("Ctrl was pressed.");
                break;
            case Qt.Key_Alt:
                altPressed = true;
                console.log("Alt was pressed.");
                break;
            case Qt.Key_Backspace:
                bsPressed = true;
                console.log("BS was pressed.");
                break;
            default:
                console.log("key not handled in main menu.");
            }

            event.accepted = true;
            if (ctrlPressed && altPressed && bsPressed) {
                Qt.quit();
            }
        }
        Keys.onReleased: {
            switch (event.key) {
            case Qt.Key_Control:
                ctrlPressed = false;
                console.log("Ctrl was released.");
                break;
            case Qt.Key_Alt:
                altPressed = false;
                console.log("Alt was released.");
                break;
            case Qt.Key_Backspace:
                bsPressed = false;
                console.log("BS was released.");
                break;
            }

            event.accepted = true;
        }
    }
}
