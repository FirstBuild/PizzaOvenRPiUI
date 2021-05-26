import QtQuick 2.3

Item {
    id: thisScreen
    property string screenName: "Screen_ProgramControl"

    opacity: 0.0
    property bool needsAnimation: true
    property int buttonWidth: 125
    property int buttonOffset: screenWidth/2 - buttonWidth- 20

    property int yesX: needsAnimation ? (screenWidth - buttonWidth)/2 : buttonOffset
    property int noX: needsAnimation ? (screenWidth - buttonWidth)/2 : screenWidth-buttonOffset-buttonWidth

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}
    PropertyAnimation on yesX { id: movementAnimYes; from: (screenWidth - buttonWidth)/2; to: buttonOffset; running: needsAnimation}
    PropertyAnimation on noX { id: movementAnimNo; from: (screenWidth - buttonWidth)/2; to: screenWidth-buttonOffset-buttonWidth; running: needsAnimation}

    property bool nowProgramming: controlBoardProgrammingInProgress

    function screenEntry() {
        console.log("Entering program control screen");
        screenEntryAnimation.start();
    }

    BackButton {
        id: backButton
        onClicked: {
            programmingStatusTimer.running = false;
            stackView.pop({immediate:immediateTransitions});
        }
    }

    // title text
    Rectangle {
        id: screenTitle
        width: 400
        height: 30
        x: (parent.width - width) / 2
        color: appBackgroundColor
        anchors.verticalCenter: backButton.verticalCenter
        Text {
            id: idButtonText
            text: "PROGRAM CONTROL"
            font.family: localFont.name
            font.pointSize: titleTextSize
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: appGrayText
        }
        NumberAnimation on y {id: titleAnimation; from: (screenHeight-screenTitle.height)/2; to: 41 }
    }

    SideButton {
        id: yesButton
        buttonText: "YES"
        width: buttonWidth
        height: lineSpacing
        y: 170
        x: yesX
        onClicked: {
            controlBoardProgrammingInProgress = true;
            backEnd.sendMessage("ProgramControlBoard ");
            programmingStatusTimer.running = true;
            programmingInProgressDialog.visible = true;
        }
    }

    Timer {
        id: programmingStatusTimer
        interval: 1500
        repeat: true
        running: false
        onTriggered: {
            backEnd.sendMessage("IsControlBoardBeingProgrammed ");
        }
    }

    onNowProgrammingChanged: {
        if (!nowProgramming) {
            programmingStatusTimer.running = false;
            programmingInProgressDialog.visible = false;
            programmingCompleteDialog.visible = true;
        }
    }

    SideButton {
        id: noButton
        buttonText: "NO"
        width: buttonWidth
        height: lineSpacing
        y: 170
        x: noX
        onClicked: {
            programmingStatusTimer.running = false;
            stackView.pop({immediate:immediateTransitions});
        }
    }

    Text {
        text: "CONTINUE PROGRAMMING?"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: yesButton.top
        anchors.bottomMargin: 20
        font.family: localFont.name
        font.pointSize: 17
        color: appGrayText
    }

    DialogNotifyNoButton{
        id: programmingInProgressDialog
        visible: false
        dialogMessage: "Programming in progress"
    }

    DialogWithCheckbox {
        id: programmingCompleteDialog
        visible: false
        dialogMessage: "Programming complete"
        onClicked: {
            backButton.clicked();
        }
    }
}
