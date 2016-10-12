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
    Q_PROPERTY(bool settingsInitialized READ areSettingsInitialized WRITE intializeSettings NOTIFY initializationChanged)
    Q_PROPERTY(bool backlightOff READ getBacklightState WRITE setBacklightState NOTIFY backlightStateChanged)
    Q_PROPERTY(bool tempDisplayInF READ getTempDisplayInF WRITE setTempDisplayInF NOTIFY tempDisplayInFStateChanged)
    Q_PROPERTY(int volumeSetting READ getVolumeSetting WRITE setVolumeSetting NOTIFY volumeSettingChanged)
    Q_PROPERTY(int maxVolume READ getMaxVolume WRITE setMaxVolume NOTIFY maxVolumeChanged)
public:
    explicit ProgramSettings(QObject *parent = 0);

    void loadSettings(void);
    void saveSettings(void);
    void initializeSettingsToDefaults(void);

    void setTodOffset(int newOffset);
    int  todOffset();
    void setScreenoffsetX(int OffsetX);
    void setScreenoffsetY(int OffsetY);
    int  getScreenOffsetX();
    int  getScreenOffsetY();
    bool areSettingsInitialized();
    void intializeSettings(bool status);
    bool getBacklightState(void);
    void setBacklightState(bool state);
    bool getTempDisplayInF(void);
    void setTempDisplayInF(bool state);
    int  getVolumeSetting(void);
    void setVolumeSetting(int volume);
    int  getMaxVolume(void);
    void setMaxVolume(int volume);
signals:
    void todOffsetChanged();
    void screenOffsetXChanged();
    void screenOffsetYChanged();
    void initializationChanged();
    void backlightStateChanged();
    void tempDisplayInFStateChanged();
    void volumeSettingChanged();
    void maxVolumeChanged();

public slots:
private:
    int m_todOffset;
    int m_screenXOffset;
    int m_screenYOffset;
    bool m_settingsInitialized;
    bool m_backlightOff;
    bool m_tempDisplayInF;
    int m_volumeSetting;
    int m_maxVolume;

    void loadSettingsFromJsonObject(const QJsonObject &settings);
    void storeSettingsToJsonObject(QJsonObject &settings) const;
};

#endif // PROGRAMSETTINGS_H
