import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtWebSockets 1.0

Window {
    id: rootWindow
    visible: true
    width: 800
    height: 480
    color: appBackgroundColor

    FontLoader { id: localFont; source: "fonts/FreeSans.ttf"; name: "FreeSans" }

    // program configuration
    // true = original oven, false = low cost ovenIsRunning:
    property bool originalConfiguration: false

    // Things related to the cooking of the oven
    property int cookTime: 30
    property int finalCheckTime: cookTime * 0.9
    property bool halfTimeRotateAlertEnabled: appSettings.rotatePizzaAlertEnabled
    property bool finalCheckAlertEnabled: appSettings.finalCheckAlertEnabled
    property bool pizzaDoneAlertEnabled: appSettings.doneAlertEnabled
    property bool halfTimeRotateAlertOccurred: false
    property bool finalCheckAlertOccurred: false
    property bool pizzaDoneAlertOccurred: false

    onHalfTimeRotateAlertOccurredChanged: {
        if (halfTimeRotateAlertOccurred) {
            backEnd.sendMessage("RotatePizzaState 1");
        }
    }
    onFinalCheckAlertOccurredChanged: {
        if (finalCheckAlertOccurred) {
            backEnd.sendMessage("FinalCheckState 1");
        }
    }
    onPizzaDoneAlertOccurredChanged: {
        if (pizzaDoneAlertOccurred) {
            backEnd.sendMessage("PizzaDoneState 1");
        }
    }

    property int dlb: 0
    property int tco: 0
    property int acPowerIsPresent: 0
    onAcPowerIsPresentChanged: {
        console.log("AC Power is now " + acPowerIsPresent);
    }
    property int powerSwitch: 0
    onPowerSwitchChanged: {
        if (acPowerIsPresent == 0) {
            return;
        }
        if (powerSwitch == 1) {
            console.log("The power switch is now on.");
            sounds.powerOn.play();
            if (developmentModeIsActive) {
                forceScreenTransition(Qt.resolvedUrl("Screen_Development.qml"));
                return;
            }
            if (productionModeIsActive){
                forceScreenTransition(Qt.resolvedUrl("Screen_ProductionTest.qml"));
                return;
            }
            if (stackView.currentItem.handlePowerSwitchStateChanged)
            {
                stackView.currentItem.handlePowerSwitchStateChanged(powerSwitch);
            }
        } else {
            sounds.powerOff.play();
            if (!callServiceFailure) {
                console.log("The power switch is now off, transitioning to the off screen.");
                forceScreenTransition(Qt.resolvedUrl("Screen_Off.qml"));
            }
        }
    }

    property bool preheatComplete: false
    property bool stoneIsPreheated: false
    property DomeState domeState: DomeState {
        id: domeState
    }

    property int upperTempDifferential: 0
    property int lowerTempDifferential: 0
    property int upperMaxTemp: 1500
    property int lowerMaxTemp: 800

    property int displayedDomeTemp: upperFront.currentTemp
    property int displayedStoneTemp: lowerFront.currentTemp

    property bool callServiceFailure: false
    onCallServiceFailureChanged: {
        if (callServiceFailure) {
            forceScreenTransition(Qt.resolvedUrl("Screen_CallService.qml"));
        }
    }
    Failures {
        id: failures
    }

    property int doorLatchState: 0
    property int doorCount: 0
    property int doorStatus: 0
    onDoorStatusChanged: {
        if (doorStatus == 1) {
            callServiceFailure = true;
        }
    }

    property bool controlBoardCommsFailed: false
    onControlBoardCommsFailedChanged: {
        if (controlBoardCommsFailed) {
            console.log("Comms with control board failed.");
        } else {
            console.log("Comms with control board restored.");
        }
        if (stackView.currentItem.handleControlBoardCommsChanged)
        {
            stackView.currentItem.handleControlBoardCommsChanged();
        }
    }

    property string foodNameString: "FOOD NAME"
    property int foodIndex: 0
    onFoodIndexChanged: {
        foodNameString = menuSettings.json.menuItems[foodIndex].name;
        backEnd.sendMessage("PizzaStyle " + foodIndex);
    }

    // Things related to how the app looks and operates
    property bool demoModeIsActive: appSettings.demoModeActive
    property bool developmentModeIsActive: false
    property bool productionModeIsActive: false

    property color appBackgroundColor: "#202020"
    property color appForegroundColor: "white"
    property color appGrayColor: "#707070"
    property color appGrayText: "#B0B0B0"

    property int centerCircleTextHeight: 24
    property string gearIconSource: "Gear-Icon-white-2.svg"
    property bool immediateTransitions: true
    property int screenWidth: 559
    property int screenHeight: 355
    property int screenOffsetX: appSettings.screenOffsetX
    property int screenOffsetY: appSettings.screenOffsetY
    property string timeOfDay: "10:04"
    property int smallTextSize: 24
    property int bigTextSize: 42
    property int appColumnWidth: 62
    property bool tempDisplayInF: appSettings.tempDisplayInF
    property int  volumeSetting: appSettings.volumeSetting
    property int  maxVolume: appSettings.maxVolume
    property int brightnessSetting: appSettings.brightness
    property int preheatFanSetting: 0
    property int cookingFanSetting: 1

    // some information
    property string controlVersion: "255.255.255.255"
    property string uiVersion: originalConfiguration ? "0.3.7" : "20.0.2"
    property string backendVersion: "255.255.255.255"
    property string interfaceVersion: "255.255.255.255"
    property string wifiMacId: ""
    property int wifiConnectionState: 0
    property string wifiSsid: ""
    property string wifiPassphrase: ""

    property int lineSpacing: 54

    property bool controlBoardProgrammingInProgress: false

    property CookTimer cookTimer: CookTimer {}
    property Timer maxPreheatTimer: Timer {
        interval: 1000*60*30 // 30 minutes
        repeat: false
        running: false
        onTriggered: {
            console.log("Preheat max timer expired.");
        }
    }

    property AutoShutoff autoShutoff: AutoShutoff {
        id: autoShutoff
        onAutoShutoffTimeoutWarning: {
            console.log("--------> Timeout warning signal received.");
            shutdownWarningDialog.visible = true;
        }
        onAutoShutoffTimeoutComplete: {
            console.log("--------> Timeout complete signal received.");
            shutdownWarningDialog.visible = false;
            if (developmentModeIsActive || productionModeIsActive) {
                backEnd.sendMessage("StopOven ");
            } else {
                forceScreenTransition(Qt.resolvedUrl("Screen_MainMenu.qml"));
            }
        }
    }

    DialogWithCheckbox {
        id: shutdownWarningDialog
        z: 100
        x: screenStackContainer.x
        y: screenStackContainer.y
        width: screenStackContainer.width
        height: screenStackContainer.height
        visible: false
        dialogMessage: "Oven shutting down, continue cooking?"
        onClicked: {
            autoShutoff.reset()
        }
    }

    property string ovenState: "Standby"

    property Item screenBookmark
    property bool singleSettingOnly: false

    property BackEndConnection backEnd: BackEndConnection {
        id:backEnd
    }

    property Utility utility: Utility {
        id: utility
    }

    // Parameters of the oven
    property HeaterBankData upperFront: HeaterBankData {
        id: upperFront
        bank: "UF"
        currentTemp: 75
        setTemp: 1250
        elementDutyCycle: 10
        elementRelay: 0
        onPercent: 0
        offPercent: 90
        temperatureDeadband: 0
        maxTemp: upperMaxTemp
    }
    property HeaterBankData upperRear: HeaterBankData {
        id: upperRear
        bank: "UR"
        currentTemp: 75
        setTemp: 1150
        elementDutyCycle: 10
        elementRelay: 0
        onPercent: 10
        offPercent: 90
        temperatureDeadband: 0
        maxTemp: upperMaxTemp
    }
    property HeaterBankData lowerFront: HeaterBankData {
        id: lowerFront
        bank: "LF"
        currentTemp: 75
        setTemp: 650
        elementDutyCycle: 10
        elementRelay: 0
        onPercent: 0
        offPercent: 49
        temperatureDeadband: 10
        maxTemp: lowerMaxTemp
    }
    property HeaterBankData lowerRear: HeaterBankData {
        id: lowerRear
        bank: "LR"
        currentTemp: 75
        setTemp: 625
        elementDutyCycle: 10
        elementRelay: 0
        onPercent: 51
        offPercent: 100
        temperatureDeadband: 10
        maxTemp: lowerMaxTemp
    }

    Sounds {
        id: sounds
    }

    function forceScreenTransition(newScreen) {
        var newScreenName = JSON.stringify(newScreen).replace(/\"/g, "").substring(5).replace(/.qml/, "");
        console.log("Requested force transition to screen " + newScreenName);

        var currentScreen = "UNKNOWN"
        var currentItem = stackView.currentItem;
        if (currentItem.screenName) {
            currentScreen = currentItem.screenName;
        }

        console.log("Current screen: " + currentScreen);

        if (currentScreen === newScreenName)
        {
            console.log("Transition to same screen, so don't switch.")
            return;
        }

        if (stackView.depth > 0) {
            if (stackView.currentItem.cleanUpOnExit)
            {
                stackView.currentItem.cleanUpOnExit();
            }
        }
        stackView.clear();
        stackView.push({item: newScreen, immediate:immediateTransitions});
    }

    function bookmarkCurrentScreen() {
        screenBookmark = stackView.currentItem;
    }
    function restoreBookmarkedScreen() {
        stackView.pop({item:screenBookmark, immediate:immediateTransitions});
    }

    function ovenIsRunning() {
        if (ovenState == "Cooldown" || ovenState == "Standby") {
            return false;
        } else {
            return true;
        }
    }

    // Define the active screen area.  All screens live here.
    Rectangle {
        id: screenStackContainer
        color: appBackgroundColor
        width: screenWidth
        height: screenHeight
        x: screenOffsetX
        y: screenOffsetY
//        border.color: "red"
//        border.width: 1
        StackView {
            id: stackView
            width: parent.width
            height: parent.height
            anchors.fill: parent
            focus: true
            initialItem: {
                appSettings.backlightOff = false;
                if (appSettings.settingsInitialized) {
                    if (callServiceFailure == false) {
                        Qt.resolvedUrl("Screen_Off.qml");
                    } else {
                        Qt.resolvedUrl("Screen_CallService.qml");
                    }

                } else {
                    Qt.resolvedUrl("Screen_ShiftScreenPosition.qml");
                }
            }
            onCurrentItemChanged: {
                if (currentItem) {
                    if (currentItem.screenEntry) {
                        currentItem.screenEntry();
                    }
                }
            }
        }
        Component.onCompleted: {
            console.log("Starting back end connection.");
            //webSocketConnectionTimer.start();
            backEnd.start();
        }
    }

    GearButton {
        id: auxGear1
        anchors.margins: 20
        anchors.left: screenStackContainer.right
        anchors.verticalCenter: screenStackContainer.verticalCenter
        onClicked: {
            console.log("Extra gear, transitioning to shift screen.");
            stackView.push({item: Qt.resolvedUrl("Screen_ShiftScreenPosition.qml"), immediate:immediateTransitions});
        }
    }
    GearButton {
        id: auxGear2
        anchors.margins: 20
        anchors.top: screenStackContainer.bottom
        anchors.horizontalCenter: screenStackContainer.horizontalCenter
        onClicked: {
            console.log("Extra gear, transitioning to shift screen.");
            stackView.push({item: Qt.resolvedUrl("Screen_ShiftScreenPosition.qml"), immediate:immediateTransitions});
        }
    }
    GearButton {
        id: auxGear3
        anchors.margins: 20
        anchors.right: screenStackContainer.left
        anchors.verticalCenter: screenStackContainer.verticalCenter
        onClicked: {
            console.log("Extra gear, transitioning to shift screen.");
            stackView.push({item: Qt.resolvedUrl("Screen_ShiftScreenPosition.qml"), immediate:immediateTransitions});
        }
    }
    GearButton {
        id: auxGear4
        anchors.margins: 20
        anchors.bottom: screenStackContainer.top
        anchors.horizontalCenter: screenStackContainer.horizontalCenter
        onClicked: {
            console.log("Extra gear, transitioning to shift screen.");
            stackView.push({item: Qt.resolvedUrl("Screen_ShiftScreenPosition.qml"), immediate:immediateTransitions});
        }
    }

    Timer {
        id: timeOfDayClock
        interval: 1000; running: true; repeat: true
        onTriggered: {
            var now = new Date(Date.now() + appSettings.todOffset);
            var hours = now.getHours();
            if (hours > 12) hours -= 12;
            var mins = now.getMinutes();
            timeOfDay = hours + ":" + ((mins < 10) ? "0" : "") + mins;
        }
    }

    function setTimeOfDay(newTime) {
        var t = newTime.split(":");
        var newHours = t[0] * 3600 * 1000;
        var newSecs = t[1] * 60 * 1000;
        var newMillis = newHours + newSecs;

        var now = new Date();
        var hours = now.getHours();
        if (hours > 12) hours -= 12;
        var mins = now.getMinutes();
        var currentMillis = hours * 3600 * 1000 + mins * 60 * 1000;

        var offset = newMillis - currentMillis;

        appSettings.todOffset = offset;
    }

    Timer {
        id: powerLossScreenOffTimer
        running: !acPowerIsPresent
        interval: 10000
        repeat: false
        onTriggered: {
            forceScreenTransition(Qt.resolvedUrl("Screen_Off.qml"));
        }
    }

//    Rectangle {
//        id: upperGuideline
//        x: 0
//        y: 170 + screenOffsetY
//        z: 100
//        width: 800
//        height: 1
//        color: "yellow"
//    }
//    Rectangle {
//        id: lowerGuideline
//        x: 0
//        y: upperGuideline.y + lineSpacing
//        z: 100
//        width: 800
//        height: 1
//        color: "yellow"
//    }
}

