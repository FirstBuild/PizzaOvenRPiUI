import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    width: parent.width
    height: parent.height

    property int tumblerColumns: 4
    property int tumblerHeight: 1
    property int tumblerRows: 5
    property int titleTextPointSize: 1
    property int titleTextToPointSize: 18

    function screenEntry() {
        screenEntryAnimation.start();
        tumblerHeightAnim.start();
        titleTextAnim.start();
        nextButton.animate();
    }

    OpacityAnimator {id: screenEntryAnimation; target: thisScreen; from: 0.0; to: 1.0;}

    BackButton {
        id: backButton
        onClicked: {
            stackView.pop({immediate:immediateTransitions});
        }
    }

    NumberAnimation on tumblerHeight {
        id: tumblerHeightAnim
        from: 1
        to: 250
    }

    NumberAnimation on titleTextPointSize {
        id: titleTextAnim
        from: 1
        to: titleTextToPointSize
    }

    Text {
        text: "Select final check time"
        font.family: localFont.name
        font.pointSize: titleTextPointSize
        color: appGrayText
        width: 400
        height: 30
        x: screenWidth - width - 26
        y: 41
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        //        opacity: 0.5
    }

    Item {
        width: 300
        height: tumblerHeight
        x:88
        anchors.verticalCenter: nextButton.verticalCenter

        OpacityAnimator { from: 0.0; to: 1.0}

        TimeEntryTumbler {
            id: timeEntryTumbler
            timeValue: finalCheckTime
            height: tumblerHeight
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            columnWidth: appColumnWidth
            tumblerRows: tumblerRows
        }
    }

    ButtonRight {
        id: nextButton
        text: "DONE"
        onClicked: SequentialAnimation {
            id: screenExitAnimation
            ScriptAction {
                script: {
                    var temp = timeEntryTumbler.getTime();
                    if (temp !== finalCheckTime) {
                        foodNameString = "CUSTOM"
                    }
                    var allSettings = menuSettings.json;
                    for(var i=0; i<allSettings.menuItems.length; i++) {
                        if (allSettings.menuItems[i].name === "CUSTOM") {
                            console.log("Custom found at index " + i);
//                            var settings = {
//                                "domeTemp": upperFront.setTemp,
//                                "stoneTemp": lowerFront.setTemp,
//                                "cookTime": cookTime,
//                                "finalCheckTime": finalCheckTime,
//                                "halfTimeCheck": halfTimeRotate
//                            }

                            allSettings.menuItems[i].domeTemp = upperFront.setTemp;
                            allSettings.menuItems[i].stoneTemp = lowerFront.setTemp;
                            allSettings.menuItems[i].cookTime = cookTime;
                            allSettings.menuItems[i].finalCheckTime = finalCheckTime;
                            allSettings.menuItems[i].halfTimeCheck = halfTimeRotate;
                            menuSettings.json = allSettings;
                        }
                    }

                    finalCheckTime = timeEntryTumbler.getTime();
                    backEnd.sendMessage("FinalCheckTime " + finalCheckTime);
                }
            }
            OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
            ScriptAction {
                script: {
                    stackView.clear();
                    stackView.push({item:Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
                }
            }
        }
    }
}

