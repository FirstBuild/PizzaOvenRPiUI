#ifndef MENUSETTINGS_H
#define MENUSETTINGS_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>

class MenuSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QJsonObject json READ json WRITE setJson NOTIFY jsonHasChanged)
public:
    explicit MenuSettings(QObject *parent = 0);

    void load(void);

    QJsonObject json(void);
    void setJson(QJsonObject settings);

signals:
    void jsonHasChanged();

public slots:
private:
    QJsonObject m_json;
};

#endif // MENUSETTINGS_H
