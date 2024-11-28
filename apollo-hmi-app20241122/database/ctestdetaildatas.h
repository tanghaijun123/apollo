/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : ctestdetaildatas.h
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

#ifndef CTESTDETAILDATAS_H
#define CTESTDETAILDATAS_H

#include <QObject>
#include "cdatabasemanage.h"
#include "global_define.h"


/**
 * @brief The CTestDetailDatas class 反应曲线数据读写操作
 */
class CTestDetailDatas : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief CTestDetailDatas
     * @param strDataPath
     * @param iTestID
     * @param parent
     */
    explicit CTestDetailDatas(QString strDataPath, int iTestID, QObject *parent = nullptr);
    ~CTestDetailDatas();
signals:
public:
    /**
     * @brief getAllData 按测试ID查询所有数据
     * @param iTestID 测试序号
     * @param query 返回查询
     * @param bAsc 查询时数据排序
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getAllData(int iTestID, QSqlQuery &query, bool bAsc = true);

    /**
     * @brief getAllDatesInTest 按测试ID查询所有测试日期
     * @param iTestID 测试序号
     * @param dates 返回日期列表
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getAllDatesInTest(int iTestID, QStringList &dates);

    /**
     * @brief getDataByDate 按日期查询数据当天测试数据
     * @param iTestID 测试序号
     * @param dDate 日期
     * @param query 返回数据所在的查询
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getDataByDate(int iTestID, QDate dDate, QSqlQuery &query);

    /**
     * @brief insertData 插入测试数据到数据库
     * @param iTestID 测试序号
     * @param dDateTime 日期
     * @param dFlowVolume 流量数据
     * @param dSpeedValue 转速数据
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int insertData(int iTestID, QDateTime dDateTime, double dFlowVolume, double dSpeedValue);

    /**
     * @brief getMinMaxValue 查询当次测试的最值参数
     * @param iTestID 测试序号
     * @param dMinFlowValue
     * @param dMaxFlowValue
     * @param iMinSpeedValue
     * @param iMaxSpeedValue
     * @param dSumFlowValue
     * @param iSumSpeedValue
     * @param iRecordCount
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getMinMaxValue(int iTestID, double &dMinFlowValue, double &dMaxFlowValue, int &iMinSpeedValue, int &iMaxSpeedValue, double &dSumFlowValue, quint64 &iSumSpeedValue, int &iRecordCount);

    /**
     * @brief getMaxDateTime get detail max datetime record
     * @param dDateTime return max datetime
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int getMaxDateTime(QDateTime &dDateTime);

private:
    /**
     * @brief initDataBase 初始化详细数据
     */
    void initDataBase();
    //读参数内部接口
    /**
     * @brief checkDabaBase 检测数据库完整性
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    int checkDabaBase();
#ifdef GLOBAL_SIMULATION
    int createRandomData(QDate curDate, int iTestID);
#endif
private:
    CDatabaseManage *m_pDB{Q_NULLPTR};
};

#endif // CTESTDETAILDATAS_H
