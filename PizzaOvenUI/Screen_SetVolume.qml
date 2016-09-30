import QtQuick 2.3
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    function screenEntry() {
        screenEntryAnimation.start();
        console.log("Entering volume settings.");
    }

    property int tumblerHeight: 250
    property int tumblerRows: 5
    property int titleTextPointSize: 1
    property int titleTextToPointSize: 18

    property int currentIndex: volumeEntry.currentIndexAt(0)

    property bool uiLoaded: false

    onCurrentIndexChanged: {
        if (uiLoaded){
            console.log("The volume tumbler index changed.");
            volumeSetting = volumeEntry.currentIndexAt(0);
            console.log("Volume is now " + volumeSetting);
            appSettings.volumeSetting = volumeSetting;
            sounds.touch.play();
        }
    }

    BackButton {
        id: backButton
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    Text {
        id: screenTitle
        text: "VOLUME SETTING"
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

    Tumbler {
        id: volumeEntry
        height: tumblerHeight
        anchors.bottomMargin: 20
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        NumberAnimation on opacity {
            id: anim;
            from: 0.0;
            to: 1.0;
            easing.type: Easing.InCubic;
        }

        Component.onCompleted: {
            volumeEntry.setCurrentIndexAt(0, volumeSetting);
            anim.start();
            uiLoaded = true;
        }

        style:  MyTumblerStyle {
            visibleItemCount: tumblerRows
            textHeight:volumeEntry.height/visibleItemCount
            textWidth: appColumnWidth
            textAlignment: Text.AlignHCenter
            showKeypress: false
        }
        TumblerColumn {
            id: volumeColumn
            width: appColumnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
    }
}
