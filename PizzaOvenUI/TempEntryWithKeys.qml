import QtQuick 2.0

Item {
    id: entryScreen

    property int myMargins: 10
    property string display: ""
    property string value: "1234"
    property string header: "Header"
    property bool obscureEntry: false

    implicitHeight: screenHeight
    implicitWidth: screenWidth

    signal dialogCompleted()
    signal dialogCanceled()

    onValueChanged: {
        if (obscureEntry) {
            var s = ""
            for (var i=0; i<value.length; i++) {
                s = s + "*";
            }
            display = s;
        } else {
            display = value;
        }
    }

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
            sounds.cancel.play();
            entryScreen.dialogCanceled();
        }
    }

    Text {
        id: idHeader
        text: entryScreen.header
        font.family: localFont.name
        font.pointSize: 16 * screenScale
        color: appForegroundColor
        anchors.margins: myMargins
        anchors.verticalCenter: cancelButton.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: entryText
        text: entryScreen.display
        font.family: localFont.name
        font.pointSize: 72
        color: appForegroundColor

        anchors.horizontalCenter: baseline.horizontalCenter
        anchors.top: idHeader.bottom
        anchors.topMargin: 10
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
        enabled: entryScreen.enabled
        onKeyPressed: {
            if (key >= Qt.Key_0 && key <= Qt.Key_9)
            {
                entryScreen.value += String.fromCharCode(key);
            } else {
                switch(key) {
                case Qt.Key_Backspace:
                case Qt.Key_Delete:
                    if (entryScreen.value.length > 0) {
                        entryScreen.value = entryScreen.value.slice(0, -1);
                    }
                    break;
                case Qt.Key_Enter:
                case Qt.Key_Return:
                    entryScreen.dialogCompleted();
                    break;
                }
            }
        }
    }
}

