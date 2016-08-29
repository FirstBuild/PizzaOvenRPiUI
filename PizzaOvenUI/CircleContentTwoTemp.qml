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
    property int textSize: 1
    property int finalTextSize: 18
    property color textColor: appForegroundColor
    property int margins: 1

    opacity: 0.0

    OpacityAnimator on opacity {from: 0; to: 1.0; easing.type: Easing.InCubic}
    NumberAnimation on textSize {from: 1; to: finalTextSize}

    Rectangle {
        id: topLine
        width: 75
        height: 1
        color: appGrayColor
        x: (screenWidth - width) / 2
        y: 165
    }

    Rectangle {
        id: bottomLine
        width: 75
        height: 1
        color: appGrayColor
        x: (screenWidth - width) / 2
        y: 228
        anchors.bottomMargin: margins
    }

    Text {
        text: circleContent.line1String
        font.family: localFont.name
        font.pointSize: textSize
        color: textColor
        width: 100
        x: (screenWidth - width) / 2
        anchors.bottom: topLine.top
        horizontalAlignment: Text.AlignHCenter
    }

    Text {
        text: circleContent.line2String
        font.family: localFont.name
        font.pointSize: textSize
        color: textColor
        width: 100
        x: (screenWidth - width) / 2
        anchors.top: topLine.bottom
        horizontalAlignment: Text.AlignHCenter
        anchors.topMargin: margins
    }

    Text {
        text: circleContent.line3String
        font.family: localFont.name
        font.pointSize: textSize
        color: textColor
        width: 100
        x: (screenWidth - width) / 2
        anchors.bottom: bottomLine.top
        horizontalAlignment: Text.AlignHCenter
        anchors.bottomMargin: margins
    }

    Text {
        text: circleContent.line4String
        font.family: localFont.name
        font.pointSize: textSize
        color: textColor
        width: 100
        x: (screenWidth - width) / 2
        anchors.top: bottomLine.bottom
        horizontalAlignment: Text.AlignHCenter
        anchors.topMargin: margins
    }
}
