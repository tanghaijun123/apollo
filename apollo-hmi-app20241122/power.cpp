/******************************************************************************/
/*! @File        : power.cpp
 *  @Brief       : 负责与电源管理板的RS485通信
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

#include "power.h"
#include <QModbusTcpClient>
#include <QModbusRtuSerialMaster>
#include <QStandardItemModel>
#include <QStatusBar>
#include <QUrl>
#include <QDebug>
#include <QSerialPort>
#include "uartport.h"
#include "database/crunningtestmanager.h"
#ifdef  GLOBAL_SIMULATION_ENABLED
#include <QTimerEvent>
#endif
#include<unistd.h>

#define POWER_MODBUS_ADDR         0x10

//#define POWER_MODULE_DEBUG          1

#define POWER_MOTOR_POWER_REG           0x0101
#define POWER_MAIN_BOARD_POWER_REG      0x0102
#define POWER_BUZZER_ENABLED_REG        0x0103
#define POWER_FUN_SPEED_REG             0x0104
#define POWER_DEFAULT_REG               0x0105
#define POWER_STATUS_REG                0x0008

Power::Power(QWidget *parent)
    : UartPort(parent)
{
    connectPort();

#ifdef  GLOBAL_SIMULATION_ENABLED
    startSimulationTmr();
#endif

    m_powerModuleErr = true;
}

Power::~Power()
{

}

bool Power::connectPort()
{
    QString retStr;
    connect(this, &UartPort::sendRecvMsg, this, &Power::receiveData);
    connect(this, &UartPort::sendErr, this, &Power::receiveErr);

#ifdef BOARD_TQ
    qInfo() << "Power module connectPort" << openPort("/dev/ttyUSB2", 9600);
#else
    qInfo() << "Power module connectPort" << openPort("/dev/ttySAC2", 9600);
#endif

    return (retStr == "OK");
}

void Power::receiveData(QByteArray data)
{
    uint8_t index = 0;

    if(data.length() >= 8)
    {
        quint8 * p_data = (quint8 *)data.data();
        index = 0;
        qint16 powerOnOff = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //1-poweroff, 0-none
        index = 1;
        qint16 bat1ChargingState = (qint16)p_data[2*index]; //0-idle, 1-charging, 2-disconnected
        qint16 bat2ChargingState = (qint16)p_data[2*index+1]; //0-idle, 1-charging, 2-disconnected
        index = 2;
        qint16 powerType = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //1-acpower, 2-battery1, 3-battery2
        index = 3;
        qint16 bat1PowerLevel = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 1 level
        index = 4;
        qint16 bat2PowerLevel = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 2 level
        index = 5;
        qint16 bat1Temp = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 1 temperature
        index = 6;
        qint16 bat2Temp = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 2 temperature
        index = 7;
        qint16 bat1Voltage = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 1 voltage
        index = 8;
        qint16 bat2Voltage = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 2 voltage
        index = 9;
        qint16 bat1Current = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 1 current
        index = 10;
        qint16 bat2Current = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 2 current
        index = 11;
        qint16 bat1CycleCount = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 1 Cycle count
        index = 12;
        qint16 bat2CycleCount = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 2 Cycle count
        index = 13;
        qint16 bat1SN = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 1 SN
        index = 14;
        qint16 bat2SN = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 2 SN
        index = 15;
        qint16 bat1RemTime = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 1 RemTime
        index = 16;
        qint16 bat2RemTime = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //battery 2 RemTime
        index = 18;
        qint16 fanSpeed = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //fan speed
        index = 19;
        qint16 postStatus = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //post status
        index = 20;
        m_version = (qint16)p_data[2*index] << 8 | p_data[2*index+1]; //version

#ifdef POWER_MODULE_DEBUG
        qInfo() << "Power state : powerOnoff=" << powerOnOff \
                 << "bat1ChargingState=" << bat1ChargingState \
                 << "bat2ChargingState=" << bat2ChargingState \
                 << "powerType=" << powerType \
                 << "bat1PowerLevel="<< bat1PowerLevel \
                 << "bat2PowerLevel="<< bat2PowerLevel \
                 << "bat1Temp="<< bat1Temp \
                 << "bat2Temp="<< bat2Temp \
                 << "bat1Voltage="<< bat1Voltage \
                 << "bat2Voltage="<< bat2Voltage \
                 << "bat1Current="<< bat1Current \
                 << "bat2Current="<< bat2Current \
                 << "bat1CycleCount" << bat1CycleCount \
                 << "bat2CycleCount" << bat2CycleCount \
                 << "bat1SN" << bat1SN \
                 << "bat1SN" << bat2SN \
                 << "bat1RemTime" << bat1RemTime \
                 << "bat2RemTime" << bat2RemTime \
                 << "fanSpeed" <<  fanSpeed \
                 << "postStatus" <<  postStatus;
#endif

#define BAT_LEVEL_LOW 30
#define BAT_LEVEL_EMPTY 5

        Q_UNUSED(powerOnOff); //if used add process code
#ifdef ALARM_ENABLED
        if(powerType == 1)
        {
            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBatteryLow))
            {
                emit glb_RunningTestManager->removeWarning(Glb_define::conWarnBatteryLow);
            }

            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBatteryPowered))
            {
                emit glb_RunningTestManager->removeWarning(Glb_define::conWarnBatteryPowered);
            }

            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBatteryEmpty))
            {
                emit glb_RunningTestManager->removeWarning(Glb_define::conWarnBatteryEmpty);
            }

            // if battery 1 and battery 2 both diconnected
            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBatteryNotFound) == false)
            {
                if(bat1ChargingState == 2 && bat2ChargingState == 2) {
                    emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnBatteryNotFound, "");
                }
            } else {
                if(bat1ChargingState != 2 || bat2ChargingState != 2) {
                    emit glb_RunningTestManager->removeWarning(Glb_define::conWarnBatteryNotFound);
                }
            }

        } else {
            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBatteryNotFound))
            {
                emit glb_RunningTestManager->removeWarning(Glb_define::conWarnBatteryNotFound);
            }

            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBatteryPowered) == false)
            {
                emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnBatteryPowered, "");
            }

            //bat1 level
            if(bat1PowerLevel < BAT_LEVEL_EMPTY && bat2PowerLevel < BAT_LEVEL_EMPTY){

                if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBatteryLow) == true)
                {
                    emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnBatteryEmpty, Glb_define::conWarnBatteryLow);
                } else {
                    emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnBatteryEmpty, "");
                }
            }
            else if(bat1PowerLevel < BAT_LEVEL_LOW && bat2PowerLevel < BAT_LEVEL_LOW){
                if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBatteryLow) == false)
                {
                    emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnBatteryLow, "");
                }
            }
        }

        if(bat1CycleCount >= 500 || bat1CycleCount >= 500) {
            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBatteryNeedMantience) == false)
            {
                emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnBatteryNeedMantience, "");
            }
        }

        if(bat1Temp/10.0 >= 75 || bat2Temp/10.0 >= 75) {
            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBatteryTempHigh) == false)
            {
                emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnBatteryTempHigh, "");
            }
        } else {
            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBatteryTempHigh))
            {
                emit glb_RunningTestManager->removeWarning(Glb_define::conWarnBatteryTempHigh);
            }
        }

        if(powerType == 1 && ((bat1PowerLevel < 96 && bat1ChargingState == 0) || (bat2PowerLevel < 96 && bat2ChargingState == 0)))
        {
            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBatteryChangeFailed) == false)
            {
                emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnBatteryChangeFailed, "");
            }
        } else {
            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnBatteryChangeFailed))
            {
                emit glb_RunningTestManager->removeWarning(Glb_define::conWarnBatteryChangeFailed);
            }
        }

#endif
        //
        Q_UNUSED(bat1ChargingState);
        Q_UNUSED(bat2ChargingState);
        Q_UNUSED(powerType);
        Q_UNUSED(bat1Temp);
        Q_UNUSED(bat2Temp);
        Q_UNUSED(bat1Voltage);
        Q_UNUSED(bat2Voltage);
        Q_UNUSED(bat1Current);
        Q_UNUSED(bat2Current);


        m_powerModuleErr = false;

        emit updatePowerStatusExtend(powerOnOff,
                                    bat1ChargingState,  bat2ChargingState,
                                    powerType,
                                    bat1PowerLevel,  bat2PowerLevel,
                                    bat1Temp/10.0,  bat2Temp/10.0,
                                    bat1Voltage/10.0,  bat2Voltage/10.0,
                                    bat1Current/10.0,  bat2Current/10.0,
                                    bat1CycleCount,  bat2CycleCount,
                                    bat1SN,  bat2SN,
                                    bat1RemTime,  bat2RemTime,
                                    fanSpeed,  postStatus
                                   );
#ifdef ALARM_ENABLED

#endif
    } else {
        qInfo() << "Power receiveData" << "data length error" << data.length();
        m_powerModuleErr = true;
    }
}

void Power::receiveErr(UartPort::emUartPortErr err)
{
    if(err == UartPort::UartReadTimeout) {
        m_powerModuleErr = true;

#ifdef ALARM_ENABLED
        m_commErrorSetCount++;
        if(m_commErrorSetCount >= 3) {
            if(glb_RunningTestManager) {
                if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnSysemErr2) == false)
                {
                    emit glb_RunningTestManager->reciveWarning(Glb_define::conWarnSysemErr2,"");
                }
            }
        }
#endif
    } else {
        m_powerModuleErr = false;
#ifdef ALARM_ENABLED
        m_commErrorSetCount = 0;

        //栓锁报警不能自动移除
//        if(glb_RunningTestManager) {
//            if(glb_RunningTestManager->isWarningExist(Glb_define::conWarnSysemErr2) == true)
//            {
//                emit glb_RunningTestManager->removeWarning(Glb_define::conWarnSysemErr2);
//            }
//        }
#endif
    }
}


void Power::timerEvent(QTimerEvent *event)
{
#ifdef  GLOBAL_SIMULATION_ENABLED

    if(event->timerId() == m_nSimulationTmr)
    {
#ifdef  GLOBAL_SIMULATION
        onSimulationTmrOut();
#else
        if(m_powerCmd == eCmdReadPowerStatus)
        {
            requestReadPowerStatus();
        }
        else if(m_powerCmd == eCmdPowerOnMotor)
        {
            requestWritePowerOnMotor();
            m_powerCmd = eCmdReadPowerStatus;  //goto read power status
        }
        else if(m_powerCmd == eCmdPowerOffMotor)
        {
            requestWritePowerOffMotor();
            m_powerCmd = eCmdReadPowerStatus;  //goto read power status
        }
        else if(m_powerCmd == eCmdPowerOffHmi)
        {
            if(glb_RunningTestManager) {
                emit glb_RunningTestManager->receiveAction(Glb_define::conActPowerOff, "");
            }

            requestWritePowerOffHmi();
            //Make sure data writed to flash
            sync();
            m_powerCmd = eCmdSysPowerOff;  //goto read power status
        }
        else if(m_powerCmd == eCmdSysPowerOff)
        {
            system("poweroff");
        }
        else if(m_powerCmd == eCmdUpdateFunSpeed)
        {
            requestWriteFunSpeed(m_funSpeed);
            m_powerCmd = eCmdReadPowerStatus;
        }
#endif
    }
#endif
}
#ifdef  GLOBAL_SIMULATION_ENABLED
void Power::startSimulationTmr()
{
    stoptSimulationTmr();
    m_nSimulationTmr = startTimer(1000);
}

void Power::stoptSimulationTmr()
{
    if(m_nSimulationTmr > 0)
    {
        killTimer(m_nSimulationTmr);
    }
    m_nSimulationTmr = 0;
}

#ifdef  GLOBAL_SIMULATION
void Power::onSimulationTmrOut()
{
//    电池充放电模拟器思路

//  1. 电池PowerLevel 最大为100 最小为0
//  2. 前100 电池1放电， 100~200 电池1充电，200~400 无电池1
//  3. 前200 电池2无电池， 200~300 电池2放电，300~400 无电池2充电
    enum emChargingState {ctNomal,  ctCharging, ctNone};
    enum empowerType{ptACPower=1, ptBattery1, ptbattery2};
    static int iStep = 0;
    int powerOnOff = 0;
    int bat1ChargingState  = (iStep < 100) ?  ctNomal: ((iStep < 200) ? ctCharging : ctNone );
    int bat2ChargingState  = (iStep < 200) ?  ctNone: ((iStep < 300) ? ctNomal : ctCharging );
    int powerType = (iStep < 100) ? ptBattery1: (( iStep < 200) ? ptACPower: ((iStep < 300) ? ptbattery2: ptACPower));
    int bat1PowerLevel = (iStep < 100) ?  (100 - iStep): ((iStep < 200) ? (iStep -100) : 100 );
    int  bat2PowerLevel = (iStep < 200) ?  (100): ((iStep < 300) ? (300 - iStep) : iStep -300 );
    int bat1Temp = 1;
    int bat2Temp = 1;
    int  bat1Voltage = 1;
    int  bat2Voltage = 1;
    int  bat1Current = 1;
    int  bat2Current = 1;
    int bat1CycleCount = 0;
    int bat2CycleCount = 0;
    int bat1SN = 0;
    int bat2SN = 0;
    int bat1RemTime = 0;
    int bat2RemTime = 0;
    int fanSpeed = 0;
    int postStatus = 0;

    emit updatePowerStatusExtend(powerOnOff,
                                bat1ChargingState,  bat2ChargingState,
                                powerType,
                                bat1PowerLevel,  bat2PowerLevel,
                                bat1Temp/10.0,  bat2Temp/10.0,
                                bat1Voltage/10.0,  bat2Voltage/10.0,
                                bat1Current/10.0,  bat2Current/10.0,
                                bat1CycleCount,  bat2CycleCount,
                                bat1SN,  bat2SN,
                                bat1RemTime,  bat2RemTime,
                                fanSpeed,  postStatus
                               );
    iStep++;
    iStep = iStep % ((100 + 100) *2);
}

#endif
#endif

void Power::requestReadPowerStatus()
{
    QByteArray ba;
    ba = packReadHoldingRegister(POWER_MODBUS_ADDR, POWER_STATUS_REG, 0x15);
    if(UartPort::UartNotOpen == writeData(ba))
    {
        qInfo() << __FILE__ <<" " << __LINE__ << "requestReadPowerStatus UartNotOpen" ;
    }
}

void Power::requestWritePowerOnMotor()
{
    QByteArray ba;
    ba = packWriteHoldingRegister(POWER_MODBUS_ADDR, POWER_MOTOR_POWER_REG, 0x0001);
    if(UartPort::UartNotOpen == writeData(ba))
    {
        qInfo() << __FILE__ <<" " << __LINE__ << "requestWriteEnableMotorPower UartNotOpen" ;
    }
}

void Power::requestWritePowerOffMotor()
{
    QByteArray ba;
    ba = packWriteHoldingRegister(POWER_MODBUS_ADDR, POWER_MOTOR_POWER_REG, 0x0000);
    if(UartPort::UartNotOpen == writeData(ba))
    {
        qInfo() << __FILE__ <<" " << __LINE__ << "requestWriteEnableMotorPower UartNotOpen" ;
    }
}

void Power::requestWritePowerOffHmi()
{
    QByteArray ba;
    ba = packWriteHoldingRegister(POWER_MODBUS_ADDR, POWER_MAIN_BOARD_POWER_REG, 0x0000);
    if(UartPort::UartNotOpen == writeData(ba))
    {
        qInfo() << __FILE__ << " " << __LINE__ << "requestWriteShutDownCmd UartNotOpen" ;
    }
}

void Power::requestWriteFunSpeed(int pwm)
{
    pwm = pwm % 100;

    QByteArray ba;
    ba = packWriteHoldingRegister(POWER_MODBUS_ADDR, POWER_FUN_SPEED_REG, pwm);
    if(UartPort::UartNotOpen == writeData(ba))
    {
        qInfo() << __FILE__ << " " << __LINE__ << "requestWriteShutDownCmd UartNotOpen" ;
    }
}

void Power::requestUpdateFunSpeedCmd(int persent)
{
    m_funSpeed = persent;
    requestCmd("UpdateFunSpeed");
}

bool Power::getError()
{

    if(UartPort::UartNoErr != getPortErr())
    {
        m_powerModuleErr = true;
    }

    return m_powerModuleErr;
}

void Power::requestCmd(QString cmd)
{
    if(cmd == "PowerOnMotor")
    {
        m_powerCmd = eCmdPowerOnMotor;
    }
    else if (cmd == "PowerOffMotor")
    {
        m_powerCmd = eCmdPowerOffMotor;
    }
    else if (cmd == "PowerOffHmi")
    {
        m_powerCmd = eCmdPowerOffHmi;
    }
    else if (cmd == "UpdateFunSpeed")
    {
        m_powerCmd = eCmdUpdateFunSpeed;
    }
    else
    {
        m_powerCmd = eCmdReadPowerStatus;
    }
}

QString Power::firmwareVersion()
{
    quint8 z = m_version & 0x00FF;
    quint8 y = (m_version&0x0F00) >> 8;
    quint8 x = (m_version&0xF000) >> 12;

    qInfo() << "Power version:" << m_version;
    QString ver = "V"+QString::number(x)+"."+QString::number(y)+"(完整版本:V"
            +QString::number(x)+"."+QString::number(y)+"."+QString::number(z)+")";

    return ver;
}
