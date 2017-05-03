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
        backEnd.sendMessage("Wifi_Get_MAC ");
        backEnd.sendMessage("Wifi_GetConnectionState ");
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
            text: "WIFI SETTINGS"
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
                        wifiSlider.state = !wifiSlider.state
                        wifiSlider.clicked();
                    }
                }
                SlideOffOn{
                    id: wifiSlider
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    state: wifiConnectionState != 0
                    onClicked: {
                    }
                }
            }
            ClickableTextBox {
                text: "WIFI STATE: " + wifiConnectionState
                width: parent.width
                horizontalAlignment: Text.AlignLeft
                foregroundColor: appForegroundColor
            }
            ClickableTextBox {
                text: "MAC ID: " + wifiMacId
                width: parent.width
                horizontalAlignment: Text.AlignLeft
                foregroundColor: appForegroundColor
            }
        }
    }
}
