#include "menuSettings.h"
#include <QFile>
#include <iostream>
#include <QJsonArray>
using namespace std;

static QString menuSettingsFile("../settings/menuSettings.json");

static QJsonObject NewYorkStylePizza
{
    {"cookTime", 360},
    {"domeTemp", 1000},
    {"finalCheckTime", 324},
    {"halfTimeCheck", true},
    {"name", "NEW YORK STYLE PIZZA"},
    {"stoneTemp", 600}
};
static QJsonObject NeapolitanPizza
{
    {"cookTime", 120},
    {"domeTemp", 1300},
    {"finalCheckTime", 105},
    {"halfTimeCheck", true},
    {"name", "NEAPOLITAN PIZZA"},
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
static QJsonObject DetroitStylePizza
{
    {"cookTime", 420},
    {"domeTemp", 900},
    {"finalCheckTime", 378},
    {"halfTimeCheck", true},
    {"name", "DETROIT STYLE PIZZA"},
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
static QJsonObject RoastedVegetables {
    {"cookTime", 480},
    {"domeTemp", 1175},
    {"finalCheckTime", 432},
    {"halfTimeCheck", true},
    {"name", "ROASTED VEGETABLES"},
    {"stoneTemp", 600}
};
static QJsonObject RoastedFruit {
    {"cookTime", 480},
    {"domeTemp", 1300},
    {"finalCheckTime", 432},
    {"halfTimeCheck", true},
    {"name", "ROASTED FRUIT"},
    {"stoneTemp", 250}
};
static QJsonObject Salmon {
    {"cookTime", 480},
    {"domeTemp", 1200},
    {"finalCheckTime", 432},
    {"halfTimeCheck", true},
    {"name", "SALMON"},
    {"stoneTemp", 625}
};
static QJsonObject WhiteFish {
    {"cookTime", 480},
    {"domeTemp", 1050},
    {"finalCheckTime", 432},
    {"halfTimeCheck", true},
    {"name", "WHITE FISH"},
    {"stoneTemp", 550}
};
QJsonArray FoodArray =
{
    NewYorkStylePizza, NeapolitanPizza, Flatbread, DetroitStylePizza, Custom,
    RoastedVegetables, RoastedFruit, Salmon, WhiteFish
};
QJsonArray MenuOrder =
{
    0, 1, 3, 2, 5, 6, 7, 8, 4
};
QJsonObject DefaultMenuItems
{
    {"menuItems", FoodArray},
    {"menuOrder", MenuOrder}
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

    if(!m_json.contains("menuOrder")) {
        qInfo("menuOrder not found, updating menu items");
        loadFile.close();

        m_json = DefaultMenuItems;

        setJson(m_json);

        return;
    }

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
