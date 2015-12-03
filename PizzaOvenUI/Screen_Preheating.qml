import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenAwaitStart
    implicitWidth: rootWindow.width
    implicitHeight: rootWindow.height

    BackButton {
        id: backbutton
        anchors.margins: 20
        x: 20
        y: 20
        onClicked: {
            stackView.pop();
        }
    }

    Text {
        id: screenLabel
        font.family: localFont.name
        font.pointSize: 24
        text: "PREHEATING"
        anchors.margins: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backbutton.verticalCenter
    }

    Item {
        id: centerCircle
        implicitWidth: rootWindow.height * 0.5;
        implicitHeight: width
        anchors.margins: 20
        anchors.top: screenLabel.bottom
        anchors.horizontalCenter: parent.horizontalCenter
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
            width: parent.width * 0.5
            height: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: parent.height/3
            anchors.top: parent.top
            border.width: 1
            border.color: "black"
        }
        Text {
            id: setTemp
            text: "725F"
            font.family: localFont.name
            font.pointSize: 18
            anchors.margins: 20
            anchors.bottom: horizontalBar.top
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: actualTemp
            text: "327F"
            font.family: localFont.name
            font.pointSize: 48
            anchors.topMargin: 40
            anchors.top: horizontalBar.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    SideButton {
        id: cancelButton
        buttonText: "CANCEL"
        anchors.margins: 20
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.right: centerCircle.left
        onClicked: {
            console.log("The edit button was clicked.");
        }
    }

}

