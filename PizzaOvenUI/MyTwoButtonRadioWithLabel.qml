import QtQuick 2.3

Item {
    id: thisControl
    property bool radioState: false

    property alias label: labelBox.text
    property alias labelWidth: labelBox.width
    property alias leftText: leftRadioButton.text
    property alias rightText: rightRadioButton.text


    Row {
        ClickableTextBox {
            id: labelBox
            text: "LABEL"
            width: thisControl.width / 3
            horizontalAlignment: Text.AlignLeft
            foregroundColor: appForegroundColor
            backgroundColor: appBackgroundColor
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                radioState = !radioState;
            }
        }

        MyRadioButton {
            id: leftRadioButton
            state: !radioState;
            height: lineSpacing
            width: thisControl.width / 3
            text: "LEFT"
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
            width: thisControl.width / 3
            text: "RIGHT"
            onClicked: {
                if (radioState == false) {
                    radioState = true;
                }
            }
        }
    }
}
