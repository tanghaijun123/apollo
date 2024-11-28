#include "testflowsensor.h"

TestFlowSensor::TestFlowSensor(QObject *parent) : QObject(parent)
{

}

void TestFlowSensor::initTestCase()
{
    m_flowSensor = new FlowSensor;
}

void TestFlowSensor::testConnectPort()
{
    QVERIFY(m_flowSensor->connectPort());
}

void TestFlowSensor::testRequestReadFlow()
{
    m_flowSensor->requestReadFlow();
}

void TestFlowSensor::testRequestReadBubbleState()
{
    m_flowSensor->requestReadBubbleState();
    qDebug() << "testRequestReadFlow" << m_flowSensor->getBubbleState();
}

void TestFlowSensor::testRecieveData()
{

}

//QTEST_MAIN(TestFlowSensor)
