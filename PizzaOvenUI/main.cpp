#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include "programSettings.h"

#include <QDebug>
#include <QtMultimedia/QAudioDeviceInfo>

#include <QtMultimedia>

int main(int argc, char *argv[])
{
    ProgramSettings appSettings;

    appSettings.loadSettings();

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

//    qDebug() << "------------- Available devices --------------------------------";
//    foreach (const QAudioDeviceInfo &deviceInfo, QAudioDeviceInfo::availableDevices(QAudio::AudioOutput))
//        qDebug() << "Device name: " << deviceInfo.deviceName();
//    qDebug() << "----------------------------------------------------------------";

//    qDebug() << "------------- Looking for the default device --------------------------------";
//    QAudioDeviceInfo defDev = QAudioDeviceInfo::defaultOutputDevice();
//    if (defDev.isNull())
//    {
//        qDebug() << "---> The default audio device is not present.";
//    }
//    else
//    {
//        qDebug() << "---> The default audio device is: " << defDev.deviceName();
//    }
//    qDebug() << "-----------------------------------------------------------------------------";

    engine.rootContext()->setContextProperty("appSettings", &appSettings);
    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

