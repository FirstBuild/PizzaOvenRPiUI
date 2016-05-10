import QtQuick 2.0
import QtMultimedia 5.0

Item {

    property alias cancel: soundCancel
    property alias decrease: soundDecrease
    property alias increase: soundIncrease
    property alias off: soundOff
    property alias on: soundOn
    property alias powerOff: soundPowerOff
    property alias powerOn: soundPowerOn
    property alias pressHoldOff: soundPressHoldOff
    property alias pressHoldOn: soundPressHoldOn
    property alias select: soundSelect
    property alias touch: soundTouch
    property alias unavailableTouch: soundUnavailableTouch
    property alias alarmLow: soundAlarmLow
    property alias alarmMid: soundAlarmMid
    property alias alarmUrgent: soundAlarmUrgent
    property alias cycleComplete: soundCycleComplete
    property alias cyclePost: soundCyclePost
    property alias cyclePre: soundCyclePre
    property alias notification: soundNotification

    SoundEffect {
        id: soundCancel
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Interact_Cancel.wav"
    }

    SoundEffect {
        id: soundDecrease
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Interact_Decrease.wav"
    }

    SoundEffect {
        id: soundIncrease
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Interact_Increase.wav"
    }

    SoundEffect {
        id: soundOff
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Interact_Off.wav"
    }

    SoundEffect {
        id: soundOn
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Interact_On.wav"
    }

    SoundEffect {
        id: soundPowerOff
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Interact_PowerOff.wav"
    }

    SoundEffect {
        id: soundPowerOn
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Interact_PowerOn.wav"
    }

    SoundEffect {
        id: soundPressHoldOff
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Interact_PressHoldOff.wav"
    }

    SoundEffect {
        id: soundPressHoldOn
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Interact_PressHoldOn.wav"
    }

    SoundEffect {
        id: soundSelect
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Interact_Select.wav"
    }

    SoundEffect {
        id: soundTouch
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Interact_Touch.wav"
    }

    SoundEffect {
        id: soundUnavailableTouch
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Interact_UnavailableTouch.wav"
    }

    SoundEffect {
        id: soundAlarmLow
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Passive_AlarmLow.wav"
    }

    SoundEffect {
        id: soundAlarmMid
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Passive_AlarmMid.wav"
    }

    SoundEffect {
        id: soundAlarmUrgent
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Passive_AlarmUrgent.wav"
    }

    SoundEffect {
        id: soundCycleComplete
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Passive_CycleComplete.wav"
    }

    SoundEffect {
        id: soundCyclePost
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Passive_CyclePost.wav"
    }

    SoundEffect {
        id: soundCyclePre
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Passive_CyclePre.wav"
    }

    SoundEffect {
        id: soundNotification
        source: "file:///" + applicationDirPath + "/sounds/Monogram_Passive_Notification.wav"
    }
}

