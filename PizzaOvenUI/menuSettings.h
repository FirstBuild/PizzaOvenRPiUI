#ifndef MENUSETTINGS_H
#define MENUSETTINGS_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>

class MenuSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString menuItems READ menuItems WRITE setMenuItems NOTIFY menuItemsHaveChange)
public:
    explicit MenuSettings(QObject *parent = 0);

    void load(void);

    QString menuItems(void);
    void setMenuItems(QString settings);

signals:
    void menuItemsHaveChange();

public slots:
private:
    QString m_menuItems;
};

#endif // MENUSETTINGS_H
