import QtQuick 2.3
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}
    OpacityAnimator {id: screenExitAnimation; target: thisScreen; from: 1.0; to: 0.0; running:false}

    function screenEntry() {
        screenEntryAnimation.start();
        console.log("Entering volume settings.");
    }

    property int tumblerHeight: 250
    property int tumblerRows: 5
    property int titleTextPointSize: 1
    property int titleTextToPointSize: 18

    property int currentVolume: volumeSetting

    property bool uiLoaded: false

    onCurrentVolumeChanged: {
        if (uiLoaded){
            console.log("The volume tumbler index changed.");
            console.log("Volume is now " + volumeSetting);
            appSettings.volumeSetting = volumeSetting;
            sounds.touch.play();
        }
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
        width: 300
        height: 30
        x: (parent.width - width) / 2
        color: appBackgroundColor
        anchors.verticalCenter: backButton.verticalCenter
//        border.color: "orange"
//        border.width: 1
        Text {
            id: idButtonText
            text: "VOLUME SETTING"
            font.family: localFont.name
            font.pointSize: 17
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: appGrayText
        }
        NumberAnimation on y {id: titleAnimation; from: (screenHeight-screenTitle.height)/2; to: 41 }
    }

    Rectangle {
        id: radioBox
        anchors.horizontalCenter: parent.horizontalCenter
        //y: (screenTitle.y + screenTitle.height - radioBox.height + screenHeight) / 2
        anchors.verticalCenter: doneButton.verticalCenter
        width: 115
        height: 4 * lineSpacing + 2
//        border.color: "orange"
//        border.width: 1
        color: appBackgroundColor
        Column {
            Component.onCompleted: {
                uiLoaded = true;
            }
            width: parent.width - 2
            height: parent.height - 2
            x: 1
            y: 1
            MyRadioButton {
                id: radioOff
                text: "Off"
                width: parent.width
                height: lineSpacing
                state: volumeSetting === 0
                silent: true
                onClicked: {
                    volumeSetting = 0
                }
            }
            MyRadioButton {
                id: radioLow
                text: "Low"
                width: parent.width
                height: lineSpacing
                state: volumeSetting === 7
                silent: true
                onClicked: {
                    volumeSetting = 7
                }
            }
            MyRadioButton {
                id: radioMedium
                text: "Medium"
                width: parent.width
                height: lineSpacing
                state: volumeSetting === 8
                silent: true
                onClicked: {
                    volumeSetting = 8
                }
            }
            MyRadioButton {
                id: radioHigh
                text: "High"
                width: parent.width
                height: lineSpacing
                state: volumeSetting === 9
                silent: true
                onClicked: {
                    volumeSetting = 9
                }
            }
        }
    }

    ButtonRight {
        id: doneButton
        text: "DONE"
        onClicked: SequentialAnimation {
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0; /*easing.type: Easing.InCubic*/}
            ScriptAction {
                script: {
                    restoreBookmarkedScreen();
                }
            }
        }
    }
}
