import QtQuick 2.3

Item {
    id: thisTimer

    property int maxRuntimeMinutes: 3 * 60
    property int timeRemaining: maxRuntimeMinutes

    signal autoShutoffTimeoutComplete()
    signal autoShutoffTimeoutWarning()

    function start() {
        timeRemaining = maxRuntimeMinutes;
        maxTimer.running = true;
    }

    function stop() {
        maxTimer.running = false;
    }

    function reset() {
        timeRemaining = maxRuntimeMinutes;
    }

    Timer {
        id: maxTimer
        interval: 60000
        running: false
        repeat: true
        onTriggered: {
            if (timeRemaining > 0) {
                timeRemaining--;
                console.log("Time remaining is " + timeRemaining + " (" + Math.floor(timeRemaining/60) + " hours, " + timeRemaining%60 + " minutes)");
                if (timeRemaining == 0) {
                    maxTimer.running = false;
                    autoShutoffTimeoutComplete();
                }
                if (timeRemaining == 5) {
                    autoShutoffTimeoutWarning();
                }
            }
        }
    }
}
