import QtQuick 2.3

Item {
    id: thisScreen
    property string screenName: "Screen_SettingsTime"
    width: screenWidth
    height: screenHeight
    property int listItemHeight: lineSpacing
    property int listItemWidth: 500
    property int listTextWidth: 350
    property int itemSeparation: 0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    function screenEntry() {
        console.log("Entering time settings screen");
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
        width: 500
        height: 40
        color: appBackgroundColor
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backButton.verticalCenter
//        border.color: "orange"
//        border.width: 1
        Text {
            id: idButtonText
            text: "TIME SETTINGS"
            font.family: localFont.name
            font.pointSize: 1
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: appGrayText
            NumberAnimation on font.pointSize {id: titleAnimation; from: 1; to: titleTextSize }
        }
    }

    Rectangle {
        id: enableTimeSliderBox
        height: listItemHeight
        width: listItemWidth
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: screenTitle.bottom
        anchors.topMargin: itemSeparation
        color: appBackgroundColor
        ClickableTextBox {
            height: listItemHeight
            width: thisScreen.listTextWidth
            text: "SHOW TIME"
            foregroundColor: appForegroundColor
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            anchors.left: parent.left
            onClicked: {
                timeOfDaySlider.state = !timeOfDaySlider.state
                timeOfDaySlider.clicked();
            }
        }
        SlideOffOn{
            id: timeOfDaySlider
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            state: timeOfDayDisplayed
            onClicked: {
                if (timeOfDayDisplayed != timeOfDaySlider.state) {
                    timeOfDayDisplayed = timeOfDaySlider.state;
                    appSettings.timeOfDayDisplayed = timeOfDayDisplayed;
                }
            }
        }
    }

    ClickableTextBox {
        id: setTimeButton
        height: listItemHeight
        width: listItemWidth
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: enableTimeSliderBox.bottom
        anchors.topMargin: itemSeparation

        foregroundColor: appGrayText
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        text: "SET TIME"
        pointSize: titleTextSize
        onClicked: {
            console.log("SET TIME button clicked");
            stackView.push({item: Qt.resolvedUrl("Screen_SetTimeOfDay.qml"), immediate:immediateTransitions});
        }
    }
}
