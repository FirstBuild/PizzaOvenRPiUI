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
////        source: "BackArrow.png"
//        source: "RadioButton.png"
//        anchors.centerIn: parent
//    }

    function screenEntry() {
        appSettings.backlightOff = true;
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (demoModeIsActive) {
                appSettings.backlightOff = false;
                stackView.push({item:Qt.resolvedUrl("Screen_MainMenu.qml"), immediate:immediateTransitions});
            }
            if (developmentModeIsActive) {
                appSettings.backlightOff = false;
                stackView.push({item:Qt.resolvedUrl("Screen_Development.qml"), immediate:immediateTransitions});
            }
        }
    }



//    MyRadioButton {
//        id: theRadio
//        x: 218
//        y: 218 -75 -19
//        onClicked: {
//            theRadio.state = !theRadio.state
//        }
//    }

    //    SlideOffOn {
    //        id: slide1
//        x: 100
//        y: 100
//    }
//    SlideOffOn {
//        anchors.left: slide1.left
//        anchors.topMargin: 10
//        anchors.top: slide1.bottom
//    }
}

