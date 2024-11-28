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

#include "mastermodbus.h"
#include <QModbusTcpClient>
#include <QModbusRtuSerialMaster>
#include <QStandardItemModel>
#include <QStatusBar>
#include <QUrl>
#include <QDebug>
#include <QSerialPort>

enum ModbusConnection {
    Serial,
    Tcp
};

MasterModbus::MasterModbus(QWidget *parent)
    : QObject(parent)
{

#if QT_CONFIG(modbus_serialport)
    onConnectTypeChanged(0);
#else
    // lock out the serial port option
    onConnectTypeChanged(1);
#endif

    //auto model = new QStandardItemModel(10, 1, this);

}

MasterModbus::~MasterModbus()
{
    if (modbusDevice)
        modbusDevice->disconnectDevice();
    delete modbusDevice;

}

void MasterModbus::onConnectTypeChanged(int index)
{
    if (modbusDevice) {
        modbusDevice->disconnectDevice();
        delete modbusDevice;
        modbusDevice = nullptr;
    }

    auto type = static_cast<ModbusConnection>(index);
    if (type == Serial) {
#if QT_CONFIG(modbus_serialport)
        modbusDevice = new QModbusRtuSerialMaster(this);
#endif
    } else if (type == Tcp) {
        modbusDevice = new QModbusTcpClient(this);
    }

    connect(modbusDevice, &QModbusClient::errorOccurred, [this](QModbusDevice::Error) {
        qDebug() << modbusDevice->errorString();
    });

    if (!modbusDevice) {
        if (type == Serial)
            qDebug() << (tr("Could not create Modbus master."));
        else
            qDebug() << (tr("Could not create Modbus client."));
    } else {
        connect(modbusDevice, &QModbusClient::stateChanged,
                this, &MasterModbus::onModbusStateChanged);
    }
}

int MasterModbus::connectSerialPort(QString portName, int baud)
{
    if (!modbusDevice)
        return 1;

    if (modbusDevice->state() != QModbusDevice::ConnectedState) {
        modbusDevice->setConnectionParameter(QModbusDevice::SerialPortNameParameter, portName);
#if QT_CONFIG(modbus_serialport)
        int parity = QSerialPort::NoParity;

        int dataBits = QSerialPort::Data8;
        int stopBits = QSerialPort::OneStop;
        modbusDevice->setConnectionParameter(QModbusDevice::SerialParityParameter, parity);
        modbusDevice->setConnectionParameter(QModbusDevice::SerialBaudRateParameter, baud);
        modbusDevice->setConnectionParameter(QModbusDevice::SerialDataBitsParameter, dataBits);
        modbusDevice->setConnectionParameter(QModbusDevice::SerialStopBitsParameter, stopBits);
#endif

        int responseTime = 1000;
        int numberOfRetries = 3;
        modbusDevice->setTimeout(responseTime);
        modbusDevice->setNumberOfRetries(numberOfRetries);
        if (!modbusDevice->connectDevice()) {
            qDebug() << (tr("Connect failed: ") + modbusDevice->errorString());
            return 2;
        } else {
            qDebug() << "Connect port: " << portName;
            return 0;
        }
    } else {
        modbusDevice->disconnectDevice();
        return 3;
    }
}

void MasterModbus::onModbusStateChanged(int state)
{
    bool connected = (state != QModbusDevice::UnconnectedState);

    //if (state == QModbusDevice::UnconnectedState)
        //ui->connectButton->setText(tr("Connect"));
    //else if (state == QModbusDevice::ConnectedState)
        //ui->connectButton->setText(tr("Disconnect"));
}

int MasterModbus::requestReadData(int serverAddress, int startAddress, quint16 numberOfEntries)
{
    if (!modbusDevice)
        return 1;

    if (auto *reply = modbusDevice->sendReadRequest(readRequest(startAddress, numberOfEntries), serverAddress)) {
        if (!reply->isFinished())
            connect(reply, &QModbusReply::finished, this, &MasterModbus::onReadReady);
        else
            delete reply; // broadcast replies return immediately

        return 0;
    } else {
        qDebug() << tr("Read error: ") + modbusDevice->errorString();
        return 2;
    }
}

void MasterModbus::onReadReady()
{
    auto reply = qobject_cast<QModbusReply *>(sender());
    if (!reply)
        return;

    if (reply->error() == QModbusDevice::NoError) {
        const QModbusDataUnit unit = reply->result();

        for (int i = 0, total = int(unit.valueCount()); i < total; ++i) {
            const QString entry = tr("Address: %1, Value: %2").arg(unit.startAddress() + i)
                                     .arg(QString::number(unit.value(i),
                                          unit.registerType() <= QModbusDataUnit::Coils ? 10 : 16));
            //qDebug() << "onReadReady" << entry;

        }

        emit responseReadRequest(unit.values());

    } else if (reply->error() == QModbusDevice::ProtocolError) {
        qDebug() << (tr("Read response error: %1 (Mobus exception: 0x%2)").
                                    arg(reply->errorString()).
                                    arg(reply->rawResult().exceptionCode(), -1, 16));
    } else {
        qDebug() << (tr("Read response error: %1 (code: 0x%2)").
                                    arg(reply->errorString()).
                                    arg(reply->error(), -1, 16));
    }

    reply->deleteLater();
}

void MasterModbus::requestWriteData(int serverAddress, int startAddress, QVector<quint16> holdingRegisters, quint16 numberOfEntries)
{
    if (!modbusDevice)
        return;

    QModbusDataUnit writeUnit = writeRequest(startAddress, numberOfEntries);
    qDebug() << "requestWriteData" << holdingRegisters.length() << writeUnit.startAddress();

    //QModbusDataUnit::RegisterType table = writeUnit.registerType();
    for (int i = 0, total = int(writeUnit.valueCount()); i < total; ++i) {
        writeUnit.setValue(i, holdingRegisters[i]);
    }

    qDebug() << "requestWriteData startAddress: " << writeUnit.startAddress();

    if (auto *reply = modbusDevice->sendWriteRequest(writeUnit, serverAddress)) {
        if (!reply->isFinished()) {
            connect(reply, &QModbusReply::finished, this, [this, reply]() {
                if (reply->error() == QModbusDevice::ProtocolError) {
                    qDebug() << tr("Write response error: %1 (Mobus exception: 0x%2)")
                        .arg(reply->errorString()).arg(reply->rawResult().exceptionCode(), -1, 16);
                } else if (reply->error() != QModbusDevice::NoError) {
                    qDebug() << tr("Write response error: %1 (code: 0x%2)").
                        arg(reply->errorString()).arg(reply->error(), -1, 16);
                }
                reply->deleteLater();
            });
        } else {
            // broadcast replies return immediately
            reply->deleteLater();
        }
    } else {
        qDebug() <<  (tr("Write error: ") + modbusDevice->errorString());
    }
}

void MasterModbus::requestReadWriteData(int serverAddress, int startAddress, QVector<quint16> holdingRegisters, quint16 numberOfEntries)
{
    if (!modbusDevice)
        return;

    QModbusDataUnit writeUnit = writeRequest(startAddress, numberOfEntries);

    //QModbusDataUnit::RegisterType table = writeUnit.registerType();
    for (int i = 0, total = int(writeUnit.valueCount()); i < total; ++i) {
        writeUnit.setValue(i, holdingRegisters[i]);
    }

    if (auto *reply = modbusDevice->sendReadWriteRequest(readRequest(startAddress, numberOfEntries), writeUnit, serverAddress)) {
        if (!reply->isFinished())
            connect(reply, &QModbusReply::finished, this, &MasterModbus::onReadReady);
        else
            delete reply; // broadcast replies return immediately
    } else {
        qDebug() << (tr("Read error: ") + modbusDevice->errorString());
    }
}

QModbusDataUnit MasterModbus::readRequest(int startAddress, quint16 numberOfEntries) const
{
    const auto table = QModbusDataUnit::HoldingRegisters;

    //qDebug() << "table" << table << "startAddress" << startAddress << "numberOfEntries" << numberOfEntries;
    return QModbusDataUnit(table, startAddress, numberOfEntries);
}

QModbusDataUnit MasterModbus::writeRequest(int startAddress, quint16 numberOfEntries) const
{
    const auto table = QModbusDataUnit::HoldingRegisters;

    return QModbusDataUnit(table, startAddress, numberOfEntries);
}
