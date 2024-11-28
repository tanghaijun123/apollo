#ifndef ROTARYENCODER_H
#define ROTARYENCODER_H
#include <QThread>
#include <QMutex>
#include <QMutexLocker>

class RotaryEncoder : public QThread
{
    Q_OBJECT
public:
    RotaryEncoder();
    Q_INVOKABLE void closeThread();
protected:
    void run();
private:
    QMutex m_Mutex;
    bool m_bRunning{true};
signals:
    void updateRoratyEncode(int rotaryEncoder, int step);
private:
    int m_rotaryEncoder;
};

#endif // ROTARYENCODER_H
