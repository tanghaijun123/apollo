/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : crunningtestopt.h
  Version       : 1.0
  Author        : han
  Created       : 2024-08-13
  Last Modified :
  Description   :  header file
  Function List :
  History       :
  1.Date        : 2024-08-13
    Author      : fensnote
    Modification: Created file

******************************************************************************/

#ifndef CRUNNINGTESTMANAGER_H
#define CRUNNINGTESTMANAGER_H

#include <QObject>
#include <QTimerEvent>
#include <QThread>
#include <QMutex>
#include <QDateTime>
#include "csettingdbopt.h"
#include "crunningtestopt.h"
#include "../cwarningsoundworder.h"
#ifdef __arm__
#include "led.h"
#endif

/**
 * @brief The CRunningTestManager class 运行管理类，用于管理当前CRunningTestOpt类运行及与主线程通信
 */
class CRunningTestManager : public QObject
{
    Q_OBJECT
public:
    explicit CRunningTestManager(CDatabaseManage *pDB, QObject *parent = nullptr);
    ~CRunningTestManager();
signals:
    //start new process=================
    /**
     * @brief processNoCloseRunning 转换处理没有正常结束的任务
     */
    void processNoCloseRunning();

    /**
     * @brief startRunning 转换开始测试任务消息
     */
    void startRunning();

    /**
     * @brief stopRunning转换结束测试任务消息
     */
    void stopRunning();

    /**
     * @brief receiveAction 转换收到动作消息
     * @param strActionName 动作名称
     * @param strParams 动作参数
     */
    void receiveAction(QString strActionName, QString strParams);

    /**
     * @brief updateFlowValueRange 转换流量范围消息
     * @param dLower 最小流量
     * @param dHigher 最大流量
     */
    void updateFlowValueRange(double dLower, double dHigher);

    /**
     * @brief updateMotorSpeedRange 转换电机转速参数
     * @param dLower 最小转速
     * @param dHigher 最大转速
     */
    void updateMotorSpeedRange(double dLower, double dHigher);

    /**
     * @brief updateCurFlowValue 转换实时流量数据
     * @param dValue 流量数据
     */
    void updateCurFlowValue(double dValue);

    /**
     * @brief updateCurMotorSpeed 转换电机转速
     * @param icurMotorSpeed 实时转速
     */
    void updateCurMotorSpeed(int icurMotorSpeed);

    /**
     * @brief reciveWarning 转换外部触发的报警信息
     * @param strWarningName 需要添加的报警信息
     * @param strRemoveWarningName 需要移除的报警信息
     */
    void reciveWarning(QString strWarningName, QString strRemoveWarningName);

    /**
     * @brief removeWarning 转换移除报警信息
     * @param strWarningName 报警名称
     */
    void removeWarning(QString strWarningName);

    /**
     * @brief appendWarningShow转换添加UI的报警信息
     * @param strWarningName 报警名称
     * @param iWarningType 报警类型
     * @param strWarningTitle 报警标题
     */
    void appendWarningShow(QString strWarningName, int iWarningType, QString strWarningTitle);

    /**
     * @brief removeWarningShow 转换移除报警信息
     * @param strWarningName 报警信息名称
     */
    void removeWarningShow(QString strWarningName);

    /**
     * @brief minWaringTypeInRunning 转换最小类型的报警类型，用于显示的背景颜色
     * @param iMinWaringType 报警类型
     */
    void minWaringTypeInRunning(int iMinWaringType, bool bNew);

    /**
     * @brief maxOrMinValueChanged 转换最值参数到UI
     * @param dMinFlowVolume
     * @param dMaxFlowVolume
     * @param iMinSpeedValue
     * @param iMaxSpeedValue
     * @param dAvgFlowVolume
     * @param iAvgSpeedValue
     */
    void maxOrMinValueChanged(double dMinFlowVolume, double dMaxFlowVolume, int iMinSpeedValue, int iMaxSpeedValue, double dAvgFlowVolume, int iAvgSpeedValue);

    /**
     * @brief updateTesingData 转换测试线程中的更新测试数据消息到UI
     * @param dMinFlowVolume
     * @param dMaxFlowVolume
     * @param iMinSpeedValue
     * @param iMaxSpeedValue
     * @param dAvgFlowVolume
     * @param iAvgSpeedValue
     */
    void updateTesingData(QDateTime dt, double dCurFlowValue, int iCurMotorSpeed, double dMinFlowVolume, double dMaxFlowVolume, int iMinSpeedValue, int iMaxSpeedValue, double dAvgFlowVolume, int iAvgSpeedValue);

    /**
     * @brief needMaxOrMinValue 更新UI需要最值参数到测试线程
     */
    void needMaxOrMinValue();

    /**
     * @brief upateCurParamToDB 主程序调用写入当前数据到数据库
     */
    void upateCurParamToDB();

    /**
     * @brief updateCurParamToDBDone 工作线程回复写实时数据到数据库完成
     */
    void updateCurParamToDBDone();
signals:

    /**
     * @brief clearWarnings 清空报警消息
     */
    void clearWarnings(bool onStop);
public:
    //check if have warning
    /**
     * @brief sthaveWarning 静态检查是否有报警信息
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    static bool sthaveWarning();
    //check if have warning, qml used

    /**
     * @brief haveWarning 主任务检查是否有报警信息
     * @return 返回是否有报警信息
     */
    Q_INVOKABLE bool haveWarning();

    /**
     * @brief isWarningExist 查询是否列表中存在报警信息
     * @param strWarningName 报警名称
     * @return 返回报警是否存在
     */
    Q_INVOKABLE bool isWarningExist(QString strWarningName);

    /**
     * @brief isWarningCanMuted 检查报警是否可以静音
     * @return  返回是否可以静音
     */
    Q_INVOKABLE bool isWarningCanMuted();

    /**
     * @brief canStartMotorUnderWarning 判断是否可以在有报警时开始测试任务
     * @return 返回是否可以开始测试任务
     */
    Q_INVOKABLE bool canStartMotorUnderWarning();

    /**
     * @brief isSIMULATION 判断是否为模拟方式
     * @return 返回是否模拟方式
     */
    Q_INVOKABLE bool isSIMULATION();

    /**
     * @brief isRunning 判断当前任务是否正在测试
     * @return 返回是否正在测试
     */
    Q_INVOKABLE bool isRunning();

    /**
     * @brief haveNocloseRecord
     * @return
     */
    Q_INVOKABLE bool haveNocloseRecord();
public slots:

    /**
     * @brief onStartRunning 更新管理类的运行状态
     */
    void onStartRunning();

    /**
     * @brief onStopRunning 更新运行状态
     */
    void onStopRunning();

    //void onWarnningStatus(bool bHaveWarning);
    /**
     * @brief onMinWaringTypeInRunning 运行中最小报警类型
     * @param iMinWaringType报警类型
     */
    void onMinWaringTypeInRunning(int iMinWaringType, bool bNew);
private:
    /**
     * @brief m_pRunningTestWorking
     */
    CRunningTestOpt *m_pRunningTestWorking{Q_NULLPTR};

    /**
     * @brief m_pThead
     */
    QThread *m_pThead{Q_NULLPTR};

    /**
     * @brief m_bStarted
     */
    bool m_bStarted{false};

    /**
     * @brief m_bHaveWarning
     */
    bool m_bHaveWarning{false};

    /**
     * @brief m_curWaringType
     */
    CRunningTestOpt::emWaringType m_curWaringType{CRunningTestOpt::wtNoWaring};

public slots:
    /**
     * @brief onSyncWaringList
     * @param list
     */
    void onSyncWaringList(QList<QString> *list);
private:

    /**
     * @brief m_strWarinngs
     */
    QList<QString> m_strWarinngs;

    /**
     * @brief m_mtxWarnings
     */
    QMutex m_mtxWarnings;

    /**
     * @brief addWarings 按测试任务添加报警信息列表
     * @param list
     */
    void addWarings(QList<QString> &list);

signals:

    /**
     * @brief pauseSound 转换或由主线程调用停止播放声音消息
     */
    void pauseSound();

    /**
     * @brief playSound 转换或由主线程调用播放声音消息
     */
    void playSound();

    /**
     * @brief volumeChanged 由主线程调用调速音量消息
     * @param iVolume 音量消息
     */
    void volumeChanged(int iVolume);

    /**
     * @brief playKeySound 由主线程调用播放按钮声音
     */
    void playKeySound();

    /**
     * @brief pauseRunning 转换停止测试状态
     * @param bPaused
     */
    void pauseRunning(bool bPaused);
signals:

private:
    /**
     * @brief m_pWarningSoundWorker
     */
    CWarningSoundWorker *m_pWarningSoundWorker{Q_NULLPTR};

    /**
     * @brief m_pWarningSoundThead
     */
    QThread *m_pWarningSoundThead;

private:
#ifdef __arm__
    Led *m_led{Q_NULLPTR};
#endif
signals:
    /**
     * @brief curRunningStatus 转换由工作线程处理的
     * @param bRunnig 测试状态
     */
    void curRunningStatus(bool bRunnig);
public slots:
    /**
     * @brief onCurRunningIDChanged 当前测试任务序号修改后处理
     * @param iCurRunningID 当前运行的测试任务ID
     */
    void onCurRunningIDChanged(int iCurRunningID);
public:
    /**
     * @brief getCurRunningTestID 主线程查询测试任务ID
     * @return 返回任务ID
     */
    Q_INVOKABLE int getCurRunningTestID();

    /**
     * @brief stGetCurRunningTestID 静态查询测试任务ID
     * @return 返回任务ID
     */
    Q_INVOKABLE static int stGetCurRunningTestID();
private:
    /**
     * @brief m_iCurRunningID
     */
    int m_iCurRunningID{0};
    CDatabaseManage *m_pDB{Q_NULLPTR};
};

extern CRunningTestManager* glb_RunningTestManager;

#endif // CRUNNINGTESTMANAGER_H
