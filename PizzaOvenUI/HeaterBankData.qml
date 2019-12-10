import QtQuick 2.0

Item {
    id: bankModel

    property string bank: "LL"
    property real currentTemp: 100
    property real failTemp: 0
    property real setTemp: 1250
    property real elementDutyCycle: 10
    property int elementRelay: 0
    property int onPercent: 0
    property int offPercent: 49
    property real temperatureDeadband: 100
    property real maxTemp: 800
}

