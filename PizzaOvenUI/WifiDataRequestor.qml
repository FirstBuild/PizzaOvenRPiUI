import QtQuick 2.0

Item {
    id: wifiDataRequestor

    property int index: 0

    function start() {
        console.log("Starting wifi info request timer.");
        requestTimer.stop();
        index = 0;
        requestTimer.start();
    }

    function getMac() {
        console.log("WifiMacID is " + wifiMacId);
        if (wifiMacId == "") {
            backEnd.sendMessage("Wifi_Get_MAC ");
        } else {
            index++;
        }
    }

    function getSsid() {
        console.log("WifiSsid is " + wifiSsid);
        if (wifiSsid == "") {
            backEnd.sendMessage("Wifi_GetSsid ");
        } else {
            index++;
        }
    }

    function getPassphrase() {
        console.log("Wifi passphrase is " + wifiPassphrase);
        if (wifiPassphrase == "") {
            backEnd.sendMessage("Wifi_GetPassphrase ");
        } else {
            index++;
        }
    }

    Timer {
        id:requestTimer
        interval: 1000
        repeat: true
        running: false
        triggeredOnStart: true
        onTriggered: {
            switch (index) {
            case 0:
                getMac();
                break;
            case 1:
                getSsid();
                break;
            case 2:
                getPassphrase();
                break;
            default:
                requestTimer.stop();
                break;
            }
        }
    }
}
