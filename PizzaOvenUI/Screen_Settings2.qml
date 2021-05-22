import QtQuick 2.3
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.0

Item {
    id: thisScreen
    height: parent.height
    width: parent.width
    property string screenName: "Screen_Settings2"

    property string targetScreen: ""

    opacity: 0.0

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    SequentialAnimation {
        id: screenExitAnimator
        OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0}
        ScriptAction {
            script: {
                stackView.push({item: Qt.resolvedUrl(targetScreen), immediate:immediateTransitions});
            }
        }
    }

    property int listItemHeight: 50
    property int listItemWidth: screenWidth - screenTitle.x - 30
    property int listTextWidth: 300

    function screenEntry() {
        console.log("Entering settings 2 screen");
        screenEntryAnimation.start();
    }

    function acceptSelection() {
        var settings = settingsModel.get(theColumn.currentIndex);

        console.log(settings.name + " selected.");

        if (settings.screen) {
            singleSettingOnly = true;
            bookmarkCurrentScreen();
            targetScreen = settings.screen
            screenExitAnimator.start();
        }
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
        //y: 41
        color: appBackgroundColor
        Text {
            id: idButtonText
            text: "SETTINGS"
            font.family: localFont.name
            font.pointSize: 18
            anchors.centerIn: parent
            color: appGrayText
        }
        NumberAnimation on y {id: titleAnimation; from: (screenHeight-screenTitle.height)/2; to: 41 }
    }

    ListModel {
        id: settingsModel
        ListElement { name: "CHECK FOOD REMINDERS"; screen: "Screen_EnterChecks.qml" }
        ListElement { name: "PREFERENCES"; screen: "Screen_Preferences.qml" }
        ListElement { name: "CONTROL LOCKOUT" }
        ListElement { name: "VOLUME"; screen: "Screen_SetVolume.qml" }
        ListElement { name: "DISPLAY BRIGHTNESS"; screen: "Screen_SetBrightness.qml" }
        ListElement { name: "ABOUT"; screen: "Screen_About.qml" }
        ListElement { name: "TIME"; screen: "Screen_SettingsTime.qml" }
    }

    Tumbler {
        id: settingsTumbler
        height: 225
        width: 375
        x: 105
        y: 85

        style:  MyTumblerStyle {
            onClicked: {
                sounds.select.play();
                acceptSelection();
            }
            visibleItemCount: 5
            textHeight:settingsTumbler.height/visibleItemCount
            textWidth: settingsTumbler.width
            padding.top: 0
            padding.bottom: 0
            padding.left: 0
            padding.right: 0
            spacing: 100
            textPointSize: 20
        }
        TumblerColumn {
            id: theColumn
            width: settingsTumbler.width
            model: settingsModel
            role: "name"
        }
    }
}
