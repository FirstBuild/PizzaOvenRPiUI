import QtQuick 2.0

Item {

    property string topText: "Top"
    property string bottomText: "Bottom"
    property int currentValue;

    onTopTextChanged: {
        topLabel.text = topText;
    }
    onBottomTextChanged: {
        bottomLabel.text = bottomText;
    }
    onCurrentValueChanged: {
        progress.currentValue = currentValue;
    }

    ProgressCircle {
        id: progress
    }

    Rectangle {
        id: horizontalBar
        width: parent.width * 0.5
        height: 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: -75/2
        anchors.top: parent.verticalCenter
        border.width: 1
        border.color: "black"
    }
    Text {
        id: topLabel
        text: "Top Label"
        font.family: localFont.name
        font.pointSize: 18
        anchors.margins: 20
        anchors.bottom: horizontalBar.top
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
        id: bottomLabel
        text: "Bottom Label"
        font.family: localFont.name
        font.pointSize: 36
        anchors.topMargin: 40
        anchors.top: horizontalBar.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

