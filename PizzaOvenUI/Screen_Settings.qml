import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.1

Item {
    id: thisScreen

    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 15

    TempEntryWithKeys {
        id: pinEntry
        z: 10
        enabled: true
        visible: true
        obscureEntry: true
        header: "Enter PIN"
        value: ""
        onDialogCanceled: {
            stackView.pop({immediate:immediateTransitions});
        }
        onDialogCompleted: {
            console.log("Dialog value is " + value);
            if (value != "3142") {
                sounds.alarmUrgent.play();
               messageDialog.visible = true;
            } else {
                enabled = false;
                visible = false;
            }
        }
        DialogWithCheckbox {
            id: messageDialog
            dialogMessage: "The PIN you entered is incorrect."
        }
    }

    Column {
        z: 1
        spacing: 15
        anchors.margins: myMargins
        anchors.left: parent.left
        anchors.top: parent.top

        MyCheckBox {
            id: demoModeCheckbox
            text: "Demo Mode"
            checked: demoModeIsActive
        }

        MyCheckBox {
            id: devModeCheckbox
            text: "Development Mode"
            checked: developmentModeIsActive
        }
    }

    SideButton {
        z: 1
        id: okButton
        buttonText: "OK"
        anchors.margins: myMargins
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        onClicked: {
            console.log("Demo mode was " + demoModeIsActive + " and will now be " + demoModeCheckbox.checked);
            demoModeIsActive = demoModeCheckbox.checked
            if (demoModeIsActive) {
                backEnd.sendMessage("StopOven ");
            }
            console.log("Dev mode was " + developmentModeIsActive + " and will now be " + devModeCheckbox.checked);
            developmentModeIsActive = devModeCheckbox.checked
            if (developmentModeIsActive) {
                forceScreenTransition(Qt.resolvedUrl("Screen_Off.qml"));
            } else {
                forceScreenTransition(Qt.resolvedUrl("Screen_MainMenu.qml"));
            }
        }
    }

    SideButton {
        z: 1
        id: adjustButton
        buttonText: "Center"
        anchors.margins: myMargins
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            stackView.push({item:Qt.resolvedUrl("Screen_ShiftScreenPosition.qml"), immediate:immediateTransitions});
        }
    }

    SideButton {
        z: 1
        id: cancelButton
        buttonText: "Cancel"
        anchors.margins: myMargins
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }
}

