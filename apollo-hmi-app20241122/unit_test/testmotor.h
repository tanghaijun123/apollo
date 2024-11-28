#ifndef TESTMOTOR_H
#define TESTMOTOR_H

#include <QObject>
#include <QTest>
#include "../motor.h"

class TestMotor : public QObject
{
    Q_OBJECT
public:
    explicit TestMotor(QObject *parent = nullptr);

signals:
private slots:
    void initTestCase();
    void testConnectPort();
    void testRequestWriteMotorState();
    void testWriteMotorSpeed();
    void testSetSettingMotorSpeed();
    void testRequestCmd();
    void testRecieveData();
private:
    Motor *m_motor;
};

#endif // TESTMOTOR_H
