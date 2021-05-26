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
    property int boxHeight: 33 * screenScale
    property int boxWidth: 100 * screenScale
    signal topStringClicked()
    signal centerTopStringClicked()
    signal centerBottomStringClicked()
    signal bottomStringClicked()

    opacity: needsAnimation ? 0.0 : 1.0

    OpacityAnimator on opacity {from: 0; to: 1.0; easing.type: Easing.InCubic; running: needsAnimation}
    NumberAnimation on textSize {from: 1; to: finalTextSize; running: needsAnimation}

    Rectangle {
        id: midLine
        width: 125 * screenScale
        height: 1
        color: appGrayColor
        x: (screenWidth - width) / 2
        y: 197 * screenScale
    }

    ClickableTextBox {
        id: topBox
        width: boxWidth
        height: boxHeight
        anchors.horizontalCenter: midLine.horizontalCenter
        y: 155 * screenScale - height

        foregroundColor: appGrayText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: circleContent.line1String
        pointSize: centerCircleTextHeight
        needsAnimation: false
        NumberAnimation on pointSize {id: text1Animation; from: 1; to: centerCircleTextHeight; running: needsAnimation}
        onClicked: {
            topStringClicked();
        }
    }

    ClickableTextBox {
        id: centerTopBox
        width: boxWidth
        height: boxHeight
        anchors.horizontalCenter: midLine.horizontalCenter
        anchors.top: topBox.bottom
        foregroundColor: appForegroundColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: circleContent.line2String
        pointSize: centerCircleTextHeight
        needsAnimation: false
        NumberAnimation on pointSize {id: text2Animation; from: 1; to: centerCircleTextHeight; running: needsAnimation}
        onClicked: {
            centerTopStringClicked();
        }
    }

    ClickableTextBox {
        id: centerBottomBox
        width: boxWidth
        height: boxHeight
        anchors.horizontalCenter: midLine.horizontalCenter
        y: 239 * screenScale - height
        foregroundColor: appGrayText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: circleContent.line3String
        pointSize: centerCircleTextHeight
        needsAnimation: false
        NumberAnimation on pointSize {id: text3Animation; from: 1; to: centerCircleTextHeight; running: needsAnimation}
        onClicked: {
            centerBottomStringClicked();
        }
    }

    ClickableTextBox {
        id: bottomBox
        width: boxWidth
        height: boxHeight
        anchors.horizontalCenter: midLine.horizontalCenter
        anchors.top: centerBottomBox.bottom
        foregroundColor: appForegroundColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: circleContent.line4String
        pointSize: centerCircleTextHeight
        needsAnimation: false
        NumberAnimation on pointSize {id: text4Animation; from: 1; to: centerCircleTextHeight; running: needsAnimation}
        onClicked: {
            bottomStringClicked();
        }
    }
}
