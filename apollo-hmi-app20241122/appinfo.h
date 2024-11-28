#ifndef APPINFO_H
#define APPINFO_H

#include <QObject>

class AppInfo : public QObject
{
    Q_OBJECT
public:
    explicit AppInfo(QObject *parent = nullptr);
    Q_INVOKABLE QString appVersion();
signals:

};

#endif // APPINFO_H
