import QtQuick 2.0

Item {
    id: entryScreen

    property int myMargins: 10
    property string display: "12:34"
    property string value: "1234"
    property string header: "Header"

    implicitHeight: screenHeight
    implicitWidth: screenWidth

    signal dialogCompleted()
    signal dialogCanceled()

    onValueChanged: {
        if (value.length > 4) {
            value = value.substring(1);
        }

        switch(value.length) {
        case 0:
            display = "  :  ";
            break;
        case 1:
            display = "  : " + value;
            break;
        case 2:
            display = "  :" + value;
            break;
        case 3:
            display = " " + value.substring(0, 1) + ":" + value.substring(1);
            break;
        case 4:
            display = value.substring(0, 2) + ":" + value.substring(2);
            break;
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
        width: 50 * screenScale
        height: 50 * screenScale
        onClicked: {
            entryScreen.dialogCanceled();
        }
    }

    Text {
        id: idHeader
        text: entryScreen.header
        font.family: localFont.name
        font.pointSize: 17 * screenScale
        color: appForegroundColor
        anchors.margins: myMargins
        anchors.verticalCenter: cancelButton.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: entryText
        text: entryScreen.display
        font.family: localFont.name
        font.pointSize: 72 * screenScale
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

