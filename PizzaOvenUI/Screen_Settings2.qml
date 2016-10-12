import QtQuick 2.3

Item {
    id: thisScreen

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    property int listItemHeight: 50
    property int listItemWidth: screenWidth - screenTitle.x - 30
    property int listTextWidth: 300

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

    // title text
    Rectangle {
        id: screenTitle
        width: 400
        height: 30
        x: (parent.width - width) / 2
        //y: 41
        color: appBackgroundColor
        Text {
            id: idButtonText
            text: "SETTINGS"
            font.family: localFont.name
            font.pointSize: 17
            anchors.centerIn: parent
            color: appGrayText
        }
        NumberAnimation on y {id: titleAnimation; from: (screenHeight-screenTitle.height)/2; to: 41 }
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
                ClickableTextBox {
                    height: listItemHeight
                    width: thisScreen.listTextWidth
                    text: "TEMPERATURE UNITS"
                    foregroundColor: appForegroundColor
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                    onClicked: {
                        if (farenRadio.state) {
                            celciusRadio.clicked();
                        } else {
                            farenRadio.clicked();
                        }
                    }
                }

                Row {
                    anchors.right: parent.right
                    spacing: 10
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    MyRadioButton {
                        id: farenRadio
                        state: tempDisplayInF
                        height: listItemHeight
                        text: String.fromCharCode(8457)
                        onClicked: {
                            if (!tempDisplayInF) {
                                tempDisplayInF = !tempDisplayInF;
                                appSettings.tempDisplayInF = tempDisplayInF;
                            }
                        }
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    MyRadioButton {
                        id: celciusRadio
                        state: !tempDisplayInF
                        height: listItemHeight
                        text: String.fromCharCode(8451)
                        onClicked: {
                            if (tempDisplayInF) {
                                tempDisplayInF = !tempDisplayInF;
                                appSettings.tempDisplayInF = tempDisplayInF;
                            }
                        }
                        anchors.verticalCenter: parent.verticalCenter
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
                    text: "WiFi"
                    foregroundColor: appForegroundColor
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                    onClicked: {
                        wifiSlider.state = !wifiSlider.state
                        wifiSlider.clicked();
                    }
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
                ClickableTextBox {
                    height: listItemHeight
                    width: thisScreen.listTextWidth
                    text: "CONTROL LOCKOUT"
                    foregroundColor: appForegroundColor
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                ClickableTextBox {
                    height: listItemHeight
                    width: thisScreen.listTextWidth
                    text: "VOLUME"
                    foregroundColor: appForegroundColor
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
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
                ClickableTextBox {
                    height: listItemHeight
                    width: thisScreen.listTextWidth
                    text: "DISPLAY BRIGHTNESS"
                    foregroundColor: appForegroundColor
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                ClickableTextBox {
                    height: listItemHeight
                    width: thisScreen.listTextWidth
                    text: "CENTER SCREEN"
                    foregroundColor: appForegroundColor
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
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
                ClickableTextBox {
                    height: listItemHeight
                    width: thisScreen.listTextWidth
                    text: "ADVANCED"
                    foregroundColor: appForegroundColor
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
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
                ClickableTextBox {
                    height: listItemHeight
                    width: thisScreen.listTextWidth
                    text: "ABOUT"
                    foregroundColor: appForegroundColor
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
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
