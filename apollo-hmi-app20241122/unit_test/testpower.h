#ifndef TESTPOWER_H
#define TESTPOWER_H

#include <QObject>
#include <QTest>
#include "../power.h"

class TestPower : public QObject
{
    Q_OBJECT
public:
    explicit TestPower(QObject *parent = nullptr);

signals:
private slots:
    void initTestCase();
    void testConnectPort();
    void testRequestReadPowerStatus();
    void testRequestWritePowerOnOffMotor();
    void testRequestWritePowerOffHmi();
    void testRequestWriteFunSpeed();
    void testRecieveData();
    void testRequestCmd();
private:
    Power *m_power;
};

#endif // TESTPOWER_H
