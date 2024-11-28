/******************************************************************************/
/*! @File        : motor.cpp
 *  @Brief       : 负责与电机驱动板的RS485通信
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
#include "motor.h"
#include <QStandardItemModel>
#include <QStatusBar>
#include <QUrl>
#include <QDebug>
#include <QSerialPort>
#include <QDateTime>
#ifdef GLOBAL_SIMULATION_ENABLED
#include <QRandomGenerator>
#endif
#include <QFile>
#include <QApplication>
#include <QDateTime>
#include <QTextStream>
#include "global_define.h"
#include "rotaryencoder.h"
#include "database/crunningtestmanager.h"
#include <QSettings>

#define MOTOR_MODBUS_ADDR         0x0C

#define MAX_MOTOR_SPEED             5000
#define DEF_MOTOR_SPEED             0
//#define MOTOR_DEBUG                 1
#define MOTOR_SETTING_VALID_COUNT    8
#define MOTOR_SPEED_LIST_CNT         5

#define MOTOR_MODBUS_STATUS_REG         0x0021      //0x0007
#define MOTOR_MODBUS_STATUS_REG_LEN     0x000C      //0x0005
#define MOTOR_MODBUS_START_STOP_REG     0x0003
#define MOTOR_MODBUS_SPEED_REG          0x0014
#define MOTOR_CURTHRED_ENABLED_REG      0x8000
#define MOTOR_CURTHRED_VALUE_REG        0x8003

#define ERR_CODE_MOTOR_DISCONNECTED     0x02
#define ERR_CODE_ROTOR_UNINSTALLED      0x10

Motor::Motor(QWidget *parent)
    : UartPort(parent)
{
#ifdef GLOBAL_SIMULATION_ENABLED
    startSimulationTmr();
#endif

    connectPort();
#if 0
    QString iniFilePath = QApplication::applicationDirPath() + QString("/config.ini");
    QSettings setting(iniFilePath, QSettings::IniFormat);

    QString strSpeed = setting.value("Motor/SettingSpeed").toString();
    if(strSpeed == "") {
        strSpeed = "0";
        m_motorSettingSpeed = 0;
        setting.setValue("Motor/SettingSpeed", strSpeed);
    } else {
        m_motorSettingSpeed = strSpeed.toInt();
        qDebug() << "Motor m_motorSettingSpeed" << m_motorSettingSpeed;
        if(m_motorSettingSpeed < 0 || m_motorSettingSpeed > 5000) {
            m_motorSettingSpeed = 0;
        }
    }
#endif
#ifdef GLOBAL_SIMULATION_ENABLED
    startSimulationTmr();
    m_bSendMotorSpeed = true;
#endif
}

void Motor::requestWriteMotorDefSpeed()
{
    requestWriteMotorSpeed(m_motorSettingSpeed);
}

void Motor::updateMotorSpeed(int /*rotaryEncoder*/, int step)
{
    if(m_bLocked){
        emit updateSettingMotorSpeed(-1);
        return;
    }

    //qDebug("%s %s %d add step: nSteps",
    //         QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss zzz").toUtf8().constData(), __FILE__,
    //         __LINE__);
#define MAX_ADD_SPEED 70
#define MIN_ADD_SPEED 10
    static int nOldStep = 0;
    static int nAddSteps = 0;
    static QDateTime dUpdatetime;
    QDateTime dCurrentDateTime = QDateTime::currentDateTime();
    if(nOldStep == 0)
    {
        nAddSteps = MIN_ADD_SPEED;
        dUpdatetime = QDateTime::currentDateTime();
    }
    else if(nOldStep != step){
        nAddSteps = MIN_ADD_SPEED;
        dUpdatetime = QDateTime::currentDateTime();
    }

    else if(dUpdatetime.msecsTo(dCurrentDateTime) < 10)
    {
        if(nAddSteps < MAX_ADD_SPEED){
            nAddSteps += MIN_ADD_SPEED;
        }
        else{
            nAddSteps = MAX_ADD_SPEED;
        }
    }
    else if(dUpdatetime.msecsTo(dCurrentDateTime) < 50)
    {
        if(nAddSteps < MAX_ADD_SPEED)
        {
            nAddSteps += MIN_ADD_SPEED;
        }
        else{
            nAddSteps = MAX_ADD_SPEED;
        }
    }
    else if(dUpdatetime.msecsTo(dCurrentDateTime) > 1000)
    {
        nAddSteps = MIN_ADD_SPEED;

    }
    else if(dUpdatetime.msecsTo(dCurrentDateTime) > 200)
    {
        if(nAddSteps > MIN_ADD_SPEED){
            nAddSteps -= MIN_ADD_SPEED;
        }
        else{
            nAddSteps = MIN_ADD_SPEED;
        }
    }

    dUpdatetime = dCurrentDateTime;
    nOldStep = step;

    m_motorSettingSpeed += step*nAddSteps;

    if(m_motorSettingSpeed < 0)
    {
        m_motorSettingSpeed = 0;
    }
    else if(m_motorSettingSpeed > MAX_MOTOR_SPEED)
    {
        m_motorSettingSpeed = MAX_MOTOR_SPEED;
    }

    emit updateSettingMotorSpeed(m_motorSettingSpeed);
    startDelaySendTargetSpeedTmr();
}

Motor::~Motor()
{
#ifdef GLOBAL_SIMULATION_ENABLED
    stoptSimulationTmr();
#endif
}

bool Motor::connectPort()
{
    QString retStr;
    connect(this, &UartPort::sendRecvMsg, this, &Motor::receiveData);
    connect(this, &UartPort::sendErr, this, &Motor::receiveErr);
#ifdef BOARD_TQ
    qWarning() << "Motor module connectPort" << openPort("/dev/ttyUSB0", 9600);
#else
    qWarning() << "Motor module connectPort" << openPort("/dev/ttySAC4", 9600);
#endif
    return (retStr == "OK");
}

void Motor::saveMotorData(QString data)
{
    QString strFileName;
    strFileName = QString("%1/data/motor-data-%2.csv").arg(QApplication::applicationDirPath(), QDate::currentDate().toString("yyyy-MM-dd"));

    QFile file(strFileName);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Append)) {
        // 处理错误，例如可以抛出异常或者返回错误标志
        qWarning("%s %d file open fail: %s!", __FILE__, __LINE__, file.errorString().toUtf8().constData());
        return;
    }
    QTextStream out(&file);
    out.setCodec("utf-8");

    QString time = QString("%1 ").arg(QDateTime::currentDateTime().toString("hh:mm:ss"));
    out << (time+","+data+"\n");
    file.flush();
    file.close();
}

void Motor::receiveData(QByteArray data)
{
    QString motorData;
    if(data.length() >= 8)
    {

        quint8 * p_data = (quint8 *)data.data();
        /*    错误说明
                00      没有错误。
                bit01 	电机未连接。
                bit02 	悬浮绕组未连接。
                bit03 	转矩绕组未连接。
                bit04 	没有转子。
                bit05 	悬浮绕组过流。
                bit06 	转矩绕组过流。
                bit07 	DC 电源异常（< 18 or >32 V DC）。*/
        quint8 index = 0;
        quint16 errCode = (quint16)p_data[2*index] << 8 | p_data[2*index+1];

        /*单位RPM*/
        index = 1;
        quint16 motorSpeed = (quint16)p_data[2*index] << 8 | p_data[2*index+1];

        /*bit15位为1表示为负温度，为零0表示正温度，bit14~bit0,为温度的绝对值。
                -20℃表示为1000-0000-0001-0100;
                20℃表示为0000-0000-0001-0100;*/
        index = 2;
        quint16 boardTemp = ((quint16)p_data[2*index] << 8 | p_data[2*index+1]);
        index = 3;
        quint16 motorTemp = ((quint16)p_data[2* index] << 8 | p_data[2*index+1]);

        /*将电流值放大100倍进行传输，接收端收到后除100得到电流值。
            如电流5.12安培，5.12*100=512(16进制0x200)。*/
        index = 4;
        quint16 suspenCurrent = ((quint16)p_data[2* index] << 8 | p_data[2*index+1]);
        index = 5;
        quint16 torqueCurrent = ((quint16)p_data[2* index] << 8 | p_data[2*index+1]);

        /*0：自检正常，1：自检发现故障*/
        index = 6;
        quint16 postResult = ((quint16)p_data[2* index] << 8 | p_data[2*index+1]);

        /*0:自检没有故障
                bit0 = 1,悬浮驱动电路故障
                bit1 = 1,转矩驱动电路故障
                bit2 = 1,电机温度传感器故障
                bit3 = 1,用户接口板未连接(影响485通信)*/
        index = 7;
        quint16 ctrlbFault = ((quint16)p_data[2* index] << 8 | p_data[2*index+1]);

        /*位移标幺数值最大值2047;
                当前位移(um)= 位移标幺数值*位移系数，
                (当前电机的位移系统为1.210)。*/
        index = 8;
        quint16 xPos = ((quint16)p_data[2* index] << 8 | p_data[2*index+1]);
        index = 9;
        quint16 yPos = ((quint16)p_data[2* index] << 8 | p_data[2*index+1]);

        /*0:静止;
              1:悬浮;
              2:旋转*/
        index = 10;
        quint16 rotorStatus = ((quint16)p_data[2* index] << 8 | p_data[2*index+1]);
        index = 11;
        m_version = ((quint16)p_data[2* index] << 8 | p_data[2*index+1]);

        motorData = QString::number(errCode)+"," \
                +QString::number(motorSpeed)+"," \
                +QString::number(boardTemp)+"," \
                +QString::number(motorTemp)+"," \
                +QString::number(suspenCurrent)+"," \
                +QString::number(torqueCurrent)+"," \
                +QString::number(xPos)+"," \
                +QString::number(yPos)+"," \
                +QString::number(postResult)+"," \
                +QString::number(ctrlbFault);

        saveMotorData(motorData);

        if(m_motorSettingSpeed != m_motorSettingSpeedPre)
        {
            m_motorSpeedList.clear();
            m_motorSettingValidCnt = 0;
        }

        if(m_motorSettingValidCnt < MOTOR_SETTING_VALID_COUNT) {
            m_motorSettingValidCnt++;
        }

        m_motorSettingSpeedPre = m_motorSettingSpeed;

        m_motorSpeedList.push_back(motorSpeed);
        if(m_motorSpeedList.count() > MOTOR_SPEED_LIST_CNT)
        {
            m_motorSpeedList.pop_front();
        }

        int motorSpeedAvg = 0;
        for(int j = 0; j < m_motorSpeedList.count(); j++)
        {
            motorSpeedAvg += m_motorSpeedList.at(j);
        }

        motorSpeedAvg = motorSpeedAvg / m_motorSpeedList.count();

        qDebug() << "m_motorSettingSpeed" << m_motorSettingSpeed << motorSpeedAvg << m_motorSettingValidCnt << m_motorSpeedList;

#ifdef MOTOR_DEBUG
        qInfo() << "errCode" << errCode \
                << "motorSpeed" << motorSpeed \
                << "boardTemp:" << boardTemp \
                << "motorTemp:" << motorTemp \
                << "suspenCurrent" << suspenCurrent \
                << "torqueCurrent" << torqueCurrent \
                << "xPos" << xPos \
                << "yPos" << yPos \
                << "postResult" << postResult \
                << "ctrlbFault" << ctrlbFault;
#endif


#ifdef ALARM_ENABLED
        if(m_bSendMotorSpeed){
            if(glb_RunningTestManager) {

                if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnMotorSpeedAbnormal) == false)
                {

                    if(abs(motorSpeedAvg - m_motorSettingSpeed) > 100 && m_motorSettingValidCnt >= MOTOR_SETTING_VALID_COUNT) {
                        emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnMotorSpeedAbnormal, "");
                    }
                }
                else
                {
                    if(abs(motorSpeedAvg - m_motorSettingSpeed) < 100) {
                        emit glb_RunningTestManager->removeWarning(Glb_define::conWarnMotorSpeedAbnormal);
                    }
                }

                if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnPumpUninstalled) == false)
                {
                    if((errCode & ERR_CODE_ROTOR_UNINSTALLED) == ERR_CODE_ROTOR_UNINSTALLED) {
                        //qInfo() << "conWarnPumpUninstalled errCode=" << errCode;
                        emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnPumpUninstalled, "");
                    }
                }
                //栓锁报警不能自动移除
//                else {
//                    if((errCode & 0x02) == 0x00) {
//                        emit glb_RunningTestManager->removeWarning(Glb_define::conWarnPumpUninstalled);
//                    }
//                }

                if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnMotorDisConnected) == false)
                {
                    if((errCode & ERR_CODE_MOTOR_DISCONNECTED) == ERR_CODE_MOTOR_DISCONNECTED) {
                        //qInfo() << "conWarnMotorDisConnected errCode=" << errCode;
                        emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnMotorDisConnected, "");
                    }
                }
                //栓锁报警不能自动移除
//                else {
//                    if((errCode & 0x10) == 0x00) {
//                        emit glb_RunningTestManager->removeWarning(Glb_define::conWarnMotorDisConnected);
//                    }
//                }

                if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnMotorStopped) == false)
                {
                    // 保证已经启动了在判断
                    if(rotorStatus == 0 && m_rotorStatus > 0 ) {
                        //qInfo() << "conWarnMotorStopped errCode=" << errCode;
                        emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnMotorStopped, "");
                        motorSpeed = 0;
                    }
                }

                if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnMotorFailure) == false)
                {
                    if(postResult != 0 || ctrlbFault != 0) {
                        emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnMotorFailure, "");
                    }
                }

                if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnMotorFailure) == false)
                {
                    if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnMotorTempHigh) == false)
                    {
                        if(motorTemp > 60 || boardTemp > 60) {
                            emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnMotorTempHigh, "");
                        }
                    } else {
                        if(motorTemp < 60 && boardTemp < 60) {
                            emit glb_RunningTestManager->removeWarning(Glb_define::conWarnMotorTempHigh);
                        }
                    }
                }

                if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnMotorCurrentHigh) == false)
                {
                    if(suspenCurrent/100.0 > 15 || torqueCurrent/100.0 > 15) {
                        emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnMotorCurrentHigh, "");
                    }
                } else {
                    if(suspenCurrent/100.0 < 15 && torqueCurrent/100.0 < 15) {
                        emit glb_RunningTestManager->removeWarning(Glb_define::conWarnMotorCurrentHigh);
                    }
                }
            }
        }
#endif

        m_rotorStatus = rotorStatus;

        float motorSpeed_f = (float)motorSpeed / 10.0f;
        motorSpeed = qRound(motorSpeed_f) * 10;

        m_motorCommErr = false;
        emit updateMotorStatusExtend(true, errCode, motorSpeed,
                               boardTemp, motorTemp,
                               suspenCurrent, torqueCurrent,
                               postResult, ctrlbFault,
                               xPos, yPos,
                               rotorStatus);
        setCurMotorSpeedToDB(motorSpeed);
    } else {
        m_motorCommErr = true;
        qWarning() << "Motor::receiveData" << m_motorCommErr;
    }
}

void Motor::receiveErr(UartPort::emUartPortErr err)
{
    if(err == UartPort::UartReadTimeout) {
        m_motorCommErr = true;

#ifdef ALARM_ENABLED
        m_commErrorSetCount++;
        if(m_commErrorSetCount >= 3) {
            emit updateMotorStatusExtend(false, 0, 0, \
                                   0, 0, \
                                   0, 0, \
                                   0, 0, \
                                   0, 0, \
                                   0);
            if(glb_RunningTestManager) {
                if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnSysemErr1) == false)
                {
                    emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnSysemErr1,"");
                }
            }
        }
#endif
    } else {
        m_motorCommErr = false;

#ifdef ALARM_ENABLED
        m_commErrorSetCount = 0;
        //栓锁报警不能自动移除
//        if(glb_RunningTestManager) {
//            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnSysemErr1) == true)
//            {
//                emit glb_RunningTestManager->removeWarning(Glb_define::conWarnSysemErr1);
//            }
//        }
#endif
    }

}

#ifdef GLOBAL_SIMULATION_ENABLED
void Motor::startSimulationTmr()
{
    stoptSimulationTmr();
    m_nSimulationTmr = startTimer(500);
}

void Motor::stoptSimulationTmr()
{
    if(m_nSimulationTmr > 0)
    {
        killTimer(m_nSimulationTmr);
    }
    m_nSimulationTmr = 0;
}

#ifdef GLOBAL_SIMULATION
void Motor::onSimulationTmrOut()
{
    stoptSimulationTmr();
    if(m_bSendMotorSpeed){

        //static int stOldValue[4] = {0, 0, 0, 0};
        int dValue[4] = {0};
        enum emParams{
            epCode =0,
            epmotorSpeed,
            boardTemp,
            motorTemp,
        };

        int iCurParam = epmotorSpeed;
        while(true)
        {
            if(iCurParam == epmotorSpeed)
            {
                dValue[iCurParam] = QRandomGenerator::global()->bounded(m_motorSettingSpeed < 1 ? 0 : m_motorSettingSpeed /2, m_motorSettingSpeed < 1 ? 1 : m_motorSettingSpeed * 3/2);
            }
            else
            {
                dValue[iCurParam] = QRandomGenerator::global()->bounded(80);
            }

            if(iCurParam >=motorTemp)
            {
                break;
            }
            iCurParam++;
        }
        QVector<quint16> data;
        for(int i = 0; i <= motorTemp; i++)
        {
            data.append(dValue[i]);
        }
        //receiveData(data);
        emit updateMotorStatusExtend(true, data[0], data[1], \
                               data[2], data[3], \
                               0, 0, \
                               0, 0, \
                               0, 0, \
                               m_bStarted);

        // requestWriteMotorSpeed(m_motorSettingSpeed);
        setCurMotorSpeedToDB(data[1]);
    }
    startSimulationTmr();
}
#endif
#endif
void Motor::startDelaySendTargetSpeedTmr()
{
    stoptDelaySendTargetSpeedTmr();
    m_tmrDelaySendTargetSpeed = startTimer(5*1000);
}

void Motor::stoptDelaySendTargetSpeedTmr()
{
    if(m_tmrDelaySendTargetSpeed > 0){
        killTimer(m_tmrDelaySendTargetSpeed);
    }
    m_tmrDelaySendTargetSpeed = 0;
}

void Motor::onDelaySendTargetSpeedTmrOut()
{
    stoptDelaySendTargetSpeedTmr();
    setTargetMotoSpeedToAction();
}

void Motor::timerEvent(QTimerEvent *event)
{
#ifdef GLOBAL_SIMULATION_ENABLED
    if(event->timerId() == m_nSimulationTmr)
    {
#ifdef  GLOBAL_SIMULATION
        onSimulationTmrOut();
#else
        if(m_motorCmd == eCmdReadMotorStatus)
        {
            requestReadMotorStatus();
            m_motorCmd = eCmdUpdateSpeed;
        }
        else if(m_motorCmd == eCmdUpdateSpeed)
        {
            if(m_bStarted) {
                requestWriteMotorSpeed(m_motorSettingSpeed);
            }
            m_motorCmd = eCmdReadMotorStatus;
        }
        else if(m_motorCmd == eCmdStart)
        {
            qInfo() << "Start motor";
            requestWriteMotorState(true);
            m_motorCmd = eCmdReadMotorStatus;
        }
        else if(m_motorCmd == eCmdStop)
        {
            qInfo() << "Stop motor";
            requestWriteMotorState(false);
            m_motorCmd = eCmdReadMotorStatus;
            m_bStarted = false;
        }
        else if(m_motorCmd == eCmdSetSpeedZero)
        {
            qInfo() << "Set motor speed 0";
            requestWriteMotorSpeed(0);
            m_motorCmd = eCmdStop;
            m_bStarted = false;
        }
        else if(m_motorCmd == eCmdSetMotorCurThredEnabled)
        {
            qInfo() << "Set motor cur thred enabled" << m_motorCurThredEnabled;
            requestWriteMotorCurThredEnabled(m_motorCurThredEnabled);
            m_motorCmd = eCmdReadMotorStatus;
        }
        else if(m_motorCmd == eCmdSetMotorCurThredValue)
        {
            qInfo() << "Set motor cur thred value" << m_motorCurThredValue;
            requestWriteMotorCurThredValue(m_motorCurThredValue);
            m_motorCmd = eCmdReadMotorStatus;
        }
#endif
        return;
    }    
#endif
    if(event->timerId() == m_tmrDelaySendTargetSpeed){
        onDelaySendTargetSpeedTmrOut();
        return;
    }

}

void Motor::requestWriteMotorSpeed(int speed)
{
    QByteArray ba;
    if(speed < 1) // for motor driver bug
    {
        speed = 1;
    }
    quint16 newValue = speed;
    ba = packWriteHoldingRegister(MOTOR_MODBUS_ADDR, MOTOR_MODBUS_SPEED_REG, newValue);

    writeData(ba);
}

void Motor::requestUpdateMotorSpeed()
{
    requestWriteMotorSpeed(m_motorSettingSpeed);
}

void Motor::requestWriteMotorState(bool bState)
{
    QByteArray ba;

    quint16 newValue = 0;
    if(bState == true)
    {
        newValue = 0x0001;
        m_bSendMotorSpeed = true;
    } else {
        newValue = 0x0000;
        m_bSendMotorSpeed = false;
    }

    qInfo() << "requestWriteMotorState" << newValue;

    ba = packWriteHoldingRegister(MOTOR_MODBUS_ADDR, MOTOR_MODBUS_START_STOP_REG, newValue);
    if(UartPort::UartNotOpen == writeData(ba))
    {
        qWarning() << __FILE__ <<" " << __LINE__ << "requestWriteMotorState UartNotOpen" ;
    }
}

void Motor::requestWriteMotorCurThredEnabled(bool enabled)
{
    QByteArray ba;

    quint16 newValue = 0;
    if(enabled == true)
    {
        newValue = 0x0001;
    } else {
        newValue = 0x0000;
    }

    qInfo() << "requestWriteMotorCurThredEnabled" << newValue;

    ba = packWriteHoldingRegister(MOTOR_MODBUS_ADDR, MOTOR_CURTHRED_ENABLED_REG, newValue);
    if(UartPort::UartNotOpen == writeData(ba))
    {
        qWarning() << __FILE__ <<" " << __LINE__ << "requestWriteMotorCurThred UartNotOpen" ;
    }
}

void Motor::requestWriteMotorCurThredValue(int value)
{
    QByteArray ba;

    quint16 newValue = value;
    ba = packWriteHoldingRegister(MOTOR_MODBUS_ADDR, MOTOR_CURTHRED_VALUE_REG, newValue);

    writeData(ba);
}

void Motor::requestReadMotorStatus()
{
    QByteArray ba;
    ba = packReadHoldingRegister(MOTOR_MODBUS_ADDR, MOTOR_MODBUS_STATUS_REG, MOTOR_MODBUS_STATUS_REG_LEN);
    if(UartPort::UartNotOpen == writeData(ba))
    {
        qWarning() << __FILE__ <<" " << __LINE__ << "requestReadMotorStatus UartNotOpen" ;
    }
}

void Motor::stepSpeedUp(int nSteps)
{
    if(m_bLocked){
        return;
    }

    //if(m_motorSettingSpeed == 0)
    //{
    //    m_motorSettingSpeed = 100;
    //} else {
        m_motorSettingSpeed += nSteps;
    //}

    if(m_motorSettingSpeed > MAX_MOTOR_SPEED)
    {
        m_motorSettingSpeed = MAX_MOTOR_SPEED;
    }
    emit updateSettingMotorSpeed(m_motorSettingSpeed);
    startDelaySendTargetSpeedTmr();
}

void Motor::stepSpeedDown(int nSteps)
{
    if(m_bLocked){
        return;
    }

    //if(m_motorSettingSpeed <= 100)
    //{
    //    m_motorSettingSpeed = 0;
    //} else {
        m_motorSettingSpeed -= nSteps;
    //}

    if(m_motorSettingSpeed < 0)
    {
        m_motorSettingSpeed = 0;
    }

    emit updateSettingMotorSpeed(m_motorSettingSpeed);
    startDelaySendTargetSpeedTmr();
}

void Motor::setSpeedZero()
{
    if(m_bLocked){
        return;
    }

    m_motorSettingSpeed = 0;
    qDebug() << "setSpeed m_motorSettingSpeed" << m_motorSettingSpeed;
    emit updateSettingMotorSpeed(m_motorSettingSpeed);
    startDelaySendTargetSpeedTmr();
}

void Motor::setSpeed(int speed)
{
    if(m_bLocked){
        return;
    }

    m_motorSettingSpeed = speed;
    qDebug() << "setSpeed m_motorSettingSpeed" << m_motorSettingSpeed;

    emit updateSettingMotorSpeed(m_motorSettingSpeed);
    startDelaySendTargetSpeedTmr();
}

void Motor::setSpeedDefault()
{
    if(m_bLocked){
        return;
    }

    m_motorSettingSpeed = 2000;
    qDebug() << "setSpeedDefault m_motorSettingSpeed" << m_motorSettingSpeed;

    emit updateSettingMotorSpeed(m_motorSettingSpeed);
    startDelaySendTargetSpeedTmr();
}

int Motor::getSettingMotorSpeed()
{
    return m_motorSettingSpeed;
}

void Motor::setLocked(bool bLock)
{
    m_bLocked = bLock;
}

void Motor::setMotorStarted(bool b)
{
    m_bStarted = b;
}

void Motor::setTargetMotoSpeedToAction()
{
    if(!glb_RunningTestManager){
        qWarning("%s %d glb_RunningTestManager is null!!!", __FILE__, __LINE__);
    }

    //save setting speed
    QString iniFilePath = QApplication::applicationDirPath() + QString("/config.ini");
    QSettings setting(iniFilePath, QSettings::IniFormat);

    QString strSpeed = setting.value("Motor/SettingSpeed").toString();
    if(strSpeed == "") {
        strSpeed = "0";
        setting.setValue("Motor/SettingSpeed", strSpeed);
    } else {
        setting.setValue("Motor/SettingSpeed", QString::number(m_motorSettingSpeed));
    }

    emit glb_RunningTestManager->receiveAction(Glb_define::conActUpdateSpeed, QString("%1 RPM").arg(m_motorSettingSpeed));
}
/**
 * @brief Motor::setCurMotorSpeedToDB
 * @param iCurSpeed
 */
void Motor::setCurMotorSpeedToDB(int iCurSpeed)
{
    if(!glb_RunningTestManager){
        qWarning("%s %d glb_RunningTestManager is null!!!", __FILE__, __LINE__);
    } else {
        //qDebug() << "Motor::setCurMotorSpeedToDB isRunning" << glb_RunningTestManager->isRunning();
        if(glb_RunningTestManager->isRunning()) {
            emit glb_RunningTestManager->updateCurMotorSpeed(iCurSpeed);
        }
    }
}
/**
 * @brief Motor::getError
 * @return
 */
bool Motor::getError()
{
#ifdef GLOBAL_SIMULATION_ENABLED
    return false;
#endif
    if(UartPort::UartNoErr != getPortErr())
    {
        qDebug() << "Motor::getError";
        m_motorCommErr = true;
    }

    qInfo() << "getError" << m_motorCommErr << getPortErr();

    return m_motorCommErr;
}

void Motor::requestCmd(QString cmd)
{
    if(cmd == "UpdateSpeed")
    {
        m_motorCmd = eCmdUpdateSpeed;
    }
    else if (cmd == "Start")
    {
        qInfo() << "requestCmd Start";
        m_motorCmd = eCmdStart;
    }
    else if (cmd == "Stop")
    {
         qInfo() << "requestCmd Stop";
        m_motorCmd = eCmdSetSpeedZero;
    }
    else if (cmd == "EnabledCurThred")
    {
        m_motorCmd = eCmdSetMotorCurThredEnabled;
    }
    else if (cmd == "SetCurThred")
    {
        m_motorCmd = eCmdSetMotorCurThredValue;
    }
}

void Motor::requestCmdSetMotorCurThredEnabled(bool enabled)
{
    m_motorCurThredEnabled = enabled;
    m_motorCmd = eCmdSetMotorCurThredEnabled;
}

void Motor::requestCmdSetMotorCurThredValue(int value)
{
    m_motorCurThredValue = value;
    m_motorCmd = eCmdSetMotorCurThredValue;
}

QString Motor::firmwareVersion()
{
    quint8 z = m_version & 0x00FF;
    quint8 y = (m_version&0x0F00) >> 8;
    quint8 x = (m_version&0xF000) >> 12;

    qInfo() << "Motor version:" << m_version;
    QString ver = "V"+QString::number(x)+"."+QString::number(y)+"(完整版本:V"
            +QString::number(x)+"."+QString::number(y)+"."+QString::number(z)+")";

    return ver;
}
