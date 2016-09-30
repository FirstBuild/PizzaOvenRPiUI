import QtQuick 2.3

Item {
    id: thisScreen

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    property int listItemHeight: 50
    property int listItemWidth: screenWidth - screenTitle.x - 30

    function screenEntry() {
        screenEntryAnimation.start();
        console.log("Entering screen settings.");
    }

    BackButton{
        id: backButton
        opacity: 0.5
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }


    Text {
        id: screenTitle
        text: "SETTINGS"
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
        id: menu
        width: listItemWidth
        height: listItemHeight * 4.5
        y: (screenHeight + screenTitle.y + screenTitle.height - menu.height)/2
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
                    text: "TEMPERATURE UNITS"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Row {
                    anchors.right: parent.right
                    spacing: 10
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    Row {
                        height: listItemHeight
                        anchors.verticalCenter: parent.verticalCenter
                        MyRadioButton {
                            id: farenRadio
                            state: tempDisplayInF
                            onClicked: {
                                if (!tempDisplayInF) {
                                    tempDisplayInF = !tempDisplayInF;
                                    appSettings.tempDisplayInF = tempDisplayInF;
                                }
                            }
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: String.fromCharCode(8457)
                            color: appForegroundColor
                            font.family: localFont.name
                            font.pointSize: 18
                            verticalAlignment: Text.AlignVCenter
                            height: listItemHeight
                        }
                    }
                    Row {
                        height: listItemHeight
                        MyRadioButton {
                            id: celciusRadio
                            state: !tempDisplayInF
                            onClicked: {
                                if (tempDisplayInF) {
                                    tempDisplayInF = !tempDisplayInF;
                                    appSettings.tempDisplayInF = tempDisplayInF;
                                }
                            }
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: String.fromCharCode(8451)
                            color: appForegroundColor
                            font.family: localFont.name
                            font.pointSize: 18
                            verticalAlignment: Text.AlignVCenter
                            height: listItemHeight
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
                    text: "TWO TEMP MODE"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                SlideOffOn{
                    id: twoTempSlider
                    anchors.right: parent.right
                    state: twoTempEntryModeIsActive
                    onClicked: {
                        if (twoTempEntryModeIsActive != twoTempSlider.state) {
                            twoTempEntryModeIsActive = twoTempSlider.state;
                            appSettings.twoTempMode = twoTempEntryModeIsActive;
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
                    text: "WiFi"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                SlideOffOn{
                    id: wifiSlider
                    anchors.right: parent.right
                    state: false
                    onClicked: {
                    }
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "CONTROL LOCKOUT"
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
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "VOLUME"
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
                                stackView.push({item: Qt.resolvedUrl("Screen_SetVolume.qml"), immediate:immediateTransitions});
                            }
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
                    text: "DISPLAY BRIGHTNESS"
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
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "CENTER SCREEN"
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
                                stackView.push({item: Qt.resolvedUrl("Screen_ShiftScreenPosition.qml"), immediate:immediateTransitions});
                            }
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
                    text: "ADVANCED"
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
                                stackView.push({item: Qt.resolvedUrl("Screen_SettingsAdvanced.qml"), immediate:immediateTransitions});
                            }
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
                    text: "ABOUT"
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
                                stackView.push({item: Qt.resolvedUrl("Screen_About.qml"), immediate:immediateTransitions});
                            }
                        }
                    }
                }
            }
        }
    }
}
