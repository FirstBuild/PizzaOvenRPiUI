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
        source: "sounds/Monogram_Interact_Cancel.wav"
    }

    SoundEffect {
        id: soundDecrease
        source: "sounds/Monogram_Interact_Decrease.wav"
    }

    SoundEffect {
        id: soundIncrease
        source: "sounds/Monogram_Interact_Increase.wav"
    }

    SoundEffect {
        id: soundOff
        source: "sounds/Monogram_Interact_Off.wav"
    }

    SoundEffect {
        id: soundOn
        source: "sounds/Monogram_Interact_On.wav"
    }

    SoundEffect {
        id: soundPowerOff
        source: "sounds/Monogram_Interact_PowerOff.wav"
    }

    SoundEffect {
        id: soundPowerOn
        source: "sounds/Monogram_Interact_PowerOn.wav"
    }

    SoundEffect {
        id: soundPressHoldOff
        source: "sounds/Monogram_Interact_PressHoldOff.wav"
    }

    SoundEffect {
        id: soundPressHoldOn
        source: "sounds/Monogram_Interact_PressHoldOn.wav"
    }

    SoundEffect {
        id: soundSelect
        source: "sounds/Monogram_Interact_Select.wav"
    }

    SoundEffect {
        id: soundTouch
        source: "sounds/Monogram_Interact_Touch.wav"
    }

    SoundEffect {
        id: soundUnavailableTouch
        source: "sounds/Monogram_Interact_UnavailableTouch.wav"
    }

    SoundEffect {
        id: soundAlarmLow
        source: "sounds/Monogram_Passive_AlarmLow.wav"
    }

    SoundEffect {
        id: soundAlarmMid
        source: "sounds/Monogram_Passive_AlarmMid.wav"
    }

    SoundEffect {
        id: soundAlarmUrgent
        source: "sounds/Monogram_Passive_AlarmUrgent.wav"
    }

    SoundEffect {
        id: soundCycleComplete
        source: "sounds/Monogram_Passive_CycleComplete.wav"
    }

    SoundEffect {
        id: soundCyclePost
        source: "sounds/Monogram_Passive_CyclePost.wav"
    }

    SoundEffect {
        id: soundCyclePre
        source: "sounds/Monogram_Passive_CyclePre.wav"
    }

    SoundEffect {
        id: soundNotification
        source: "sounds/Monogram_Passive_Notification.wav"
    }
}

