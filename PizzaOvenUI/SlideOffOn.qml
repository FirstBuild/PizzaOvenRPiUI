import QtQuick 2.0

Item {
    id: toggle

    width: 110
    height: 40

    property int barHeight: 4
    property int barWidth: toggle.width * 0.4
    property color barColor: { toggle.state ? appForegroundColor : appGrayColor }
    property int ballRadius: 10
    property color ballColor: { toggle.state ? appForegroundColor : appGrayColor }
    property bool state: false
    property string trueText: "ON"
    property string falseText: "OFF"

    Text {
        text: { toggle.state ? trueText : falseText }
        font.family: localFont.name
        font.pointSize: 18
        color: { toggle.state ? appForegroundColor : appGrayText }
        width: parent.width/2
        height: parent.height
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    Item {
        id: toggleBar
        width: toggle.barWidth
        height: parent.height
        anchors.right: parent.right

        Rectangle {
            id: leftBarEnd
            height: barHeight
            width: barHeight
            radius: barHeight/2
            x: 0
            anchors.verticalCenter: parent.verticalCenter
            color: barColor
        }

        Rectangle {
            id:rightBarEnd
            height: barHeight
            width: barHeight
            radius: barHeight/2
            x: parent.width - barHeight
            anchors.verticalCenter: parent.verticalCenter
            color: barColor
        }

        Rectangle {
            id: bar
            height: barHeight
            width: parent.width - barHeight
            x: barHeight/2
            anchors.verticalCenter: parent.verticalCenter
            color: barColor
        }

        Rectangle {
            id: ball
            width: ballRadius * 2
            height: width
            radius: ballRadius
            anchors.verticalCenter: parent.verticalCenter
            x: {toggle.state ? (parent.width - ballRadius * 2) : 0}
            color: ballColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                toggle.state = !toggle.state;
            }
        }
    }
}
