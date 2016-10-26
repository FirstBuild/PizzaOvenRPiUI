#include <iostream>
#include "programSettings.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QProcess>
#include <QDebug>

using namespace std;

// Defaults here...
const int defaultTodOffset = 0;
const int defaultScreenXOffset = 60;
const int defaultScreenYOffset = 25;
const bool defaultTempDisplayInF = true;
const int defaultVolumeSetting = 8;
const int defaultMaxVolume = 70;
const int defaultBrightness = 255;
const bool defaultRotatePizzaAlert = true;
const bool defaultFinalCheckAlert = true;
const bool defaultDoneAlert = true;

extern QObject *appParentObj;
bool backlightFileExists = false;
bool brightnessFileExists = false;

#define BACKLIGHT_FILE ("/sys/class/backlight/rpi_backlight/bl_power")
#define BRIGHTNESS_FILE "/sys/class/backlight/rpi_backlight/brightness"

// Module static function prototypes
static void writeBacklightStateToBacklightFile(bool state);
static void setSystemVolume(int volume);
static void setLcdBrightness(int brightness);

ProgramSettings::ProgramSettings(QObject *parent) : QObject(parent)
{
    initializeSettingsToDefaults();
}

void ProgramSettings::loadSettings(void)
{

    if (QFile(BACKLIGHT_FILE).exists())
    {
        qInfo("Backlight file exists, backlight control is possible.");
        backlightFileExists = true;
    }
    else
    {
        qInfo("Backlight file not found, cannot control backlight.");
        backlightFileExists = false;
    }

    if (QFile(BRIGHTNESS_FILE).exists())
    {
        qInfo("Brightness file exists, brightness control is possible.");
        brightnessFileExists = true;
    }
    else
    {
        qInfo("Brightness file not found, cannot control brightness.");
        brightnessFileExists = false;
    }


    qInfo("Loading application settings...");
    QFile loadFile(QStringLiteral("settings.json"));

    if (!loadFile.open(QIODevice::ReadOnly)) {
        qInfo("...from defaults.");
        initializeSettingsToDefaults();
        qInfo("Creating new settings file.");
        saveSettings();
        // set to false so that we get the initial center screen screen
        m_settingsInitialized = false;

    } else {
        qInfo("...from JSON file.");

        QByteArray saveData = loadFile.readAll();

        QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));

        loadSettingsFromJsonObject(loadDoc.object());

        m_settingsInitialized = true;
    }

    setSystemVolume(m_maxVolume * m_volumeSetting / 9);
    setLcdBrightness(m_brightness);

    qInfo("Done loading application settings.");
}

void ProgramSettings::saveSettings(void)
{
    QFile saveFile(QStringLiteral("settings.json"));

    if (!saveFile.open(QIODevice::WriteOnly)) {
        qWarning("Couldn't open save file.");
        return;
    }

    QJsonObject jsonSettings;
    storeSettingsToJsonObject(jsonSettings);
    QJsonDocument saveDoc(jsonSettings);
    saveFile.write(saveDoc.toJson());

    m_settingsInitialized = true;
}

void ProgramSettings::loadSettingsFromJsonObject(const QJsonObject &settings)
{
    m_todOffset = (settings.contains("todOffset")) ? settings["todOffset"].toInt() : defaultTodOffset;
    m_screenXOffset = (settings.contains("screenOffsetX")) ? settings["screenOffsetX"].toInt() : defaultScreenXOffset;
    m_screenYOffset = (settings.contains("screenOffsetY")) ? settings["screenOffsetY"].toInt() : defaultScreenYOffset;
    m_tempDisplayInF = (settings.contains("tempDisplayInF")) ? settings["tempDisplayInF"].toBool() : defaultTempDisplayInF;
    m_volumeSetting = (settings.contains("volumeSetting")) ? settings["volumeSetting"].toInt() : defaultVolumeSetting;
    m_maxVolume = (settings.contains("maxVolume")) ? settings["maxVolume"].toInt() : defaultMaxVolume;
    m_brightness = (settings.contains("brightness")) ? settings["brightness"].toInt() : defaultBrightness;
    m_rotatePizzaAlertEnabled = (settings.contains("rotatePizzaAlertEnabled")) ? settings["rotatePizzaAlertEnabled"].toBool() : defaultRotatePizzaAlert;
    m_finalCheckAlertEnabled = (settings.contains("finalCheckAlertEnabled")) ? settings["finalCheckAlertEnabled"].toBool() : defaultFinalCheckAlert;
    m_doneAlertEnabled = (settings.contains("doneAlertEnabled")) ? settings["doneAlertEnabled"].toBool() : defaultDoneAlert;
}

void ProgramSettings::storeSettingsToJsonObject(QJsonObject &settings) const
{
    settings["todOffset"] = m_todOffset;
    settings["screenOffsetX"] = m_screenXOffset;
    settings["screenOffsetY"] = m_screenYOffset;
    settings["tempDisplayInF"] = m_tempDisplayInF;
    settings["volumeSetting"] = m_volumeSetting;
    settings["maxVolume"] = m_maxVolume;
    settings["brightness"] = m_brightness;
    settings["rotatePizzaAlertEnabled"] = m_rotatePizzaAlertEnabled;
    settings["finalCheckAlertEnabled"] = m_finalCheckAlertEnabled;
    settings["doneAlertEnabled"] = m_doneAlertEnabled;
}

void ProgramSettings::initializeSettingsToDefaults(void)
{
    // initialize all settings here
    m_todOffset = defaultTodOffset;
    m_screenXOffset = defaultScreenXOffset;
    m_screenYOffset = defaultScreenYOffset;
    m_tempDisplayInF = defaultTempDisplayInF;
    m_volumeSetting = defaultVolumeSetting;
    m_maxVolume = defaultMaxVolume;
    m_brightness = defaultBrightness;
    m_settingsInitialized = false;
    m_rotatePizzaAlertEnabled = defaultRotatePizzaAlert;
    m_finalCheckAlertEnabled = defaultFinalCheckAlert;
    m_doneAlertEnabled = defaultDoneAlert;
}

/*************** TOD Offset ***************/
void ProgramSettings::setTodOffset(int newOffset)
{
    cout << "Setting time of day offset to " << newOffset << endl;
    if (newOffset != m_todOffset) {
        m_todOffset = newOffset;
        emit todOffsetChanged();
        saveSettings();
    }
}

int ProgramSettings::todOffset()
{\
    return m_todOffset;
}

/*************** Screen Offset X ***************/
void ProgramSettings::setScreenoffsetX(int OffsetX)
{
    cout << "Setting screen offset X to " << OffsetX << endl;
    m_screenXOffset = OffsetX;
    emit screenOffsetXChanged();
    saveSettings();
}

int ProgramSettings::getScreenOffsetX()
{
    return m_screenXOffset;
}

/*************** Screen Offset Y ***************/
void ProgramSettings::setScreenoffsetY(int OffsetY)
{
    cout << "Setting screen offset Y to " << OffsetY << endl;
    m_screenYOffset = OffsetY;
    emit screenOffsetYChanged();
    saveSettings();
}

int ProgramSettings::getScreenOffsetY()
{
    return m_screenYOffset;
}

/*************** Settings initialized ***************/
bool ProgramSettings::areSettingsInitialized()
{
    return m_settingsInitialized;
}
void ProgramSettings::intializeSettings(bool status)
{
    m_settingsInitialized = status;
    emit screenOffsetYChanged();
}

/*************** Backlight Setting ***************/
bool ProgramSettings::getBacklightState(void)
{
    return m_backlightOff;
}
void ProgramSettings::setBacklightState(bool state)
{
    m_backlightOff = state;

    if (m_backlightOff)
    {
        qInfo("Turning backlight off.");
    }
    else
    {
        qInfo("Turning backlight on.");
    }
    writeBacklightStateToBacklightFile(m_backlightOff);
}

static void writeBacklightStateToBacklightFile(bool backlightOff)
{
    QFile file(BACKLIGHT_FILE);
    const char backlightOnMsg[] = "0";
    const char backlightOffMsg[] = "1";

    if (backlightFileExists)
    {

        if (file.open(QIODevice::WriteOnly))
        {
            if (true == backlightOff)
            {
                file.write(backlightOffMsg);
            }
            else
            {
                file.write(backlightOnMsg);
            }


            file.flush();
            file.close();
        }
        else
        {
            qWarning("Unable to open the backlight file.");
        }
    }
    else
    {
        qWarning("The backlight file does not exist.");
    }
}

/*************** F/C Setting ***************/
bool ProgramSettings::getTempDisplayInF(void)
{
    return m_tempDisplayInF;
}
void ProgramSettings::setTempDisplayInF(bool state)
{
    m_tempDisplayInF = state;
    emit tempDisplayInFStateChanged();
    saveSettings();
}

// "amixer -D pulse set Master 100% unmute"
/*************** Volume Setting ***************/
int ProgramSettings::getVolumeSetting(void)
{
    return m_volumeSetting;
}
void ProgramSettings::setVolumeSetting(int volume)
{
    int volumePercent = m_maxVolume * volume / 9;
    m_volumeSetting = volume;

    emit volumeSettingChanged();
    qInfo("Volume setting is %d", volume);
    qInfo("Max volume percent is %d", m_maxVolume);
    qInfo("Percent setting is %d", volumePercent );
    saveSettings();

    setSystemVolume(volumePercent);
}

static void setSystemVolume(int volume)
{
    char cmd[] = "amixer sset Master 100%padpad";
    sprintf(cmd, "amixer sset Master %d%%", volume);
    qInfo("Command: %s", cmd);
    QProcess process;
    process.start(cmd);
    process.waitForFinished(30000);
    qDebug() << process.readAllStandardOutput();
}

/*************** Volume Max Setting Percent ***************/
int ProgramSettings::getMaxVolume(void)
{
    return m_maxVolume;
}
void ProgramSettings::setMaxVolume(int volume)
{
    m_maxVolume = volume;
    qInfo("Setting max volume to %d", volume);
    emit maxVolumeChanged();
    saveSettings();
    setVolumeSetting(m_volumeSetting);
}

/*************** Brightness Setting ***************/
int ProgramSettings::getBrightness(void)
{
    return m_brightness;
}
void ProgramSettings::setBrightness(int brightness)
{
    m_brightness = (brightness > 0) ? brightness : 1;
    m_brightness = (brightness < 256) ? brightness : 255;

    emit brightnessChanged();
    qInfo("Brightness setting is %d", m_brightness);
    saveSettings();

    setLcdBrightness(m_brightness);
}

static void setLcdBrightness(int brightness)
{
    QFile file(BRIGHTNESS_FILE);
    char brightnessMsg[] = "255xx";
    sprintf(brightnessMsg, "%d", brightness);

    qInfo("Setting system brightness to %d", brightness);

    if (brightnessFileExists)
    {

        if (file.open(QIODevice::WriteOnly))
        {
            file.write(brightnessMsg);

            file.flush();
            file.close();
        }
        else
        {
            qWarning("Unable to open the brightness file.");
        }
    }
    else
    {
        qWarning("The brightness file does not exist.");
    }
}

/*************** Rotate Pizza Notification ***************/
void ProgramSettings::setRotatePizzaAlert(bool rotatePizzaAlertEnabled)
{
    cout << "Setting rotate pizza alert to " << rotatePizzaAlertEnabled << endl;
    m_rotatePizzaAlertEnabled = rotatePizzaAlertEnabled;
    emit rotatePizzaAlertChanged();
    saveSettings();
}

bool ProgramSettings::getRotatePizzaAlert()
{
    return m_rotatePizzaAlertEnabled;
}

/*************** Final Check Notification ***************/
void ProgramSettings::setFinalCheckAlert(bool finalCheckAlertEnabled)
{
    cout << "Setting final check alert to " << finalCheckAlertEnabled << endl;
    m_finalCheckAlertEnabled = finalCheckAlertEnabled;
    emit finalCheckAlertChanged();
    saveSettings();
}

bool ProgramSettings::getFinalCheckAlert()
{
    return m_finalCheckAlertEnabled;
}

/*************** Done Notification ***************/
void ProgramSettings::setDoneAlert(bool doneAlertEnabled)
{
    cout << "Setting done  alert to " << doneAlertEnabled << endl;
    m_doneAlertEnabled = doneAlertEnabled;
    emit doneAlertChanged();
    saveSettings();
}

bool ProgramSettings::getDoneAlert()
{
    return m_doneAlertEnabled;
}
