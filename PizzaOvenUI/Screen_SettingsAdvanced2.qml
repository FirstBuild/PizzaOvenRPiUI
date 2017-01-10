import QtQuick 2.3

Item {
    id: thisScreen

    property int listItemHeight: lineSpacing
    property int listItemWidth: screenWidth - screenTitle.x - 30
    property int listTextWidth: 300

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    function screenEntry() {
        screenEntryAnimation.start();
    }

    Item {
        id: scroller
        visible: true
        z: 1
        x: 0
        y: 0
        width: screenWidth
        height: screenHeight
        BackButton {
            id: backButton
            onClicked: {
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
                text: "ADVANCED SETTINGS"
                font.family: localFont.name
                font.pointSize: 17
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: appGrayText
            }
            NumberAnimation on y {id: titleAnimation; from: (screenHeight-screenTitle.height)/2; to: 41 }
        }

        Flickable {
            width: listItemWidth
            height: screenHeight - backButton.y - backButton.height - anchors.topMargin - 30
            anchors.topMargin: 10
            anchors.top: screenTitle.bottom
            x: 80
            contentWidth: listItemWidth
            contentHeight: settingsList.height
            clip: true
            Column {
                id: settingsList
                width: parent.width
                Rectangle {
                    height: listItemHeight
                    width: parent.width
                    color: appBackgroundColor
                    ClickableTextBox {
                        height: listItemHeight
                        width: thisScreen.listTextWidth
                        text: "DEVELOPMENT MODE"
                        foregroundColor: appForegroundColor
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.left
                        onClicked: {
                            devModeSlider.state = !devModeSlider.state
                            devModeSlider.clicked();
                        }
                    }
                    SlideOffOn{
                        id: devModeSlider
                        anchors.right: parent.right
                        state: developmentModeIsActive
                        onClicked: {
                            if (developmentModeIsActive != devModeSlider.state) {
                                developmentModeIsActive = devModeSlider.state;
                            }
                        }
                    }
                }
                Rectangle {
                    height: listItemHeight
                    width: parent.width
                    color: appBackgroundColor
                    ClickableTextBox {
                        height: listItemHeight
                        width: thisScreen.listTextWidth
                        text: "PROGRAM CONTROL"
                        foregroundColor: appForegroundColor
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.left
                        onClicked: SequentialAnimation {
                            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0}
                            ScriptAction {
                                script: {
                                    bookmarkCurrentScreen();
                                    stackView.push({item: Qt.resolvedUrl("Screen_ProgramControl.qml"), immediate:immediateTransitions});
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    TempEntryWithKeys {
        id: pinEntry
        z: 10
        enabled: false
        visible: false
        obscureEntry: true
        header: "Enter PIN"
        value: ""
        onDialogCanceled: {
            stackView.pop({immediate:immediateTransitions});
        }
        onDialogCompleted: SequentialAnimation {
            id: checkAnim
            ScriptAction {
                script: {
                    if (pinEntry.value != "40208") {
                        sounds.alarmUrgent.play();
                        messageDialog.visible = true;
                        checkAnim.stop();
                    }
                }
            }
            NumberAnimation {target: thisScreen; property: "opacity"; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    pinEntry.enabled = false;
                    pinEntry.visible = false;
                    scroller.visible = true;
                }
            }
            NumberAnimation {target: thisScreen; property: "opacity"; from: 0.0; to: 1.0;}
        }
    }
    DialogWithCheckbox {
        z: 20
        id: messageDialog
        dialogMessage: "The PIN you entered is incorrect."
    }
}
