import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: rightButton

    property int finalPositionX: screenWidth - (26 * screenScale) - width
    width: 125 * screenScale
    height: lineSpacing
    x: needsAnimation ? (screenWidth-width)/2 : finalPositionX
    y: 165 * screenScale + (64 * screenScale - lineSpacing) / 2
    property string text: "LABEL"
    signal clicked()

    property bool needsAnimation: true

    function animate() {
        if (needsAnimation) {
            opacityAnim.start();
            movementAnim.start();
        }
    }

    opacity: needsAnimation ? 0.0 : 1.0

    PropertyAnimation on x { id: movementAnim; from: (screenWidth-width)/2; to: finalPositionX; running: needsAnimation}
    OpacityAnimator on opacity { id: opacityAnim; from: 0; to: 1.0; easing.type: Easing.InCubic; running: needsAnimation}

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
