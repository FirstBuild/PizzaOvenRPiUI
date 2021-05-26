import QtQuick 2.3
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    property string screenName: "Screen_EnterChecks"

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    function screenEntry() {
        screenEntryAnimation.start();
        console.log("Entering enter checks screen.");
    }

    function cleanUpOnExit() {
        screenExitAnimation.stop();
    }

    property int titleTextPointSize: 1
    property int titleTextToPointSize: 18 * screenScale
    property int textWidth: 150 * screenScale
    property int optionLabelSize: 20 * screenScale

    property bool uiLoaded: false

    BackButton {
        id: backButton
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    ClickableTextBox {
        text: "FOOD CHECK REMINDERS"
        foregroundColor: appGrayText
        width: 185 * screenScale
        height: 30 * screenScale
        x: screenWidth - width - 26 * screenScale
        y: 41 * screenScale
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        onClicked: {
            doneButton.clicked();
        }
    }

    Rectangle {
        id: checkBoxes
        anchors.verticalCenter: doneButton.verticalCenter
        x: 85 * screenScale
        width: 300 * screenScale
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

            Row {
                width: parent.width
                height: lineSpacing
                anchors.right: parent.right
                spacing: 20 * screenScale
                ClickableTextBox {
                    height: lineSpacing
                    width: textWidth
                    text: "Rotate Food"
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
                spacing: 20 * screenScale
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
                spacing: 20 * screenScale
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

    SequentialAnimation {
        id: screenExitAnimation
        OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
        ScriptAction {
            script: {
                halfTimeRotateAlertEnabled = halfSlider.state;
                finalCheckAlertEnabled = finalSlider.state;
                rootWindow.pizzaDoneAlertEnabled = finishedSlider.state;
                appSettings.rotatePizzaAlertEnabled = halfTimeRotateAlertEnabled;
                appSettings.finalCheckAlertEnabled = finalCheckAlertEnabled;
                appSettings.doneAlertEnabled = rootWindow.pizzaDoneAlertEnabled;
                console.log("Sending updated reminder settings to backend.");
                utility.updateReminderSettingsOnBackend();

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

    ButtonRight {
        id: doneButton
        text: "DONE"
        onClicked: screenExitAnimation.start();
    }
}
