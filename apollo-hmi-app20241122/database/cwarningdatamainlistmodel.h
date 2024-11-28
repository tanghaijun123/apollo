/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : cwarningdatamainlistmodel.h
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


#ifndef CWARNINGDATAMAINLISTMODEL_H
#define CWARNINGDATAMAINLISTMODEL_H

#include <QAbstractListModel>
#include <QJSEngine>
#include "ctestinginfodatas.h"
#include "csettingdbopt.h"
#include "crunningtestopt.h"
/**
 * @brief The CWarningDataMainListModel class 报警数据与UI对接的接口类
 */
class CWarningDataMainListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    /**
     * @brief The StModelItem class
     */
    struct StModelItem{
        StModelItem() {}
        StModelItem(QString stralarmTextContent, int iWarningType){
            textDateContent = stralarmTextContent;
            WarningType = iWarningType;
        }
        QString textDateContent{""};
        int WarningType{0};
    };
    /*
     *
     *
     */
     enum emWarningRoles{emAlarmTextContentRole = Qt::UserRole+1,
           emWarningTypeRole};
public:
     /**
     * @brief CWarningDataMainListModel
     * @param parent
     */
    explicit CWarningDataMainListModel(CDatabaseManage *pDataDb, QObject *parent = nullptr);
    ~CWarningDataMainListModel();

    /**
     * @brief getInstance
     * @return
     */
    static CWarningDataMainListModel* getInstance(CDatabaseManage *pDataDb, QQmlEngine*, QJSEngine*);
    // Basic functionality: 返回行数
    /**
     * @brief rowCount 行数
     * @param parent
     * @return
     */
    Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    /**
     * @brief data 返回数据
     * @param index数据索引号
     * @param role 角色
     * @return
     */
    Q_INVOKABLE QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    /**
     * @brief setRowsPerPage 设置每页的报警记录数
     * @param nRowsPerPage报警记录数
     */

    Q_INVOKABLE void setRowsPerPage(int nRowsPerPage);

    /**
     * @brief loadNoSolvedWarningPageCount 加载未解决页数
     * @param iTestID 任务ID
     * @return
     */
    Q_INVOKABLE QJsonObject loadNoSolvedWarningPageCount(int iTestID = 0);

    /**
     * @brief loadNoSolvedWarning按页码查询 任务ID号
     * @param nPageIndex 页码序号
     * @param iTestID 测试任务编号
     * @return
     */
    Q_INVOKABLE QJsonObject loadNoSolvedWarning(int nPageIndex, int iTestID = 0);

    /**
     * @brief roleNames 返回角色
     * @return
     */
    QHash<int, QByteArray> roleNames() const override;

    /**
     * @brief getRowData 获取行数据
     * @param iRow 行号
     * @return 返回某行数据
     */
    Q_INVOKABLE QJsonObject getRowData(int iRow);
public slots:
    /**
     * @brief onUpdateWarningShow 将报警数据写列表
     * @param warings
     */
    void onUpdateWarningShow(QList<CRunningTestOpt::StWaring> * warings);
signals:
    /**
     * @brief curdataChange
     */
    void curdataChange();

private:
    /**
     * @brief m_data
     */
    QList<StModelItem> m_data;

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
    CDatabaseManage *m_pDataDB{Q_NULLPTR};

    /**
     * @brief m_model
     */
    static CWarningDataMainListModel *m_model;
};

#endif // CWARNINGDATAMAINLISTMODEL_H
