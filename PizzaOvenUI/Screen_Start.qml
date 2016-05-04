import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenStart
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

    function screenEntry() {
        sounds.notification.play();
    }

    Text {
        id: screenLabel
        font.family: localFont.name
        font.pointSize: 24
        text: "READY"
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
            topText: tempToString(upperFront.setTemp)
            middleText: tempToString(lowerFront.setTemp)
            bottomText: timeToString(cookTime)
        }
    }

    CancelButton {
        id: cancelButton
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.right: centerCircle.left
        onClicked: {
            console.log("The cancel button was clicked.");
            stackView.clear();
            stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
        }
    }
    SideButton {
        id: startButton
        buttonText: "START"
        anchors.margins: myMargins
        anchors.verticalCenter: centerCircle.verticalCenter
        anchors.left: centerCircle.right
        onClicked: {
            console.log("The start button was clicked.");
            currentTime = 0;
            stackView.push({item:Qt.resolvedUrl("Screen_CookingFirstHalf.qml"), immediate:immediateTransitions});
        }
    }
}

