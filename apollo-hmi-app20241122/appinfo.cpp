#include "appinfo.h"

AppInfo::AppInfo(QObject *parent) : QObject(parent)
{

}

QString AppInfo::appVersion()
{
    return QString(APP_VERSION).left(4);
}
