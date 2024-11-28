#include "testpower.h"

TestPower::TestPower(QObject *parent) : QObject(parent)
{

}

void TestPower::initTestCase()
{
    m_power = new Power;
}

void TestPower::testConnectPort()
{
    QVERIFY(m_power->connectPort());
}

void TestPower::testRequestReadPowerStatus()
{
    m_power->requestReadPowerStatus();
}

void TestPower::testRequestWritePowerOnOffMotor()
{
    m_power->requestWritePowerOnMotor();
    QThread::msleep(5000);

    m_power->requestWritePowerOffMotor();
    QThread::msleep(5000);
}

void TestPower::testRequestWritePowerOffHmi()
{
    m_power->requestWritePowerOffHmi();
    QThread::msleep(5000);
}


void TestPower::testRequestWriteFunSpeed()
{
    m_power->requestWriteFunSpeed(30);
    QThread::msleep(5000);

    m_power->requestWriteFunSpeed(70);
    QThread::msleep(5000);
}

void TestPower::testRequestCmd()
{
    m_power->requestCmd("PowerOnMotor");
    QThread::msleep(5000);
    m_power->requestCmd("PowerOffMotor");
    QThread::msleep(5000);
    m_power->requestCmd("PowerOffHmi");
    QThread::msleep(5000);
}

void TestPower::testRecieveData()
{

}

//QTEST_MAIN(TestPower)
