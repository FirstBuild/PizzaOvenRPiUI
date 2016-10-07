import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    property string topString: "TOP"
    property string middleString: "MIDDLE"
    property string bottomString: "BOTTOM"

    signal topStringClicked()
    signal middleStringClicked()
    signal bottomStringClicked()

    opacity: 0.0

    OpacityAnimator on opacity {id: screenAnimation; from: 0; to: 1.0; easing.type: Easing.InCubic}

    function animate() {
        screenAnimation.start();
        text1Animation.start();
        text2Animation.start();
        text3Animation.start();
        text4Animation.start();
        text5Animation.start();
    }

    // Stuff for two lines of text
    Rectangle {
        width: 75
        height: 1
        color: appGrayColor
        x: (screenWidth - width) / 2
        y: 197 - lineSpacing/2
        visible: !twoTempEntryModeIsActive
    }

    ClickableTextBox {
        width: 100
        height: 30
        foregroundColor: appForegroundColor
        text: parent.middleString
        pointSize: 17
        x: (screenWidth - width) / 2
        y: 125
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: !twoTempEntryModeIsActive
        NumberAnimation on pointSize {id: text1Animation; from: 1; to: 17}
        onClicked: middleStringClicked();
    }

    ClickableTextBox {
        text: parent.bottomString
        pointSize: 36
        foregroundColor: appForegroundColor
        width: 150
        height: 45
        x: (screenWidth - width) / 2
        y: 200
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: !twoTempEntryModeIsActive
        NumberAnimation on pointSize {id: text2Animation; from: 1; to: 36}
        onClicked: bottomStringClicked();
    }

    // Stuff for three lines of text
    Rectangle {
        width: 75
        height: 1
        color: appGrayColor
        x: (screenWidth - width) / 2
        y: 196 + lineSpacing/2
        visible: twoTempEntryModeIsActive
    }

    ClickableTextBox {
        text: parent.topString
        pointSize: 27
        foregroundColor: appForegroundColor
        width: 120
        height: 30
        x: (screenWidth - width) / 2
        y: 134
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: twoTempEntryModeIsActive
        NumberAnimation on pointSize {id: text3Animation; from: 1; to: 27}
        onClicked: topStringClicked();
    }

    ClickableTextBox {
        text: parent.middleString
        pointSize: 27
        foregroundColor: appForegroundColor
        width: 100
        height: 30
        x: (screenWidth - width) / 2
        y: 180
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: twoTempEntryModeIsActive
        NumberAnimation on pointSize {id: text4Animation; from: 1; to: 27}
        onClicked: middleStringClicked();
    }

    ClickableTextBox {
        text: parent.bottomString
        pointSize: 27
        foregroundColor: appForegroundColor
        width: 100
        height: 30
        x: (screenWidth - width) / 2
        y: 248
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: twoTempEntryModeIsActive
        NumberAnimation on pointSize {id: text5Animation; from: 1; to: 27}
        onClicked: bottomStringClicked();
    }
}
