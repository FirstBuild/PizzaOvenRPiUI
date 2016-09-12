import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: keyboard
    width: parent.width

    property int myMargins: 10

    signal keyPressed(int key)

    property string value

    property int keyWidth: 0.9 * keyboard.width / 6;
    property int spacing: (keyboard.width - 6 * keyWidth) / 7
    height: keyWidth * 2 + spacing * 3

    Column {
        spacing: 10

        Row {
            spacing: (keyboard.width - 6 * keyWidth) / 7
            x: spacing
            MyButton {text: "1"; onClicked: keyboard.keyPressed(Qt.Key_1); width: keyWidth; height: keyWidth}
            MyButton {text: "2"; onClicked: keyboard.keyPressed(Qt.Key_2); width: keyWidth; height: keyWidth}
            MyButton {text: "3"; onClicked: keyboard.keyPressed(Qt.Key_3); width: keyWidth; height: keyWidth}
            MyButton {text: "4"; onClicked: keyboard.keyPressed(Qt.Key_4); width: keyWidth; height: keyWidth}
            MyButton {text: "5"; onClicked: keyboard.keyPressed(Qt.Key_5); width: keyWidth; height: keyWidth}
            MyButton {text: "DEL"; onClicked: keyboard.keyPressed(Qt.Key_Backspace); width: keyWidth; height: keyWidth}
        }
        Row {
            spacing: (keyboard.width - 6 * keyWidth) / 7
            x: spacing
            MyButton {text: "6"; onClicked: keyboard.keyPressed(Qt.Key_6); width: keyWidth; height: keyWidth}
            MyButton {text: "7"; onClicked: keyboard.keyPressed(Qt.Key_7); width: keyWidth; height: keyWidth}
            MyButton {text: "8"; onClicked: keyboard.keyPressed(Qt.Key_8); width: keyWidth; height: keyWidth}
            MyButton {text: "9"; onClicked: keyboard.keyPressed(Qt.Key_9); width: keyWidth; height: keyWidth}
            MyButton {text: "0"; onClicked: keyboard.keyPressed(Qt.Key_0); width: keyWidth; height: keyWidth}
            MyButton {text: "ENT"; onClicked: keyboard.keyPressed(Qt.Key_Return); width: keyWidth; height: keyWidth}
        }
    }
    Item {
        width: screenWidth
        height: screenHeight
        x: 0
        y: 0
        focus: keyboard.enabled
        Keys.onPressed: {
            sounds.touch.play();
            keyboard.keyPressed(event.key);
        }
    }
}

