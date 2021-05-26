import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    width: parent.width
    height: parent.height
    property string screenName: "Screen_EnterFinalCheckTime"

    property int tumblerColumns: 4
    property int tumblerHeight: 1
    property int tumblerRows: 5
    property int titleTextPointSize: 1
    property int titleTextToPointSize: 18 * screenScale

    function screenEntry() {
        console.log("Entering enter final check time screen");
        screenEntryAnimation.start();
        tumblerHeightAnim.start();
        titleTextAnim.start();
        nextButton.animate();
    }

    function cleanUpOnExit() {
        screenExitAnimation.stop();
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
        to: 250 * screenScale
    }

    NumberAnimation on titleTextPointSize {
        id: titleTextAnim
        from: 1
        to: titleTextToPointSize
    }

    ClickableTextBox {
        text: "Select final check time"
        foregroundColor: appGrayText
        width: 235 * screenScale
        height: 30 * screenScale
        x: screenWidth - width - 26 * screenScale
        y: 41 * screenScale
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        onClicked: {
            nextButton.clicked();
        }
    }

    Item {
        width: 300 * screenScale
        height: tumblerHeight
        x:88 * screenScale
        anchors.verticalCenter: nextButton.verticalCenter

        OpacityAnimator { from: 0.0; to: 1.0}

        TimeEntryTumbler {
            id: timeEntryTumbler
            timeValue: finalCheckTime
            height: tumblerHeight
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            columnWidth: appColumnWidth
            tumblerRows: tumblerRows
        }
    }

    SequentialAnimation {
        id: screenExitAnimation
        ScriptAction {
            script: {
                var temp = timeEntryTumbler.getTime();
                if (temp !== finalCheckTime) {
                    foodIndex = 4;
                    finalCheckTime = timeEntryTumbler.getTime();
                    utility.saveCurrentSettingsAsCustom();
                    backEnd.sendMessage("FinalCheckTime " + finalCheckTime);
                }
            }
        }
        OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
        ScriptAction {
            script: {
                if (singleSettingOnly) {
                    restoreBookmarkedScreen();
                } else {
                    stackView.clear();
                    stackView.push({item:Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    ButtonRight {
        id: nextButton
        text: "DONE"
        onClicked: screenExitAnimation.start()
    }
}

