import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    width: parent.width
    height: parent.height

    property int tumblerColumns: 4
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
        text: "Select Cook Time"
        foregroundColor: appGrayText
        width: 185
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

        OpacityAnimator { from: 0.0; to: 1.0}

        TimeEntryTumbler {
            id: timeEntryTumbler
            timeValue: cookTime
            height: tumblerHeight
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            columnWidth: appColumnWidth
            tumblerRows: tumblerRows
        }
    }

    ButtonRight {
        id: nextButton
        text: "NEXT"
        onClicked: SequentialAnimation {
            id: screenExitAnimation
            ScriptAction {
                script: {
                    var temp = timeEntryTumbler.getTime();
                    if (temp !== cookTime) {
                        foodNameString = "CUSTOM"
                        foodIndex = 4;
                        cookTime = timeEntryTumbler.getTime();
                        backEnd.sendMessage("CookTime " + cookTime);
                        finalCheckTime = cookTime * 0.9
                        backEnd.sendMessage("FinalCheckTime " + finalCheckTime);
                        utility.saveCurrentSettingsAsCustom();
                    }
                }
            }
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
//                    stackView.push({item:Qt.resolvedUrl("Screen_EnterFinalCheckTime.qml"), immediate:immediateTransitions});
                    stackView.push({item:Qt.resolvedUrl("Screen_EnterChecks.qml"), immediate:immediateTransitions});
                }
            }
        }
    }
}

