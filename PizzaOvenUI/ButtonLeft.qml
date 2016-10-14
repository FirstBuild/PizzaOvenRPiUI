import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: leftButton

    x: needsAnimation ? (screenWidth - width)/2 : 26
    y: 165 + (64 - lineSpacing) / 2
    width: 125
    height: lineSpacing
    property string text: "LABEL"
    signal clicked()

    property bool needsAnimation: true

    opacity: needsAnimation ? 0.0 : 1.0

    function animate() {
        if (needsAnimation) {
            opacityAnim.start();
            movementAnim.start();
        }
    }

    PropertyAnimation on x { id: movementAnim; from: (screenWidth - width)/2; to: 26; running: needsAnimation}
    OpacityAnimator on opacity { id: opacityAnim; from: 0; to: 1.0; easing.type: Easing.InCubic; running: needsAnimation}

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
