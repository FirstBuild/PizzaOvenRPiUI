import QtQuick 2.6

Item {
    id: radioButton

    width: 50 * screenScale
    height: lineSpacing
    property bool state: true
    signal clicked()
    property string text: "LABEL"
    property real spacing: 5
    property bool silent: false
    property alias border: background.border

    Rectangle {
        id: background
        width: parent.width
        height: parent.height
        color: appBackgroundColor
//        border.color: "yellow"
//        border.width: 1
        MouseArea {
            anchors.fill: parent
            onClicked: {
                autoShutoff.reset();
                if (!silent) sounds.touch.play();
                radioButton.clicked();
            }
            onPressed: {
                background.color = appForegroundColor;
                label.color = appBackgroundColor;
            }
            onReleased: {
                background.color = appBackgroundColor;
                label.color = appForegroundColor;
            }
        }
    }

    Row {
        height: parent.height
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        spacing: radioButton.spacing
        Rectangle {
            width: 19 * screenScale
            height: width
            radius: width/2
            anchors.verticalCenter: parent.verticalCenter
            color: appBackgroundColor
            border.color: appGrayText
            border.width: 2
            Rectangle {
                width: 11 * screenScale
                height: width
                radius: width/2
                anchors.centerIn: parent
                color: {radioButton.state ? appForegroundColor : appBackgroundColor}
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (!silent) sounds.touch.play();
                    radioButton.clicked();
                }
                onPressed: {
                    background.color = appForegroundColor;
                    label.color = appBackgroundColor;
                }
                onReleased: {
                    background.color = appBackgroundColor;
                    label.color = appForegroundColor;
                }
            }
        }
        Text {
            id: label
            text: radioButton.text
            color: appForegroundColor
            font.family: localFont.name
            font.pointSize: 18 * screenScale
            verticalAlignment: Text.AlignVCenter
            height: radioButton.height
        }
    }

}
