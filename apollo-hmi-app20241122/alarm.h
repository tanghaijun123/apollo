/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : alarm.h
  Version       : 1.0
  Author        : han
  Created       : 2024-08-12
  Last Modified :
  Description   :  header file
  Function List :
  History       :
  1.Date        : 2024-08-12
    Author      : fensnote
    Modification: Created file

******************************************************************************/

#ifndef ALARM_H
#define ALARM_H

#include <QObject>
#include <QMap>
#include <QDateTime>


class AlarmItem
{


public:
    /**
     * @brief The emAlarmPriority enum  报警等级
     */
    enum emAlarmPriority{
        ePriorityLow,
        ePriorityHigh,
    };

    /**
     * @brief The emAlarmId enum 报警类型
     */
    enum emAlarmId{
        eAlarmSystemError = 0,
        eAlarmMotorDisconnected = 1,
        eAlarmMotorFailure = 2,
        eAlarmMotorTempHigh = 3,
        eAlarmMotorStoped = 4,
        eAlarmPumpUninstalled = 5,
        eAlarmMotorCurrentHigh = 6,
        eAlarmSpeedHigh = 7,
        eAlarmSpeedLow = 8,
        eAlarmFlowSensorDisconnected = 9,
        eAlarmFlowSensorFailure = 10,
        eAlarmFlowHigh = 11,
        eAlarmFlowLow = 12,
        eAlarmBatteryEmpty = 13,
        eAlarmBatteryLow = 14,
        eAlarmBatteryPowered = 15,
        eAlarmBatteryNotFound = 16,
        eAlarmBatteryTempHigh = 17,
        eAlarmBatteryChargeFailed = 18,
        eAlarmBatteryNeedMaintenance = 19,
        eAlarmMaxId,
    };

    /**
     * @brief m_dateTime
     */
    QDateTime       m_dateTime;
    /**
     * @brief m_priority
     */
    emAlarmPriority m_priority;
    /**
     * @brief m_id
     */
    emAlarmId       m_id;
    /**
     * @brief m_keepTime
     */
    int             m_keepTime;

    /**
     * @brief AlarmItem
     * @param id
     * @param priority
     * @param keepTime
     */
    AlarmItem(AlarmItem::emAlarmId id, emAlarmPriority priority, int keepTime)
    {
        m_id = id;
        m_priority = priority;
        m_keepTime = keepTime;
    }

    /**
     * @brief priority
     * @return
     */
    emAlarmPriority priority() { return m_priority; }

    /**
     * @brief alarmId
     * @return
     */
    emAlarmId       alarmId()  { return m_id; }

    /**
     * @brief dateTime
     * @return
     */
    QDateTime       dateTime()  { return m_dateTime; }
};

/**
 * @brief The Alarm class
 */
class Alarm : public QObject
{
    Q_OBJECT

public:

    /**
     * @brief conStrAlarmSystemError
     */
    QString conStrAlarmSystemError {"eAlarmSystemError"};

    /**
     * @brief conStrAlarmMotorDisconnected
     */
    QString conStrAlarmMotorDisconnected {"eAlarmMotorDisconnected"};

    /**
     * @brief conStrAlarmMotorFailure
     */
    QString conStrAlarmMotorFailure {"eAlarmMotorFailure"};

    /**
     * @brief conStrAlarmMotorTempHigh
     */
    QString conStrAlarmMotorTempHigh {"eAlarmMotorTempHigh"};

    /**
     * @brief conStrAlarmMotorStoped
     */
    QString conStrAlarmMotorStoped {"eAlarmMotorStoped"};

    /**
     * @brief conStrAlarmPumpUninstalled
     */
    QString conStrAlarmPumpUninstalled {"eAlarmPumpUninstalled"};

    /**
     * @brief conStrAlarmMotorCurrentHigh
     */
    QString conStrAlarmMotorCurrentHigh {"eAlarmMotorCurrentHigh"};

    /**
     * @brief conStrAlarmSpeedHigh
     */
    QString conStrAlarmSpeedHigh {"eAlarmSpeedHigh"};

    /**
     * @brief conStrAlarmSpeedLow
     */
    QString conStrAlarmSpeedLow {"eAlarmSpeedLow"};

    /**
     * @brief conStrAlarmFlowSensorDisconnected
     */
    QString conStrAlarmFlowSensorDisconnected {"eAlarmFlowSensorDisconnected"};

    /**
     * @brief conStrAlarmFlowSensorFailure
     */
    QString conStrAlarmFlowSensorFailure {"eAlarmFlowSensorFailure"};

    /**
     * @brief conStrAlarmFlowHigh
     */
    QString conStrAlarmFlowHigh {"eAlarmFlowHigh"};

    /**
     * @brief conStrAlarmFlowLow
     */
    QString conStrAlarmFlowLow {"eAlarmFlowLow"};

    /**
     * @brief conStrAlarmBatteryEmpty
     */
    QString conStrAlarmBatteryEmpty {"eAlarmBatteryEmpty"};

    /**
     * @brief conStrAlarmBatteryLow
     */
    QString conStrAlarmBatteryLow {"eAlarmBatteryLow"};

    /**
     * @brief conStrAlarmBatteryPowered
     */
    QString conStrAlarmBatteryPowered {"eAlarmBatteryPowered"};

    /**
     * @brief conStrAlarmBatteryNotFound
     */
    QString conStrAlarmBatteryNotFound {"eAlarmBatteryNotFound"};

    /**
     * @brief conStrAlarmTempHigh
     */
    QString conStrAlarmTempHigh {"eAlarmBatteryTempHigh"};

    /**
     * @brief conStrAlarmBatteryChargeFailed
     */
    QString conStrAlarmBatteryChargeFailed {"eAlarmBatteryChargeFailed"};

    /**
     * @brief conStrAlarmBatteryNeedMaintenance
     */
    QString conStrAlarmBatteryNeedMaintenance {"eAlarmBatteryNeedMaintenance"};


    /**
     * @brief Alarm
     * @param parent
     */
    explicit Alarm(QObject *parent = 0);

    /**
     * @brief addAlarm
     * @param id
     */
    void addAlarm(AlarmItem::emAlarmId id);

    /**
     * @brief delAlarm
     * @param id
     */
    void delAlarm(AlarmItem::emAlarmId id);

    /**
     * @brief getHighestAlarmPriority
     * @return
     */
    AlarmItem::emAlarmPriority getHighestAlarmPriority();

    /**
     * @brief playHighAlarmSound
     */
    void playHighAlarmSound();

    /**
     * @brief playLowAlarmSound
     */
    void playLowAlarmSound();

    /**
     * @brief setLedHigh
     */
    void setLedHigh();

    /**
     * @brief setLedLow
     */
    void setLedLow();

    /**
     * @brief isAlarmExist
     * @return
     */
    bool isAlarmExist();
signals:

public slots:

private:
    QMap<AlarmItem::emAlarmId, AlarmItem*> m_AlarmMap;
    QList<AlarmItem*> m_currentAlarmList;
};

#endif // ALARM_H
