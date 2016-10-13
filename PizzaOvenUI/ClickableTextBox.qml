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
//        border.color: "orange"
//        border.width: 1
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                sounds.touch.play();
                box.clicked();
            }

//            onPressed: {
//                textBackgroundOnReleased.stop();
//                textBackgroundOnPressed.start();
//                selectionTextOnReleased.stop();
//                selectionTextOnPressed.start();
//            }
//            onReleased: {
//                textBackgroundOnPressed.stop();
//                textBackgroundOnReleased.start();
//                selectionTextOnPressed.stop();
//                selectionTextOnReleased.start();
//            }
//            onPositionChanged: {
//                textBackgroundOnReleased.stop();
//                selectionTextOnReleased.stop();
//                textBackgroundOnPressed.stop();
//                selectionTextOnPressed.stop();
//                selectionTextOnReleased.start();
//                background.color = box.backgroundColor;
//                theText.color = box.foregroundColor;
//            }
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

    ColorAnimation {
        id: textBackgroundOnPressed
        target: background
        property: "color"
        to: box.foregroundColor
        running: false
    }
    ColorAnimation {
        id: textBackgroundOnReleased
        target: background
        property: "color"
        to: box.backgroundColor
        running: false
    }
    ColorAnimation {
        id: selectionTextOnPressed
        target: theText
        property: "color"
        to: box.backgroundColor
        running: false
    }
    ColorAnimation {
        id: selectionTextOnReleased
        target: theText
        property: "color"
        to: box.foregroundColor
        running: false
    }

}
