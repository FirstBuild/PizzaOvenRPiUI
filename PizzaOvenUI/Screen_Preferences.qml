import QtQuick 2.3
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.0

Item {
    id: thisScreen

    opacity: 0.0

    property string targetScreen: ""

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    SequentialAnimation {
        id: screenExitAnimator
        OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0}
        ScriptAction {
            script: {
                stackView.push({item: Qt.resolvedUrl(targetScreen), immediate:immediateTransitions});
            }
        }
    }

    function screenEntry() {
        screenEntryAnimation.start();
    }

    BackButton{
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
        //y: 41
        color: appBackgroundColor
        Text {
            id: idButtonText
            text: "PREFERENCES"
            font.family: localFont.name
            font.pointSize: 17
            anchors.centerIn: parent
            color: appGrayText
        }
        NumberAnimation on y {id: titleAnimation; from: (screenHeight-screenTitle.height)/2; to: 41 }
    }

    Rectangle {
        id: content
        width: 400
        height: 4 * lineSpacing
        x: 80
        y: 85
        color: appBackgroundColor
        Column {
            width: parent.width
            height: parent.height
            anchors.left: parent.left
            ClickableTextBox {
                text: "ADVANCED"
                width: parent.width
                horizontalAlignment: Text.AlignLeft
                foregroundColor: appForegroundColor
                onClicked: {
                    targetScreen = "Screen_SettingsAdvanced.qml";
                    singleSettingOnly = true;
                    bookmarkCurrentScreen();
                    screenExitAnimator.start();
                }
            }
            Item {
                height: lineSpacing
                width: parent.width
                ClickableTextBox {
                    height: lineSpacing
                    width: 200
                    text: "WI-FI"
                    foregroundColor: appForegroundColor
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        targetScreen = "Screen_WiFi.qml";
                        singleSettingOnly = true;
                        bookmarkCurrentScreen();
                        screenExitAnimator.start();
                    }
                }
            }
//            Item {
//                height: lineSpacing
//                width: parent.width
//                ClickableTextBox {
//                    height: lineSpacing
//                    width: 200
//                    text: "WI-FI"
//                    foregroundColor: appForegroundColor
//                    horizontalAlignment: Text.AlignLeft
//                    verticalAlignment: Text.AlignVCenter
//                    anchors.left: parent.left
//                    anchors.verticalCenter: parent.verticalCenter
//                    onClicked: {
//                        wifiSlider.state = !wifiSlider.state
//                        wifiSlider.clicked();
//                    }
//                }
//                SlideOffOn{
//                    id: wifiSlider
//                    anchors.right: parent.right
//                    anchors.verticalCenter: parent.verticalCenter
//                    state: false
//                    onClicked: {
//                    }
//                }
//            }
            ClickableTextBox {
                text: "RESET DEFAULTS"
                width: parent.width
                horizontalAlignment: Text.AlignLeft
                foregroundColor: appForegroundColor
            }
            Item {
                width: parent.width
                height: lineSpacing
                ClickableTextBox {
                    text: "TEMPERATURE UNITS"
                    width: parent.width
                    horizontalAlignment: Text.AlignLeft
                    foregroundColor: appForegroundColor
                    backgroundColor: appBackgroundColor
                    onClicked: {
                        tempDisplayInF = !tempDisplayInF;
                        appSettings.tempDisplayInF = tempDisplayInF;
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
                        height: lineSpacing
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
                        height: lineSpacing
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
        }
    }
}
