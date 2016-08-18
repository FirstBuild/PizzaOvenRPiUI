import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: circleScreenTemplate

    implicitWidth: parent.width
    implicitHeight: parent.height

    property int circleValue: 25
    property string titleText: "TITLE TEXT"

    // center circle
    Item {
        id: centerCircle
        height: 206
        width: 206
        x: (parent.width - width) / 2
        y: 96
        ProgressCircle {
            id: dataCircle
            height: parent.height
            width: parent.width
            currentValue: circleValue
        }
    }

    // title text
    Rectangle {
        id: titleBox
        width: 400
        height: 30
        x: (parent.width - width) / 2
        y: 41
        color: appBackgroundColor
        Text {
            id: idButtonText
            text: titleText
            font.family: localFont.name
            font.pointSize: 17
            anchors.centerIn: parent
            color: appGrayText
        }
    }
}

