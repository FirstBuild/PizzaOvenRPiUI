import QtQuick 2.3

Item {
    id: thisButton

    property bool needsAnimation: true

    function animate() {
        if (thisButton.needsAnimation) {
            editButton.animate();
        }
    }

    ButtonLeft {
        id: editButton
        text: "EDIT"
        needsAnimation: thisButton.needsAnimation
        onClicked: SequentialAnimation {
            ScriptAction {
                script: {
                    rootWindow.cookTimer.stop();
                }
            }
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    rootWindow.cookTimer.reset();
                    stackView.clear();
                    singleSettingOnly = false;
                    stackView.push({item:Qt.resolvedUrl("Screen_EnterDomeTemp.qml"), immediate:immediateTransitions});
                }
            }
        }
    }
}
