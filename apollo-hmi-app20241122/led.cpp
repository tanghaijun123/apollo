/******************************************************************************/
/*! @File        : motor.cpp
 *  @Brief       : LED灯报警显示
 *  @Details     : 详细说明
 *  @Author      : kevin
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


#include <sys/file.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/input.h>
#include <string.h>
#include <QDebug>
#include <QMutexLocker>
#include "led.h"

#define RLED_DEV_PATH "/sys/class/leds/led4/brightness"
#define YLED_DEV_PATH "/sys/class/leds/led5/brightness"

//Red led on 400
//Red led off 600

//#define LED_DEBUG       1

Led::Led()
{

}

Led::~Led()
{

}

void Led::onSetLedPriority(int priority, bool bNew)
{
    qInfo() << "Led::setCurLedPriority" << priority;
    QMutexLocker locker(&m_mutex);
    m_alarmPrority = (LedPriority_t)priority;
}

void Led::onSetLedState(bool bOn)
{
    setCurLedState(bOn);
}

void Led::onLedOn()
{
    onSetLedState(true);
}

void Led::onLedOff()
{
    onSetLedState(false);
}

void Led::setCurLedPriority(int priority)
{
    qInfo() << "Led::setCurLedPriority" << priority;
    if(m_alarmPrority == priority)
        return;

    QMutexLocker locker(&m_mutex);
    m_alarmPrority = (LedPriority_t)priority;
}

void Led::setCurLedState(bool bOn)
{
    QMutexLocker locker(&m_mutex);
    m_ledState =  bOn ? eLED_ON : eLED_OFF;
}

Led::LedPriority_t Led::getCurLedPriority()
{
    Led::LedPriority_t curPriority = eLED_None;

    QMutexLocker locker(&m_mutex);
    curPriority = m_alarmPrority;

    return curPriority;
}

Led::LedState_t Led::getCurLedState()
{
    Led::LedState_t curState = eLED_OFF;
    {
        QMutexLocker locker(&m_mutex);
        curState = m_ledState;
    }
    return curState;
}

void Led::stop()
{
    m_bRunning = false;
}

void Led::setRedLedStatus(bool b)
{
    FILE *r_fd = NULL;

    r_fd = fopen(RLED_DEV_PATH, "w");
    if(r_fd == NULL){
        qDebug("Fail to Open %s device\n", RLED_DEV_PATH);
        return ;
    }

    if(b)
    {
        fwrite("1",1,1,r_fd);
    } else {
        fwrite("0",1,1,r_fd);
    }

    fclose(r_fd);
}

void Led::setYelLedStatus(bool b)
{
    FILE *y_fd = NULL;

    y_fd = fopen(YLED_DEV_PATH, "w");
    if(y_fd == NULL){
        qDebug("Fail to Open %s device\n", YLED_DEV_PATH);
        return ;
    }

    if(b)
    {
        fwrite("1",1,1,y_fd);
    } else {
        fwrite("0",1,1,y_fd);
    }

    fclose(y_fd);
}

void Led::run()
{
    setRedLedStatus(true);
    QThread::msleep(500);
    setRedLedStatus(false);
    QThread::msleep(500);
    setYelLedStatus(true);
    QThread::msleep(500);
    setYelLedStatus(false);
    QThread::msleep(500);

    while(m_bRunning) {
        LedPriority_t curPrority =  getCurLedPriority();
#ifdef LED_DEBUG
        qInfo() << "curPrority" << curPrority;
#endif
        if(curPrority == eLED_High)
        {
            //黄灯灭
            setYelLedStatus(false);

            //红灯亮
            setRedLedStatus(true);
#ifdef LED_DEBUG
            qInfo() << "Led thread" << "eLED_on";
#endif
            QThread::msleep(400);

            //红灯灭
            setRedLedStatus(false);
#ifdef LED_DEBUG
            qInfo() << "Led thread" << "eLED_off";
#endif
            QThread::msleep(600);

#ifdef LED_DEBUG
            qInfo() << "Led thread" << "eLED_High";
#endif
        }
        else if(curPrority == eLED_Median)
        {
            //红灯灭
            setRedLedStatus(false);

            //黄灯亮
            setYelLedStatus(true);
#ifdef LED_DEBUG
            qInfo() << "Led thread" << "eLED_on";
#endif
            QThread::msleep(400);

            //黄灯灭
            setYelLedStatus(false);
#ifdef LED_DEBUG
            qInfo() << "Led thread" << "eLED_off";
#endif
            QThread::msleep(600);

#ifdef LED_DEBUG
            qInfo() << "Led thread" << "eLED_Median";
#endif
        }
        else if(curPrority == eLED_Low)
        {
            //红灯灭
            setRedLedStatus(false);

            //黄灯亮
            setYelLedStatus(true);
#ifdef LED_DEBUG
            qInfo() << "Led thread" << "eLED_Low";
#endif
        }
        else if(curPrority == eLED_None)
        {
            //红灯灭
            setRedLedStatus(false);

            //黄灯灭
            setYelLedStatus(false);
            QThread::msleep(5000);
        }
        else{
            sleep(5000);
        }
    }
}
