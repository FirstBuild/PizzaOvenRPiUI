#include <iostream>
#include "programSettings.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>

using namespace std;

ProgramSettings::ProgramSettings(QObject *parent) : QObject(parent)
{
    initializeSettingsToDefaults();
}

void ProgramSettings::loadSettings(void)
{
    QFile loadFile(QStringLiteral("settings.json"));

    if (!loadFile.open(QIODevice::ReadOnly)) {
        qWarning("Couldn't open save file.");
        return;
    }

    QByteArray saveData = loadFile.readAll();

    QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));

    loadSettingsFromJsonObject(loadDoc.object());
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
}

void ProgramSettings::loadSettingsFromJsonObject(const QJsonObject &settings)
{
    m_todOffset = settings["todOffset"].toInt();
}

void ProgramSettings::storeSettingsToJsonObject(QJsonObject &settings) const
{
    settings["todOffset"] = m_todOffset;
}

void ProgramSettings::initializeSettingsToDefaults(void)
{
    // initialize all settings here
    m_todOffset = 0;
}

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

