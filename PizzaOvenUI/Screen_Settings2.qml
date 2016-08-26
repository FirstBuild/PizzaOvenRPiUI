import QtQuick 2.0

Item {
//    Image {
//        id: pizzaOvenOffImage
//        //            source: "pizza_oven_blank_screen.jpg"
//        //        source: "PizzaOvenAwaitPreheat.png"
//        //        source: "TwoTemps.png"
//        //        source: "BackArrow.png"
//        source: "SettingsTitleLocation.png"
////        anchors.centerIn: parent
//        y:18
//        x:-1
//    }

    BackButton{
        id: backButton
        opacity: 0.5
    }


    Text {
        id: screenTitle
        text: "SETTINGS"
        font.family: localFont.name
        font.pointSize: 18
        color: appGrayText
        width: 400
        height: 30
        x: 80
        anchors.verticalCenter: backButton.verticalCenter
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }


    property int listItemHeight: 40
    property int listItemWidth: screenWidth - screenTitle.x - 30

    Flickable {
        width: listItemWidth
        height: screenHeight - backButton.y - backButton.height - anchors.topMargin - 30
        anchors.topMargin: 10
        anchors.top: screenTitle.bottom
//        anchors.horizontalCenter: parent.horizontalCenter
        x: screenTitle.x
        contentWidth: listItemWidth
        contentHeight: settingsList.height
        clip: true
        Column {
            id: settingsList
            width: parent.width
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "TEMPERATURE UNITS"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                SlideOffOn{
                    anchors.right: parent.right
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "TEMPERATURE UNITS"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Text {
                    height: listItemHeight
                    text: "F   C"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.right: parent.right
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "TEMPERATURE UNITS"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Text {
                    height: listItemHeight
                    text: "F   C"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.right: parent.right
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "TEMPERATURE UNITS"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Text {
                    height: listItemHeight
                    text: "F   C"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.right: parent.right
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "TEMPERATURE UNITS"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Text {
                    height: listItemHeight
                    text: "F   C"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.right: parent.right
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "TEMPERATURE UNITS"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Text {
                    height: listItemHeight
                    text: "F   C"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.right: parent.right
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "TEMPERATURE UNITS"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Text {
                    height: listItemHeight
                    text: "F   C"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.right: parent.right
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "TEMPERATURE UNITS"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Text {
                    height: listItemHeight
                    text: "F   C"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.right: parent.right
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "TEMPERATURE UNITS"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Text {
                    height: listItemHeight
                    text: "F   C"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.right: parent.right
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "TEMPERATURE UNITS"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Text {
                    height: listItemHeight
                    text: "F   C"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.right: parent.right
                }
            }
            Rectangle {
                height: listItemHeight
                width: parent.width
                color: appBackgroundColor
                Text {
                    height: listItemHeight
                    text: "TEMPERATURE UNITS"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Text {
                    height: listItemHeight
                    text: "F   C"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors.right: parent.right
                }
            }
        }
    }
}
