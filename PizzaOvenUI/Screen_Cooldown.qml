import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenCooldown

    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 10

    CircleScreenTemplate {
        circleValue: 0
        titleText: "COOLING DOWN"
    }

    HomeButton {
        id: homeButton
        onClicked: SequentialAnimation {
            OpacityAnimator {target: screenAwaitStart; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    stackView.clear();
                    stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
                }
            }
        }
    }

    Text {
        id: screenMessage
        text: "CAUTION<br>OVEN IS HOT"
        height: 206
        width: height
        x: (parent.width - width) / 2
        y: 96 + (206 - height)/2
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: localFont.name
        font.pointSize: 18
        wrapMode: Text.Wrap
        color: appForegroundColor
    }
}
