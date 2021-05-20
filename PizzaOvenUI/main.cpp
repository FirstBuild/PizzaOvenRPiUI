#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include "programSettings.h"
#include "menuSettings.h"

#include <QDebug>
#include <QtMultimedia/QAudioDeviceInfo>

#include <QtMultimedia>

QObject *appParentObj;

int main(int argc, char *argv[])
{
    ProgramSettings appSettings;
    MenuSettings menuSettings;

    appSettings.loadSettings();
    menuSettings.load();

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qDebug()<<"SSL version use for build: "<<QSslSocket::sslLibraryBuildVersionString();
    qDebug()<<"SSL version use for run-time: "<<QSslSocket::sslLibraryVersionNumber();
    qDebug()<<QCoreApplication::libraryPaths();

#ifdef KILL
    qDebug() << "------------- Available devices --------------------------------";
    foreach (const QAudioDeviceInfo &deviceInfo, QAudioDeviceInfo::availableDevices(QAudio::AudioOutput))
    {
        qDebug() << "---------- Device name: " << deviceInfo.deviceName() << "--------";
        qDebug() << "Preferred codecs: ";
        foreach (const QString &codeName, deviceInfo.supportedCodecs())
            qDebug() << "   " << codeName;
        qDebug() << "----------------------------------------------------------------";
    }
    qDebug() << "----------------------------------------------------------------";

    qDebug() << "------------- Looking for the default device --------------------------------";
    QAudioDeviceInfo defDev = QAudioDeviceInfo::defaultOutputDevice();
    if (defDev.isNull())
    {
        qDebug() << "---> The default audio device is not present.";
    }
    else
    {
        qDebug() << "---> The default audio device is: " << defDev.deviceName();
    }
    qDebug() << "-----------------------------------------------------------------------------";
#endif

    engine.rootContext()->setContextProperty("appSettings", &appSettings);
    engine.rootContext()->setContextProperty("menuSettings", &menuSettings);
    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    appParentObj = engine.parent();

    return app.exec();
}

