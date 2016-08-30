import QtQuick 2.3

Item {
    ButtonRight {
        id: pauseButton
        text: "PAUSE"
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
        }
    }

}
