import QtQuick 2.5
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4
//import QtQuick.Controls 2.0
import Qt.labs.controls 1.0
//import Qt.labs.templates 1.0 as T

Item {
    width: screenWidth
    height: screenHeight

    Component {
        id: theDelegate
        Rectangle {
            width: 350
            implicitHeight: lineSpacing
            height: lineSpacing
            color: appBackgroundColor
            Text {
                text: (model === null) ? "null" : model.name
                font.family: localFont.name
                font.pointSize: 24
                height:lineSpacing
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color:  appForegroundColor
                anchors.left: parent.left
                opacity: Math.pow(2.7183, -Math.abs(styleData.displacement))
            }
            SlideOffOn{
                id: twoTempSlider
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                state: true
                visible: (model === null) ? false : model.display
                opacity: Math.pow(2.7183, -Math.abs(styleData.displacement))
            }
        }
    }

    ListModel {
        id: settingsModel
        ListElement { name: "TEMP"; color: "red"; display: true }
        ListElement { name: "Two"; color: "green"; display: false }
        ListElement { name: "Three"; color: "blue"; display: false }
        ListElement { name: "Four"; color: "yellow"; display: false }
        ListElement { name: "Five"; color: "orange"; display: false }
        ListElement { name: "Six"; color: "cyan"; display: false }
        ListElement { name: "Seven"; color: "gray"; display: true }
    }

//    Rectangle {
//        color: "yellow"
//        height: 1
//        width: listViewTumbler.width + 20
//        x: listViewTumbler.x - 10
//        y: listViewTumbler.y + listViewTumbler.height/2 - lineSpacing / 2
//    }
//    Rectangle {
//        color: "yellow"
//        height: 1
//        width: listViewTumbler.width + 20
//        x: listViewTumbler.x - 10
//        y: listViewTumbler.y + listViewTumbler.height/2 + lineSpacing / 2
//    }

    MyTumbler {
        id: listViewTumbler
        height: 250
        width: 300
        x: 180
        y: 85
        font.pointSize: 24
        font.family: localFont.name

        model: settingsModel
        visibleItemCount: 5

        foregroundColor: appForegroundColor

        onClicked: {
//            if (name !== listView.currentItem.text) {
//                for (var i=0; i<settingsModel.count; i++) {
//                    if (settingsModel.get(i).name === name) {
//                        listView.positionViewAtIndex(i, ListView.Center);
//                        return;
//                    }
//                }
//            } else {
//                console.log(name + " was clicked.");
//            }
        }

//        contentItem: ListView {
//            id: listView
//            model: listViewTumbler.model
//            snapMode: ListView.SnapToItem
//            anchors.fill: parent
//            delegate: listViewTumbler.delegate
//            highlightRangeMode: ListView.StrictlyEnforceRange
//            preferredHighlightBegin: height / 2 - (height / listViewTumbler.visibleItemCount / 2)
//            preferredHighlightEnd: height / 2  + (height / listViewTumbler.visibleItemCount / 2)
//            clip: true
//        }
    }
}
