#include "menuSettings.h"
#include <QFile>
#include <iostream>
using namespace std;

static QString menuSettingsFile("./menuSettings.json");

MenuSettings::MenuSettings(QObject *parent) : QObject(parent)
{
    load();
}

void MenuSettings::load(void)
{
    qInfo("Loading menu settings...");
    QFile loadFile(menuSettingsFile);

    if (!loadFile.open(QIODevice::ReadOnly)) {
        qWarning("...ERROR: couldn't open menu file");
        return;
    }

    QJsonDocument loadDoc(QJsonDocument::fromJson(loadFile.readAll()));
    m_json =  loadDoc.object();

    qInfo("...menu settings loaded.");

    loadFile.close();
}

QJsonObject MenuSettings::json(void)
{
    return m_json;
}

void MenuSettings::setJson(QJsonObject settings)
{
    QFile saveFile(menuSettingsFile);

    qInfo("The menu settings have changed...");

    if (!saveFile.open(QIODevice::WriteOnly)) {
        qWarning("...ERROR: could not open save file for menu data.");
        return;
    }

    QJsonDocument saveDoc(settings);
    saveFile.write(saveDoc.toJson());

    qInfo("...menu settings saved.");
    m_json = settings;
}
