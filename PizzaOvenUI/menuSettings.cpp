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

    QString menuData(loadFile.readAll());
    m_menuItems =  menuData;
    qInfo("...menu settings loaded.");
}

QString MenuSettings::menuItems(void)
{
    return m_menuItems;
}

void MenuSettings::setMenuItems(QString settings)
{
    (void)settings;
}
