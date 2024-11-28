/******************************************************************************/
/*! @File        : uartport.cpp
 *  @Brief       : 串口通信基本接口
 *  @Details     : 详细说明
 *  @Author      : han
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

#include <QMessageBox>
#include <QFile>
#include <QApplication>
#include <QSerialPortInfo>
#include <QPainter>
#include <QFileInfo>
#include "uartport.h"

//#define MODBUS_LOW_LEVEL_DEBUG              1

static const char blankString[] = QT_TRANSLATE_NOOP("SettingsDialog", "N/A");

#define MODBUS_WRITE_HOLDING_REGISTER   06
#define MODBUS_READ_HOLDING_REGISTER    03

uint16_t GetModbusCRC16_Cal(uint8_t *data, uint32_t len)
{
    uint8_t temp;
    uint16_t wcrc = 0XFFFF;//16位crc寄存器预置
    uint32_t i = 0, j = 0;//计数
    for (i = 0; i < len; i++)//循环计算每个数据
    {
        temp = (*(data +i)) & 0xFF;//将八位数据与crc寄存器亦或
        wcrc ^= temp;						//将数据存入crc寄存器
        for (j = 0; j < 8; j++)	//循环计算数据的
        {
            if (wcrc & 0X0001)//判断右移出的是不是1，如果是1则与多项式进行异或。
            {
                wcrc >>= 1;//先将数据右移一位
                wcrc ^= 0XA001;//与上面的多项式进行异或
            }
            else//如果不是1，则直接移出
            {
                wcrc >>= 1;//直接移出
            }
        }
    }

    return ((wcrc << 8) | (wcrc >> 8));//高低位置换
}


UartPort::UartPort(QObject *parent)
    : QThread(parent), m_serial(new QSerialPort(this))
{
    connect(m_serial, &QSerialPort::errorOccurred, this, &UartPort::handleError);

    connect(m_serial, &QSerialPort::readyRead, this, &UartPort::readData);

    m_recv_timer = new QTimer(this);
    m_recv_timeout = new QTimer(this);
    connect(m_recv_timer, &QTimer::timeout, this, &UartPort::readDataCompleted);
    connect(m_recv_timeout, &QTimer::timeout, this, &UartPort::readDataCompleted);

    m_recv_data.clear();
    m_uart_port_err = UartPort::UartNoErr;
}

void UartPort::handleError(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::ResourceError) {
        m_uart_port_err = UartPort::UartNotOpen;
        closePort();
    }
}


QStringList UartPort::portList()
{
    QString description;
    QString manufacturer;
    QString serialNumber;
    QStringList  portList;
    const auto infos = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &info : infos) {
        QStringList list;
        description = info.description();
        manufacturer = info.manufacturer();
        serialNumber = info.serialNumber();
        list << info.portName()
             << (!description.isEmpty() ? description : blankString)
             << (!manufacturer.isEmpty() ? manufacturer : blankString)
             << (!serialNumber.isEmpty() ? serialNumber : blankString)
             << info.systemLocation()
             << (info.vendorIdentifier() ? QString::number(info.vendorIdentifier(), 16) : blankString)
             << (info.productIdentifier() ? QString::number(info.productIdentifier(), 16) : blankString);

        qInfo() << "portName: " << info.portName();
        portList << info.portName();
    }

    return portList;
}

QString UartPort::openPort(QString name, qint32 baudRate, QSerialPort::DataBits dataBits, QSerialPort::Parity parity,
                    QSerialPort::StopBits stopBits, QSerialPort::FlowControl flowControl)
{
    m_serial->setPortName(name);
    m_serial->setBaudRate(baudRate);
    m_serial->setDataBits(dataBits);
    m_serial->setParity(parity);
    m_serial->setStopBits(stopBits);
    m_serial->setFlowControl(flowControl);

    if (m_serial->open(QIODevice::ReadWrite)) {
        m_serial->setDataTerminalReady(true);
        return "OK";
    } else {
        m_uart_port_err = UartNotOpen;
        return m_serial->errorString();
    }
}

QString UartPort::openPort(QString port, qint32 baudRate)
{
    QString name = port;
    QSerialPort::DataBits dataBits = QSerialPort::Data8;
    QSerialPort::Parity parity = QSerialPort::NoParity;
    QSerialPort::StopBits stopBits = QSerialPort::OneStop;
    QSerialPort::FlowControl flowControl = QSerialPort::NoFlowControl;

    m_serial->setPortName(name);
    m_serial->setBaudRate(baudRate);
    m_serial->setDataBits(dataBits);
    m_serial->setParity(parity);
    m_serial->setStopBits(stopBits);
    m_serial->setFlowControl(flowControl);

    if (m_serial->open(QIODevice::ReadWrite)) {
        m_serial->setDataTerminalReady(true);
        return "OK";
    } else {
        m_uart_port_err = UartNotOpen;
        return m_serial->errorString();
    }
}

bool UartPort::isPortOpen()
{
    return m_serial->isOpen();
}

void UartPort::closePort()
{
    if (m_serial->isOpen())
        m_serial->close();
}

UartPort::emUartPortErr UartPort::writeData(const QByteArray &data)
{
    QByteArray ba;
    ba = data;
#ifdef MODBUS_LOW_LEVEL_DEBUG
    qInfo() << m_serial->portName() << "UART SEND:" << ba.toHex();
#endif

    if(m_serial->isOpen())
    {
        m_serial->write(ba);
        m_recv_flag = false;
        if(MODBUS_READ_HOLDING_REGISTER == ba[1]) {
            m_recv_timeout->start(MSG_RECV_TIMEOUT);
        }
        return UartPort::UartNoErr;
    } else {
        m_uart_port_err = UartNotOpen;
        return UartPort::UartNotOpen;
    }
}

void UartPort::readData()
{
    m_recv_data.append(m_serial->readAll());
    m_recv_flag = true;
    m_recv_timeout->stop();
    m_recv_timer->start(MSG_BLE_RECV_DELAY);
}

void UartPort::readDataCompleted()
{
    m_recv_timer->stop();
    m_recv_timeout->stop();
#ifdef MODBUS_LOW_LEVEL_DEBUG
    qInfo() << m_serial->portName() << "UART RECV:" << m_recv_data.toHex();
#endif

    if(m_recv_flag)
    {
        quint8* p_data = (quint8* )m_recv_data.data();
        quint8 hostAddress = p_data[0];
        quint8 functionCode = p_data[1];
        quint8 length = p_data[2];
        if(m_recv_data.length() == 5 + length) // length of hostAddress/function/number/crc16 = 5
        {
            quint16 crc16 = (quint16)p_data[3+length] << 8 | p_data[4+length];
            quint16 cal_crc16 = GetModbusCRC16_Cal((uint8_t *)m_recv_data.data(), m_recv_data.length()-2);

            if(crc16 == cal_crc16)
            {
                if(functionCode == MODBUS_READ_HOLDING_REGISTER) {
                    if(m_uart_port_err != UartPort::UartNoErr)
                    {
                        m_uart_port_err = UartPort::UartNoErr;
                        emit sendErr(UartPort::UartNoErr);
                    }

                    emit sendRecvMsg(m_recv_data.mid(3, length));
                } else {
                    m_uart_port_err = UartPort::UartDataErr;
#ifdef MODBUS_LOW_LEVEL_DEBUG
                    qInfo("readDataCompleted functionCode, %x" , functionCode);
#endif
                }
            } else {
                m_uart_port_err = UartPort::UartDataErr;
#ifdef MODBUS_LOW_LEVEL_DEBUG
                qInfo("readDataCompleted crc error, %x, %x" , crc16 ,cal_crc16);
#endif
            }
        }
    } else {
#ifdef MODBUS_LOW_LEVEL_DEBUG
        qInfo() << __FILE__ <<" " << __LINE__ << "readDataCompleted receive none" ;
#endif
        m_uart_port_err = UartPort::UartReadTimeout;
        emit sendErr(UartPort::UartReadTimeout);
    }


    m_recv_data.clear();
}

QByteArray UartPort::packWriteHoldingRegister(qint16 serverAddress, qint16 startAddress, quint16 value)
{
    QByteArray ba;
    ba.append(serverAddress);
    ba.append(MODBUS_WRITE_HOLDING_REGISTER);
    ba.append((startAddress & 0xff00) >> 8);
    ba.append((startAddress & 0xff));

    ba.append((value & 0xff00) >> 8);
    ba.append((value & 0xff));

    quint16 crc16 = (quint16)GetModbusCRC16_Cal((uint8_t *)ba.data(), ba.length());

    ba.append((crc16 & 0xff00) >> 8);
    ba.append((crc16 & 0xff));

    return ba;
}

QByteArray UartPort::packReadHoldingRegister(qint16 serverAddress, qint16 startAddress, quint16 number)
{
    QByteArray ba;
    ba.append(serverAddress);
    ba.append(MODBUS_READ_HOLDING_REGISTER);
    ba.append((startAddress & 0xff00) >> 8);
    ba.append((startAddress & 0xff));

    ba.append((number & 0xff00) >> 8);
    ba.append((number & 0xff));

    quint16 crc16 = GetModbusCRC16_Cal((uint8_t *)ba.data(), ba.length());

    ba.append((crc16 & 0xff00) >> 8);
    ba.append((crc16 & 0xff));
    return ba;
}

UartPort::emUartPortErr UartPort::getPortErr()
{
    return m_uart_port_err;
}
