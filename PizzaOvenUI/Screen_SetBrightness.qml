import QtQuick 2.3
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    property string screenName: "Screen_SetBrightness"

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}
    OpacityAnimator {id: screenExitAnimation; target: thisScreen; from: 1.0; to: 0.0; running:false}

    function screenEntry() {
        console.log("Entering set brightness screen");
        screenEntryAnimation.start();
        console.log("Brightness value is " + brightnessSetting);
    }

    property int tumblerHeight: 250 * screenScale
    property int tumblerRows: 5
    property int titleTextPointSize: 1
    property int titleTextToPointSize: titleTextSize

    property int currentBrightness: brightnessSetting

    property bool uiLoaded: false

    onCurrentBrightnessChanged: {
        if (uiLoaded){
            console.log("The brightness tumbler index changed.");
            console.log("Brightness is now " + brightnessSetting);
            appSettings.brightness = brightnessSetting;
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
        width: 300 * screenScale
        height: 30 * screenScale
        x: (parent.width - width) / 2
        color: appBackgroundColor
        anchors.verticalCenter: backButton.verticalCenter
//        border.color: "orange"
//        border.width: 1
        Text {
            id: idButtonText
            text: "BRIGHTNESS SETTING"
            font.family: localFont.name
            font.pointSize: 17 * screenScale
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: appGrayText
        }
        NumberAnimation on y {id: titleAnimation; from: (screenHeight-screenTitle.height)/2; to: 41 * screenScale }
    }

    Rectangle {
        id: radioBox
        anchors.horizontalCenter: parent.horizontalCenter
        //y: (screenTitle.y + screenTitle.height - radioBox.height + screenHeight) / 2
        anchors.verticalCenter: doneButton.verticalCenter
        width: 115 * screenScale
        height: 3 * lineSpacing + 2
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
                id: radioLow
                text: "Low"
                width: parent.width
                height: lineSpacing
                state: brightnessSetting === 20
                onClicked: {
                    brightnessSetting = 20
                }
            }
            MyRadioButton {
                id: radioMedium
                text: "Medium"
                width: parent.width
                height: lineSpacing
                state: brightnessSetting === 80
                onClicked: {
                    brightnessSetting = 80
                }
            }
            MyRadioButton {
                id: radioHigh
                text: "High"
                width: parent.width
                height: lineSpacing
                state: brightnessSetting === 255
                onClicked: {
                    brightnessSetting = 255
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
