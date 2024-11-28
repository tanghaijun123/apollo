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

#ifndef Motor_H
#define Motor_H

#include <QObject>
#include <QModbusDataUnit>
#include <QTimerEvent>
#include <QMutex>
#include "global_define.h"
#include "uartport.h"

#define GLOBAL_SIMULATION_ENABLED   1

class Motor : public UartPort
{
    Q_OBJECT
    //Q_PROPERTY(bool sendMotorSpeed READ getSendMotorSpeed WRITE setSendMotorSpeed NOTIFY sendMotorSpeedChanged FINAL)
public:
    enum eMotorCmd{
        eCmdReadMotorStatus = 0,
        eCmdUpdateSpeed = 1,
        eCmdStart = 2,
        eCmdStop = 3,
        eCmdSetSpeedZero = 4,
        eCmdSetMotorCurThredEnabled = 5,
        eCmdSetMotorCurThredValue = 6,
    };

    enum MotorErrorCode {
        eMotorNoErr,
        eMotorDisconnected,
        eSuspensionWindingDisconnected,
        eTorequeWindingDisconnected,
        eNoPump,
        eSuspensionWindingOvercurrent,
        eTorqueWindingOvercurrent,
        eDCVoltageAbnormal,
    };


    explicit Motor(QWidget *parent = nullptr);
    ~Motor();
    Q_INVOKABLE bool connectPort();
    Q_INVOKABLE void requestWriteMotorState(bool bState);
    Q_INVOKABLE void requestReadMotorStatus();
    Q_INVOKABLE void requestWriteMotorDefSpeed();
    Q_INVOKABLE void requestWriteMotorSpeed(int speed);
    Q_INVOKABLE void requestUpdateMotorSpeed();
    Q_INVOKABLE void stepSpeedUp(int nSteps);
    Q_INVOKABLE void stepSpeedDown(int nSteps);
    Q_INVOKABLE void setSpeedZero();
    Q_INVOKABLE void setSpeed(int speed);
    Q_INVOKABLE void setSpeedDefault();
    Q_INVOKABLE int  getSettingMotorSpeed();
    Q_INVOKABLE bool getError();
    Q_INVOKABLE void setLocked(bool bLock);
    Q_INVOKABLE void setMotorStarted(bool b);
    Q_INVOKABLE void requestCmd(QString cmd);
    Q_INVOKABLE QString firmwareVersion();
    Q_INVOKABLE void requestCmdSetMotorCurThredEnabled(bool enabled);
    Q_INVOKABLE void requestCmdSetMotorCurThredValue(int value);
private:
    void setTargetMotoSpeedToAction();
    void setCurMotorSpeedToDB(int iCurSpeed);
    void saveMotorData(QString data);

    void requestWriteMotorCurThredEnabled(bool enabled);
    void requestWriteMotorCurThredValue(int value);
signals:
    void updateMotorStatusExtend(bool connState, int errCode, int motorSpeed,
                                       int boardTemp, int motorTemp,
                                       int suspenCurrent, int torqueCurrent,
                                       int postResult, int ctrlbFault,
                                       int xPos, int yPos,
                                       int rotorStatus);
    void updateSettingMotorSpeed(int speed);
    void updateNewSelect(int step);

public slots:
    void receiveData(QByteArray data);
    void updateMotorSpeed(int rotaryEncoder, int step);
    void receiveErr(UartPort::emUartPortErr err);

#ifdef GLOBAL_SIMULATION_ENABLED
private:
    int m_nSimulationTmr{0};
    void startSimulationTmr();
    void stoptSimulationTmr();
    void onSimulationTmrOut();
#endif

private:
    int m_tmrDelaySendTargetSpeed{0};
    void startDelaySendTargetSpeedTmr();
    void stoptDelaySendTargetSpeedTmr();
    void onDelaySendTargetSpeedTmrOut();
protected:
    void timerEvent(QTimerEvent *event);

signals:
    void sendMotorSpeedChanged();

private:
    int m_motorSettingSpeed{0};
    int m_motorSettingSpeedPre{0};
    int m_motorSettingValidCnt{0};
    bool m_motorCommErr{false};
    bool m_bSendMotorSpeed{false};
    bool m_bLocked{false};
    int m_commErrorSetCount{0};
    eMotorCmd m_motorCmd{eCmdUpdateSpeed};
    bool m_bStarted{false};
    int m_rotorStatus{0};
    QMutex m_mutex;
    quint16 m_version;

    bool m_motorCurThredEnabled{false};
    int m_motorCurThredValue{0};
    QList<int> m_motorSpeedList;

};

#endif // Motor_H
