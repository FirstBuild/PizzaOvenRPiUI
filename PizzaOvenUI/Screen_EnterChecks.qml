import QtQuick 2.3
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    function screenEntry() {
        screenEntryAnimation.start();
        console.log("Entering checks settings.");
    }

    property int titleTextPointSize: 1
    property int titleTextToPointSize: 18

    property bool uiLoaded: false

    BackButton {
        id: backButton
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    // title text
//    Rectangle {
//        id: screenTitle
//        width: 300
//        height: 30
//        x: (parent.width - width) / 2
//        color: appBackgroundColor
//        anchors.verticalCenter: backButton.verticalCenter
////        border.color: "orange"
////        border.width: 1
//        Text {
//            id: idButtonText
//            text: "NOTIFICATIONS"
//            font.family: localFont.name
//            font.pointSize: 17
//            anchors.centerIn: parent
//            horizontalAlignment: Text.AlignLeft
//            verticalAlignment: Text.AlignVCenter
//            color: appGrayText
//        }
//        NumberAnimation on y {id: titleAnimation; from: (screenHeight-screenTitle.height)/2; to: 41 }
//    }

    ClickableTextBox {
        text: "Notification Selections"
        foregroundColor: appGrayText
        width: 185
        height: 30
        x: screenWidth - width - 26
        y: 41
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        onClicked: doneButton.clicked()
    }

    Rectangle {
        id: checksBoxes
        x: 200
        anchors.verticalCenter: doneButton.verticalCenter
        width: 200
        height: 2 * lineSpacing + 2
        border.color: "orange"
        border.width: 1
        color: appBackgroundColor
        Column {
            Component.onCompleted: {
                uiLoaded = true;
            }
            width: parent.width - 2
            height: parent.height - 2
            x: 1
            y: 1
            MyCheckBox {
                id: radioRotate
                text: "Rotate Pizza"
                width: parent.width
                height: lineSpacing
                checked: rootWindow.halfTimeRotate
            }
            MyCheckBox {
                id: radioFinalCheck
                text: "Final Check"
                width: parent.width
                height: lineSpacing
                checked: rootWindow.finalCheck
            }
        }
    }

    ButtonRight {
        id: doneButton
        text: "DONE"
        onClicked: SequentialAnimation {
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    halfTimeRotate = radioRotate.checked;
                    finalCheck = radioFinalCheck.checked;
                    appSettings.rotatePizza = halfTimeRotate;
                    appSettings.finalCheck = finalCheck;
                    if (singleSettingOnly) {
                        restoreBookmarkedScreen();
                    } else {
                        stackView.clear();
                        stackView.push({item:Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
                    }
                }
            }
        }
    }
}
