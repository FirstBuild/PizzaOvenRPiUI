import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: keyboard
    width: parent.width

    property int myMargins: 10

    signal onePressed()
    signal twoPressed()
    signal threePressed()
    signal fourPressed()
    signal fivePressed()
    signal sixPressed()
    signal sevenPressed()
    signal eightPressed()
    signal ninePressed()
    signal zeroPressed()
    signal deletePressed()
    signal enterPressed()

    property string value

    property int keyWidth: 0.9 * keyboard.width / 6;
    property int spacing: (keyboard.width - 6 * keyWidth) / 7
    height: keyWidth * 2 + spacing * 3

    Column {
        spacing: 10

        Row {
            spacing: (keyboard.width - 6 * keyWidth) / 7
            x: spacing
            MyButton {text: "1"; onClicked: keyboard.onePressed(); width: keyWidth; height: keyWidth}
            MyButton {text: "2"; onClicked: keyboard.twoPressed(); width: keyWidth; height: keyWidth}
            MyButton {text: "3"; onClicked: keyboard.threePressed(); width: keyWidth; height: keyWidth}
            MyButton {text: "4"; onClicked: keyboard.fourPressed(); width: keyWidth; height: keyWidth}
            MyButton {text: "5"; onClicked: keyboard.fivePressed(); width: keyWidth; height: keyWidth}
            MyButton {text: "DEL"; onClicked: keyboard.deletePressed(); width: keyWidth; height: keyWidth}
        }
        Row {
            spacing: (keyboard.width - 6 * keyWidth) / 7
            x: spacing
            MyButton {text: "6"; onClicked: keyboard.sixPressed(); width: keyWidth; height: keyWidth}
            MyButton {text: "7"; onClicked: keyboard.sevenPressed(); width: keyWidth; height: keyWidth}
            MyButton {text: "8"; onClicked: keyboard.eightPressed(); width: keyWidth; height: keyWidth}
            MyButton {text: "9"; onClicked: keyboard.ninePressed(); width: keyWidth; height: keyWidth}
            MyButton {text: "0"; onClicked: keyboard.zeroPressed(); width: keyWidth; height: keyWidth}
            MyButton {text: "ENT"; onClicked: keyboard.enterPressed(); width: keyWidth; height: keyWidth}
        }
    }
    Item {
        width: screenWidth
        height: screenHeight
        x: 0
        y: 0
        focus: keyboard.enabled
        Keys.onPressed: {
            switch(event.key) {
            case Qt.Key_0:
                keyboard.zeroPressed();
                break;
            case Qt.Key_1:
                keyboard.onePressed();
                break;
            case Qt.Key_2:
                keyboard.twoPressed();
                break;
            case Qt.Key_3:
                keyboard.threePressed();
                break;
            case Qt.Key_4:
                keyboard.fourPressed();
                break;
            case Qt.Key_5:
                keyboard.fivePressed();
                break;
            case Qt.Key_6:
                keyboard.sixPressed();
                break;
            case Qt.Key_7:
                keyboard.sevenPressed();
                break;
            case Qt.Key_8:
                keyboard.eightPressed();
                break;
            case Qt.Key_9:
                keyboard.ninePressed();
                break;
            case Qt.Key_Delete:
            case Qt.Key_Backspace:
                keyboard.deletePressed();
                break
            case Qt.Key_Enter:
            case Qt.Key_Return:
                keyboard.enterPressed();
                break
            }
            event.accepted = true;
        }
    }
}

