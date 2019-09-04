import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import QtMultimedia 5.0

Item {
    id: thisScreen
    height: parent.height
    width: parent.width

    property bool ctrlPressed: false
    property bool altPressed: false
    property bool bsPressed: false
    property int foodTypeXLocation: mainMenuGearButton.x + mainMenuGearButton.width + 10
    property int foodTypeWidth: parent.width - foodTypeXLocation - mainMenuGearButton.x
    property int tumblerWidth: foodTypeWidth
    property int foodIndexShadow: rootWindow.foodIndex

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    function handlePowerSwitchStateChanged() {
        if (powerSwitch == 0) {
            screenExit();
            stackView.clear();
            stackView.push({item: Qt.resolvedUrl("Screen_Off.qml"), immediate:immediateTransitions});
        }
    }

    // a reference rectangle
//    Rectangle {
//        x: 0
//        y: 0
//        width: parent.width
//        height: parent.height
//        color: appBackgroundColor
//        border.color: "red"
//        border.width: 1
//    }

    function setMenuPositionFromFoodIndex() {
        var menuIndexes = menuSettings.json.menuOrder;
        for (var i=0; i<menuIndexes.length; i++) {
            if (foodIndex === menuIndexes[i]) {
                foodType.setCurrentIndexAt(0, i, 0);
            }
        }
    }

    onFoodIndexShadowChanged: {
        setMenuPositionFromFoodIndex();
    }

    function screenEntry() {
        backEnd.sendMessage("StopOven ");
        autoShutoff.stop();
        preheatComplete = false;
        console.log("Entering main menu screen.");
        // load up the list
        foodListModel.clear();
        var menuItems = menuSettings.json.menuItems;
        var menuIndexes = menuSettings.json.menuOrder;
        if (menuItems.length === menuIndexes.length) {
            for(var i=0; i<menuItems.length; i++)  {
                foodListModel.append(menuItems[menuIndexes[i]]);
            }
        } else {
            for(var i=0; i<menuItems.length; i++)  {
                foodListModel.append(menuItems[i]);
            }
        }

        appSettings.backlightOff = false;
        if (powerSwitch == 0) {
            demoTimeoutTimer.restart();
        }
        keyhandler.focus = true;
        setMenuPositionFromFoodIndex();
        screenEntryAnimation.start();
    }

    function screenExit() {
        keyhandler.focus = false;
        demoTimeoutTimer.running = false;
    }

    Timer {
        id: demoTimeoutTimer
        interval: 60000; running: false; repeat: false
        onTriggered: SequentialAnimation {
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    screenExit();
                    stackView.clear();
                    stackView.push({item: Qt.resolvedUrl("Screen_Off.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    GearButton {
        id: mainMenuGearButton
        onClicked: SequentialAnimation {
            ScriptAction {
                script: {
                    if (demoModeIsActive) {
                        demoTimeoutTimer.stop();
                    }
                }
            }
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    screenExit();
                    stackView.push({item: Qt.resolvedUrl("Screen_Settings2.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    ListModel {
        id: foodListModel
    }

    Tumbler {
        id: foodType
        x: foodTypeXLocation
        y: 85
        height: 225
        width: foodTypeWidth

        style:  MyTumblerStyle {
            onClicked: {
                sounds.select.play();
                acceptSelection();
            }
            visibleItemCount: 5
            textHeight:foodType.height / visibleItemCount
            textWidth: parent.width
            padding.top: 0
            padding.bottom: 0
            padding.left: 0
            padding.right: 0
        }
        TumblerColumn {
            id: theColumn
            width: tumblerWidth
            model: foodListModel
            role: "name"
        }
    }
//    Rectangle {
//        x: foodType.x
//        y: foodType.y
//        width: foodType.width
//        height: foodType.height
//        color: appBackgroundColor
//        border.color: "yellow"
//        border.width: 1
//        opacity: 0.25
//    }

    SequentialAnimation {
        id: screenExitAnimation
        OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
        ScriptAction {script: {
                var menuIndexes = menuSettings.json.menuOrder;
                foodNameString = foodListModel.get(theColumn.currentIndex).name;
                foodIndex = menuIndexes[theColumn.currentIndex];
                screenExit();
                forceScreenTransition(Qt.resolvedUrl("Screen_AwaitStart.qml"));
            }
        }
    }

    function acceptSelection() {
        var settings = foodListModel.get(theColumn.currentIndex);
        utility.setUpperTemps(settings.domeTemp)
        utility.setLowerTemps(settings.stoneTemp)
        cookTime = settings.cookTime;
        backEnd.sendMessage("CookTime " + cookTime);
        finalCheckTime = settings.finalCheckTime

        demoTimeoutTimer.stop();
        screenExitAnimation.start();
    }

    Item {
        id: keyhandler
        anchors.fill: parent
        focus: true
        Keys.onPressed: {
            switch (event.key) {
            case Qt.Key_Control:
                ctrlPressed = true;
                console.log("Ctrl was pressed.");
                break;
            case Qt.Key_Alt:
                altPressed = true;
                console.log("Alt was pressed.");
                break;
            case Qt.Key_Backspace:
                bsPressed = true;
                console.log("BS was pressed.");
                break;
            default:
                console.log("key not handled in main menu.");
            }

            event.accepted = true;
            if (ctrlPressed && altPressed && bsPressed) {
                Qt.quit();
            }
        }
        Keys.onReleased: {
            switch (event.key) {
            case Qt.Key_Control:
                ctrlPressed = false;
                console.log("Ctrl was released.");
                break;
            case Qt.Key_Alt:
                altPressed = false;
                console.log("Alt was released.");
                break;
            case Qt.Key_Backspace:
                bsPressed = false;
                console.log("BS was released.");
                break;
            }

            event.accepted = true;
        }
    }
}
