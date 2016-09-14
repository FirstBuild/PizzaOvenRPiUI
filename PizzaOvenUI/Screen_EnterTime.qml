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

    Text {
        text: "Select Cook Time"
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

    Rectangle {
        id: tick
        width: 30
        height: 30
        border.width: 2
        border.color: appForegroundColor
        color: appBackgroundColor
        anchors.topMargin: 20
        anchors.left: nextButton.left
        anchors.top: nextButton.bottom

        Text {
            text: halfTimeRotate ? "X" : ""
            anchors.centerIn: parent
            color: appForegroundColor
        }
        MouseArea {
            anchors.fill: parent
            onClicked:{
                halfTimeRotate = !halfTimeRotate;
            }
        }
    }

    Text {
        text: "Half Time"
        color: appGrayText
        font.family: localFont.name
        font.pointSize: 15
        y: tick.y + 12
        anchors.left: tick.right
        anchors.leftMargin: 10

    }
    Text {
        text: "Check Notice"
        color: appGrayText
        font.family: localFont.name
        font.pointSize: 15
        anchors.left: tick.left
        anchors.top: tick.bottom
        anchors.topMargin: 7

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
                    }

                    cookTime = timeEntryTumbler.getTime();
                    backEnd.sendMessage("CookTime " + cookTime);
                    finalCheckTime = cookTime * 0.9
                }
            }
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    stackView.push({item:Qt.resolvedUrl("Screen_EnterFinalCheckTime.qml"), immediate:immediateTransitions});
                }
            }
        }
    }
}

