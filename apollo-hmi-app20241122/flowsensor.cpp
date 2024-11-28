/******************************************************************************/
/*! @File        : flowsensor.cpp
 *  @Brief       : 负责与流量传感器的RS485通信
 *  @Details     : 详细说明
 *  @Author      : kevin
 *  @Date        : 2024-08-13
 *  @Version     : v1.0
 *  @Copyright   : Copyright By yongrenxing, All Rights Reserved
 *
 **********************************************************
 *
 *  @Attention   :
 *  @par 修改日志:
 *  <table>
 *  <tr><th>Date       <th>Version   <th>Author    <th>Description
 *  <tr><td>2024-08-13 <td>1.0       <td>xxx     <td>创建初始版本
 *  </table>
 *
 **********************************************************
*/

#include "flowsensor.h"
#include <QModbusTcpClient>
#include <QModbusRtuSerialMaster>
#include <QStandardItemModel>
#include <QStatusBar>
#include <QUrl>
#include <QDebug>
#include <QtMath>
#include <QSerialPort>
#include "uartport.h"
#ifdef GLOBAL_SIMULATION_ENABLED
#include <QRandomGenerator>
#endif
#include "database/crunningtestmanager.h"

#define FLOW_SENSOR_MODBUS_ADDR         0x04
#define FLOWSENSOR_MODULE_DEBUG         1

#define USR_REQ_BUB_STAT_REG            4096
#define USR_REQ_SYS_STAT_REG            2067
#define USR_REQ_FLOW_RATE_REG           0x100C

#define SCALE_BLOOD_WATER               1.1

FlowSensor::FlowSensor(QWidget *parent)
    : UartPort(parent)
{
    connectPort();
#ifdef GLOBAL_SIMULATION_ENABLED
    startSimulationTmr();
#endif
}

FlowSensor::~FlowSensor()
{
#ifdef GLOBAL_SIMULATION_ENABLED
    stoptSimulationTmr();
#endif
}

bool FlowSensor::connectPort()
{
    QString retStr;
    connect(this, &UartPort::sendRecvMsg, this, &FlowSensor::receiveData);
    connect(this, &UartPort::sendErr, this, &FlowSensor::receiveErr);
#ifdef BOARD_TQ
    qDebug() << "FlowSensor module connectPort" << openPort("/dev/ttyUSB1", 115200);
#else
    qDebug() << "FlowSensor module connectPort" << openPort("/dev/ttySAC3", 115200);
#endif

    return (retStr == "OK");
}


void FlowSensor::receiveData(QByteArray data)
{
    uint8_t *p_value;

    if(m_flowSensorCmd == eCmdReadFlowValue || m_flowSensorCmd == eCmdReadFlowValue2)
    {
        float flow_value;
        p_value = (uint8_t *)&flow_value;
        p_value[0] = data[1];
        p_value[1] = data[0];
        p_value[2] = data[3];
        p_value[3] = data[2];

        flow_value = flow_value*SCALE_BLOOD_WATER/1000.0;
        //flow_value = fabs(flow_value);

        if(fabs(flow_value) < 0.05) {
            flow_value = 0;
        }
    #ifdef FLOW_SENSOR_DEBUG
        qDebug() << "FlowSensorValue=" << flow_value;
    #endif
        emit updateFlowValue(true, QString::number(flow_value, 'f', 2));
        setCurFlowVolumeToDB(flow_value);
        if(m_flowSensorCmd == eCmdReadFlowValue2)
        {
            m_flowSensorCmd = eCmdReadBubbleState;
        }
        else
        {
            m_flowSensorCmd = eCmdReadSystemState;
        }
    }
    else if(m_flowSensorCmd == eCmdReadBubbleState)
    {
        int bubble_state;
        p_value = (uint8_t *)&bubble_state;
        p_value[0] = data[1];
        p_value[1] = data[0];
        p_value[2] = data[3];
        p_value[3] = data[2];

        // Bubble exist
        m_flowSensorCmd = eCmdReadFlowValue;

        // qInfo() << "bubble_state" << bubble_state;
        m_bubbleState = bubble_state;
        quint8 cnt = 0;
        for(quint8 i = 0; i < 32; i++) {
            if(bubble_state & (1 << i))
            {
                cnt++;
            }
        }

        if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBubbleInPipe) == false)
        {
            if(cnt > 0) {
                emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnBubbleInPipe, "");
            }
        }
        else {
            if(cnt == 0) {
                emit glb_RunningTestManager->removeWarning(Glb_define::conWarnBubbleInPipe);
            }
        }
    }
    else if(m_flowSensorCmd == eCmdReadSystemState)
    {
        int sys_state = data[0];

        /*系统状态，低 8位编码含义:
        12:系统处于零点校正状态
        121:参数检查错误
        122:系统运行正常
        126:无超声接收信号(管内无液体或者有气泡)*/

        // Goto read flow value
        m_flowSensorCmd = eCmdReadFlowValue2;

        if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnFlowSensorFailure) == false)
        {
            if(sys_state == 121) {
                emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnFlowSensorFailure, "");
            }
        }
        else {
            if(sys_state != 121) {
                emit glb_RunningTestManager->removeWarning(Glb_define::conWarnFlowSensorFailure);
            }
        }
    }
}

void FlowSensor::receiveErr(UartPort::emUartPortErr err)
{

    if(err == UartPort::UartReadTimeout) {
        m_flowSensorErr = true;

#ifdef ALARM_ENABLED
        m_commErrorSetCount++;
        if(m_commErrorSetCount >= 3) {
            emit updateFlowValue(false, 0);
            setCurFlowVolumeToDB(0.0);
#ifdef FLOW_SENSOR_DEBUG
            qInfo() << __FILE__ <<" " << __LINE__ << "receiveErr" ;
#endif
            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnFlowSensorDisconnected) == false)
            {
                emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnFlowSensorDisconnected,"");
            }
        }
#endif
    } else {
        m_flowSensorErr = false;

#ifdef ALARM_ENABLED
        m_commErrorSetCount = 0;
        emit updateFlowValue(true, 0);
        if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnFlowSensorDisconnected) == true)
        {
            emit glb_RunningTestManager->removeWarning(Glb_define::conWarnFlowSensorDisconnected);
        }
#endif
    }
}

#ifdef GLOBAL_SIMULATION_ENABLED
void FlowSensor::startSimulationTmr()
{
    stoptSimulationTmr();
    m_nSimulationTmr = startTimer(500);
}

void FlowSensor::stoptSimulationTmr()
{
    if(m_nSimulationTmr > 0)
    {
        killTimer(m_nSimulationTmr);
    }
    m_nSimulationTmr = 0;
}

void FlowSensor::onSimulationTmrOut()
{
    stoptSimulationTmr();
    static double stOldValue = 0;
    double dValue = 0;
    while(true)
    {
        dValue = QRandomGenerator::global()->bounded(8.0);
        if(stOldValue > 0.001)
        {
            if(abs(dValue - stOldValue) / stOldValue < 0.03)
            {
                stOldValue = dValue;
                break;
            }
        }
        else
        {
            stOldValue = dValue;
        }
    }
    emit updateFlowValue(true, QString::number(dValue, 'f', 2));
    setCurFlowVolumeToDB(dValue);
    startSimulationTmr();
}

void FlowSensor::timerEvent(QTimerEvent *event)
{
    if(event->timerId() == m_nSimulationTmr)
    {
#ifdef GLOBAL_SIMULATION
        onSimulationTmrOut();
#else
        if(m_flowSensorCmd == eCmdReadFlowValue)
        {
            requestReadFlow();
        }
        else if(m_flowSensorCmd == eCmdReadBubbleState)
        {
            requestReadBubbleState();
        }
        else if(m_flowSensorCmd == eCmdReadSystemState)
        {
            requestReadSystemState();
        }
        else if(m_flowSensorCmd == eCmdNone)
        {

        }

#endif
        return;
    }
    UartPort::timerEvent(event);
}
#endif

void FlowSensor::setCurFlowVolumeToDB(double dFlowVolume)
{
    if(glb_RunningTestManager) {

        emit glb_RunningTestManager->updateCurFlowValue(dFlowVolume);
    }
    else{
        qDebug("%s %d glb_RunningTestManager is null!!!", __FILE__, __LINE__);
    }
}

void FlowSensor::requestReadFlow()
{
    QByteArray ba;
    ba = packReadHoldingRegister(FLOW_SENSOR_MODBUS_ADDR, USR_REQ_FLOW_RATE_REG, 2);
    if(UartPort::UartNotOpen == writeData(ba))
    {
        //qDebug() << __FILE__ <<" " << __LINE__ << "requestReadFlow UartNotOpen" ;
        emit updateFlowValue(false,"0");
    }
}

void FlowSensor::requestReadBubbleState()
{
    QByteArray ba;
    ba = packReadHoldingRegister(FLOW_SENSOR_MODBUS_ADDR, USR_REQ_BUB_STAT_REG, 2);
    if(UartPort::UartNotOpen == writeData(ba))
    {
        //qDebug() << __FILE__ <<" " << __LINE__ << "requestReadFlow UartNotOpen" ;
        emit updateFlowValue(false,"0");
    }
}

void FlowSensor::requestReadSystemState()
{
    QByteArray ba;
    ba = packReadHoldingRegister(FLOW_SENSOR_MODBUS_ADDR, USR_REQ_SYS_STAT_REG, 1);
    if(UartPort::UartNotOpen == writeData(ba))
    {
        //qDebug() << __FILE__ <<" " << __LINE__ << "requestReadFlow UartNotOpen" ;
        emit updateFlowValue(false,"0");
    }
}

bool FlowSensor::getError()
{
#ifdef GLOBAL_SIMULATION_ENABLED
    return false;
#endif
    if(UartPort::UartNoErr != getPortErr())
    {
        m_flowSensorErr = true;
    }

    return m_flowSensorErr;
}

QString FlowSensor::getBubbleState()
{
    return QString::number(m_bubbleState, 2);
}
