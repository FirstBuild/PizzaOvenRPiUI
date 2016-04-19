import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenAwaitStart
    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 10

    BackButton {
        id: backbutton
        anchors.margins: myMargins
        x: myMargins
        y: myMargins
//        onClicked: {
//            stackView.pop({immediate:immediateTransitions});
//        }
    }

    Text {
        id: screenLabel
        font.family: localFont.name
        font.pointSize: 24
        text: "PREHEATING"
        anchors.margins: myMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: backbutton.verticalCenter
        color: appForegroundColor
    }

    Item {
        id: centerCircle
        implicitWidth: parent.height * 0.7;
        implicitHeight: width
        anchors.margins: myMargins
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40

        CircleAsymmetrical {
            id: dataCircle
            height: parent.height;
            width: parent.width
            topText: tempToString(targetTemp)
            bottomText: tempToString(currentTemp)
        }
    }

    SideButton {
        id: cancelButton
        buttonText: "CANCEL"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.right: centerCircle.left
        onClicked: {
            console.log("The cancel button was clicked.");
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
        }
    }

    Timer {
        id: animateTimer
        interval: 250; running: true; repeat: true
        onTriggered: {
            var val = 0;
            if (demoModeIsActive) {
                val = dataCircle.currentValue + 10;
                if (val > 100) {
                    val = 0;
                    animateTimer.stop();
                    stackView.push({item:Qt.resolvedUrl("Screen_Start.qml"), immediate:immediateTransitions});
                }
                dataCircle.currentValue = val;

                val = 80 + (targetTemp - 80) * val / 100
                dataCircle.bottomText = tempToString(val);
            } else {
                val = 100 * currentTemp / targetTemp;
                if (val >= 100) {
                    val = 0;
                    animateTimer.stop();
                    stackView.push({item:Qt.resolvedUrl("Screen_Start.qml"), immediate:immediateTransitions});
                }
                dataCircle.currentValue = val;

                dataCircle.bottomText = tempToString(currentTemp);
            }

            dataCircle.topText = tempToString(targetTemp);
        }
    }
}

