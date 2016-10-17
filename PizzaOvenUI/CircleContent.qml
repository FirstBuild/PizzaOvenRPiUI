import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    property string topString: "TOP"
    property string middleString: "MIDDLE"
    property string bottomString: "BOTTOM"
    property bool needsAnimation: true
    opacity: needsAnimation ? 0.0 : 1.0

    OpacityAnimator on opacity {id: screenAnimation; from: 0; to: 1.0; easing.type: Easing.InCubic; running: needsAnimation}
    signal topStringClicked()
    signal middleStringClicked()
    signal bottomStringClicked()

    property int boxHeight: 40

    function animate() {
        screenAnimation.start();
        text3Animation.start();
        text4Animation.start();
        text5Animation.start();
    }

   // Stuff for three lines of text
    Rectangle {
        width: 75
        height: 1
        color: appGrayColor
        x: (screenWidth - width) / 2
        y: 196 + lineSpacing/2
    }

    ClickableTextBox {
        text: parent.topString
        pointSize: centerCircleTextHeight
        foregroundColor: appForegroundColor
        width: 120
        height: boxHeight
        x: (screenWidth - width) / 2
        y: 134
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        NumberAnimation on pointSize {id: text3Animation; from: 1; to: centerCircleTextHeight; running: needsAnimation}
        onClicked: topStringClicked();
        needsAnimation: false
    }

    ClickableTextBox {
        text: parent.middleString
        pointSize: centerCircleTextHeight
        foregroundColor: appForegroundColor
        width: 100
        height: boxHeight
        x: (screenWidth - width) / 2
        y: 175
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        NumberAnimation on pointSize {id: text4Animation; from: 1; to: centerCircleTextHeight; running: needsAnimation}
        onClicked: middleStringClicked();
        needsAnimation: false
    }

    ClickableTextBox {
        text: parent.bottomString
        pointSize: centerCircleTextHeight
        foregroundColor: appForegroundColor
        width: 100
        height: boxHeight
        x: (screenWidth - width) / 2
        y: 235
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        NumberAnimation on pointSize {id: text5Animation; from: 1; to: centerCircleTextHeight; running: needsAnimation}
        onClicked: bottomStringClicked();
        needsAnimation: false
    }
}
