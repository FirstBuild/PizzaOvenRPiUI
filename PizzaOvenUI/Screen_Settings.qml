import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: settingsScreen

    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 15

    Column {
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
        id: okButton
        buttonText: "OK"
        anchors.margins: myMargins
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        onClicked: {
            console.log("Demo mode was " + demoModeIsActive + " and will now be " + demoModeCheckbox.checked);
            demoModeIsActive = demoModeCheckbox.checked
            console.log("Dev mode was " + developmentModeIsActive + " and will now be " + devModeCheckbox.checked);
            developmentModeIsActive = devModeCheckbox.checked
            console.log("Two temp mode was " + twoTempEntryModeIsActive + " and will now be " + twoTempCheckbox.checked);
            twoTempEntryModeIsActive = twoTempCheckbox.checked
            forceScreenTransition(Qt.resolvedUrl("Screen_Off.qml"));
        }
    }

    SideButton {
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

