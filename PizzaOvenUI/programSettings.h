#ifndef PROGRAMSETTINGS_H
#define PROGRAMSETTINGS_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>

/*
 * Save/restore program settings
 */

class ProgramSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int todOffset READ todOffset WRITE setTodOffset NOTIFY todOffsetChanged)
public:
    explicit ProgramSettings(QObject *parent = 0);

    void loadSettings(void);
    void saveSettings(void);
    void initializeSettingsToDefaults(void);

    void setTodOffset(int newOffset);
    int todOffset();
signals:
    void todOffsetChanged();

public slots:
private:
    int m_todOffset;

    void loadSettingsFromJsonObject(const QJsonObject &settings);
    void storeSettingsToJsonObject(QJsonObject &settings) const;
};

#endif // PROGRAMSETTINGS_H
