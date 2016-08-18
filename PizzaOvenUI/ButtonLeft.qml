import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: leftButton

    x: 26
    y: 165
    width: 125
    height: 64
    property string text: "LABEL"
    signal clicked()

    SideButton {
        id: theButton
        width: parent.width
        height: parent.height
        buttonText: leftButton.text
        onClicked: {
            parent.clicked();
        }
    }
}
