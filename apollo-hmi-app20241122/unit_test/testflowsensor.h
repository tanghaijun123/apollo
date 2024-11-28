#ifndef TESTFLOWSENSOR_H
#define TESTFLOWSENSOR_H

#include <QObject>
#include <QTest>
#include "../flowsensor.h"

class TestFlowSensor : public QObject
{
    Q_OBJECT
public:
    explicit TestFlowSensor(QObject *parent = nullptr);

signals:
private slots:
    void initTestCase();
    void testConnectPort();
    void testRequestReadFlow();
    void testRequestReadBubbleState();
    void testRecieveData();
private:
    FlowSensor *m_flowSensor;
};

#endif // TESTFLOWSENSOR_H
