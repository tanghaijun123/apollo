#include "alarm.h"
#include "cshellprocess.h"

Alarm::Alarm(QObject *parent) : QObject(parent)
{
    AlarmItem* item;
    item = new AlarmItem(AlarmItem::eAlarmSystemError, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmSystemError, item);

    item = new AlarmItem(AlarmItem::eAlarmMotorDisconnected, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmMotorDisconnected, item);

    item = new AlarmItem(AlarmItem::eAlarmMotorFailure, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmMotorFailure, item);

    item = new AlarmItem(AlarmItem::eAlarmMotorTempHigh, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmMotorTempHigh, item);

    item = new AlarmItem(AlarmItem::eAlarmMotorStoped, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmMotorStoped, item);

    item = new AlarmItem(AlarmItem::eAlarmPumpUninstalled, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmPumpUninstalled, item);

    item = new AlarmItem(AlarmItem::eAlarmMotorCurrentHigh, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmMotorCurrentHigh, item);

    item = new AlarmItem(AlarmItem::eAlarmSystemError, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmSystemError, item);

    item = new AlarmItem(AlarmItem::eAlarmSpeedHigh, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmSpeedHigh, item);

    item = new AlarmItem(AlarmItem::eAlarmSpeedLow, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmSpeedLow, item);

    item = new AlarmItem(AlarmItem::eAlarmFlowSensorDisconnected, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmFlowSensorDisconnected, item);

    item = new AlarmItem(AlarmItem::eAlarmFlowSensorFailure, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmFlowSensorFailure, item);

    item = new AlarmItem(AlarmItem::eAlarmFlowHigh, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmFlowHigh, item);

    item = new AlarmItem(AlarmItem::eAlarmBatteryEmpty, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmBatteryEmpty, item);

    item = new AlarmItem(AlarmItem::eAlarmBatteryLow, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmBatteryLow, item);

    item = new AlarmItem(AlarmItem::eAlarmBatteryPowered, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmBatteryPowered, item);

    item = new AlarmItem(AlarmItem::eAlarmBatteryNotFound, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmBatteryNotFound, item);

    item = new AlarmItem(AlarmItem::eAlarmBatteryTempHigh, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmBatteryTempHigh, item);

    item = new AlarmItem(AlarmItem::eAlarmBatteryChargeFailed, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmBatteryChargeFailed, item);

    item = new AlarmItem(AlarmItem::eAlarmBatteryNeedMaintenance, AlarmItem::ePriorityHigh, 0);
    m_AlarmMap.insert(AlarmItem::eAlarmBatteryNeedMaintenance, item);

}

static bool sort(AlarmItem *alarm1, AlarmItem *alarm2)
{
    return alarm1->priority() > alarm2->priority();
}

void Alarm::addAlarm(AlarmItem::emAlarmId id)
{
    AlarmItem *item = m_AlarmMap[id];
    m_currentAlarmList.append(item);

    qSort(m_currentAlarmList.begin(), m_currentAlarmList.end(), sort);
}

void Alarm::delAlarm(AlarmItem::emAlarmId id)
{
    for(int i = 0; i < m_currentAlarmList.size(); i++)
    {
        AlarmItem *item = m_currentAlarmList.at(i);
        if(item->alarmId() == id) {
            m_currentAlarmList.removeAt(i);
            break;
        }
    }
}

AlarmItem::emAlarmPriority Alarm::getHighestAlarmPriority()
{
    AlarmItem *item = m_currentAlarmList.at(0);
    return item->priority();
}

void Alarm::playHighAlarmSound()
{
    CShellProcess::playSound("");
}

void Alarm::playLowAlarmSound()
{
    CShellProcess::playSound("");
}

void Alarm::setLedHigh()
{
    CShellProcess::playSound("");
}

void Alarm::setLedLow()
{
    CShellProcess::playSound("");
}

bool Alarm::isAlarmExist()
{

}
