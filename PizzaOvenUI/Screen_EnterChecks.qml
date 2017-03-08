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
    property int textWidth: 150
    property int optionLabelSize: 20

    property bool uiLoaded: false

    BackButton {
        id: backButton
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    ClickableTextBox {
        text: "PIZZA CHECK REMINDERS"
        foregroundColor: appGrayText
        width: 185
        height: 30
        x: screenWidth - width - 26
        y: 41
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        onClicked: {
            doneButton.clicked();
        }
    }

    Rectangle {
        id: checkBoxes
        anchors.verticalCenter: doneButton.verticalCenter
        x: 85
        width: 300
        height: 3 * lineSpacing + 2
        color: appBackgroundColor
        Column {
            Component.onCompleted: {
                uiLoaded = true;
            }
            width: parent.width - 2
            height: parent.height - 2
            x: 1
            y: 1
//            MyCheckBox {
//                id: radioRotate
//                text: "Half Done"
//                width: parent.width
//                height: lineSpacing
//                checked: rootWindow.halfTimeRotateAlertEnabled
//                opacity: rootWindow.pizzaAlertsDisabled ? 0.5 : 1.0
//                enabled: !rootWindow.pizzaAlertsDisabled
//            }
//            MyCheckBox {
//                id: radioFinalCheck
//                text: "Nearly Done"
//                width: parent.width
//                height: lineSpacing
//                checked: rootWindow.finalCheckAlertEnabled
//                opacity: rootWindow.pizzaAlertsDisabled ? 0.5 : 1.0
//                enabled: !rootWindow.pizzaAlertsDisabled
//            }
//            MyCheckBox {
//                id: radioDone
//                text: "Finished"
//                width: parent.width
//                height: lineSpacing
//                checked: rootWindow.pizzaDoneAlertEnabled
//                opacity: rootWindow.pizzaAlertsDisabled ? 0.5 : 1.0
//                enabled: !rootWindow.pizzaAlertsDisabled
//            }

            Row {
                width: parent.width
                height: lineSpacing
                anchors.right: parent.right
                spacing: 20
                ClickableTextBox {
                    height: lineSpacing
                    width: textWidth
                    text: "Rotate Pizza"
                    pointSize: optionLabelSize
                    onClicked: {
                        halfSlider.state = !halfSlider.state;
                    }
                    horizontalAlignment: Text.AlignRight
                    foregroundColor: appForegroundColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                SlideOffOn{
                    id: halfSlider
                    anchors.verticalCenter: parent.verticalCenter
                    state: rootWindow.halfTimeRotateAlertEnabled
                    trueText: "On"
                    falseText: "Off"
                }
            }
            Row {
                width: parent.width
                height: lineSpacing
                anchors.right: parent.right
                spacing: 20
                ClickableTextBox {
                    height: lineSpacing
                    width: textWidth
                    text: "Final Check"
                    pointSize: optionLabelSize
                    onClicked: {
                        finalSlider.state = !finalSlider.state;
                    }
                    horizontalAlignment: Text.AlignRight
                    foregroundColor: appForegroundColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                SlideOffOn{
                    id: finalSlider
                    anchors.verticalCenter: parent.verticalCenter
                    state: rootWindow.finalCheckAlertEnabled
                    trueText: "On"
                    falseText: "Off"
                }
            }
            Row {
                width: parent.width
                height: lineSpacing
                anchors.right: parent.right
                spacing: 20
                ClickableTextBox {
                    height: lineSpacing
                    width: textWidth
                    text: "Done"
                    pointSize: optionLabelSize
                    onClicked: {
                        finishedSlider.state = !finishedSlider.state;
                    }
                    horizontalAlignment: Text.AlignRight
                    foregroundColor: appForegroundColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                SlideOffOn{
                    id: finishedSlider
                    anchors.verticalCenter: parent.verticalCenter
                    state: rootWindow.pizzaDoneAlertEnabled
                    trueText: "On"
                    falseText: "Off"
                }
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
//                    halfTimeRotateAlertEnabled = radioRotate.checked;
//                    finalCheckAlertEnabled = radioFinalCheck.checked;
                    halfTimeRotateAlertEnabled = halfSlider.state;
                    finalCheckAlertEnabled = finalSlider.state;
                    rootWindow.pizzaDoneAlertEnabled = finishedSlider.state;
                    appSettings.rotatePizzaAlertEnabled = halfTimeRotateAlertEnabled;
                    appSettings.finalCheckAlertEnabled = finalCheckAlertEnabled;
                    appSettings.doneAlertEnabled = rootWindow.pizzaDoneAlertEnabled;
                    if (singleSettingOnly) {
                        if (!preheatComplete && ovenIsRunning()) {
                            rootWindow.maxPreheatTimer.restart();
                            stackView.clear();
                            stackView.push({item:Qt.resolvedUrl("Screen_Preheating2Temp.qml"), immediate:immediateTransitions});
                        } else {
                            restoreBookmarkedScreen();
                        }
                    } else {
                        stackView.clear();
                        if (ovenIsRunning()) {
                            if (!preheatComplete) {
                                rootWindow.maxPreheatTimer.restart();
                                stackView.push({item:Qt.resolvedUrl("Screen_Preheating2Temp.qml"), immediate:immediateTransitions});
                            } else {
                                stackView.push({item:Qt.resolvedUrl("Screen_Cooking.qml"), immediate:immediateTransitions});
                            }
                        } else {
                            stackView.push({item:Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
                        }
                    }
                }
            }
        }
    }
}
