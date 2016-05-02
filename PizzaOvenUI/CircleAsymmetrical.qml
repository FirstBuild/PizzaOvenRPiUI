import QtQuick 2.0

Item {
    id: asymmetricalCircle

    property string topText: "Top"
    property string middleText: "Middle"
    property string bottomText: "Bottom"
    property int currentValue;
    property int smallTextSize: 24
    property int bigTextSize: 42
    property color rulerColor: appBackgroundColor

    implicitHeight: 50
    implicitWidth: 50

    onTopTextChanged: {
        topLabel.text = topText;
    }
    onMiddleTextChanged: {
        middleLabel.text = middleText;
    }
    onBottomTextChanged: {
        bottomLabel.text = bottomText;
    }
    onCurrentValueChanged: {
        progress.currentValue = currentValue;
    }

//    Rectangle {
//        width: asymmetricalCircle.width
//        height: asymmetricalCircle.height
//        border.width: 1
//        border.color: "orange"
//        color: "black"
//    }

    ProgressCircle {
        id: progress
        width: asymmetricalCircle.width
        height: asymmetricalCircle.height
    }


    Rectangle {
        id: topQuarterPosition
        width: parent.width * 0.5
        height: 2
        anchors.horizontalCenter: parent.horizontalCenter
        y: asymmetricalCircle.height / 4
        border.width: 1
//        border.color: appBackgroundColor
        border.color: rulerColor
    }

    Rectangle {
        id: topThirdPosition
        width: parent.width * 0.5
        height: 2
        anchors.horizontalCenter: parent.horizontalCenter
        y: 5 * asymmetricalCircle.height / 12
        border.width: 1
//        border.color: appBackgroundColor
        border.color: rulerColor
    }
    Rectangle {
        id: halfPosition
        width: parent.width * 0.5
        height: 2
        anchors.horizontalCenter: parent.horizontalCenter
        y: asymmetricalCircle.height / 2
        border.width: 1
//        border.color: appBackgroundColor
        border.color: rulerColor
    }

    Rectangle {
        id: fiveEighthsPosition
        width: parent.width * 0.5
        height: 2
        anchors.horizontalCenter: parent.horizontalCenter
        y: 5 * asymmetricalCircle.height / 8
        border.width: 1
//        border.color: appBackgroundColor
        border.color: rulerColor
    }
    Rectangle {
        id: twoThirdsPosition
        width: parent.width * 0.5
        height: 2
        anchors.horizontalCenter: parent.horizontalCenter
        y: 2 * asymmetricalCircle.height / 3
        border.width: 1
//        border.color: appBackgroundColor
        border.color: rulerColor
    }
    Rectangle {
        id: bottomQuarterPosition
        width: parent.width * 0.5
        height: 2
        anchors.horizontalCenter: parent.horizontalCenter
        y: 3 * asymmetricalCircle.height / 4
        border.width: 1
//        border.color: appBackgroundColor
        border.color: rulerColor
    }


    Text {
        id: topLabel
        text: "Top Label"
        font.family: localFont.name
        font.pointSize: smallTextSize
        anchors.margins: 20
//        anchors.bottom: horizontalBar.top
        anchors.verticalCenter: topQuarterPosition.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: appForegroundColor
        visible: twoTempEntryModeIsActive
    }
    Text {
        id: middleLabel
        text: "Middle Label"
        font.family: localFont.name
        font.pointSize: smallTextSize
        anchors.margins: 20
//        anchors.bottom: horizontalBar.top
        anchors.verticalCenter: twoTempEntryModeIsActive ? halfPosition.verticalCenter : topQuarterPosition.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: appForegroundColor
    }
    Text {
        id: bottomLabel
        text: "Bottom Label"
        font.family: localFont.name
        font.pointSize: (twoTempEntryModeIsActive == true) ? smallTextSize : bigTextSize
//        anchors.top: horizontalBar.bottom
        anchors.verticalCenter: twoTempEntryModeIsActive ? bottomQuarterPosition.verticalCenter : twoThirdsPosition.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: appForegroundColor
    }

    Rectangle {
        id: horizontalBar
        width: parent.width * 0.5
        height: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: twoTempEntryModeIsActive ? fiveEighthsPosition.verticalCenter : topThirdPosition.verticalCenter
        border.width: 1
        border.color: appForegroundColor
    }

}

