import QtQuick 2.3

Item {
    id: thisTimer

//    property int maxRuntimeMinutes: 12 * 60
    property int maxRuntimeMinutes: 2
    property int timeRemaining: maxRuntimeMinutes

    signal autoShutoffTimeoutComplete()
    signal autoShutoffTimeoutWarning()

    function start() {
        timeRemaining = maxRuntimeMinutes;
        maxTimer.running = true;
        console.log("Auto shutoff timer started.");
    }

    function stop() {
        maxTimer.running = false;
        console.log("Auto shutoff timer stopped.");
    }

    function reset() {
        timeRemaining = maxRuntimeMinutes;
        console.log("Auto shutoff timer reset.");
    }

    Timer {
        id: maxTimer
        interval: 60000
        running: false
        repeat: true
        onTriggered: {
            if (timeRemaining > 0) {
                timeRemaining--;
                console.log("Time remaining is " + timeRemaining);
                if (timeRemaining == 0) {
                    maxTimer.running = false;
                    autoShutoffTimeoutComplete();
                }
//                if (timeRemaining == 5) {
                if (timeRemaining == 1) {
                    autoShutoffTimeoutWarning();
                }
            }
        }
    }
}
