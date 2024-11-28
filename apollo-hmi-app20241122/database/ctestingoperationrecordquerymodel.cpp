/******************************************************************************/
/*! @File        : ctestingoperationrecordquerymodel.cpp
 *  @Brief       : 简要说明
 *  @Details     : 详细说明
 *  @Author      : han
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

#include "ctestingoperationrecordquerymodel.h"
#include <QtMath>
#include <QSqlRecord>
#include <QtCharts>


CTestingOperationRecordQueryModel::CTestingOperationRecordQueryModel(CDatabaseManage *pTestingDB, QObject *parent)
    : QSqlQueryModel(parent), m_pTestingDB(pTestingDB)
{
    m_pDB = new CTestingInfoDatas(m_pTestingDB, this);
    setHeaderData(aaID, Qt::Horizontal, tr("操作编号"));
    setHeaderData(aaTestingID, Qt::Horizontal, tr("测试编号"));
    setHeaderData(aaRecordingTime, Qt::Horizontal, tr("时间"));
    setHeaderData(aaActionType, Qt::Horizontal, tr("调整类型"));
    setHeaderData(aaParams, Qt::Horizontal, tr("参数"));
    //m_pSetting = new CSettingDBOpt(this);
}

CTestingOperationRecordQueryModel::~CTestingOperationRecordQueryModel()
{
    if(m_pDB){
        delete m_pDB;
        m_pDB = Q_NULLPTR;
    }
}

QVariant CTestingOperationRecordQueryModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    // FIXME: Implement me!
    return QSqlQueryModel::headerData(section, orientation, role);
}

QVariant CTestingOperationRecordQueryModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!
    return QSqlQueryModel::data(index, role);
}

QJsonObject CTestingOperationRecordQueryModel::loadData(int nPageIndex, int iTestID)
{
    QSqlQuery query;
    int iResult = m_pDB->getTestingOperateRecords(query, nPageIndex, m_nRowsPerPage, m_nPageCount, iTestID);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d loadData error code: %d", __FILE__, __LINE__, iResult);
        return QJsonObject({{"res", iResult}, {"nPageCount", 0}});
    }
    setQuery(query);
    return QJsonObject({{"res", CDatabaseManage::DBENoErr}, {"nPageCount", m_nPageCount}});
}

QJsonObject CTestingOperationRecordQueryModel::setRowsPerPage(int nRowsPerPage)
{
    int nPageCount = 0;
    m_nRowsPerPage = (nRowsPerPage <1) ? 1 : nRowsPerPage;
    m_nPageCount = 0;
    int nRows = 0;
    int iResult = m_pDB->getTestingOperateRecordCount(nRows);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d getTestingOperateRecordCount error code: %d", __FILE__, __LINE__, iResult);
        return QJsonObject({{"res", iResult}, {"nPageCount", 0}});
    }
    nPageCount = ceil(nRows / m_nRowsPerPage);
    m_nPageCount = nPageCount;

    return QJsonObject({{"res", CDatabaseManage::DBENoErr}, {"nPageCount", m_nPageCount}}) ;
}

int CTestingOperationRecordQueryModel::getPageCount()
{
    return m_nPageCount;
}

QJsonObject CTestingOperationRecordQueryModel::getRowJsonData(int nRowIndex)
{
    QSqlRecord rc = record(nRowIndex);

    return QJsonObject({{"textDate", rc.value(aaRecordingTime).toDateTime().toString("yyyy/MM/dd")},
                        {"textTime", rc.value(aaRecordingTime).toDateTime().toString("hh:mm:ss")},
                        {"setType", rc.value(aaActionType).toString()},
                        {"parameterData", rc.value(aaParams).toString()}});
}

int CTestingOperationRecordQueryModel::getActionSerialByDate(QString dDate, int iTestID, QtCharts::QAbstractSeries *pActionSeries)
{
    qDebug()<<"CTestingOperationRecordQueryModel::getActionDataByDate dDate"<<dDate;
    if(pActionSeries == Q_NULLPTR){
        qDebug("%s %d pActionSeries is null!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDObjectIsNull;
    }

    QtCharts::QScatterSeries  * pCurActionSeries = qobject_cast<QtCharts::QScatterSeries*>(pActionSeries);
    if(!pCurActionSeries){
        qDebug("%s %d QAbstractSeries is null!", __FILE__, __LINE__);
        return CDatabaseManage::DBEAbstractSeriesIsNull;
    }

    QSqlQuery query;
    QDate dt = QDate::fromString(dDate, "yyyy/MM/dd");
    if(!dt.isValid()){
        qDebug("%s %d date is invalid!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDateTimeisInValid;
    }
    int iResult = m_pDB->getActionRecordByDate(iTestID, dt, query);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d getAllData return %d!", __FILE__, __LINE__, iResult);
        return CDatabaseManage::DBEDObjectIsNull;
    }
    pCurActionSeries->blockSignals(true);
    pCurActionSeries->clear();
    while(query.next()){
        pCurActionSeries->append(query.value("RecordingTime").toDateTime().toMSecsSinceEpoch(), 1500/*query.value("1500").toDouble()*/);
    }
    pCurActionSeries->blockSignals(false);

    return iResult;
}
