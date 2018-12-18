#include "menuSettings.h"
#include <QFile>
#include <iostream>
#include <QJsonArray>
using namespace std;

static QString menuSettingsFile("../settings/menuSettings.json");

static QJsonObject NewYorkStyle
{
    {"cookTime", 360},
    {"domeTemp", 1000},
    {"finalCheckTime", 324},
    {"halfTimeCheck", true},
    {"name", "NEW YORK STYLE"},
    {"stoneTemp", 600}
};
static QJsonObject Neapolitan
{
    {"cookTime", 120},
    {"domeTemp", 1400},
    {"finalCheckTime", 105},
    {"halfTimeCheck", true},
    {"name", "NEAPOLITAN"},
    {"stoneTemp", 675}
};
static QJsonObject Flatbread
{
    {"cookTime", 90},
    {"domeTemp", 1000},
    {"finalCheckTime", 105},
    {"halfTimeCheck", false},
    {"name", "FLATBREAD"},
    {"stoneTemp", 625}
};
static QJsonObject DetroitStyle
{
    {"cookTime", 420},
    {"domeTemp", 900},
    {"finalCheckTime", 378},
    {"halfTimeCheck", true},
    {"name", "DETROIT STYLE"},
    {"stoneTemp", 700}
};
static QJsonObject Custom
{
    {"cookTime", 120},
    {"domeTemp", 1250},
    {"finalCheckTime", 105},
    {"halfTimeCheck", true},
    {"name", "CUSTOM"},
    {"stoneTemp", 650}
};
QJsonArray FoodArray =
{
    NewYorkStyle, Neapolitan, Flatbread, DetroitStyle, Custom
};
QJsonObject DefaultMenuItems
{
    {"menuItems", FoodArray}
};

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
        qInfo("Creating default menu settings.");

        m_json = DefaultMenuItems;

        setJson(m_json);

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
