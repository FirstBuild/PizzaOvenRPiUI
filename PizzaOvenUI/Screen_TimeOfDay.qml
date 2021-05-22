import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    property string screenName: "Screen_TimeOfDay"

    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 10

    property int powerSwitchShadow: powerSwitch

    function handlePowerSwitchStateChanged() {
        console.log("Power switch state changed call in the off screen");
        if (powerSwitch == 1) {
            transitionOutOfOff();
        }
    }

    function handleOvenStateMsg(state) {
        switch(state) {
        case "Cooldown":
            appSettings.backlightOff = false;
            if (powerSwitch == 1) {
                forceScreenTransition(Qt.resolvedUrl("Screen_MainMenu.qml"));
            } else {
                forceScreenTransition(Qt.resolvedUrl("Screen_Cooldown.qml"));
            }
            break;
        }
    }

    function screenEntry() {
        console.log("Entering time of day screen.");
        appSettings.backlightOff = false;
    }

    function transitionOutOfOff() {
        if (developmentModeIsActive) {
            forceScreenTransition(Qt.resolvedUrl("Screen_Development.qml"));
        } else if (productionModeIsActive){
            forceScreenTransition(Qt.resolvedUrl("Screen_ProductionTest.qml"));
        } else {
            console.log("Transitioning from off to main menu.");
            forceScreenTransition(Qt.resolvedUrl("Screen_MainMenu.qml"));
        }
    }

    Text {
        anchors.centerIn: parent
        text: timeOfDay
        font.family: localFont.name
        font.pointSize: 150
        color: appForegroundColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            autoShutoff.reset();
            transitionOutOfOff();
        }
    }
}

