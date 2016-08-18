import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: screenOff

    implicitWidth: parent.width
    implicitHeight: parent.height

    property int myMargins: 10

//    Image {
//        id: pizzaOvenOffImage
////            source: "pizza_oven_blank_screen.jpg"
////        source: "PizzaOvenAwaitPreheat.png"
////        source: "TwoTemps.png"
//        source: "MainMenu.png"
//        anchors.centerIn: parent
//    }


    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (demoModeIsActive) {
                stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
            }
            if (developmentModeIsActive) {
                stackView.push({item:Qt.resolvedUrl("Screen_Development.qml"), immediate:immediateTransitions});
            }
        }
    }
}

