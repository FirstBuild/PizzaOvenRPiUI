import QtQuick 2.3
import QtQuick.Controls.Styles 1.4

TumblerStyle {
    id: tumblerStyle
    property int textHeight: 64
    property int textWidth: 64
    property int textAlignment: Text.AlignLeft
    signal clicked(string name)
    frame: Rectangle {
//        border.color: "red"
//        border.width: 1
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
//            Rectangle {
//                width: 1
//                height: parent.height
//                color: appGrayColor
//                anchors.centerIn: parent
//            }
        }
    }

    delegate: Item {
        id: tumblerDelegate
        implicitHeight: (control.height - padding.top - padding.bottom) / tumblerStyle.visibleItemCount

        Rectangle {
            id: textBackground
            color: appBackgroundColor
            //height: parent.height
            height: 62
//            width: textWidth
            width: parent.width
            anchors.centerIn: parent
        }

        Text {
            id: selectionText
            height: textHeight
            width: textWidth
            font.family: localFont.name
            font.pointSize: 24
            text: styleData.value
            anchors.centerIn: parent
            horizontalAlignment: textAlignment
            verticalAlignment: Text.AlignVCenter
            color: appForegroundColor
            opacity: Math.pow(2.7183, -Math.abs(styleData.displacement))
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                if (styleData.current) {
                    tumblerStyle.clicked(styleData.value);
                }
            }
            onPressed: {
                if (styleData.current) {

//                    textBackground.color = appForegroundColor;
//                    selectionText.color = appBackgroundColor;
                    textBackgroundOnPressed.start();
                    selectionTextOnPressed.start();
                }
            }
            onReleased: {
                if (styleData.current) {
//                    textBackground.color = appBackgroundColor;
//                    selectionText.color = appForegroundColor;
                    textBackgroundOnReleased.start();
                    selectionTextOnReleased.start();
                }
            }
            onPositionChanged: {
                if (styleData.current) {
                    textBackground.color = appBackgroundColor;
                    selectionText.color = appForegroundColor;
                }
            }
        }
        ColorAnimation {
            id: textBackgroundOnPressed
            target: textBackground
            property: "color"
            to: appForegroundColor
        }
        ColorAnimation {
            id: textBackgroundOnReleased
            target: textBackground
            property: "color"
            to: appBackgroundColor
        }
        ColorAnimation {
            id: selectionTextOnPressed
            target: selectionText
            property: "color"
            to: appBackgroundColor
        }
        ColorAnimation {
            id: selectionTextOnReleased
            target: selectionText
            property: "color"
            to: appForegroundColor
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
            var y1 = parent.height/2 - 31;
            var y2 = parent.height/2 + 31;
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


