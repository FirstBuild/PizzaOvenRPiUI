import QtQuick 2.3

Item {
    id: thisScreen

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    property int listItemHeight: 40
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

    ClickableTextBox {
        id: screenTitle
        text: "ABOUT"
        width: 85
        x: 80
        anchors.verticalCenter: backButton.verticalCenter
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        onClicked: backButton.clicked();
    }

    Flickable {
        width: listItemWidth
        height: screenHeight - backButton.y - backButton.height - anchors.topMargin - 30
        anchors.topMargin: 10
        anchors.top: screenTitle.bottom
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
