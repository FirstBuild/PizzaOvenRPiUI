import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: rightButton

    width: 125
    height: lineSpacing
    x: (screenWidth-width)/2
    y: 165 + (64 - lineSpacing) / 2
    property string text: "LABEL"
    signal clicked()

    function animate() {
        opacityAnim.start();
        movementAnim.start();
    }

    opacity: 0.0

    PropertyAnimation on x { id: movementAnim; from: (screenWidth-width)/2; to: screenWidth-26-width}
    OpacityAnimator on opacity { id: opacityAnim; from: 0; to: 1.0; easing.type: Easing.InCubic}

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
