/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : ctestingoperationrecordquerymodel.h
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

#ifndef CTESTINGOPERATIONRECORDQUERYMODEL_H
#define CTESTINGOPERATIONRECORDQUERYMODEL_H

#include <QSqlQueryModel>
#include "ctestinginfodatas.h"
#include <QJsonObject>
//#include "csettingdbopt.h"
#include <QtCharts>


/**
 * @brief The CTestingOperationRecordQueryModel class 操作数据UI数据提供接口
 */
class CTestingOperationRecordQueryModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    /**
     * @brief The emActionData enum
     */
    enum emActionData{
        aaID,
        aaTestingID,
        aaRecordingTime,
        aaActionType,
        aaParams
    };
public:
    /**
     * @brief CTestingOperationRecordQueryModel
     * @param parent
     */
    explicit CTestingOperationRecordQueryModel(CDatabaseManage *pTestingDB, QObject *parent = nullptr);
    ~CTestingOperationRecordQueryModel();

    // Header:
    /**
     * @brief headerData 表头
     * @param section
     * @param orientation
     * @param role
     * @return 返回 需要的数据
     */
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    /**
     * @brief data 提供需要的数据
     * @param index 数据索引号
     * @param role 角色类型
     * @return 返回需要的数据
     */
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
public:
    //加载nPageIndex页的数据，大于最大页，会显示最大页
    /**
     * @brief loadData 按页码查询当前页的操作数据
     * @param nPageIndex 页码
     * @param iTestID 测试任务ID
     * @return 返回Json样式的网络数据
     */
    Q_INVOKABLE QJsonObject loadData(int nPageIndex, int iTestID = 0);

    //设置每页中的记录行数
    /**
     * @brief setRowsPerPage 设置当前Model的数据每页数据
     * @param nRowsPerPage 每页的记录数量
     * @return 返回是否成功及页数
     */
    Q_INVOKABLE QJsonObject setRowsPerPage(int nRowsPerPage);

    //获取数据的页数
    /**
     * @brief getPageCount 查询记录的总页数
     * @return 返回查询是否成功及页数
     */
    Q_INVOKABLE int getPageCount();

    /**
     * @brief getRowJsonData 查询某一行的操作数据的Json数据
     * @param nRowIndex
     * @return 返回查询是否成功当前行的数据
     */
    Q_INVOKABLE QJsonObject getRowJsonData(int nRowIndex);

    /**
     * @brief getActionSerialByDate 查询日期所在的测试ID对应该的曲线数据
     * @param dDate 日期
     * @param iTestID 测试ID
     * @param pActionSeries 给pActionSeries曲线赋值
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    Q_INVOKABLE int getActionSerialByDate(QString dDate, int iTestID, QtCharts::QAbstractSeries *pActionSeries);

private:
    /**
     * @brief m_pDB
     */
    CTestingInfoDatas *m_pDB{Q_NULLPTR};
    /**
     * @brief m_nRowsPerPage
     */
    int m_nRowsPerPage{10};
    /**
     * @brief m_nPageCount
     */
    int m_nPageCount{0};
    //CSettingDBOpt *m_pSetting{Q_NULLPTR};

    CDatabaseManage *m_pTestingDB{Q_NULLPTR};
};

#endif // CTESTINGOPERATIONRECORDQUERYMODEL_H
