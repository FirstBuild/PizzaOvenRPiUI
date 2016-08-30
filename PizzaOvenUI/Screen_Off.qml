import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen

    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 10

    function screenEntry() {
        appSettings.backlightOff = true;
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (demoModeIsActive) {
                appSettings.backlightOff = false;
                stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
            }
            if (developmentModeIsActive) {
                appSettings.backlightOff = false;
                stackView.push({item:Qt.resolvedUrl("Screen_Development.qml"), immediate:immediateTransitions});
            }
        }
    }
}

