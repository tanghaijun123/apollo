/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : ctestinginfodatas.h
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

#ifndef CTESTINGINFODATAS_H
#define CTESTINGINFODATAS_H

#include <QObject>
#include "cdatabasemanage.h"
#include <QDateTime>

/**
 * @brief The CTestingInfoDatas class
 */
class CTestingInfoDatas : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief CTestingInfoDatas
     * @param parent
     */
    explicit CTestingInfoDatas(CDatabaseManage* pDataDb, QObject *parent = nullptr);
    ~CTestingInfoDatas();
public:
    /**
     * @brief getRunningReCordCount 查询历史测试记录数据
     * @param nCount 返回测试测试记录数据
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getRunningReCordCount(int &nCount);

    /**
     * @brief getRunningRecords 返回当前页码中的历史数据
     * @param query 返回查询
     * @param nPageIndex 查询号码序号
     * @param nRowsInPage 每页中记录数据
     * @param nPageCount 返回新的页码数量
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getRunningRecords(QSqlQuery &query, int nPageIndex, int nRowsInPage, int &nPageCount);

    /**
     * @brief getWarningRecordCount 查询历史记录数量
     * @param nCount 返回记录数量
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getWarningRecordCount(int &nCount);

    /**
     * @brief getWarningRecords 按测试任务ID查询历史测试数据列表
     * @param query 返回查询
     * @param nPageIndex 当前页面序号
     * @param nRowsInPage 每页中数据行数
     * @param nPageCount 返回页码数量
     * @param iTestID 测试任务序号
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getWarningRecords(QSqlQuery &query, int nPageIndex, int nRowsInPage, int &nPageCount, int iTestID = 0);

    /**
     * @brief getWarningRecordsByTestingID 按任务序号查询报警数据
     * @param iTestingID 测试任务ID
     * @param query 返回数据查询
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getWarningRecordsByTestingID(int iTestingID, QSqlQuery &query);

    /**
     * @brief getAllWarningRecords 查询所有报警数据
     * @param query 返回数据的查询
     * @param bAsc 查询数据的顺序
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getAllWarningRecords(QSqlQuery &query, bool bAsc = true);

    /**
     * @brief getTestingOperateRecordCount 查询所有操作数据数量
     * @param nCount返回查询的操作数据数量
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getTestingOperateRecordCount(int &nCount);

    /**
     * @brief getTestingOperateRecords 按页码查询当前页的运行数据
     * @param query 返回数据查询
     * @param nPageIndex 数据的页序列
     * @param nRowsInPage 每页数据行数
     * @param nPageCount 返回最的数据页数
     * @param iTestID 测试序号
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getTestingOperateRecords(QSqlQuery &query, int nPageIndex, int nRowsInPage, int &nPageCount, int iTestID = 0);

    /**
     * @brief getNoSolvedWarningRecordCount 查询未处理的报警数量
     * @param nCount返回未处理的记录数量
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getNoSolvedWarningRecordCount(int &nCount);

    /**
     * @brief getNoSolvedWarnins 按页码序号查询当前页的未处理报警信息
     * @param query返回报警信息列表
     * @param nPageIndex 查询序号
     * @param nRowsInPage 每页的数据数量
     * @param nPageCount 返回最新页码数
     * @param iTestID 测试任务ID
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getNoSolvedWarnins(QSqlQuery &query, int nPageIndex, int nRowsInPage, int &nPageCount, int iTestID = 0);
//patientInfo
public:
    /**
     * @brief getPatientID 查询新最的患者ID号，未有患者信息会成生新的患者信息
     * @param iPatientID 返回患者ID
     * @return  返回 CDatabaseManage::emDataBaseErr
     */
    int getPatientID(int &iPatientID);

    /**
     * @brief getPatientByPatientID 按患者ID号查询患者信息
     * @param iPatientID 患者ID
     * @param strPatientName 患者姓名
     * @param strSex 性别
     * @param strAge 患者年龄
     * @param strPatientID 返回患者ID
     * @param strBloodType 血型
     * @param dWeight 体重
     * @param dHeight 身高
     * @param dImplantationTime 植入时间
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getPatientByPatientID(int iPatientID, QString &strPatientName, QString &strSex, QString &strAge, QString &strPatientID, QString &strBloodType, double &dWeight, double &dHeight, QDateTime &dImplantationTime);

    /**
     * @brief getFirstPatient 查询每一个患者信息
     * @param strPatientName 患者姓名
     * @param strSex 性别
     * @param strAge 患者年龄
     * @param strPatientID 返回患者ID
     * @param strBloodType 血型
     * @param dWeight 体重
     * @param dHeight 身高
     * @param dImplantationTime 植入时间
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getFirstPatient(QString &strPatientName, QString &strSex, QString &strAge, QString &strPatientID, QString &strBloodType, double &dWeight, double &dHeight, QDateTime &dImplantationTime);

    /**
     * @brief getPatientIDByTestID 查询测试任务对应的患者ID
     * @param iTestID 测试任务序号ID
     * @param iPatientID 患者ID
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getPatientIDByTestID(int iTestID, int &iPatientID);

    /**
     * @brief insertPatientInfo 插入患者信息到数据库
     * @param strPatientName 患者姓名
     * @param strSex 患者性别
     * @param strAge 患者年龄
     * @param strPatientID 患者ID号
     * @param strBloodType 血型
     * @param dWeight 体重
     * @param dHeight 身高
     * @param dImplantationTime 植入时间
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int insertPatientInfo(QString strPatientName, QString strSex, QString strAge, QString strPatientID, QString strBloodType, double dWeight, double dHeight, QDateTime dImplantationTime);

    /**
     * @brief updateFirstPatientInfo 更新患者信息，如果不存在，则插入患者信息
     * @param strPatientName 患者姓名
     * @param strSex 患者性别
     * @param strAge 患者年龄
     * @param strPatientID 患者ID
     * @param strBloodType 患者血型
     * @param dWeight 患者体重
     * @param dHeight 患者身高
     * @param dImplantationTime
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int updateFirstPatientInfo(QString strPatientName, QString strSex, QString strAge, QString strPatientID, QString strBloodType, double dWeight, double dHeight, QDateTime dImplantationTime);

    /**
     * @brief updatePatientInfo 按患者数据库ID更新患者信息
     * @param iID 患者数据库ID
     * @param strPatientName 患者君姓名
     * @param strSex 患者性别
     * @param strAge 患者年龄
     * @param strPatientID 患者ID
     * @param strBloodType 患者血型
     * @param dWeight 患者体重
     * @param dHeight患者身高
     * @param dImplantationTime
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int updatePatientInfo(int iID, QString strPatientName, QString strSex, QString strAge, QString strPatientID, QString strBloodType, double dWeight, double dHeight, QDateTime dImplantationTime);

    /**
     * @brief deletePatetientInfo 按患者数据ID删除患者信息
     * @param iID 患者数据库ID
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int deletePatetientInfo(int iID);

//RunningReCord
public:
    /**
     * @brief updateNoCloseTestDone 更新未完成测试任务状态
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int updateNoCloseTestDone();

    /**
     * @brief getRunningReCordID 返回当前测试任务的任务ID及详细数据目录
     * @param iTestID返回测试任务ID
     * @param strDetailDataPath 返回测试详细数据路径
     * @param bGetOnly 只作查询，不创建新测试任务
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getRunningReCordID(int &iTestID, QString &strDetailDataPath, bool bGetOnly = false);

    /**
     * @brief getDetailDataPathByTestID 按测试任务ID查询详细数据路径
     * @param iTestID 测试任务ID
     * @param strDetailDataPath 返回详细数据路径
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getDetailDataPathByTestID(int iTestID, QString &strDetailDataPath);

    /**
     * @brief insertRunningRecordInfo 插入测试任务数据到数据库
     * @param iPatientID 患者ID
     * @param dStartDateTime 任务开始时间
     * @param nRunMinute 运行分钟数
     * @param bTestDone 测试任务是否已经完成
     * @param strDetailPath 详细数据路径
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int insertRunningRecordInfo(int iPatientID = 0, QDateTime dStartDateTime = QDateTime(), int nRunMinute = 0, bool bTestDone = false, QString strDetailPath= "Detail");

    /**
     * @brief updateRunningRecordInfo 更新测试数据到数据库，
     * @param iTestID 测试任务ID
     * @param iPatientID 患者ID
     * @param dStartDateTime 开始时间
     * @param nRunMinute 运行分钟时长
     * @param bTestDone 测试任务是否结束
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int updateRunningRecordInfo(int iTestID, int iPatientID, QDateTime dStartDateTime, int nRunMinute, bool bTestDone);

    /**
     * @brief updateRunningReCordIDPatientID 更新测试任务对应的患者ID
     * @param iTestID 测试任务ID
     * @param iPatientID 测试患者ID
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int updateRunningReCordIDPatientID(int iTestID, int iPatientID);

    /**
     * @brief updateRunningStartToDB 更新测试任务开妈
     * @param iTestingID 测试任务ID
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int updateRunningStartToDB(int iTestingID);

    /**
     * @brief updateRunningDone 更新测试任务已经
     * @param iTestID 测试任务编号
     * @param dMinFlowValue 流量等限制数据
     * @param dMaxFlowValue
     * @param iMinSpeedValue
     * @param iMaxSpeedValue
     * @param dAvgFlowValue
     * @param iAvgSpeedValue
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int updateRunningDone(int iTestID, double dMinFlowValue, double dMaxFlowValue, int iMinSpeedValue, int iMaxSpeedValue, double dAvgFlowValue, int iAvgSpeedValue);

    /**
     * @brief updateStatisticsValue 按测试任务ID更新统计数据
     * @param iTestID 测试任务编号
     * @param dMinFlowValue 流量等限制数据
     * @param dMaxFlowValue
     * @param iMinSpeedValue
     * @param iMaxSpeedValue
     * @param dAvgFlowValue
     * @param iAvgSpeedValue
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int updateStatisticsValue(int iTestID, double dMinFlowValue, double dMaxFlowValue, int iMinSpeedValue, int iMaxSpeedValue, double dAvgFlowValue, int iAvgSpeedValue);

    /**
     * @brief deleteRunningRecordInfo 删除测试记录
     * @param iTestID 测试任务ID号
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int deleteRunningRecordInfo(int iTestID);

    /**
     * @brief getRunningRecordList 查询患者历史测试数据列表
     * @param iPatientID患者数据
     * @param query 历史数据查询
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getRunningRecordList(int iPatientID, QSqlQuery &query);

    /**
     * @brief getLastRunningRecord 查询患者的最后一次测试任务
     * @param iPatientID 患者ID
     * @param query 返回最后一次数据的查询
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getLastRunningRecord(int iPatientID , QSqlQuery &query);

//actionRecords
public:
    /**
     * @brief insertActionRecord 插入操作数据到数据库
     * @param iTestingID 测试任务ID
     * @param StrActionType 动作类型
     * @param strParam 动作参数
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int insertActionRecord(int iTestingID, QString StrActionType, QString strParam);

    /**
     * @brief updateActionRecord 更新操作数据到数据库
     * @param iID 操作数据的表ID
     * @param iTestingID 测试任务ID
     * @param StrActionType 动作类型
     * @param strParam动作参数
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int updateActionRecord(int iID, int iTestingID, QString StrActionType, QString strParam);

    /**
     * @brief deleteActionRecord 删除动作数据
     * @param iID 动作数据的数据库ID
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int deleteActionRecord(int iID);

    /**
     * @brief getActionsByTestinID 按测试任务ID查询动作数据
     * @param iTestingID 测试任务ID
     * @param query 返回测试任务查询
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getActionsByTestinID(int iTestingID, QSqlQuery &query);

    /**
     * @brief getAllActions 查询数据中所有动作记录
     * @param query 返回动作数据查询
     * @param bAsc 数据排序
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getAllActions(QSqlQuery &query, bool bAsc = true);

    /**
     * @brief getActionRecordByDate 按测试ID及日期查询动作数据
     * @param iTestID测试任务ID
     * @param dDate运行日期
     * @param query 返回动作数据的查询
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getActionRecordByDate(int iTestID, QDate dDate, QSqlQuery &query);

    /**
     * @brief getWarningRecordByDate按日期查询当前测试ID对应的报警记录
     * @param iTestID测试任务ID
     * @param dDate 测试日期
     * @param query返回报警数据记录
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getWarningRecordByDate(int iTestID, QDate dDate, QSqlQuery &query);
//waringsRecords
public:

    /**
     * @brief insertWaringsRecords 插入报警数据到数据库
     * @param iTestingID 测试任务ID
     * @param strWarningName 报警名称
     * @param iWarningType 报警类型
     * @param strWarningTitle 报警标题
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int insertWaringsRecords(int iTestingID, QString strWarningName, int iWarningType, QString strWarningTitle);

    /**
     * @brief updateWaringsRecords 更新报警记录到数据库
     * @param iID 报警数据库表ID
     * @param iTestingID 测试任务ID
     * @param strWarningName 报警名称
     * @param iWarningType 报警类型
     * @param strWarningTitle 报警标题
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int updateWaringsRecords(int iID, int iTestingID, QString strWarningName, int iWarningType, QString strWarningTitle);

    /**
     * @brief deleteWaringsRecords 删除报警信息
     * @param iID 报警信息对谁的数据库ID
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int deleteWaringsRecords(int iID);

private:
    /**
     * @brief initDataBase 初始化测试任务数据表
     */
    void initDataBase();
    //读参数内部接口
    /**
     * @brief checkDabaBase 查获测试数据表结构完整性
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int checkDabaBase();

    CDatabaseManage *m_pDB{Q_NULLPTR};
};

#endif // CTESTINGINFODATAS_H
