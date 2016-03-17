import QtQuick 2.3
import QtQuick.Controls.Styles 1.4

TumblerStyle {
    id: tumblerStyle
    property int textHeight: 50
    property int textWidth: 50
    property int textAlignment: Text.AlignLeft
    signal clicked(string name)
    frame: Rectangle {
        border.color: "black"
        border.width: 0
        color: appBackgroundColor
    }

//    background: Item {
//        MouseArea {
//            onClicked: {
//                console.log("Background was clicked.");
//            }

//        }
//    }

    delegate: Item {
        id: tumblerDelegate
        implicitHeight: (control.height - padding.top - padding.bottom) / tumblerStyle.visibleItemCount

        Rectangle {
            id: textBackground
            color: appBackgroundColor
            height: parent.height
            width: parent.width
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

            opacity: 1.0 - (Math.abs(styleData.displacement)+1)/visibleItemCount
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
                    textBackground.color = appForegroundColor;
                    selectionText.color = appBackgroundColor;
                }
            }
            onReleased: {
                if (styleData.current) {
                    textBackground.color = appBackgroundColor;
                    selectionText.color = appForegroundColor;
                }
            }
            onPositionChanged: {
                if (styleData.current) {
                    textBackground.color = appBackgroundColor;
                    selectionText.color = appForegroundColor;
                }
            }
        }
    }

    foreground: Canvas {
        id:canvas
        width:parent.width
        height:parent.height
//        property color strokeStyle:  Qt.darker(fillStyle, 1.4)
        property color strokeStyle:  fillStyle
//        property color fillStyle: "#808080"
        property color fillStyle: appForegroundColor
        property bool fill: true
        property bool stroke: true
        property real alpha: 1.0
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
            var y1 = ((visibleItemCount-1)/2)*parent.height/visibleItemCount;
            var y2 = ((visibleItemCount+1)/2)*parent.height/visibleItemCount;
            ctx.moveTo(0, y1);
            ctx.lineTo(parent.width, y1);
            ctx.moveTo(0, y2);
            ctx.lineTo(parent.width, y2);

            // Draw an X across the viewport
//            ctx.moveTo(0, 0);
//            ctx.lineTo(parent.width, parent.height);
//            ctx.moveTo(0, parent.height);
//            ctx.lineTo(parent.width, 0);


//            console.log("Width: " + parent.width);
//            console.log("Height: " + parent.height);

            ctx.closePath();
            if (canvas.fill)
                ctx.fill();
            if (canvas.stroke)
                ctx.stroke();
            ctx.restore();
        }

    }
}


