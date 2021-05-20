import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: circleScreenTemplate

    width: parent.width
    height: parent.height

    property int circleValue: 25
    property string titleText: "TITLE TEXT"
    property bool showTitle: true
    property bool showNotice: false
    property string noticeText: "RIGHT TEXT"
    property int circleDiameter: 272
//    property int circleDiameter: 206
    property bool needsAnimation: true
    property string newTitleText: "NEW TITLE"
    property bool fadeInTitle: false

    opacity: needsAnimation ? 0.0 : 1.0

    OpacityAnimator on opacity {id: screenAnimation; from: 0; to: 1.0; easing.type: Easing.InCubic; running: needsAnimation }
    OpacityAnimator on opacity {id: fadeTitleIn; target: titleBox; from: 0.0; to: 1.0; easing.type: Easing.InCubic; running: false }
    OpacityAnimator on opacity {id: fadeTitleOut; target: titleBox; from: 1.0; to: 0.0; easing.type: Easing.InCubic; running: false }

    onShowTitleChanged: {
        if (showTitle) {
            showNotice = false;
            showTitleBox.start();
        }
    }

    onShowNoticeChanged: {
        if (showNotice) {
            showTitle = false;
            showNoticeBox.start();
        }
    }

    function animate() {
        screenAnimation.start();
        circleWidthAnimation.start();
        circleHeightAnimation.start();
        titleAnimation.start();
        noticeAnimation.start();
    }

    function fadeOutTitleText() {
        fadeTitleOut.start();
    }

    function fadeInTitleText() {
        fadeTitleIn.start();
    }

    onNewTitleTextChanged: SequentialAnimation {
        OpacityAnimator {target: titleBox; from: 1.0; to: 0.0}
        ScriptAction {
            script: {titleText = newTitleText;}
        }
        OpacityAnimator {target: titleBox; from: 0.0; to: 1.0}
    }

    // center circle
    Item {
        id: centerCircle
//        height: 206
//        width: 206
        height: 272
        width: 272
        x: (parent.width - width) / 2
//        y: 96
        y: 127

        ProgressCircle {
            id: dataCircle
            currentValue: circleValue
            NumberAnimation on width {id: circleWidthAnimation; from: 10; to: circleDiameter; running: needsAnimation}
            NumberAnimation on height {id: circleHeightAnimation; from: 10; to: circleDiameter; running: needsAnimation}
            anchors.centerIn: parent
        }
    }

    // title text
    Rectangle {
        id: titleBox
//        width: 400
//        height: 30
        width: 528
        height: 40
        opacity: fadeInTitle ? 0.0 : 1.0
        x: (parent.width - width) / 2
//        y: needsAnimation ? (screenHeight-titleBox.height)/2 : 41
        y: needsAnimation ? (screenHeight-titleBox.height)/2 : 54
        color: appBackgroundColor
        Text {
            text: titleText
            font.family: localFont.name
//            font.pointSize: 17
            font.pointSize: 22
            anchors.centerIn: parent
            color: appGrayText
        }
        OpacityAnimator {target: titleBox; from: 0.0; to: 1.0; running: fadeInTitle}
//        NumberAnimation on y {id: titleAnimation; from: (screenHeight-titleBox.height)/2; to: 41; running: needsAnimation }
        NumberAnimation on y {id: titleAnimation; from: (screenHeight-titleBox.height)/2; to: 54; running: needsAnimation }
    }

    // notification text
    Rectangle {
        id: noticeBox
        width: screenWidth - 60
//        height: 30
        height: 40
        opacity: 0.0
//        x: 30
//        y: needsAnimation ? (screenHeight-titleBox.height)/2 : 41
        x: 40
        y: needsAnimation ? (screenHeight-titleBox.height)/2 : 54
        color: appBackgroundColor
        Text {
            text: noticeText
            font.family: localFont.name
//            font.pointSize: 17
            font.pointSize: 22
            anchors.right: parent.right
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: appGrayText
        }
//        NumberAnimation on y {id: noticeAnimation; from: (screenHeight-titleBox.height)/2; to: 41; running: needsAnimation }
        NumberAnimation on y {id: noticeAnimation; from: (screenHeight-titleBox.height)/2; to: 54; running: needsAnimation }
    }

    ParallelAnimation {
        id: showTitleBox
        running: false
        NumberAnimation {target: noticeBox; property: "opacity"; from: 1.0; to: 0.0; }
        NumberAnimation {target: titleBox; property: "opacity"; from: 0.0; to: 1.0; }
    }
    ParallelAnimation {
        id: showNoticeBox
        running: false
        NumberAnimation {target: noticeBox; property: "opacity"; from: 0.0; to: 1.0; }
        NumberAnimation {target: titleBox; property: "opacity"; from: 1.0; to: 0.0; }
    }
}

