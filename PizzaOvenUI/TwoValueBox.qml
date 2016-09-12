import QtQuick 2.0

Item {
    id: twoValueBox

    height: 0.9 * screenHeight/4
    width: 0.9 * screenWidth/2

    signal clicked()

    property string upperLabel: "UpLbl"
    property string upperValue: "UpVal"
    property string lowerLabel: "LowLbl"
    property string lowerValue: "LowVal"
    property color borderColor: appForegroundColor

    Rectangle {
        height: twoValueBox.height
        width: twoValueBox.width
        border.color: twoValueBox.borderColor
        border.width: 2
        color: appBackgroundColor
        Row {
            id: upperRow
//            anchors.margins: myMargins
            spacing: 5
            x: 5
            y:5
            Text {
                color: appForegroundColor
                text: upperLabel
                font.family: localFont.name
                font.pointSize: 16
            }
            Text {
                color: appForegroundColor
                text: upperValue
                font.family: localFont.name
                font.pointSize: 16
            }
        }
        Row {
            id: lowerRow
//            anchors.margins: myMargins
            anchors.top: upperRow.bottom
            spacing: 5
            x: 5
            Text {
                color: appForegroundColor
                text: lowerLabel
//                anchors.margins: myMargins
                font.family: localFont.name
                font.pointSize: 16
            }
            Text {
                color: appForegroundColor
                text: lowerValue
//                anchors.margins: myMargins
                font.family: localFont.name
                font.pointSize: 16
            }
        }
        MouseArea {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            onClicked: {
                twoValueBox.clicked();
            }
        }
    }
}

