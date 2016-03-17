import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenAwaitStart
    width: parent.width
    height: parent.height

    property int myMargins: 15

    BackButton {
        id: awaitStartBackButton
        anchors.margins: myMargins
        x: myMargins
        y: myMargins
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    Text {
        id: foodSelectedLabel
        font.family: localFont.name
        font.pointSize: 24
        text: "NEOPOLITAN"
        anchors.margins: myMargins
        anchors.horizontalCenter: screenAwaitStart.horizontalCenter
        anchors.verticalCenter: awaitStartBackButton.verticalCenter
        color: appForegroundColor
    }

    Item {
        id: centerCircle
        implicitWidth: parent.height * 0.7;
        implicitHeight: width
        anchors.margins: myMargins
        anchors.horizontalCenter: foodSelectedLabel.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        Rectangle {
            width: parent.width;
            height: width
            radius: width/2
            anchors.centerIn: parent
            border.width: 1
            border.color: appForegroundColor
            color: appBackgroundColor
        }
        Rectangle {
            id: horizontalBar
            width: parent.width * 0.66
            height: 2
            anchors.centerIn: parent
            border.width: 1
            border.color: appForegroundColor
        }
        Text {
            id: setTemp
            text: tempToString(targetTemp)
            font.family: localFont.name
            font.pointSize: 36
            anchors.margins: myMargins
            anchors.bottom: horizontalBar.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: appForegroundColor
        }
        Text {
            id: setTime
            text: timeToString(cookTime)
            font.family: localFont.name
            font.pointSize: 36
            anchors.margins: myMargins
            anchors.top: horizontalBar.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: appForegroundColor
        }
    }

    SideButton {
        id: editButton
        buttonText: "EDIT"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.right: centerCircle.left
        onClicked: {
            console.log("The edit button was clicked.");
            console.log("Current item: " + stackView.currentItem);
            screenBookmark = stackView.currentItem;
            stackView.push({item:Qt.resolvedUrl("Screen_TemperatureEntry.qml"), immediate:immediateTransitions});
        }
    }

    SideButton {
        id: preheatButton
        buttonText: "PREHEAT"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.left: centerCircle.right
        onClicked: {
            console.log("The preheat button was clicked.");
            stackView.push({item:Qt.resolvedUrl("Screen_Preheating.qml"), immediate:immediateTransitions});
        }
    }
}

