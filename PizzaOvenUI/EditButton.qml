import QtQuick 2.3

Item {
    ButtonLeft {
        id: editButton
        text: "EDIT"
        onClicked: SequentialAnimation {
            ScriptAction {
                script: {
                    rootWindow.cookTimer.stop();
                }
            }
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    stackView.clear();
                    stackView.push({item:Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
                    stackView.completeTransition();
                    screenBookmark = stackView.currentItem;
                    if (twoTempEntryModeIsActive) {
                        stackView.push({item:Qt.resolvedUrl("Screen_EnterDomeTemp.qml"), immediate:immediateTransitions});
                    } else {
                        stackView.push({item:Qt.resolvedUrl("Screen_TemperatureEntry.qml"), immediate:immediateTransitions});
                    }
                }
            }
        }
    }
}
