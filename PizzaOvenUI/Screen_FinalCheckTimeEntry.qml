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
        text: "Select final check time"
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
        timeValue: finalCheckTime
        height: tumblerHeight
        anchors.verticalCenter: nextButton.verticalCenter
        anchors.right: nextButton.left
        anchors.rightMargin: 20
        columnWidth: appColumnWidth
        itemsPerTumbler: 5
    }

    ButtonRight {
        id: nextButton
        text: "DONE"
        onClicked: {
            finalCheckTime = timeEntryTumbler.getTime();
            sendWebSocketMessage("FinalCheckTime " + finalCheckTime);
            stackView.pop({item:screenBookmark, immediate:immediateTransitions});
        }
    }
}

