import QtQuick 2.0

Item {
    // define utility functions and other stuff.

    function f2c(t) {
//        return Math.floor((t - 32) * 5 / 9);
        return ((t - 32) * 5 / 9);
    }

    function c2f(t) {
//        return Math.floor((t * 9 / 5) + 32);
        return ((t * 9 / 5) + 32);
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
        upperFront.setTemp = Math.floor(temp);
        upperRear.setTemp = Math.floor(upperFront.setTemp - upperTempDifferential);

        backEnd.sendMessage("Set UF SetPoint " +
                             (upperFront.setTemp - 0.5 * upperFront.temperatureDeadband) + " " +
                             (upperFront.setTemp + 0.5 * upperFront.temperatureDeadband));
        backEnd.sendMessage("Set UR SetPoint " +
                             (upperRear.setTemp - 0.5 * upperRear.temperatureDeadband) + " " +
                             (upperRear.setTemp + 0.5 * upperRear.temperatureDeadband));
    }

    function setLowerTemps(temp) {
        lowerFront.setTemp = Math.floor(temp);
        lowerRear.setTemp = Math.floor(lowerFront.setTemp - lowerTempDifferential);

        backEnd.sendMessage("Set LF SetPoint " +
                             (lowerFront.setTemp - 0.5 * lowerFront.temperatureDeadband) + " " +
                             (lowerFront.setTemp + 0.5 * lowerFront.temperatureDeadband));
        backEnd.sendMessage("Set LR SetPoint " +
                             (lowerRear.setTemp - 0.5 * lowerRear.temperatureDeadband) + " " +
                             (lowerRear.setTemp + 0.5 * lowerRear.temperatureDeadband));
    }

    function saveCurrentSettingsAsCustom() {
        var allSettings = menuSettings.json;
        for(var i=0; i<allSettings.menuItems.length; i++) {
            if (allSettings.menuItems[i].name === "CUSTOM") {
                console.log("Custom found at index " + i);
                allSettings.menuItems[i].domeTemp = upperFront.setTemp;
                allSettings.menuItems[i].stoneTemp = lowerFront.setTemp;
                allSettings.menuItems[i].cookTime = cookTime;
                allSettings.menuItems[i].finalCheckTime = finalCheckTime;
                allSettings.menuItems[i].halfTimeCheck = halfTimeRotateAlertEnabled;
                menuSettings.json = allSettings;
            }
        }
    }

    function restoreDisplayedTemps() {
        rootWindow.displayedDomeTemp = rootWindow.upperFront.currentTemp;
        rootWindow.displayedStoneTemp = rootWindow.lowerFront.currentTemp;
    }
}
