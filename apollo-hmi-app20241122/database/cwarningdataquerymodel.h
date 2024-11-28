/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : cwarningdataquerymodel.h
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

#ifndef CWARNINGDATAQUERYMODEL_H
#define CWARNINGDATAQUERYMODEL_H

#include <QAbstractTableModel>
#include <QSqlQueryModel>
#include <QStringListModel>
#include <QJsonObject>
#include <QtCharts>
#include "ctestinginfodatas.h"
#include "csettingdbopt.h"

/**
 * @brief The CWarningDataQueryModel class
 */

class CWarningDataQueryModel : public QSqlQueryModel
{
    Q_OBJECT
public:

    /**
     * @brief The emWaringData enum
     */
    enum emWaringData{
        wdID,
        wdTestingID,
        WarningDateTime,
        wdWarningName,
        wdWarningType,
        wdWarningTitle,
    };
public:
    /**
     * @brief CWarningDataQueryModel
     * @param parent
     */
    explicit CWarningDataQueryModel(CDatabaseManage *pTestingDB, QObject *parent = nullptr);
    ~CWarningDataQueryModel();

    // Header:
    /**
     * @brief headerData
     * @param section
     * @param orientation
     * @param role
     * @return
     */
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
    /**
     * @brief data
     * @param index
     * @param role
     * @return
     */
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

public:
    //加载nPageIndex页的数据，大于最大页，会显示最大页
    /**
     * @brief loadData
     * @param nPageIndex
     * @param iTestID
     * @return
     */
    Q_INVOKABLE QJsonObject loadData(int nPageIndex, int iTestID = 0);

    //设置每页中的记录行数
    /**
     * @brief setRowsPerPage
     * @param nRowsPerPage
     * @return
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
     * @brief loadNoSolvedWarningPageCount
     * @param iTestID
     * @return
     */
    Q_INVOKABLE QJsonObject loadNoSolvedWarningPageCount(int iTestID = 0);

    /**
     * @brief loadNoSolvedWarning
     * @param pModel
     * @param nPageIndex
     * @param iTestID
     * @return
     */
    Q_INVOKABLE QJsonObject loadNoSolvedWarning(QStringListModel *pModel, int nPageIndex, int iTestID = 0);

    /**
     * @brief getWarningSeriesByDate
     * @param dDate
     * @param iTestID
     * @param pWarnSeries
     * @return
     */
    Q_INVOKABLE int getWarningSeriesByDate(QString dDate, int iTestID, QtCharts::QAbstractSeries *pWarnSeries);

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

    /**
     * @brief m_pSetting
     */
    CSettingDBOpt *m_pSetting{Q_NULLPTR};

    CDatabaseManage *m_pTestingDB{Q_NULLPTR};
};

#endif // CWARNINGDATAQUERYMODEL_H
