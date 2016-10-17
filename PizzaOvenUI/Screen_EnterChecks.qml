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
        x: 75
        anchors.verticalCenter: doneButton.verticalCenter
        width: 300
        height: 2 * lineSpacing + 2
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
                text: "ROTATE PIZZA"
                width: parent.width
                height: lineSpacing
                checked: rootWindow.halfTimeRotate
            }
            MyCheckBox {
                id: radioFinalCheck
                text: "FINAL CHECK"
                width: parent.width
                height: lineSpacing
                checked: rootWindow.finalCheck
            }
//            Rectangle {
//                height: lineSpacing
//                width: parent.width
//                color: appBackgroundColor
//                ClickableTextBox {
//                    height: lineSpacing
//                    width: thisScreen.listTextWidth
//                    text: "FINAL CHECK"
//                    foregroundColor: appForegroundColor
//                    horizontalAlignment: Text.AlignLeft
//                    verticalAlignment: Text.AlignVCenter
//                    anchors.left: parent.left
//                    pointSize: 18
//                    onClicked: {
//                        finalCheckSlider.state = !finalCheckSlider.state
//                        finalCheckSlider.clicked();
//                    }
//                }
//                SlideOffOn{
//                    id: finalCheckSlider
//                    anchors.right: parent.right
//                    state: finalCheck
//                    onClicked: {
//                    }
//                    anchors.verticalCenter: parent.verticalCenter
//                }
//            }
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
                        if (preheatComplete) {
                            stackView.push({item:Qt.resolvedUrl("Screen_Cooking.qml"), immediate:immediateTransitions});
//                            stackView.push({item:Qt.resolvedUrl("Screen_Start.qml"), immediate:immediateTransitions});
                        } else {
                            stackView.push({item:Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
                        }
                    }
                }
            }
        }
    }
}
