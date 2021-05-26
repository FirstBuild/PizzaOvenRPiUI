import QtQuick 2.3

Item {
    id: thisScreen
    property string screenName: "Screen_ResetDoor"
    width: screenWidth
    height: screenHeight

    opacity: 0.0
    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    function screenEntry() {
        console.log("Entering advanced settings screen");
        screenEntryAnimation.start();
    }

    BackButton {
        id: backButton
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    // title text
    Rectangle {
        id: screenTitle
        width: 400 * screenScale
        height: 30 * screenScale
        x: (parent.width - width) / 2
        color: appBackgroundColor
        anchors.verticalCenter: backButton.verticalCenter
        Text {
            id: idButtonText
            text: "RESET DOOR"
            font.family: localFont.name
            font.pointSize: titleTextSize
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: appGrayText
        }
        NumberAnimation on y {id: titleAnimation; from: (screenHeight-screenTitle.height)/2; to: 41 * screenScale }
    }

    Text {
        id: doorLatchStateText
        text: rootWindow.doorLatchState == 1 ? "DOOR LATCH LOCKED" : "DOOR LATCH UNLOCKED"
        color: appForegroundColor
        font.family: localFont.name
        font.pointSize: 18 * screenScale
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.top: screenTitle.bottom
        anchors.topMargin: 20 * screenScale
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: doorLatchMotorStateText
        text: rootWindow.lowerRear.elementRelay == 1 ? "LATCH MOTOR ON" : "LATCH MOTOR OFF"
        color: appForegroundColor
        font.family: localFont.name
        font.pointSize: 18 * screenScale
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        anchors.top: doorLatchStateText.bottom
        anchors.topMargin: 20 * screenScale
        anchors.horizontalCenter: parent.horizontalCenter
    }

    SideButton {
        id: toggleButton
        buttonText: "RUN MOTOR"
        width: 200 * screenScale
        height: lineSpacing
        pointSize: 18 * screenScale
        enabled: rootWindow.lowerRear.elementRelay == 0
        visible: enabled
        anchors.top: doorLatchMotorStateText.bottom
        anchors.topMargin: 20 * screenScale
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            backEnd.sendMessage("ToggleLatchMotor ");
        }
    }
}
