/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the QtSerialBus module.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef POWER_H
#define POWER_H

#include <QObject>
#include <QModbusDataUnit>
#include "uartport.h"
#include "global_define.h"

#define GLOBAL_SIMULATION_ENABLED    1

class Power : public UartPort
{
    Q_OBJECT

public:
    enum ePowerCmd{
        eCmdReadPowerStatus = 0,
        eCmdPowerOnMotor = 1,
        eCmdPowerOffMotor = 2,
        eCmdPowerOffHmi = 3,
        eCmdSysPowerOff = 4,
        eCmdUpdateFunSpeed = 5
    };

    explicit Power(QWidget *parent = nullptr);
    ~Power();
    Q_INVOKABLE bool connectPort();
    Q_INVOKABLE void requestReadPowerStatus();
    Q_INVOKABLE void requestWritePowerOnMotor();
    Q_INVOKABLE void requestWritePowerOffMotor();
    Q_INVOKABLE void requestWritePowerOffHmi();
    Q_INVOKABLE void requestWriteFunSpeed(int pwm);
    Q_INVOKABLE bool getError();
    Q_INVOKABLE void requestCmd(QString cmd);
    Q_INVOKABLE void requestUpdateFunSpeedCmd(int persent);
    Q_INVOKABLE QString firmwareVersion();
signals:

    void updatePowerStatusExtend(int powerOnOff,
                           int bat1chargingState, int bat2chargingState,
                           int powerType,
                           int bat1PowerLevel, int bat2PowerLevel,
                           int bat1Temp, int bat2Temp,
                           int bat1Voltage, int bat2Voltage,
                           int bat1Current, int bat2Current,
                           int bat1CycleCount, int bat2CycleCount,
                           int bat1SN, int bat2SN,
                           int bat1RemTime, int bat2RemTime,
                           int fanSpeed, int postStatus
                           );

private slots:
    void receiveData(QByteArray data);
    void receiveErr(UartPort::emUartPortErr err);


protected:
    void timerEvent(QTimerEvent *event);
#ifdef  GLOBAL_SIMULATION_ENABLED
private:
    int m_nSimulationTmr{0};
    void startSimulationTmr();
    void stoptSimulationTmr();
    void onSimulationTmrOut();
#endif
private:
    bool m_powerModuleErr;
    int m_funSpeed{20};
    int m_commErrorSetCount{0};
    ePowerCmd m_powerCmd{eCmdPowerOnMotor};
    quint16 m_version;
};

#endif // Power_H
