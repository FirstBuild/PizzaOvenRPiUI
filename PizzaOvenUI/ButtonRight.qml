import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: rightButton

    width: 125
    height: 64
    x: screenWidth-26-width
    y: 165
    property string text: "LABEL"
    signal clicked()

    SideButton {
        id: theButton
        width: parent.width
        height: parent.height
        buttonText: parent.text
        onClicked: {
            parent.clicked();
        }
    }
}
