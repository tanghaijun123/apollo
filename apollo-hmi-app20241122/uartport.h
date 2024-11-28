#ifndef UARTPORT_H
#define UARTPORT_H

#include <QObject>
#include <QObject>
#include <QTimer>
#include <QSerialPort>
#include <QDebug>
#include <QThread>

#define MSG_START_FLAG      (0xAA55)
#define MSG_BLE_RECV_DELAY  (50)
#define MSG_BLE_SEND_DELAY  (500)
#define MSG_RECV_TIMEOUT    300

class UartPort : public QThread
{
    Q_OBJECT

public:
    enum emUartPortErr{
        UartNoErr = 0,
        UartNotOpen = 1,
        UartWriteFailed ,
        UartReadTimeout,
        UartDataErr
    };
    explicit UartPort(QObject *parent = nullptr);
    static QStringList portList();
    QString openPort(QString name, qint32 baudRate, QSerialPort::DataBits dataBits, QSerialPort::Parity parity,
                        QSerialPort::StopBits stopBits, QSerialPort::FlowControl flowControl);
    QString openPort(QString port, qint32 baudRate);
    bool isPortOpen();
    void closePort();
    UartPort::emUartPortErr writeData(const QByteArray &data);

    QByteArray packWriteHoldingRegister(qint16 serverAddress, qint16 startAddress, quint16 value);
    QByteArray packReadHoldingRegister(qint16 serverAddress, qint16 startAddress, quint16 number);
    UartPort::emUartPortErr getPortErr();
public slots:
    void readData();
    void readDataCompleted();
    void handleError(QSerialPort::SerialPortError error);

signals:
    void sendRecvMsg(QByteArray msg);
    void sendErr(emUartPortErr err);

public:
    QSerialPort *m_serial = nullptr;

private:
    QByteArray m_recv_data;
    QTimer *m_recv_timer;
    QTimer *m_send_timer;
    QTimer *m_recv_timeout;
    bool    m_recv_flag;
    emUartPortErr m_uart_port_err{UartPort::UartNoErr};
};

#endif // UARTPORT_H
