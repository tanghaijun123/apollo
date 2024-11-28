#ifndef Led_H
#define Led_H
#include <QThread>
#include <QMutex>


class Led : public QThread
{
    Q_OBJECT
public:
    enum LedState_t {
        eLED_OFF = 0,
        eLED_ON = 1,
    } ;

    enum LedPriority_t {
        eLED_None = -1,
        eLED_High = 0,
        eLED_Median = 1,
        eLED_Low = 2,
    } ;

public:
    Led();
    ~Led();
signals:
public slots:
    void onSetLedPriority(int priority, bool bNew);
    void onSetLedState(bool bOn);
    void onLedOn();
    void onLedOff();
    void setRedLedStatus(bool b);
    void setYelLedStatus(bool b);
private:
   void setCurLedPriority(int priority);
   void setCurLedState(bool bOn);
   LedPriority_t getCurLedPriority();
   LedState_t getCurLedState();
public:
   void stop();
protected:
    void run();

private:
    LedPriority_t m_alarmPrority{eLED_None};
    LedState_t m_ledState{eLED_OFF};
    bool m_bRunning{true};
    QMutex m_mutex;
};

#endif // Led_H
