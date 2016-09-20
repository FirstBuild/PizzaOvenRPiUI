#include "menuSettings.h"
#include <QFile>
#include <iostream>
#include <QJsonArray>
using namespace std;

static QString menuSettingsFile("./menuSettings.json");

//                            var settings = {
//                                "domeTemp": upperFront.setTemp,
//                                "stoneTemp": lowerFront.setTemp,
//                                "cookTime": cookTime,
//                                "finalCheckTime": finalCheckTime,
//                                "halfTimeCheck": halfTimeRotate
//                            }

/*
 {
    "menuItems": [
        {
            "cookTime": 120,
            "domeTemp": 1000,
            "finalCheckTime": 108,
            "halfTimeCheck": true,
            "name": "CUSTOM",
            "stoneTemp": 650
        },
        {
            "cookTime": 120,
            "domeTemp": 1250,
            "finalCheckTime": 105,
            "halfTimeCheck": true,
            "name": "NEAPOLITAN",
            "stoneTemp": 650
        },
        {
            "cookTime": 120,
            "domeTemp": 1250,
            "finalCheckTime": 105,
            "halfTimeCheck": true,
            "name": "DETROIT STYLE",
            "stoneTemp": 650
        },
        {
            "cookTime": 120,
            "domeTemp": 1250,
            "finalCheckTime": 105,
            "halfTimeCheck": true,
            "name": "FLATBREAD",
            "stoneTemp": 650
        },
        {
            "cookTime": 120,
            "domeTemp": 1250,
            "finalCheckTime": 105,
            "halfTimeCheck": true,
            "name": "NEW YORK STYLE",
            "stoneTemp": 650
        }
    ]
}
 */

static QJsonObject NewYorkStyle
{
    {"cookTime", 120},
    {"domeTemp", 1250},
    {"finalCheckTime", 105},
    {"halfTimeCheck", true},
    {"name", "NEW YORK STYLE"},
    {"stoneTemp", 650}
};
static QJsonObject Neapolitan
{
    {"cookTime", 120},
    {"domeTemp", 1250},
    {"finalCheckTime", 105},
    {"halfTimeCheck", true},
    {"name", "NEAPOLITAN"},
    {"stoneTemp", 650}
};
static QJsonObject Flatbread
{
    {"cookTime", 120},
    {"domeTemp", 1250},
    {"finalCheckTime", 105},
    {"halfTimeCheck", true},
    {"name", "FlATBREAD"},
    {"stoneTemp", 650}
};
static QJsonObject DetroitStyle
{
    {"cookTime", 120},
    {"domeTemp", 1250},
    {"finalCheckTime", 105},
    {"halfTimeCheck", true},
    {"name", "DETROIT STYLE"},
    {"stoneTemp", 650}
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
