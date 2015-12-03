import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenAwaitStart
    width: rootWindow.width
    height: rootWindow.height

    BackButton {
        id: awaitStartBackButton
        anchors.margins: 20
        x: 20
        y: 20
        onClicked: {
            stackView.pop();
        }
    }

    Text {
        id: foodSelectedLabel
        font.family: localFont.name
        font.pointSize: 24
        text: "NEOPOLITAN"
        anchors.margins: 20
        anchors.horizontalCenter: screenAwaitStart.horizontalCenter
        anchors.verticalCenter: awaitStartBackButton.verticalCenter
    }

    Item {
        id: centerCircle
        implicitWidth: rootWindow.height * 0.5;
        implicitHeight: width
        anchors.margins: 20
        anchors.top: foodSelectedLabel.bottom
        anchors.horizontalCenter: foodSelectedLabel.horizontalCenter
        Rectangle {
            width: parent.width;
            height: width
            radius: width/2
            anchors.centerIn: parent
            border.width: 1
            border.color: "black"
        }
        Rectangle {
            id: horizontalBar
            width: parent.width * 0.66
            height: 2
            anchors.centerIn: parent
            border.width: 1
            border.color: "black"
        }
        Text {
            id: setTemp
            text: "725F"
            font.family: localFont.name
            font.pointSize: 36
            anchors.margins: 20
            anchors.bottom: horizontalBar.top
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: setTime
            text: "01:30"
            font.family: localFont.name
            font.pointSize: 36
            anchors.margins: 20
            anchors.top: horizontalBar.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    SideButton {
        id: editButton
        buttonText: "EDIT"
        anchors.margins: 20
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.right: centerCircle.left
        onClicked: {
            console.log("The edit button was clicked.");
        }
    }

    SideButton {
        id: preheatButton
        buttonText: "PREHEAT"
        anchors.margins: 20
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.left: centerCircle.right
        onClicked: {
            console.log("The preheat button was clicked.");
            stackView.push(Qt.resolvedUrl("Screen_Preheating.qml"));
        }
    }
}

