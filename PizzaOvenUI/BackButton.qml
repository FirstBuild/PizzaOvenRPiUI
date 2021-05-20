import QtQuick 2.3

Rectangle {
    id: backButton
    signal clicked()
    implicitWidth: 14
    implicitHeight: 26
    color: appBackgroundColor
    x: 48
    y: 45
    property int segmentThickness: 2
    property color segmentColor: appForegroundColor

    NumberAnimation on opacity { from: 0; to: 1.0; easing.type: Easing.InCubic }

    Rectangle {
        height: lineSpacing
        width: lineSpacing
        anchors.centerIn: parent
        color: backButton.color
//        border.color: "orange"
//        border.width: 1
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: SequentialAnimation {
                ScriptAction {
                    script: {
                        autoShutoff.reset();
                        sounds.touch.play();
                    }
                }
                OpacityAnimator {target: thisScreen; from: 1.0; to: 0.0;}
                ScriptAction {
                    script: {
                        console.log("Current stack depth: " + stackView.depth);
                        if (stackView.depth > 1) {
                            backButton.clicked();
                        }
                        else
                        {
                            console.log("Preheat complete is " + preheatComplete);
                            console.log("clearing stack view");
                            stackView.clear();
                            if (preheatComplete) {
                                stackView.push({item:Qt.resolvedUrl("Screen_Cooking.qml"), immediate:immediateTransitions});
                            } else {
                                if (ovenIsRunning()) {
                                    stackView.push({item:Qt.resolvedUrl("Screen_Preheating2Temp.qml"), immediate:immediateTransitions});
                                } else {
                                    stackView.push({item:Qt.resolvedUrl("Screen_AwaitStart.qml"), immediate:immediateTransitions});
                                }
                            }
                        }

                    }
                }
            }
        }
    }

    Canvas {
        id: drawing
        width: parent.width
        height: parent.height
        antialiasing: true
        anchors.centerIn: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.save();

            ctx.clearRect(0, 0, width, height);

            ctx.beginPath();
            ctx.lineWidth = segmentThickness;
            ctx.strokeStyle = segmentColor;
            ctx.moveTo(width-1, height-1);
            ctx.lineTo(1, height/2);
            ctx.lineTo(width-1, 1);
            ctx.stroke();

            ctx.restore();
        }
    }

}

