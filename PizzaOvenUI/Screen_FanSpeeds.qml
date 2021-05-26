import QtQuick 2.3

Item {
    id: thisScreen

    width: screenWidth
    height: screenHeight
    property int listItemHeight: lineSpacing
    property int listItemWidth: screenWidth - screenTitle.x - 30
    property int listTextWidth: 300 * screenScale
    property string screenName: "Screen_FanSpeeds"

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    function screenEntry() {
        console.log("Entering advanced settings 2 screen");
        screenEntryAnimation.start();
        getFanSpeeds();
    }

    BackButton {
        id: backButton
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    function getFanSpeeds() {
        backEnd.sendMessage("GetFanSpeeds ");
    }

    function setFanSpeeds() {
        backEnd.sendMessage("SetFanSpeeds " + (preheatFanSpeedRadio.radioState ? '1' : '0') + " " + (cookingFanSpeedRadio.radioState ? '1' : '0'));
    }

    // title text
    Rectangle {
        id: screenTitle
        width: 400 * screenScale
        height: 30 * screenScale
        color: appBackgroundColor
        anchors.verticalCenter: backButton.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: idTitleText
            text: "FAN SPEED SETTINGS"
            font.family: localFont.name
            font.pointSize: titleTextSize
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: appGrayText
        }
        NumberAnimation on y {id: titleAnimation; from: (screenHeight-screenTitle.height)/2; to: 41 * screenScale }
    }

    MyTwoButtonRadioWithLabel {
        id: preheatFanSpeedRadio
        anchors.top: screenTitle.bottom
        anchors.topMargin: 10 * screenScale
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.75
        height: lineSpacing
        label: "PREHEAT"
        leftText: "LOW"
        rightText: "HIGH"
        radioState: preheatFanSetting == 1
        onRadioStateChanged: {
            console.log("The radio state changed and is now " + radioState);
            setFanSpeeds();
        }
    }

    MyTwoButtonRadioWithLabel {
        id: cookingFanSpeedRadio
        anchors.top: preheatFanSpeedRadio.bottom
        anchors.topMargin: 10 * screenScale
        anchors.left: preheatFanSpeedRadio.left
        width: preheatFanSpeedRadio.width
        height: lineSpacing
        label: "COOKING"
        leftText: "LOW"
        rightText: "HIGH"
        radioState: cookingFanSetting == 1
        onRadioStateChanged: {
            console.log("The radio state changed and is now " + radioState);
            setFanSpeeds();
        }
    }
}
