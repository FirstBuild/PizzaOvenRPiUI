import QtQuick 2.3

Item {
    id: thisButton
    property bool needsAnimation: true
    signal clicked()
    property real cookTimerPausedShadow: rootWindow.cookTimer.paused

    ButtonRight {
        id: pauseButton
        text: "PAUSE"
        needsAnimation: thisButton.needsAnimation
        onClicked: {
            if (rootWindow.cookTimer.running)
            {
                rootWindow.cookTimer.pause();
                pauseButton.text = "RESUME"
            }
            else
            {
                rootWindow.cookTimer.resume();
                pauseButton.text = "PAUSE"
            }
            thisButton.clicked();
        }
    }

    onCookTimerPausedShadowChanged: {
        if (cookTimer.paused) {
            pauseButton.text = "RESUME"
        } else {
            pauseButton.text = "PAUSE"
        }
    }
}
