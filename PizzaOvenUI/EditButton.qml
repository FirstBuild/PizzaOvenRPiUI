import QtQuick 2.3

Item {
    id: thisButton

    property bool needsAnimation: true

    function animate() {
        if (thisButton.needsAnimation) {
            console.log("Animating the button");
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
                    stackView.clear();
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
