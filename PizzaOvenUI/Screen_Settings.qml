import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.1

Item {
    id: settingsScreen

    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 15

    MessageDialog {
        id: messageDialog
        title: "Wrong PIN"
        text: "The PIN you entered is incorrect."
        onAccepted: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

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
                messageDialog.open();
            } else {
                enabled = false;
                visible = false;
            }
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

        MyCheckBox {
            id: twoTempCheckbox
            text: "Two Temp Mode"
            checked: twoTempEntryModeIsActive
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
                sendWebSocketMessage("StopOven ");
            }
            console.log("Dev mode was " + developmentModeIsActive + " and will now be " + devModeCheckbox.checked);
            developmentModeIsActive = devModeCheckbox.checked
            console.log("Two temp mode was " + twoTempEntryModeIsActive + " and will now be " + twoTempCheckbox.checked);
            twoTempEntryModeIsActive = twoTempCheckbox.checked
            forceScreenTransition(Qt.resolvedUrl("Screen_Off.qml"));
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
