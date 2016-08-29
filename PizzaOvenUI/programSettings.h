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
    Q_PROPERTY(int screenOffsetX READ getScreenOffsetX WRITE setScreenoffsetX NOTIFY screenOffsetXChanged)
    Q_PROPERTY(int screenOffsetY READ getScreenOffsetY WRITE setScreenoffsetY NOTIFY screenOffsetYChanged)
    Q_PROPERTY(bool twoTempMode READ getTwoTempMode WRITE setTwoTempMode NOTIFY twoTempModeChanged)
    Q_PROPERTY(bool settingsInitialized READ areSettingsInitialized WRITE intializeSettings NOTIFY initializationChanged)
    Q_PROPERTY(bool backlightOff READ getBacklightState WRITE setBacklightState NOTIFY backlightStateChanged)
public:
    explicit ProgramSettings(QObject *parent = 0);

    void loadSettings(void);
    void saveSettings(void);
    void initializeSettingsToDefaults(void);

    void setTodOffset(int newOffset);
    int todOffset();
    void setScreenoffsetX(int OffsetX);
    void setScreenoffsetY(int OffsetY);
    void setTwoTempMode(bool mode);
    int getScreenOffsetX();
    int getScreenOffsetY();
    bool getTwoTempMode();
    bool areSettingsInitialized();
    void intializeSettings(bool status);
    bool getBacklightState(void);
    void setBacklightState(bool state);
signals:
    void todOffsetChanged();
    void screenOffsetXChanged();
    void screenOffsetYChanged();
    void twoTempModeChanged();
    void initializationChanged();
    void backlightStateChanged();

public slots:
private:
    int m_todOffset;
    int m_screenXOffset;
    int m_screenYOffset;
    bool m_twoTempMode;
    bool m_settingsInitialized;
    bool m_backlightOff;

    void loadSettingsFromJsonObject(const QJsonObject &settings);
    void storeSettingsToJsonObject(QJsonObject &settings) const;
};

#endif // PROGRAMSETTINGS_H
