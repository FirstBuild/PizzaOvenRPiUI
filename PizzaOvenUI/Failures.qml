import QtQuick 2.0

Item {
    id: failures
    property bool upperDiffExceeded: false
    property bool lowerDiffExceeded: false
    property bool watchdogResetOccurred: false
    property bool tcoFailure: false
    property bool coolingFanFailure: false
    property bool upperFrontOvertemp: false
    property bool upperRearOvertemp: false
    property bool lowerFrontOvertemp: false
    property bool lowerRearOvertemp: false
    property bool doorDropped: false

    function appendFailureString(t, a) {
        if (t.length > 0) {
            return t + "\r\n" + a;
        } else {
            return a;
        }
    }

    function getFailureText() {
        var t = "";
        if (upperDiffExceeded) t = appendFailureString(t, "Upper Temp Differential");
        if (lowerDiffExceeded) t = appendFailureString(t, "Lower Temp Differential");
        if (watchdogResetOccurred) t = appendFailureString(t, "Watchdog Reset");
        if (tcoFailure) t = appendFailureString(t, "TCO or Door Switch Open");
        if (coolingFanFailure) t = appendFailureString(t, "Cooling Fan Switch Open");
        if (upperFrontOvertemp) t = appendFailureString(t, "Upper Front Over Temp");
        if (upperRearOvertemp) t = appendFailureString(t, "Upper Rear Over Temp");
        if (lowerFrontOvertemp) t = appendFailureString(t, "Lower Front Over Temp");
        if (lowerRearOvertemp) t = appendFailureString(t, "Lower Rear Over Temp");
        if (doorDropped) t = appendFailureString(t, "Safety Door Latch Set");
        return t;
    }

    function logFailure(failure) {
        switch(failure) {
            case "upper_diff_exceeded":
                upperDiffExceeded = true;
                break;
            case "lower_diff_exceeded":
                lowerDiffExceeded = true;
                break;
            case "watchdog_reset":
                watchdogResetOccurred = true;
                break;
            case "tco_failure":
                tcoFailure = true;
                break;
            case "cooling_fan":
                coolingFanFailure = true;
                break;
            case "uf_overtemp":
                upperFrontOvertemp = true;
                break;
            case "ur_overtemp":
                upperRearOvertemp = true;
                break;
            case "lf_overtemp":
                lowerFrontOvertemp = true;
                break;
            case "lr_overtemp":
                lowerRearOvertemp = true;
                break;
            case "door_dropped":
                doorDropped = true;
                break;
            default:
                console.log("Failure case not handled: " + failure);
                break;
        }

    }
}
