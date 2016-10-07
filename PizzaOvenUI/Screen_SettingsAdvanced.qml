import QtQuick 2.3

Item {
    id: thisScreen

    property int listItemHeight: 40
    property int listItemWidth: screenWidth - screenTitle.x - 30
    property int listTextWidth: 300

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    function screenEntry() {
        screenEntryAnimation.start();
        console.log("Entering advanced settings.");
    }

    Item {
        id: scroller
        visible: false
        z: 1
        BackButton {
            id: backButton
            onClicked: {
                stackView.pop({immediate:immediateTransitions});
            }
        }

        ClickableTextBox {
            id: screenTitle
            text: "ADVANCED SETTINGS"
            x: 80
            width: 260
            anchors.verticalCenter: backButton.verticalCenter
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            onClicked: backButton.clicked()
        }

        Flickable {
            width: listItemWidth
            height: screenHeight - backButton.y - backButton.height - anchors.topMargin - 30
            anchors.topMargin: 10
            anchors.top: screenTitle.bottom
            x: screenTitle.x
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
                        text: "DEMO MODE"
                        foregroundColor: appForegroundColor
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.left
                        onClicked: {
                            demoModeSlider.state = !demoModeSlider.state
                            demoModeSlider.clicked();
                        }
                    }
                    SlideOffOn{
                        id: demoModeSlider
                        anchors.right: parent.right
                        state: demoModeIsActive
                        onClicked: {
                            if (demoModeIsActive != demoModeSlider.state) {
                                demoModeIsActive = demoModeSlider.state;
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
                        text: "MAX VOLUME"
                        foregroundColor: appForegroundColor
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.left
                        onClicked: {
                            maxVolumeForwardButton.clicked();
                        }
                    }
                    ForwardButton {
                        id: maxVolumeForwardButton
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: SequentialAnimation {
                            NumberAnimation {target: thisScreen; property: "opacity"; from: 1.0; to: 0.0;}
                            ScriptAction {script: {
                                    stackView.push({item: Qt.resolvedUrl("Screen_SettingMaxVolume.qml"), immediate:immediateTransitions});
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
        enabled: true
        visible: true
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
