import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: leftButton

    x: (screenWidth - width)/2
    y: 165 + (64 - lineSpacing) / 2
    width: 125
    height: lineSpacing
    property string text: "LABEL"
    signal clicked()

    opacity: 0.0

    function animate() {
        opacityAnim.start();
        movementAnim.start();
    }

    PropertyAnimation on x { id: movementAnim; from: (screenWidth - width)/2; to: 26}
    OpacityAnimator on opacity { id: opacityAnim; from: 0; to: 1.0; easing.type: Easing.InCubic}

    Rectangle {
        width: screenWidth
        height: leftButton.height
        x: 0
        y: 0
        color: appBackgroundColor
        border.color: "yellow"
        border.width: 1
    }

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
