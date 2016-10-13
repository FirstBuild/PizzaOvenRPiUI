import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: circleContent

    property string line1String: "LINE 1"
    property string line2String: "LINE 2"
    property string line3String: "LINE 3"
    property string line4String: "LINE 4"
    property int textSize: needsAnimation ? 1 : finalTextSize
    property bool needsAnimation: true
    property int finalTextSize: centerCircleTextHeight
    property color textColor: appForegroundColor
    property int margins: 1
    property int boxHeight: 33
    property int boxWidth: 100

    opacity: needsAnimation ? 0.0 : 1.0

    OpacityAnimator on opacity {from: 0; to: 1.0; easing.type: Easing.InCubic; running: needsAnimation}
    NumberAnimation on textSize {from: 1; to: finalTextSize; running: needsAnimation}

    Rectangle {
        id: midLine
        width: 125
        height: 1
        color: appGrayColor
        x: (screenWidth - width) / 2
        y: 197
    }

    Rectangle {
        id: topBox
        width: boxWidth
        height: boxHeight
        border.color: "yellow"
        border.width: 0
        anchors.horizontalCenter: midLine.horizontalCenter
        y: 155 - height
        color: appBackgroundColor
        Text {
            text: circleContent.line1String
            font.family: localFont.name
            font.pointSize: textSize
            color: appGrayText
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle {
        id: centerTopBox
        width: boxWidth
        height: boxHeight
        border.color: "yellow"
        border.width: 0
        anchors.horizontalCenter: midLine.horizontalCenter
        anchors.top: topBox.bottom
        color: appBackgroundColor
        Text {
            text: circleContent.line2String
            font.family: localFont.name
            font.pointSize: textSize
            color: textColor
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle {
        id: centerBottomBox
        width: boxWidth
        height: boxHeight
        border.color: "yellow"
        border.width: 0
        anchors.horizontalCenter: midLine.horizontalCenter
        y: 239 - height
        color: appBackgroundColor
        Text {
            text: circleContent.line3String
            font.family: localFont.name
            font.pointSize: textSize
            color: appGrayText
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle {
        id: bottomBox
        width: boxWidth
        height: boxHeight
        border.color: "yellow"
        border.width: 0
        anchors.horizontalCenter: midLine.horizontalCenter
        anchors.top: centerBottomBox.bottom
        color: appBackgroundColor
        Text {
            text: circleContent.line4String
            font.family: localFont.name
            font.pointSize: textSize
            color: textColor
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
