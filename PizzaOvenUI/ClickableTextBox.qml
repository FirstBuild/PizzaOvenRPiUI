import QtQuick 2.3

Item {
    id: box

    width: 380
    height: lineSpacing
    property string text: "CLICKABLE TEXT BOX"
    property int pointSize: 18
    property int horizontalAlignment: Text.AlignRight
    property int verticalAlignment: Text.AlignVCenter
    property color backgroundColor: appBackgroundColor
    property color foregroundColor: appGrayText
    property int titleTextPointSize: 1

    signal clicked()

    NumberAnimation on titleTextPointSize {
        id: titleTextAnim
        from: 1
        to: pointSize
    }

    Rectangle {
        id: background
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        color: box.backgroundColor
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                sounds.touch.play();
                box.clicked();
            }

            onPressed: {
                theText.color = box.backgroundColor;
                background.color = box.foregroundColor
            }
            onReleased: {
                theText.color = box.foregroundColor;
                background.color = box.backgroundColor
            }
            onPositionChanged: {
                theText.color = box.foregroundColor;
                background.color = box.backgroundColor
            }
        }
    }

    Text {
        id: theText
        width: parent.width
        height: parent.height
        text: box.text
        font.family: localFont.name
        font.pointSize: box.titleTextPointSize
        color: box.foregroundColor
        horizontalAlignment: box.horizontalAlignment
        verticalAlignment: box.verticalAlignment
    }

}
