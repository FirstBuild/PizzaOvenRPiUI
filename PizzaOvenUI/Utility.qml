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

    function findPizzaTypeFromSettings() {
        var dome = upperFront.setTemp;
        var stone = lowerFront.setTemp;
        var menuItems = menuSettings.json.menuItems;

        console.log("In findPizzaTypeFromSettings.");
        console.log("Requested settings - dome: " + dome + ", stone: " + stone + ", time: " + cookTime);

        console.log("Searching cycles for a match.");
        for(var i=0; i<menuItems.length; i++)  {
            console.log("name: " + menuItems[i].name + ", dome: " + menuItems[i].domeTemp + ", stone: " + menuItems[i].stoneTemp + ", time: " + menuItems[i].cookTime);
            if (menuItems[i].domeTemp == dome && menuItems[i].stoneTemp == stone && cookTime == menuItems[i].cookTime) {
                console.log("Found matching settings, setting the food index to " + i);
                rootWindow.foodIndex = i;
                return;
            }
        }
        console.log("No match found, setting the food index to 4 and save these new settings as custom.");
        rootWindow.foodIndex = 4;
        saveCurrentSettingsAsCustom();
    }

    function updateReminderSettingsOnBackend() {
        backEnd.sendMessage("ReminderSettings" +
                    " rotatePizza " + (halfTimeRotateAlertEnabled ? 1 : 0) +
                    " finalCheck " + (finalCheckAlertEnabled ? 1 : 0) +
                    " done " + (pizzaDoneAlertEnabled ? 1 : 0)
                    );
    }
}
