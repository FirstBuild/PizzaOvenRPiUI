import QtQuick 2.0

Item {
    id: domeState

    property bool requested: true
    property bool actual: true
    property bool newStateRequested: false
    property bool displayed: newStateRequested ? requested : actual

    function set(state) {
        requested = state;
        newStateRequested = true;
        backEnd.sendMessage("SetDome " + (requested ? "1" : "0"));
        console.log("---> Requesting dome state: " + (requested ? "on" : "off"));
        timer.restart();
    }

    function toggle() {
        set(!displayed);
    }

    Timer {
        id: timer
        interval: 2000
        repeat: false
        running: false
        onTriggered: {
            newStateRequested = false;
            console.log("Dome state timer fired, resuming display to actual.");
            console.log("Requested: " + requested)
            console.log("Actual: " + actual);
            console.log("new state requested: " + newStateRequested);
            console.log("Displayed: " + displayed);
        }
    }
}
