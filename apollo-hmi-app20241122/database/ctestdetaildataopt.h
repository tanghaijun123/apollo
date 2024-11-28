/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : ctestdetaildataopt.h
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

#ifndef CTESTDETAILDATAOPT_H
#define CTESTDETAILDATAOPT_H

#include <QObject>
#include <QJsonObject>
#include <QtCharts>
#include <QtCharts/QPolarChart>


class CTestDetailDataOpt : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief conDetailDBPath
     */
    const QString conDetailDBPath{"Detail"};
public:
    /**
     * @brief CTestDetailDataOpt
     * @param parent
     */
    explicit CTestDetailDataOpt(QObject *parent = nullptr);
public:
    /**
     * @brief getAllData 按任务ID查询所有记录数据
     * @param iTestID 测试任务编号
     * @return 返回 res： CDatabaseManage::emDataBaseErr及 json风格数据
     */
    Q_INVOKABLE QJsonObject getAllData(int iTestID);
    /**
     * @brief getAllData 返回流量曲线数据及速度曲线数据
     * @param iTestID 测试任务编号
     * @param pLineFlowVolume 流量曲线
     * @param pSpeedValue 转速曲线
     * @return
     */
    Q_INVOKABLE int getAllData(int iTestID, QtCharts::QAbstractSeries* pLineFlowVolume, QtCharts::QAbstractSeries* pSpeedValue);
    /**
     * @brief getAllDatesInTest 返回按测试任务ID测试时经历的测试日期
     * @param iTestID 测试任务编号
     * @return res： CDatabaseManage::emDataBaseErr及 json数据的日期列表
     */
    Q_INVOKABLE QJsonObject getAllDatesInTest(int iTestID);

    /**
     * @brief getDataByDate 查询所在日期的测试日期测试ID的所有数据
     * @param dDate 查询日期
     * @param iTestID 查询数据
     * @return res： CDatabaseManage::emDataBaseErr及 json的测试网络数据
     */
    Q_INVOKABLE QJsonObject getDataByDate(QString dDate, int iTestID);

    /**
     * @brief getDataByDate 按日期查询数据数据，将数据写入曲线数据中
     * @param dDate 测试日期
     * @param iTestID 测试序号
     * @param pLineFlowVolume 流量曲线
     * @param pSpeedValue 速度曲线
     * @return
     */
    Q_INVOKABLE int getDataByDate(QString dDate, int iTestID, QtCharts::QAbstractSeries* pLineFlowVolume, QtCharts::QAbstractSeries* pSpeedValue);
signals:
private:

};

#endif // CTESTDETAILDATAOPT_H
