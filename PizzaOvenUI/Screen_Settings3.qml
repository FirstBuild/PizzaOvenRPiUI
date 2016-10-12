import QtQuick 2.6
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4

Item {

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

    Tumbler {
        id: listViewTumbler
        height: 5 * lineSpacing
        width: 350
        anchors.centerIn: parent

        style: MyTumblerStyle {
            visibleItemCount: 5
            textHeight:lineSpacing
            padding.top: 0
            padding.bottom: 0
            padding.left: 0
            padding.right: 0
            delegate: theDelegate
        }

        TumblerColumn {
            model: settingsModel
            width: 350
        }
    }
}
