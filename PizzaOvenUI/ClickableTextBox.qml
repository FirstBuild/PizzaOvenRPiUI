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
    property int titleTextPointSize: needsAnimation ? 1 : pointSize
    property bool needsAnimation: true

    signal clicked()

    NumberAnimation on titleTextPointSize {
        id: titleTextAnim
        from: 1
        to: pointSize
        running: needsAnimation
    }

    Rectangle {
        id: background
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        color: box.backgroundColor
//        border.color: "orange"
//        border.width: 1
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                autoShutoff.reset();
                sounds.touch.play();
                box.clicked();
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
