/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : crunningrecordmodel.h
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

#ifndef CRUNNINGRECORDMODEL_H
#define CRUNNINGRECORDMODEL_H

#include <QAbstractTableModel>
#include <QSqlQueryModel>
#include <QJsonObject>
#include "ctestinginfodatas.h"

/**
 * @brief The CRunningRecordModel class 运行记录
 */
class CRunningRecordModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    enum emRunningRecordColumn{
        rrcTestingID,
        rrcPatientID,
        rrcStartDateTime,
        rrcrunMinute,
        rrcTestDone,
        rrcDetailPath,
        rrcCreateDate,
        rrcFlowValueMin,
        rrcFlowValueMax,
        rrcMotorSpeedMin,
        rrcMotorSpeedMax,
        rrcFlowValueAvg,
        rrcMotorSpeedAvg
    };
public:
    /**
     * @brief CRunningRecordModel 测试任务基本表数据model
     * @param parent 父对象
     */
    explicit CRunningRecordModel(CDatabaseManage* pDataDb, QObject *parent = nullptr);
    ~CRunningRecordModel();

    // Header:
    /**
     * @brief headerData 表头数据
     * @param section 表头单元序号
     * @param orientation 方向
     * @param role 角色
     * @return 返回 表头数据或样式
     */
    Q_INVOKABLE QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // Basic functionality:
    /**
     * @brief data 返回表数据
     * @param index 数据对应索引
     * @param role 角色
     * @return
     */
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    /**
     * @brief roleNames 角色名称
     * @return
     */
    QHash<int, QByteArray> roleNames() const override;

    /**
     * @brief rowCount 行数据
     * @param parent 父对象
     * @return 返回行数
     */
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    /**
     * @brief columnCount 列数
     * @param parent 父对象
     * @return 返回列数
     */
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
public:
    //加载nPageIndex页的数据，大于最大页，会显示最大页
    /**
     * @brief loadData 按页序号加载数据
     * @param nPageIndex 页面数据序号
     * @return
     */
    Q_INVOKABLE QJsonObject loadData(int nPageIndex);

    //设置每页中的记录行数
    /**
     * @brief setRowsPerPage 设置每页行数
     * @param nRowsPerPage 每页的行数
     * @return 返回res，返回码参照emDataBaseErr，
     */
    Q_INVOKABLE QJsonObject setRowsPerPage(int nRowsPerPage);

    //获取数据的页数
    /**
     * @brief getPageCount
     * @return
     */
    Q_INVOKABLE int getPageCount();

    /**
     * @brief getRowJsonData
     * @param nRowIndex
     * @return
     */
    Q_INVOKABLE QJsonObject getRowJsonData(int nRowIndex);

    /**
     * @brief getRowMaxOrMinJsonData
     * @param nRowIndex
     * @return
     */
    Q_INVOKABLE QJsonObject getRowMaxOrMinJsonData(int nRowIndex);

    //Q_INVOKABLE int getCurRuningTestID();
private:
    /**
     * @brief m_nRowsPerPage
     */
    int m_nRowsPerPage{10};
    /**
     * @brief m_nPageCount
     */
    int m_nPageCount{0};

    CDatabaseManage* m_pDataDb;
    /**
     * @brief m_pDB
     */
    CTestingInfoDatas *m_pDB{Q_NULLPTR};
    /**
     * @brief m_roleNames
     */
    QHash<int, QByteArray> m_roleNames;
};

#endif // CRUNNINGRECORDMODEL_H
