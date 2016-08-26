import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    property string topString: "TOP"
    property string middleString: "MIDDLE"
    property string bottomString: "BOTTOM"

    opacity: 0.0

    OpacityAnimator on opacity {from: 0; to: 1.0; easing.type: Easing.InCubic}

    // Stuff for two lines of text
    Rectangle {
        width: 75
        height: 1
        color: appGrayColor
        x: (screenWidth - width) / 2
        y: 165
        visible: !twoTempEntryModeIsActive
    }

    Text {
        text: parent.middleString
        font.family: localFont.name
        font.pointSize: 17
        color: appForegroundColor
        width: 100
        height: 30
        x: (screenWidth - width) / 2
        y: 125
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: !twoTempEntryModeIsActive
        NumberAnimation on font.pointSize {from: 1; to: 17}
    }

    Text {
        text: parent.bottomString
        font.family: localFont.name
        font.pointSize: 36
        color: appForegroundColor
        width: 150
        height: 45
        x: (screenWidth - width) / 2
        y: 200
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: !twoTempEntryModeIsActive
        NumberAnimation on font.pointSize {from: 1; to: 36}
    }

    // Stuff for three lines of text
    Rectangle {
        width: 75
        height: 1
        color: appGrayColor
        x: (screenWidth - width) / 2
        y: 228
        visible: twoTempEntryModeIsActive
    }

    Text {
        text: parent.topString
        font.family: localFont.name
        font.pointSize: 27
        color: appForegroundColor
        width: 100
        height: 30
        x: (screenWidth - width) / 2
        y: 134
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: twoTempEntryModeIsActive
        NumberAnimation on font.pointSize {from: 1; to: 27}
    }

    Text {
        text: parent.middleString
        font.family: localFont.name
        font.pointSize: 27
        color: appForegroundColor
        width: 100
        height: 30
        x: (screenWidth - width) / 2
        y: 180
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: twoTempEntryModeIsActive
        NumberAnimation on font.pointSize {from: 1; to: 27}
    }

    Text {
        text: parent.bottomString
        font.family: localFont.name
        font.pointSize: 27
        color: appForegroundColor
        width: 100
        height: 30
        x: (screenWidth - width) / 2
        y: 248
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: twoTempEntryModeIsActive
        NumberAnimation on font.pointSize {from: 1; to: 27}
    }
}
