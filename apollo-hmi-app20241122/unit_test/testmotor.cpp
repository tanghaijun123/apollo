#include "testmotor.h"

TestMotor::TestMotor(QObject *parent) : QObject(parent)
{

}

void TestMotor::initTestCase()
{
    m_motor = new Motor;
}

void TestMotor::testConnectPort()
{
    QVERIFY(m_motor->connectPort());
}

void TestMotor::testRequestWriteMotorState()
{
    m_motor->requestWriteMotorState(true);
    m_motor->requestWriteMotorState(false);
}

void TestMotor::testWriteMotorSpeed()
{
    int speed;

     m_motor->requestWriteMotorDefSpeed();
    QThread::msleep(5000);

    m_motor->requestWriteMotorSpeed(2000);
    QThread::msleep(5000);

    m_motor->requestUpdateMotorSpeed();
    QThread::msleep(5000);
    speed = m_motor->getSettingMotorSpeed();
    qDebug() << "testWriteMotorSpeed" << speed;
}

void TestMotor::testSetSettingMotorSpeed()
{
    int speed;
    m_motor->stepSpeedUp(200);
    QThread::msleep(5000);
    speed = m_motor->getSettingMotorSpeed();
    qDebug() << "testSetSettingMotorSpeed" << speed;

    m_motor->stepSpeedDown(100);
    QThread::msleep(5000);
    speed = m_motor->getSettingMotorSpeed();
    qDebug() << "testSetSettingMotorSpeed" << speed;

    m_motor->setSpeedZero();
    QThread::msleep(5000);
    speed = m_motor->getSettingMotorSpeed();
    qDebug() << "testSetSettingMotorSpeed" << speed;

    m_motor->setSpeed(3000);
    QThread::msleep(5000);
    speed = m_motor->getSettingMotorSpeed();
    qDebug() << "testSetSettingMotorSpeed" << speed;
}

void TestMotor::testRequestCmd()
{
    m_motor->requestCmd("Start");
    QThread::msleep(5000);
    m_motor->setSpeed(3000);
    m_motor->requestCmd("UpdateSpeed");
    QThread::msleep(10000);
    m_motor->requestCmd("Stop");
    QThread::msleep(5000);
}

void TestMotor::testRecieveData()
{

}

//QTEST_MAIN(TestMotor)
