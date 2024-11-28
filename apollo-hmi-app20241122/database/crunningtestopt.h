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

#ifndef CRUNNINGTESTOPT_H
#define CRUNNINGTESTOPT_H

#include <QObject>
#include <QTimerEvent>
#include <QThread>
#include <QMutex>
#include <QDateTime>
#include "csettingdbopt.h"
#include "../cwarningsoundworder.h"
#ifdef __arm__
#include "led.h"
#endif

// 如果需要生成模拟曲线数据，取消下位注释，第一次生成28天，第二次生成56天，依次类推
//#define TEST_CREATE_DELTIAL_DATA

//运行测试流程，记录速度，流量、异常等
class CRunningTestOpt : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief The emRangeErr enum
     */
    enum emRangeErr{
        reLower = -1,  // 偏高
        reNormal = 0,  // 正常
        reHigher = 1   // 偏低
    };
    /**
     * @brief The emWaringType enum
     */
    enum emWaringType{
        wtNoWaring =-1, //正常
        wtWarningHigh = 0, //High
        wtWarningMedium = 1, //medium
        wtWarningLow = 2 // Reminder
    };

    /**
     * @brief The StWaring class 存放动态报警信息
     */
    struct StWaring{
        StWaring() {
            WaringType = 0;
            Muteable = 0;
            Latching = 0;
            WarningName = "";
            WarningTitle = "";
            WarningDateTime = QDateTime();
        }

        /**
         * @brief StWaring 生成报警类
         * @param iWaringType //报警类型
         * @param iMuteable //可静音
         * @param iLatching  //闩锁
         * @param strWarningName 报警名称
         * @param strWarningTitle 报警标题
         * @param dtWarningDateTime 报警时间
         */
        StWaring(int iWaringType, int iMuteable, int iLatching, QString strWarningName, QString strWarningTitle, QDateTime dtWarningDateTime);
        /**
         * @brief operator ==
         * @param newWarning
         * @return
         */
        bool operator==(const StWaring &newWarning) const;
        bool operator<(const StWaring &newWarning) const;
        int WaringType{wtWarningHigh};
        int Muteable{1};
        int Latching{0};
        QString WarningName{""};
        QString WarningTitle{""};
        QDateTime WarningDateTime{QDateTime::currentDateTime()};
    };

public:
    /**
     * @brief CRunningTestOpt
     * @param parent
     */
    explicit CRunningTestOpt(QObject *parent = nullptr);
    ~CRunningTestOpt();
public slots:
    void onInitDatas();
private:
    void freeDatas();
public:
    /**
     * @brief appendNewWarning 添加新的报警信息
     * @param strWarningName 报警名称
     * @param iWarningType 报警类型
     * @param strWarningTitle 报警标题
     * @param iMuteable 可以静音
     * @param iLatching 闩锁
     * @param itrigOnRun 触发还是由运行产生
     * @return
     */
    bool appendNewWarning(QString strWarningName, int iWarningType, QString strWarningTitle, int iMuteable, int iLatching, int itrigOnRun);

    /**
     * @brief findWaring 按报警名称查找报警信息
     * @param strWarningName 报警名称
     * @return
     */
    bool findWaring(QString strWarningName);

    /**
     * @brief removeWaring 移除报警信息
     * @param strWarningName 报警名称
     * @return
     */
    bool removeWaring(QString strWarningName);

    /**
     * @brief isWarningExist 报警信息是否存在
     * @param strWarningName 报警名称
     * @return
     */
    bool isWarningExist(QString strWarningName);

    /**
     * @brief isWarningCanMuted 报警可以静音
     * @return
     */
    bool isWarningCanMuted();

    /**
     * @brief canStartMotorUnderWarning 可以开始电机报警
     * @return
     */
    bool canStartMotorUnderWarning();
public:

signals:  //报警类信号

    /**
     * @brief appendWarningShow 添加报警信息到显示列表
     * @param strWarningName 报警名称
     * @param iWarningType 报警类型
     * @param strWarningTitle 报警标题
     */
    void appendWarningShow(QString strWarningName, int iWarningType, QString strWarningTitle);

    /**
     * @brief removeWarningShow 移除显示报警
     * @param strWarningName 报警名称
     */
    void removeWarningShow(QString strWarningName);

    /**
     * @brief minWaringTypeInRunning 返回最小的报警类型到界面
     * @param iMinWaringType 报警类型
     */
    void minWaringTypeInRunning(int iMinWaringType, bool bNew);

    /**
     * @brief syncWaringNames 同步报警名称列表
     * @param lwarnnings 报警名称列表
     */
    void syncWaringNames(QList<QString> *lwarnnings);
private:
    //waringtype, warings
    QList<StWaring> m_curWarings;
    /**
     * @brief getMinWaringTypeInList查找最小报警列表
     * @return
     */
    emWaringType getMinWaringTypeInList();
    /**
     * @brief updatesyncWaringNames
     */
    void updatesyncWaringNames();
public slots:

    /**
     * @brief onClearWarnings 执行清除报警信息的槽函数
     */
    void onClearWarnings(bool onStop);

    //start new process=================
    /**
     * @brief onProcessNoCloseRunning 处理没有正常关闭的测试任务
     */
    void onProcessNoCloseRunning();

    /**
     * @brief onStartRunning 开始新的测试任务
     */
    void onStartRunning();

    /**
     * @brief onStopRunning 结束当前测试任务
     */
    void onStopRunning();
//run process============================
private:
#define TESTING_RECORD_INTERVAL 30 * 1000
protected:
    /**
     * @brief timerEvent
     * @param event
     */
    void timerEvent(QTimerEvent *event);
private:

    /**
     * @brief startRunningTmr 开始任务后，定时保存测试数据
     */
    void startRunningTmr();

    /**
     * @brief stopRunningTmr 结束任务时，停止定时保存测试数据
     */
    void stopRunningTmr();

    /**
     * @brief onRunningProcessTimeOut 执行时定时保存测试数据
     */
    void onRunningProcessTimeOut(bool bByMain = false);

    /**
     * @brief m_hRunningTmr 测试任务定时器
     */
    int m_hRunningTmr{0};

    /**
     * @brief startCheckWarningTmr 开始定时检查报警信息定时器
     */
    void startCheckWarningTmr();

    /**
     * @brief stopCheckWarningTmr 结束检查报警信息定时器
     */
    void stopCheckWarningTmr();

    /**
     * @brief onCheckWarningTimeOut 报警检查报警信息操作
     */
    void onCheckWarningTimeOut();

    /**
     * @brief m_hCheckWarningTmr 报警信息检查定时器
     */
    int m_hCheckWarningTmr{0};

    /**
     * @brief createNewRunningRecord 创建新测试任务
     * @param iTestID 测试记录数据库ID
     * @param strDetailDataPath 详细数据目录
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int createNewRunningRecord(int &iTestID, QString &strDetailDataPath, bool &bIsNoCloseRecord);

    /**
     * @brief createNewPatient 创建患者信息
     * @param iPatientID 患者信息编号
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int createNewPatient(int &iPatientID);

    /**
     * @brief updatePatientToRunningRecord 更新测试信息中患者数据库编号
     * @param iTestID 测试数据库编号
     * @param iPatientID 患者数据数据库ID
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int updatePatientToRunningRecord(int iTestID, int iPatientID);

    int addInvalidDataToDetail(int iTestID, QString strDetailDataPath);

    /**
     * @brief updateRunningStartToDB 更新开始状态到测试数据记录
     * @param iTestID 测试数据库编号
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int updateRunningStartToDB(int iTestID);

    /**
     * @brief createNewRunningDetail 创建测试实时数据记录
     * @param iTestID 测试数据库编号
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int createNewRunningDetail(int iTestID);

    /**
     * @brief saveRunningDetailParams 保存当前的电机转速或流量参数到数据库
     * @param dt 更新时间
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int saveRunningDetailParams(QDateTime dt = QDateTime::currentDateTime());

    /**
     * @brief processRunning 处理实时测试流程，保存实时参数，及统计数据
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int processRunning(bool bByMain);

    /**
     * @brief updateRunningDone 更新测试完成状态到数据库
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int updateRunningDone();

    /**
     * @brief getStatisticData 更新统计数据到数据库
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getStatisticData();

    /**
     * @brief m_iCurRunningID
     */
    int m_iCurRunningID{0};

    /**
     * @brief m_bWaitMotorChangeSpeed
     */
    //bool m_bWaitMotorChangeSpeed{true};

    /**
     * @brief m_strDetailDataPath
     */
    QString m_strDetailDataPath{""};

    /**
     * @brief m_bCanReportWaring
     */
    bool m_bCanReportWaring{false};

private:
#ifdef TEST_CREATE_DELTIAL_DATA
    void createSimulaData();
#endif
signals:
    /**
     * @brief curRunningIDChanged
     * @param iCurRunningID
     */
    void curRunningIDChanged(int iCurRunningID);

public slots:
    /**
     * @brief onReceiveAction
     * @param strActionName
     * @param strParams
     */
    void onReceiveAction(QString strActionName, QString strParams);
//ranges checker========================
private:
    /**
     * @brief loadRange 加载电机转速及流程的参数。
     * @return
     */
    int loadRange();

//flow value=========================
signals:
   // void warnningStatus(bool bHave);
public slots:
    /**
     * @brief onUpdateFlowValueRange 处理更新流量参数的槽函数
     * @param dLower 最大流量
     * @param dHigher 最小流量
     */
    void onUpdateFlowValueRange(double dLower, double dHigher);

    /**
     * @brief onUpdateCurFlowValue 处理流量实时数据。
     * @param dValue 实时流量数据
     */
    void onUpdateCurFlowValue(double dValue);
public:

    /**
     * @brief updateFlowValueRange 处理更新流量参数
     * @param dLower 最大流量
     * @param dHigher 最小流量
     */
    void updateFlowValueRange(double dLower, double dHigher);
private:
    /**
     * @brief checkFlowValueRange 检查流量范围
     * @return emRangeErr 流量的是否正常
     */
    emRangeErr checkFlowValueRange();

    /**
     * @brief saveFlowValueOutRange 保存异常流量状态到数据库
     * @param rangErr
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int saveFlowValueOutRange(emRangeErr rangErr);

    /**
     * @brief m_settingFlowValueLowThredhold
     */
    double m_settingFlowValueLowThredhold{0};

    /**
     * @brief m_settingFlowValueHighThredhold
     */
    double m_settingFlowValueHighThredhold{0};

    /**
     * @brief m_dCurFlowValue
     */
    double m_dCurFlowValue{0};
    bool m_bCurFlowValueChangeByReal{false};

    /**
     * @brief m_dcurTestMinFlow
     */
    double m_dcurTestMinFlow{100000};

    /**
     * @brief m_dcurTestMaxFlow
     */
    double m_dcurTestMaxFlow{0};

    /**
     * @brief m_dTestFlowSum
     */
    double m_dTestFlowSum{0};

    /**
     * @brief m_iFlowCount
     */
    int m_iFlowCount{0};

public slots:
    /**
     * @brief onUpdateMotorSpeedRange 更新电机转速参数到测试系统的槽函数
     * @param dLower 最小转速
     * @param dHigher 最大转速
     */
    void onUpdateMotorSpeedRange(double dLower, double dHigher);

    /**
     * @brief onUpdateCurMotorSpeed 更新当前电机转速参数的槽函数
     * @param icurMotorSpeed 当前转速
     */
    void onUpdateCurMotorSpeed(int icurMotorSpeed);

    /**
     * @brief onUpateCurParamToDB 当前参数写入数据库
     */
    void onUpateCurParamToDB();
signals:
    /**
     * @brief updateCurParamToDBDone UpateCurParamToDB 返回
     */
    void updateCurParamToDBDone();
public slots:
    /**
     * @brief onReceiveWarning 处理报警槽函数
     * @param strWarningName 添加报警信息
     * @param strRemoveWarningName 移除报警信息
     */
    void onReceiveWarning(QString strWarningName, QString strRemoveWarningName);

    /**
     * @brief onRemoveWarning 单独收到的添加报警信息的槽函数
     * @param strWarningName 添加报警信息
     */
    void onRemoveWarning(QString strWarningName);
private:

    /**
     * @brief processWaringmsg 按报警信息名称查询报警详细信息，并保存到数据库
     * @param strWarningName 报警信息名称
     * @return
     */
    int processWaringmsg(QString strWarningName);

    /**
     * @brief removeWaringMsg 移除报警信息
     * @param strWarningName 报警信息名称
     * @return
     */
    int removeWaringMsg(QString strWarningName);
public:
    /**
     * @brief updateMotorSpeedRange 更新测试系统速度范围参数
     * @param dLower 最小转速
     * @param dHigher 最大转速
     */
    void updateMotorSpeedRange(double dLower, double dHigher);
private:
    /**
     * @brief checkMotorSpeedRange 检查电机转速状态
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    emRangeErr checkMotorSpeedRange();

    /**
     * @brief saveMotorSpeedOutRange 保存电机转速异常参数
     * @param rangErr  电机范围异常
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int saveMotorSpeedOutRange(emRangeErr rangErr);

    /**
     * @brief m_settingMotorSpeedLowThrehold
     */
    int m_settingMotorSpeedLowThrehold{0};

    /**
     * @brief m_settingMotorSpeedHighThrehold
     */
    int m_settingMotorSpeedHighThrehold{0};

    /**
     * @brief m_iCurMotorSpeed
     */
    int m_iCurMotorSpeed{0};

    bool m_bCurMotorSpeedChangeByReal{false};

    /**
     * @brief m_icurTestMinSpeed
     */
    int m_icurTestMinSpeed{100000};

    /**
     * @brief m_icurTestMaxSpeed
     */
    int m_icurTestMaxSpeed{0};

    /**
     * @brief m_iTestSeepSum
     */
    qint64 m_iTestSeepSum{0};

    /**
     * @brief m_iSpeedCount
     */
    int m_iSpeedCount{0};
signals:

    /**
     * @brief maxOrMinValueChanged 转速、流量的最大最小值及均值更新到UI用于显示实时最大小值
     * @param dMinFlowVolume 最小流量
     * @param dMaxFlowVolume 最大流量
     * @param iMinSpeedValue 最小转速
     * @param iMaxSpeedValue 最大转速
     * @param dAvgFlowVolume 平均流量
     * @param iAvgSpeedValue 平均转速
     */
    void maxOrMinValueChanged(double dMinFlowVolume, double dMaxFlowVolume, int iMinSpeedValue, int iMaxSpeedValue, double dAvgFlowVolume, int iAvgSpeedValue);

    /**
     * @brief updateTesingData 用于更新实时测试数据的信号量，收到此信号后，UI加载曲线数据，及更新UI最值参数
     * @param dMinFlowVolume
     * @param dMaxFlowVolume
     * @param iMinSpeedValue
     * @param iMaxSpeedValue
     * @param dAvgFlowVolume
     * @param iAvgSpeedValue
     */
    void updateTesingData(QDateTime dt, double dCurFlowValue, int iCurMotorSpeed, double dMinFlowVolume, double dMaxFlowVolume, int iMinSpeedValue, int iMaxSpeedValue, double dAvgFlowVolume, int iAvgSpeedValue);
private:

    /**
     * @brief m_bMaxOrMinChanged
     */
    bool m_bMaxOrMinChanged{false};

public slots:

    /**
     * @brief onNeedMaxOrMinValue 处理UI发送的最值需求消息。
     */
    void onNeedMaxOrMinValue();
private:

    /**
     * @brief getActionByName 按动作名称查询动作信息
     * @param strActionName 动作名称
     * @param strActionTitle  动作信息
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getActionByName(QString strActionName, QString &strActionTitle);

    /**
     * @brief getWaringByName 按报警名称查询所有报警参数
     * @param strWaringName 报警名称
     * @param iWarningType 报警类型
     * @param strWarningTitle 报警信息
     * @param iMuteable 是否可以静音
     * @param iLatching 是否闩锁
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getWaringByName(QString strWaringName, int &iWarningType, QString &strWarningTitle, int &iMuteable, int &iLatching);

    /**
     * @brief getWarningSettingByName 按报警名称查询所有报警参数
     * @param strWaringName 报警名称
     * @param iWarningType 报警类型
     * @param strWarningTitle 报警信息
     * @param iMuteable 是否可以静音
     * @param iLatching 是否闩锁
     * @param iTrigOnRun 由外部触发还是由运行类产生
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getWarningSettingByName(QString strWaringName, int &iWarningType, QString &strWarningTitle, int &iMuteable, int &iLatching, int &iTrigOnRun);

    /**
     * @brief m_pSettingDB
     */
    CSettingDBOpt *m_pSettingDB{nullptr};
private:

    /**
     * @brief m_dLastSaveMinMaxTime
     */
    QDateTime m_dLastSaveMinMaxTime{QDateTime()};
    //QDateTime m_startTime{QDateTime()};

    CDatabaseManage *m_pTestingDB{Q_NULLPTR};
};

#endif // CRUNNINGTESTOPT_H
