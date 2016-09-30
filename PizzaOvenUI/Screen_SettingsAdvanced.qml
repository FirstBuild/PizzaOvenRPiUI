import QtQuick 2.3

Item {
    id: thisScreen

    property int listItemHeight: 40
    property int listItemWidth: screenWidth - screenTitle.x - 30

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

        Text {
            id: screenTitle
            text: "ADVANCED SETTINGS"
            font.family: localFont.name
            font.pointSize: 18
            color: appGrayText
            width: 400
            height: 30
            x: 80
            anchors.verticalCenter: backButton.verticalCenter
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
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
                    Text {
                        height: listItemHeight
                        text: "DEMO MODE"
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 18
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.left
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
                    Text {
                        height: listItemHeight
                        text: "DEVELOPMENT MODE"
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 18
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.left
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
                    Text {
                        height: listItemHeight
                        text: "MAX VOLUME"
                        color: appForegroundColor
                        font.family: localFont.name
                        font.pointSize: 18
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.left
                    }
                    ForwardButton {
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
