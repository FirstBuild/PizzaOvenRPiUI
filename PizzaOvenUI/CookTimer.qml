import QtQuick 2.3

Item {
    id: thisTimer

    property int interval: cookTime
    property real value: 0.0
    property bool running: animation.running && !animation.paused
    property bool paused: animation.paused
    property real timerValue: cookTime * value / 100
    property real timeRemaining: cookTime - timerValue

    signal cooktimeComplete()

    NumberAnimation on value {
        id: animation; running: false; from: 0.0; to: 100.0; duration: 100
        onStopped: {
            console.log("The timer stopped and the value is " + thisTimer.value);
        }
    }

    function getCookTimerState() {
        if (cookTimer.running) {
            return 1;
        } else if (cookTimer.value < 100.0) {
            return 0;
        } else {
            return 2;
        }
    }

    onRunningChanged: {
        backEnd.sendMessage("TimerState " + getCookTimerState().toString());
        console.log("Cooking running state changed.")
        console.log("Running: " + running);
        console.log("Paused: " + paused);
    }

    onPausedChanged: {
        backEnd.sendMessage("TimerState " + getCookTimerState().toString());
        console.log("Cooking paused state changed.")
        console.log("Running: " + running);
        console.log("Paused: " + paused);
    }

    function start() {
        value = 0.0;
        animation.from = 0.0;
        animation.to = 100.0;
        animation.duration = cookTime * 1000;
        animation.start();
    }

    function stop() {
        animation.stop();
    }

    function pause() {
        animation.pause();
    }

    function resume() {
        animation.resume();
    }

    function reset() {
        value = 0.0;
    }
}
