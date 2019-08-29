import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen

    implicitWidth: parent.width
    implicitHeight: parent.height

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    function screenEntry() {
        console.log("Entering shift screen position screen");
        screenEntryAnimation.start();
    }

    property int myMargins: 10

    Rectangle {
        width: parent.width
        height: parent.height
        border.width: 1
        border.color: "red"
        color: appBackgroundColor
    }

    SideButton {
        id: doneButton
        buttonText: "DONE"
        anchors.margins: myMargins
        anchors.centerIn: parent
        onClicked: SequentialAnimation {
            ScriptAction {
                script: {
                    appSettings.screenOffsetX = screenOffsetX;
                    appSettings.screenOffsetY = screenOffsetY;
                }
            }
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0; /*easing.type: Easing.InCubic*/}
            ScriptAction {
                script: {
                    stackView.clear();
                    stackView.push({item: Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    SideButton {
        id: upButton
        buttonText: "UP"
        anchors.margins: myMargins
        anchors.horizontalCenter: doneButton.horizontalCenter
        anchors.bottom: doneButton.top
        onClicked: {
            screenOffsetY -= 5;
            if (screenOffsetY < 0) screenOffsetY = 0;
        }
    }
    SideButton {
        id: downButton
        buttonText: "DOWN"
        anchors.margins: myMargins
        anchors.horizontalCenter: doneButton.horizontalCenter
        anchors.top: doneButton.bottom
        onClicked: {
            screenOffsetY += 5;
        }
    }
    SideButton {
        id: leftButton
        buttonText: "LEFT"
        anchors.margins: myMargins
        anchors.verticalCenter: doneButton.verticalCenter
        anchors.right: doneButton.left
        onClicked: {
            screenOffsetX -= 5;
            if (screenOffsetX < 0) screenOffsetX = 0;
        }
    }
    SideButton {
        id: rightButton
        buttonText: "RIGHT"
        anchors.margins: myMargins
        anchors.verticalCenter: doneButton.verticalCenter
        anchors.left: doneButton.right
        onClicked: {
            screenOffsetX += 5;
        }
    }

}
