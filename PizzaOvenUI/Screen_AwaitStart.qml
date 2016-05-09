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
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40

        CircleAsymmetrical {
            id: dataCircle
            height: parent.height;
            width: parent.width
            topText: tempToString(upperFront.setTemp)
            middleText: tempToString(lowerFront.setTemp)
            bottomText: timeToString(cookTime)
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
            if (twoTempEntryModeIsActive) {
                stackView.push({item:Qt.resolvedUrl("Screen_EnterStoneTemp.qml"), immediate:immediateTransitions});
            } else {
                stackView.push({item:Qt.resolvedUrl("Screen_TemperatureEntry.qml"), immediate:immediateTransitions});
            }
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
            if (!demoModeIsActive) {
                sendWebSocketMessage("StartOven ");
            }
            screenBookmark = stackView.currentItem;
            stackView.push({item:Qt.resolvedUrl("Screen_Preheating.qml"), immediate:immediateTransitions});
        }
    }
}

