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

#ifndef FLOWSENSOR_H
#define FLOWSENSOR_H

#define GLOBAL_SIMULATION_ENABLED   1

#include <QObject>
#include <QModbusDataUnit>
#include "global_define.h"
#include "uartport.h"
#ifdef GLOBAL_SIMULATION_ENABLED
#include <QTimerEvent>
#endif

class FlowSensor : public UartPort
{
    Q_OBJECT

public:
    explicit FlowSensor(QWidget *parent = nullptr);
    ~FlowSensor();
    Q_INVOKABLE bool connectPort();
    Q_INVOKABLE void requestReadFlow();
    Q_INVOKABLE void requestReadBubbleState();
    Q_INVOKABLE void requestReadSystemState();
    Q_INVOKABLE bool getError();
    Q_INVOKABLE QString getBubbleState();

    enum eFlowSensorCmd{
        eCmdReadFlowValue = 0,
        eCmdReadBubbleState = 1,
        eCmdReadSystemState = 2,
        eCmdReadFlowValue2 = 3,
        eCmdNone = 99
    };

signals:
    void updateFlowValue(bool connState, QString flow);

private slots:
    void receiveData(QByteArray data);
    void receiveErr(UartPort::emUartPortErr err);
#ifdef GLOBAL_SIMULATION_ENABLED
private:
    int m_nSimulationTmr{0};
    void startSimulationTmr();
    void stoptSimulationTmr();
    void onSimulationTmrOut();
protected:
    void timerEvent(QTimerEvent *event);
#endif
private:
    void setCurFlowVolumeToDB(double dFlowVolume);
private:
    bool m_flowSensorErr{false};
    int m_commErrorSetCount{0};
    eFlowSensorCmd m_flowSensorCmd{eCmdReadFlowValue};
    qint32 m_bubbleState{0};
};

#endif // FLOWSENSOR_H
