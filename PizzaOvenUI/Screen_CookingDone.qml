import QtQuick 2.0

Item {
    id: screenCookingDone
    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 10

//    BackButton {
//        id: backbutton
//        anchors.margins: myMargins
//        x: myMargins
//        y: myMargins
//        onClicked: {
//            stackView.pop({immediate:immediateTransitions});
//        }
//        }

    HomeButton {
        id: homeButton
        anchors.margins: myMargins
        x: 5
        y: 5
        onClicked: {
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
        }
    }

    Text {
        id: screenLabel
        font.family: localFont.name
        font.pointSize: 24
        text: "COOKING"
        anchors.margins: myMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: homeButton.verticalCenter
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
            bottomText: "DONE"
            currentValue: 100
        }
    }

    SideButton {
        id: completeButton
        buttonText: "COMPLETE"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.right: centerCircle.left
        onClicked: {
            console.log("The complete button was clicked.");
//            sendWebSocketMessage("StopOven ");
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
        }
    }
    SideButton {
        id: repeatButton
        buttonText: "REPEAT"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.left: centerCircle.right
        onClicked: {
            console.log("The repeat button was clicked.");
            stackView.pop({item:screenBookmark, immediate:immediateTransitions});
        }
    }
}

