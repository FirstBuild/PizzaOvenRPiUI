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

//    property int boxHeight: 40
    property int boxHeight: 53

    function animate() {
        screenAnimation.start();
        text3Animation.start();
        text4Animation.start();
        text5Animation.start();
    }

    ClickableTextBox {
        id: topString
        text: parent.topString
        pointSize: centerCircleTextHeight
        foregroundColor: appForegroundColor
//        width: 120
        width: 158
        height: boxHeight
        x: (screenWidth - width) / 2
//        y: 134
        y: 177

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        NumberAnimation on pointSize {id: text3Animation; from: 1; to: centerCircleTextHeight; running: needsAnimation}
        onClicked: {
            topStringClicked();
        }
        needsAnimation: false
    }

    ClickableTextBox {
        id: middleString
        text: parent.middleString
        pointSize: centerCircleTextHeight
        foregroundColor: appForegroundColor
//        width: 100
        width: 132
        height: boxHeight
        anchors.top: topString.bottom
        anchors.horizontalCenter: topString.horizontalCenter
        anchors.topMargin: 2
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        NumberAnimation on pointSize {id: text4Animation; from: 1; to: centerCircleTextHeight; running: needsAnimation}
        onClicked: {
            middleStringClicked();
        }
        needsAnimation: false
    }

    Rectangle {
        id: divider
//        width: 75
        width: 99
        height: 2
        color: appGrayColor
        anchors.top: middleString.bottom
        anchors.horizontalCenter: middleString.horizontalCenter
        anchors.topMargin: 10
    }

    ClickableTextBox {
        text: parent.bottomString
        pointSize: centerCircleTextHeight
        foregroundColor: appForegroundColor
//        width: 100
        width: 132
        height: boxHeight
        anchors.top: divider.bottom
        anchors.horizontalCenter: divider.horizontalCenter
        anchors.topMargin: 10
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        NumberAnimation on pointSize {id: text5Animation; from: 1; to: centerCircleTextHeight; running: needsAnimation}
        onClicked: {
            bottomStringClicked();
        }
        needsAnimation: false
    }
}
