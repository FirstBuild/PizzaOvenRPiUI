import QtQuick 2.3
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen

    property int tumblerHeight: 250
    property int tumblerRows: 5
    property int titleTextPointSize: 1
    property int titleTextToPointSize: 18

    property int currentMaxVolume: volumeEntry.currentIndexAt(0) * 10 +
                                   volumeEntry.currentIndexAt(1)
    property bool uiLoaded: false

    onCurrentMaxVolumeChanged: {
        if (uiLoaded) {
            maxVolume = currentMaxVolume;
            appSettings.maxVolume = maxVolume;
            console.log("Max volume is now " + maxVolume);
            sounds.touch.play();
        }
    }

    BackButton {
        id: backButton
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    ClickableTextBox {
        id: screenTitle
        text: "MAX VOLUME SETTING"
        width: 270
        x: 80
        anchors.verticalCenter: backButton.verticalCenter
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        onClicked: backButton.clicked();
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
            volumeEntry.setCurrentIndexAt(0, maxVolume/10);
            volumeEntry.setCurrentIndexAt(1, maxVolume%10);
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
            id: tensColumn
            width: appColumnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
        TumblerColumn {
            id: onesColumn
            width: appColumnWidth
            model: [0,1,2,3,4,5,6,7,8,9]
        }
    }}
