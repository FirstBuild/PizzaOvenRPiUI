import QtQuick 2.3

Item {
    id: thisScreen

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    property int listItemHeight: lineSpacing
    property int listItemWidth: screenWidth - screenTitle.x - 30

    function screenEntry() {
        screenEntryAnimation.start();
        console.log("Entering screen about.");
        backEnd.sendMessage("GetControlVersion no_params");
        backEnd.sendMessage("GetBackendVersion no_params");
    }

    BackButton{
        id: backButton
        opacity: 0.5
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    // title text
    Rectangle {
        id: screenTitle
        width: 400
        height: 30
        x: (parent.width - width) / 2
        color: appBackgroundColor
        anchors.verticalCenter: backButton.verticalCenter
        Text {
            id: idButtonText
            text: "ABOUT"
            font.family: localFont.name
            font.pointSize: 17
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            color: appGrayText
        }
        NumberAnimation on y {id: titleAnimation; from: (screenHeight-screenTitle.height)/2; to: 41 }
    }

    Flickable {
        width: listItemWidth
        height: screenHeight - backButton.y - backButton.height - anchors.topMargin - 30
        anchors.topMargin: 10
        anchors.top: screenTitle.bottom
        x: 80
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
                    text: "UI VERSION"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Text {
                    height: listItemHeight
                    text: uiVersion
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
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
                    text: "CONTROL VERSION"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Text {
                    height: listItemHeight
                    text: controlVersion
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
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
                    text: "BACKEND VERSION"
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.left: parent.left
                }
                Text {
                    height: listItemHeight
                    text: backendVersion
                    color: appForegroundColor
                    font.family: localFont.name
                    font.pointSize: 18
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    anchors.right: parent.right
                }
            }
        }
    }
}
