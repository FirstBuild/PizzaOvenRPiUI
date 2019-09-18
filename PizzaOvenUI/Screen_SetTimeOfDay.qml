import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id: thisScreen
    width: parent.width
    height: parent.height
    property string screenName: "Screen_SetTimeOfDay"

    property int itemsPerTumbler: 5

    TimeEntryWithKeys {
        id: timeBox
        header: "Enter the time of day"
        value: {
            var t = timeOfDay.split(":");
            return t[0] + t[1];
        }

        onDialogCanceled: {
            stackView.pop({immediate:immediateTransitions});
        }

        onDialogCompleted: {
            setTimeOfDay(display)
            stackView.pop({immediate:immediateTransitions});
        }
    }
}

