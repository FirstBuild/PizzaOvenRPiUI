import QtQuick 2.3
import QtQuick.Controls.Styles 1.4

TumblerStyle {
    id: tumblerStyle

    property int textHeight: lineSpacing
    property int textWidth: 64 * screenScale
    property int textAlignment: Text.AlignLeft
    property int textPointSize: 22 * screenScale
    property bool showKeypress: true

    signal clicked(string name)

    frame: Rectangle {
//        border.color: "red"
//        border.width: 2
        color: appBackgroundColor
    }

    background: Component {
        Rectangle {
            color: appBackgroundColor
        }
    }

    separator: Component {
        Rectangle {
            width: 5
            color: appBackgroundColor
        }
    }

    delegate: Item {
        id: tumblerDelegate
        implicitHeight: textHeight
        implicitWidth: textWidth

        Rectangle {
            id: textBackground
            color: appBackgroundColor
            height: textHeight
            width: textWidth
            anchors.centerIn: parent
//            border.color: "orange"
//            border.width: 1
            Text {
                id: selectionText
                height: parent.height
                width: parent.width
                font.family: localFont.name
                font.pointSize: textPointSize
                text: styleData.value
                anchors.left: parent.left
                horizontalAlignment: textAlignment
                verticalAlignment: Text.AlignVCenter
                color: appForegroundColor
                opacity: Math.pow(2.7183, -Math.abs(styleData.displacement))
            }

        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                autoShutoff.reset();
                if (styleData.current) {
                    tumblerStyle.clicked(styleData.value);
                } else {
                    control.setCurrentIndexAt(styleData.column, styleData.index, 200);
                }
            }
        }
    }


    foreground: Canvas {
        id:canvas
        width:parent.width
        height:parent.height
        property color strokeStyle:  fillStyle
        property color fillStyle: appGrayColor
        property bool fill: true
        property bool stroke: true
        property real alpha: 1.0
        property int lineWidth: 1
        antialiasing: true

        onFillChanged:requestPaint();
        onStrokeChanged:requestPaint();
        onScaleChanged:requestPaint();

        onPaint: {
            var ctx = canvas.getContext('2d');
            var originX = 0
            var originY = 0
            ctx.save();

            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.translate(originX, originX);
            ctx.globalAlpha = canvas.alpha;
            ctx.strokeStyle = canvas.strokeStyle;
            ctx.fillStyle = canvas.fillStyle;
            ctx.lineWidth = canvas.lineWidth;

            ctx.translate(originX, originY)
            ctx.scale(canvas.scale, canvas.scale);
            //            ctx.rotate(canvas.rotate);
            ctx.translate(-originX, -originY)

            ctx.beginPath();
            //            ctx.moveTo(75,40);
            var y1 = parent.height/2 - (lineSpacing/2);
            var y2 = parent.height/2 + (lineSpacing/2);
            ctx.moveTo(0, y1);
            ctx.lineTo(parent.width, y1);
            ctx.moveTo(0, y2);
            ctx.lineTo(parent.width, y2);

            // Draw an X across the viewport
//            ctx.moveTo(0, 0);
//            ctx.lineTo(parent.width, parent.height);
//            ctx.moveTo(0, parent.height);
//            ctx.lineTo(parent.width, 0);


            ctx.closePath();
            if (canvas.fill)
                ctx.fill();
            if (canvas.stroke)
                ctx.stroke();
            ctx.restore();
        }

    }
}


