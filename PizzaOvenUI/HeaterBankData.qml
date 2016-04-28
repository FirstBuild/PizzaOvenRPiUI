import QtQuick 2.0

Item {
    id: bankModel

    property string bank: "LL"
    property int currentTemp: 100
    property int setTemp: 1250
    property real elementDutyCycle: 10
    property int elementRelay: 0
    property int onPercent: 0
    property int offPercent: 49
    property int temperatureDeadband: 100
}

