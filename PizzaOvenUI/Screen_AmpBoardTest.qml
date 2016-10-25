import QtQuick 2.0

Item {
    id: thisScreen

    property int spacing: 30
    property bool ctrlPressed: false
    property bool altPressed: false
    property bool bsPressed: false

    // title text
    Text {
        id: screenTitle
        text: "Amp Board Tester"
        font.family: localFont.name
        font.pointSize: 24
        anchors.horizontalCenter: parent.horizontalCenter
        y: 10
        color: "cyan"
    }

    Timer {
        id: soundTimer
        interval: 4000
        repeat: true
        running: false
        triggeredOnStart: true
        onTriggered: {
            sounds.powerOn.play();
        }
    }

    Column {
        width: screenWidth
        anchors.top: screenTitle.bottom
        anchors.topMargin: thisScreen.spacing
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: thisScreen.spacing
        MyCheckBox {
            id: repeatSound
            text: "Repeat sound"
            checked: false
            anchors.horizontalCenter: parent.horizontalCenter
            height: lineSpacing
            onCheckChanged: {
                if (checked) {
                    soundTimer.start();
                } else {
                    soundTimer.stop();
                }
            }
            width: 150
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: thisScreen.spacing
            height: lineSpacing
            ClickableTextBox {
                id: label
                pointSize: 18
                text: "Amp reset output"
                foregroundColor: appForegroundColor
                height: lineSpacing
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                onClicked: resetLineSlider.state = !resetLineSlider.state
                width: 150
            }
            SlideOffOn {
                id: resetLineSlider
                trueText: "High"
                falseText: "Low"
                state: true
                height: lineSpacing
                anchors.verticalCenter: parent.verticalCenter
                onStateChanged: {
                    queryResetLine.onTriggered();
                }
            }
        }

        Text {
            id: resetLineText
            font.pointSize: 18
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Comms says reset is " +  (backEnd.resetLineState ? "HIGH" : "low")
            color: backEnd.resetLineState ?  appForegroundColor : appGrayText
        }
    }

    Timer {
        id: queryResetLine
        interval: 500
        repeat: true
        running: true
        onTriggered: {
            backEnd.sendMessage("SetReset " + (resetLineSlider.state ? "High" : "Low"));
            backEnd.sendMessage("GetReset no_params");
        }
    }

    Item {
        id: keyhandler
        anchors.fill: parent
        focus: true
        Keys.onPressed: {
            switch (event.key) {
            case Qt.Key_Control:
                ctrlPressed = true;
                console.log("Ctrl was pressed.");
                break;
            case Qt.Key_Alt:
                altPressed = true;
                console.log("Alt was pressed.");
                break;
            case Qt.Key_Backspace:
                bsPressed = true;
                console.log("BS was pressed.");
                break;
            default:
                console.log("key not handled in main menu.");
            }

            event.accepted = true;
            if (ctrlPressed && altPressed && bsPressed) {
                Qt.quit();
            }
        }
        Keys.onReleased: {
            switch (event.key) {
            case Qt.Key_Control:
                ctrlPressed = false;
                console.log("Ctrl was released.");
                break;
            case Qt.Key_Alt:
                altPressed = false;
                console.log("Alt was released.");
                break;
            case Qt.Key_Backspace:
                bsPressed = false;
                console.log("BS was released.");
                break;
            }

            event.accepted = true;
        }
    }}
