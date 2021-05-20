import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: domeToggle

//    property int finalPositionX: screenWidth-26-width
    property int finalPositionX: screenWidth-34-width
    property bool state: rootWindow.domeState.displayed

//    width: 125
    width: 165
    height: lineSpacing
    x: needsAnimation ? (screenWidth-width)/2 : finalPositionX
//    y: 300 - lineSpacing
    y: 396 - lineSpacing
    property string text: "IDLE"
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

    Column {
        //spacing: 10
        Text {
            id: theText
            text: "DOME"
            width: domeToggle.width
            height: domeToggle.height/2
            font.family: localFont.name
//            font.pointSize: 16
            font.pointSize: 21
            color: appForegroundColor
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
        }

        SlideOffOn {
            id: theSlider
            trueText: "On"
            falseText: "Off"
            width: domeToggle.width
            height: domeToggle.height/2
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                console.log("Got a click in the dome slider.");
                domeToggle.clicked();
            }
            state: rootWindow.domeState.displayed;
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("The dome mouse area was clicked");
            autoShutoff.reset();
            sounds.touch.play();
            rootWindow.domeState.toggle();
            domeToggle.clicked();
        }
    }
}
