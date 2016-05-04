import QtQuick 2.0

Item {
    id: screenCookingDone
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

    function screenEntry() {
        sounds.cycleComplete.play();
    }

    Text {
        id: screenLabel
        font.family: localFont.name
        font.pointSize: 24
        text: "DONE"
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

        CircleAsymmetrical {
            id: dataCircle
            height: parent.height;
            width: parent.width
            topText: tempToString(upperFront.setTemp)
            middleText: tempToString(lowerFront.setTemp)
            bottomText: "00:00"
        }

//    Item {
//        id: centerCircle
//        implicitWidth: parent.height * 0.7;
//        implicitHeight: width
//        anchors.margins: myMargins
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.bottom: parent.bottom
//        anchors.bottomMargin: 40

//        ProgressCircle {
//            id: progress
//            currentValue: 100 * currentTime/cookTime
//            width: centerCircle.width
//            height: centerCircle.height
//        }

//        Rectangle {
//            id: horizontalBar
//            width: parent.width * 0.5
//            height: 2
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.topMargin: -completeButton.height/2
//            anchors.top: parent.verticalCenter
//            border.width: 1
//            border.color: appForegroundColor
//        }
//        Text {
//            id: setTemp
//            text: tempToString(lowerFront.setTemp)
//            font.family: localFont.name
//            font.pointSize: 18
//            anchors.margins: myMargins
//            anchors.bottom: horizontalBar.top
//            anchors.horizontalCenter: parent.horizontalCenter
//            color: appForegroundColor
//        }
//        Text {
//            id: setTime
////            text: timeToString(cookTime - currentTime)
//            text: "00:00"
//            font.family: localFont.name
//            font.pointSize: 36
//            anchors.topMargin: 40
//            anchors.top: horizontalBar.bottom
//            anchors.horizontalCenter: parent.horizontalCenter
//            color: appForegroundColor
//        }
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

