import QtQuick 2.3

Item {
    property bool radioState: false

    property alias label: labelBox.text
    property alias labelWidth: labelBox.width

    property alias leftText: leftRadioButton.text

    property alias rightText: rightRadioButton.text

    ClickableTextBox {
        id: labelBox
        text: "LABEL"
        width: parent.width * 0.4
        horizontalAlignment: Text.AlignLeft
        foregroundColor: appForegroundColor
        backgroundColor: appBackgroundColor
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        onClicked: {
            radioState = !radioState;
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        width: parent.width - labelBox.width
        MyRadioButton {
            id: leftRadioButton
            state: !radioState;
            height: lineSpacing
            width: parent.width/2
            text: "LEFT"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            onClicked: {
                if (radioState == true) {
                    radioState = false;
                }
            }
        }
        MyRadioButton {
            id: rightRadioButton
            state: radioState
            height: lineSpacing
            width: parent.width/2
            text: "RIGHT"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            onClicked: {
                if (radioState == false) {
                    radioState = true;
                }
            }
        }
    }
}
