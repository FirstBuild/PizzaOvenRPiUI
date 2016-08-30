import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    width: parent.width
    height: parent.height

    property int myMargins: 10
    property int itemsPerTumbler: 5

    BackButton {
        id: backButton
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    property int tumblerColumns: 4
    property int tumblerHeight: 250
    property int columnHeight: tumblerHeight

    Text {
        text: "Select Cook Time"
        font.family: localFont.name
        font.pointSize: 18
        color: appGrayText
        width: 400
        height: 30
        anchors.right: nextButton.right
        y: 41
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        //        opacity: 0.5
    }


    TimeEntryTumbler {
        id: timeEntryTumbler
        timeValue: cookTime
        height: tumblerHeight
        anchors.verticalCenter: nextButton.verticalCenter
        anchors.right: nextButton.left
        anchors.rightMargin: 20
//        x: 100
        columnWidth: appColumnWidth
        itemsPerTumbler: 5
    }


    Rectangle {
        id: tick
        width: 30
        height: 30
        border.width: 2
        border.color: appForegroundColor
        color: appBackgroundColor
        anchors.topMargin: 20
        anchors.left: nextButton.left
        anchors.top: nextButton.bottom

        Text {
            text: halfTimeRotate ? "X" : ""
            anchors.centerIn: parent
            color: appForegroundColor
        }
        MouseArea {
            anchors.fill: parent
            onClicked:{
                halfTimeRotate = !halfTimeRotate;
            }
        }
    }

    Text {
        text: "Half Time"
        color: appGrayText
        font.family: localFont.name
        font.pointSize: 15
        y: tick.y + 12
        anchors.left: tick.right
        anchors.leftMargin: 10

    }
    Text {
        text: "Check Notice"
        color: appGrayText
        font.family: localFont.name
        font.pointSize: 15
        anchors.left: tick.left
        anchors.top: tick.bottom
        anchors.topMargin: 7

    }

    ButtonRight {
        id: nextButton
        text: "NEXT"
        onClicked: {
            cookTime = timeEntryTumbler.getTime();
            sendWebSocketMessage("CookTime " + cookTime);
            finalCheckTime = cookTime * 0.9
            stackView.push({item:Qt.resolvedUrl("Screen_FinalCheckTimeEntry.qml"), immediate:immediateTransitions});
        }
    }
}

