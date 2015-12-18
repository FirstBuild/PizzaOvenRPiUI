import QtQuick 2.0

Item {
    id: screenCookingSecondHalf
    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 10

    BackButton {
        id: backbutton
        anchors.margins: myMargins
        x: myMargins
        y: myMargins
        onClicked: {
            stackView.pop();
        }
    }

    Text {
        id: screenLabel
        font.family: localFont.name
        font.pointSize: 24
        text: "COOKING"
        anchors.margins: myMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backbutton.verticalCenter
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
            currentValue: 100 * currentTime/cookTime
        }

        Rectangle {
            id: horizontalBar
            width: parent.width * 0.5
            height: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: -cancelButton.height/2
            anchors.top: parent.verticalCenter
            border.width: 1
            border.color: "black"
        }
        Text {
            id: setTemp
            text: tempToString(targetTemp)
            font.family: localFont.name
            font.pointSize: 18
            anchors.margins: myMargins
            anchors.bottom: horizontalBar.top
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: setTime
            text: timeToString(cookTime - currentTime)
            font.family: localFont.name
            font.pointSize: 36
            anchors.topMargin: 40
            anchors.top: horizontalBar.bottom
            anchors.horizontalCenter: parent.horizontalCenter
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
        }
    }
    SideButton {
        id: pauseButton
        buttonText: "PAUSE"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.left: centerCircle.right
        onClicked: {
            console.log("The pause button was clicked.");
        }
    }
    Timer {
        id: countdownTimer
        interval: 1000; running: true; repeat: true
        onTriggered: {
            currentTime++;
            if (currentTime < cookTime*0.9) {
                var val = 100 * currentTime/cookTime;
                progress.currentValue = val;

                val = cookTime - currentTime;
                setTime.text = timeToString(val);

            } else {
                countdownTimer.stop();
            }
        }
    }
}

