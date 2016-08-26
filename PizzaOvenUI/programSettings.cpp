#include <iostream>
#include "programSettings.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QProcess>

using namespace std;

// Defaults here...
const int defaultTodOffset = 0;
const int defaultScreenXOffset = 60;
const int defaultScreenYOffset = 25;
const bool defaultTwoTempMode = false;

extern QObject *appParentObj;

ProgramSettings::ProgramSettings(QObject *parent) : QObject(parent)
{
    initializeSettingsToDefaults();
}

void ProgramSettings::loadSettings(void)
{

    qInfo("Loading application settings...");
    QFile loadFile(QStringLiteral("settings.json"));

    if (!loadFile.open(QIODevice::ReadOnly)) {
        qWarning("Couldn't open save file, initializing...");
        return;
    }

    m_settingsInitialized = true;

    QByteArray saveData = loadFile.readAll();

    QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));

    loadSettingsFromJsonObject(loadDoc.object());

    if (QFile("/sys/class/backlight/rpi_backlight/bl_power").exists())
    {
        qInfo("Backlight file exists, backlight control is possible.");
    }
    else
    {
        qWarning("Backlight file not found, cannot control backlight.");
    }
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
    m_twoTempMode = (settings.contains("twoTempMode")) ? settings["twoTempMode"].toBool() : defaultTwoTempMode;
}

void ProgramSettings::storeSettingsToJsonObject(QJsonObject &settings) const
{
    settings["todOffset"] = m_todOffset;
    settings["screenOffsetX"] = m_screenXOffset;
    settings["screenOffsetY"] = m_screenYOffset;
    settings["twoTempMode"] = m_twoTempMode;
}

void ProgramSettings::initializeSettingsToDefaults(void)
{
    // initialize all settings here
    m_todOffset = defaultTodOffset;
    m_screenXOffset = defaultScreenXOffset;
    m_screenYOffset = defaultScreenYOffset;
    m_twoTempMode = defaultTwoTempMode;
    m_settingsInitialized = false;
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
    if (OffsetX != m_screenXOffset) {
        m_screenXOffset = OffsetX;
        emit screenOffsetXChanged();
        saveSettings();
    }
}

int ProgramSettings::getScreenOffsetX()
{
    return m_screenXOffset;
}

/*************** Screen Offset Y ***************/
void ProgramSettings::setScreenoffsetY(int OffsetY)
{
    cout << "Setting screen offset Y to " << OffsetY << endl;
    if (OffsetY != m_screenYOffset) {
        m_screenYOffset = OffsetY;
        emit screenOffsetYChanged();
        saveSettings();
    }
}

int ProgramSettings::getScreenOffsetY()
{
    return m_screenYOffset;
}

/*************** Two Temp Mode ***************/
void ProgramSettings::setTwoTempMode(bool mode)
{
    cout << "Setting two temp mode to " << mode << endl;
    if (mode != m_twoTempMode) {
        m_twoTempMode = mode;
        emit twoTempModeChanged();
        saveSettings();
    }
}

bool ProgramSettings::getTwoTempMode()
{
    return m_twoTempMode;
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
    return m_backlightState;
}
void ProgramSettings::setBacklightState(bool state)
{
    m_backlightState = state;

    if (m_backlightState)
    {
        qInfo("Turning backlight off.");
    }
    else
    {
        qInfo("Turning backlight on.");
    }
}

