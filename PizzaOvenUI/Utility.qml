import QtQuick 2.0

Item {
    // define utility functions and other stuff.

    function f2c(t) {
        return (t - 32) * 5 / 9;
    }

    function timeToString(t) {
        var first = Math.floor(t/60).toString()
        if (first.length == 1) first = "0" + first
        var second = Math.floor(t%60).toString()
        if (second.length == 1) second = "0" + second
        return first + ":" + second
    }

    function tempToString(t) {
        var temp = tempDisplayInF ? t : f2c(t);
        var unit = tempDisplayInF ? String.fromCharCode(8457) : String.fromCharCode(8451);
        return temp.toFixed(0).toString() + unit;
    }

    function setUpperTemps(temp) {
        upperFront.setTemp = temp;
        upperRear.setTemp = upperFront.setTemp - upperTempDifferential;

        backEnd.sendMessage("Set UF SetPoint " +
                             (upperFront.setTemp - 0.5 * upperFront.temperatureDeadband) + " " +
                             (upperFront.setTemp + 0.5 * upperFront.temperatureDeadband));
        backEnd.sendMessage("Set UR SetPoint " +
                             (upperRear.setTemp - 0.5 * upperRear.temperatureDeadband) + " " +
                             (upperRear.setTemp + 0.5 * upperRear.temperatureDeadband));
    }

    function setLowerTemps(temp) {
        lowerFront.setTemp = temp;
        lowerRear.setTemp = lowerFront.setTemp - lowerTempDifferential;

        backEnd.sendMessage("Set LF SetPoint " +
                             (lowerFront.setTemp - 0.5 * lowerFront.temperatureDeadband) + " " +
                             (lowerFront.setTemp + 0.5 * lowerFront.temperatureDeadband));
        backEnd.sendMessage("Set LR SetPoint " +
                             (lowerRear.setTemp - 0.5 * lowerRear.temperatureDeadband) + " " +
                             (lowerRear.setTemp + 0.5 * lowerRear.temperatureDeadband));
    }
}
