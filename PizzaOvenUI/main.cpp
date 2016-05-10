#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include "programSettings.h"

int main(int argc, char *argv[])
{
    ProgramSettings appSettings;

    appSettings.loadSettings();

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("appSettings", &appSettings);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

