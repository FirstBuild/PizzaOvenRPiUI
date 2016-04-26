import QtQuick 2.0

Item {
    id: entryScreen

    property int myMargins: 10
    property string value: "1234"
    property string header: "Value"

    implicitHeight: screenHeight
    implicitWidth: screenWidth

    signal dialogCompleted()
    signal dialogCanceled()

    Rectangle {
        color: appBackgroundColor
        width: screenWidth
        height: screenHeight
        border.color: "blue"
        border.width: 0
    }

    MyButton {
        id: cancelButton
        anchors.margins: myMargins
        anchors.top: parent.top
        anchors.left: parent.left
        text: "X"
        width: 50
        height: 50
        onClicked: {
            entryScreen.dialogCanceled();
        }
    }

    Text {
        id: idHeader
        text: entryScreen.header
        font.family: localFont.name
        font.pointSize: 16
        color: appForegroundColor
        anchors.margins: myMargins
        anchors.verticalCenter: cancelButton.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: entryText
        text: entryScreen.value
        font.family: localFont.name
        font.pointSize: 72
        color: appForegroundColor

        anchors.horizontalCenter: baseline.horizontalCenter
        anchors.top: idHeader.bottom
    }

    Rectangle {
        id: baseline
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: entryText.bottom
        height: 2
        width: parent.width /2
        border.color: appForegroundColor
        border.width: 2
    }

    Keyboard {
        id: keyboard
        anchors.bottom: parent.bottom
        onOnePressed: {
            entryScreen.value += "1";
        }
        onTwoPressed: {
            entryScreen.value += "2";
        }
        onThreePressed: {
            entryScreen.value += "3";
        }
        onFourPressed: {
            entryScreen.value += "4";
        }
        onFivePressed: {
            entryScreen.value += "5";
        }
        onSixPressed: {
            entryScreen.value += "6";
        }
        onSevenPressed: {
            entryScreen.value += "7";
        }
        onEightPressed: {
            entryScreen.value += "8";
        }
        onNinePressed: {
            entryScreen.value += "9";
        }
        onZeroPressed: {
            entryScreen.value += "0";
        }
        onDeletePressed: {
            if (entryScreen.value.length > 0) {
                entryScreen.value = entryScreen.value.slice(0, -1);
            }
        }
        onEnterPressed: {
            entryScreen.dialogCompleted();
        }
    }
}

