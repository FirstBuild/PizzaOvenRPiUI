import QtQuick 2.3
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.0

Item {
    id: thisScreen

    opacity: 0.0

    property string targetScreen: ""

    property variant wifiStateNames: ["OFF", "AP MODE", "CONNECTING", "CONNECTED", "CONNECTED/OFF", "SCANNING", "RECONNECTING"]
    property int pointSize: 18
    property int textPointSize: 1
    property int labelWidth: 200

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    SequentialAnimation {
        id: screenExitAnimator
        OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0}
        ScriptAction {
            script: {
                queryWifiState.stop();
                stackView.push({item: Qt.resolvedUrl(targetScreen), immediate:immediateTransitions});
            }
        }
    }

    NumberAnimation on textPointSize {
        id: titleTextAnim
        from: 1
        to: pointSize
        running: true
    }

    function screenEntry() {
        console.log("Entering wifi screen");
        screenEntryAnimation.start();
        queryWifiState.start();
    }

    Timer {
        id: queryWifiState
        repeat: true
        running: false
        interval: 2000
        triggeredOnStart: true
        onTriggered: {
            console.log("Connection state is currently " + wifiConnectionState);
            backEnd.sendMessage("Wifi_GetConnectionState ");
        }
    }

    BackButton{
        id: backButton
        onClicked: {
            queryWifiState.stop();
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
            text: "WI-FI SETTINGS"
            font.family: localFont.name
            font.pointSize: 17
            anchors.centerIn: parent
            color: appGrayText
        }
        NumberAnimation on y {id: titleAnimation; from: (screenHeight-screenTitle.height)/2; to: 41 }
    }

    WifiIcon {
        id: wifiIcon
        anchors.verticalCenter: screenTitle.verticalCenter
        anchors.left: screenTitle.right
        anchors.leftMargin: 10
        blinking: !((wifiConnectionState == 3) || (wifiConnectionState == 4) || (wifiConnectionState == 0))
        color: (wifiConnectionState == 0) ? appBackgroundColor : ((wifiConnectionState == 4) ? appGrayColor : appForegroundColor)
    }

    Rectangle {
        id: content
        x: 80
        y: 85
        width: 400
        height: parent.height - y - 1
        color: appBackgroundColor
        Column {
            width: parent.width
            height: parent.height - 1
            anchors.left: parent.left

            Row {
                width: parent.width
                height: parent.height/5
                ClickableTextBox {
                    height: parent.height
                    width: labelWidth
                    horizontalAlignment: Text.AlignLeft
                    text: "WI-FI"
                    foregroundColor: appForegroundColor
                    verticalAlignment: Text.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    onClicked: {
                        wifiSlider.clicked();
                    }
                }
                SlideOffOn{
                    id: wifiSlider
                    anchors.verticalCenter: parent.verticalCenter
                    state: (wifiConnectionState != 0) && (wifiConnectionState != 4)
                    onClicked: {
                        queryWifiState.restart();
                        switch (wifiConnectionState) {
                        case 0:
                            backEnd.sendMessage("Wifi_SetConnectionState 1");
                            wifiConnectionState = 1;
                            break;
                        case 1:
                            backEnd.sendMessage("Wifi_SetConnectionState 0");
                            wifiConnectionState = 0;
                            break;
                        case 3:
                            backEnd.sendMessage("Wifi_SetConnectionState 4");
                            wifiConnectionState = 4;
                            break;
                        case 4:
                            backEnd.sendMessage("Wifi_SetConnectionState 6");
                            wifiConnectionState = 6;
                            break;
                        }
                    }
                }
            }
            Row {
                height: parent.height/5
                width: parent.width
                Text {
                    text: "SSID"
                    width: labelWidth
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: appGrayText
                    height: parent.height
                    font.family: localFont.name
                    font.pointSize: textPointSize
                }
                Text {
                    text: wifiSsid
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: appGrayText
                    height: parent.height
                    font.family: localFont.name
                    font.pointSize: textPointSize
                }
            }
            Row {
                height: parent.height/5
                width: parent.width
                Text {
                    text: "PASSPHRASE"
                    width: labelWidth
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: appGrayText
                    height: parent.height
                    font.family: localFont.name
                    font.pointSize: textPointSize
                }
                Text {
                    text: wifiPassphrase
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    color: appGrayText
                    height: parent.height
                    font.family: localFont.name
                    font.pointSize: textPointSize
                }
            }
            ClickableTextBox {
                width: parent.width
                height: parent.height/5
                text: wifiConnectionState == 0 ? "ENABLE APP CONTROL" : "DISABLE APP CONTROL"
                horizontalAlignment: Text.AlignLeft
                foregroundColor: appForegroundColor
                onClicked: {
                    if (wifiConnectionState == 0) {
                        wifiSlider.clicked();
                    } else {
                        messageDialog.visible = true
                    }
                }
            }
        }
    }

    DialogWithYesNoButtons {
        id: messageDialog
        pointSize: 17
        dialogMessage: "ARE YOU SURE YOU WANT TO DISABLE APP CONTROL?"
        onClicked: {
            console.log("The result is " + messageDialog.result);
            if (messageDialog.result == "YES") {
                backEnd.sendMessage("Wifi_SetConnectionState 0");
                wifiConnectionState = 0;
            }
        }
    }
}
