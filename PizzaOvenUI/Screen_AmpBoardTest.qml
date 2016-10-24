import QtQuick 2.0

Item {
    id: thisScreen

    property int spacing: 20

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

    Column {
        width: screenWidth
        anchors.top: screenTitle.bottom
        anchors.topMargin: thisScreen.spacing
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: thisScreen.spacing
        SideButton {
            id: soundButton
            height: lineSpacing
            buttonText: "Click to beep"
            width: 150
            anchors.horizontalCenter: parent.horizontalCenter
        }
        MyCheckBox {
            id: resetLineCheckbox
            checked: false
            text: checked ? "Set reset low" : "Set reset high"
            anchors.horizontalCenter: parent.horizontalCenter
            width: 185
            height: lineSpacing
            onCheckChanged: {
                backEnd.sendMessage("Set Reset " + checked ? "High" : "Low");
            }
        }
        Text {
            id: resetLineText
            font.pointSize: 18
            anchors.horizontalCenter: parent.horizontalCenter
            text: backEnd.resetLineState ? "RESET IS HIGH" : "reset is low"
            color: backEnd.resetLineState ?  appForegroundColor : appGrayText
        }
    }

    Timer {
        id: queryResetLine
        interval: 500
        repeat: true
        running: true
        onTriggered: {
            backEnd.sendMessage("Set Reset " + resetLineCheckbox.checked ? "High" : "Low");
        }
    }
}
