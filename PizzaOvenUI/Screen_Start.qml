import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenStart
    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 10

    BackButton {
        id: backbutton
        anchors.margins: myMargins
        x: myMargins
        y: myMargins
//        onClicked: {
//            stackView.pop({immediate:immediateTransitions});
//        }
    }

    Text {
        id: screenLabel
        font.family: localFont.name
        font.pointSize: 24
        text: "READY"
        anchors.margins: myMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backbutton.verticalCenter
        color: appForegroundColor
    }

    Item {
        id: centerCircle
        implicitWidth: parent.height * 0.7;
        implicitHeight: width
        anchors.margins: myMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40

        ProgressCircle {
            id: progress
        }

        Rectangle {
            id: horizontalBar
            width: parent.width * 0.5
            height: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: -startButton.height/2
            anchors.top: parent.verticalCenter
            border.width: 1
            border.color: appForegroundColor
        }
        Text {
            id: setTemp
            text: tempToString(targetTemp)
            font.family: localFont.name
            font.pointSize: 18
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
            anchors.topMargin: 40
            anchors.top: horizontalBar.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: appForegroundColor
        }
    }

    SideButton {
        id: cancelButton
        buttonText: "CANCEL"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.right: centerCircle.left
        onClicked: {
            console.log("The cancel button was clicked.");
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
        }
    }
    SideButton {
        id: startButton
        buttonText: "START"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.left: centerCircle.right
        onClicked: {
            console.log("The start button was clicked.");
            currentTime = 0;
            stackView.push({item:Qt.resolvedUrl("Screen_CookingFirstHalf.qml"), immediate:immediateTransitions});
        }
    }
}

