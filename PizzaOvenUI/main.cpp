#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>

class MyClass : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int myVal READ myVal WRITE setMyVal NOTIFY myValChanged)
public:
    MyClass();
//    MyClass(int i) {m_myVal = i;}
    void setMyVal(int newVal) {
        if (newVal != m_myVal) {
            m_myVal = newVal;
            emit myValChanged(newVal);
        }
    }
    int myVal() const {
        return m_myVal;
    }
signals:
    void myValChanged(int newVal);
private:
    int m_myVal;
};
MyClass::MyClass() {m_myVal = 0;}

int main(int argc, char *argv[])
{
    MyClass myClass;

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("myClass", &myClass);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

