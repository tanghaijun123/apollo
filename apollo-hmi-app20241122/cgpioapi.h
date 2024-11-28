#ifndef CGPIOAPI_H
#define CGPIOAPI_H
#include <QObject>

class CgpioAPI: public QObject
{
    Q_OBJECT
public:
    explicit CgpioAPI();
    ~CgpioAPI();
};

#endif // CGPIOAPI_H
