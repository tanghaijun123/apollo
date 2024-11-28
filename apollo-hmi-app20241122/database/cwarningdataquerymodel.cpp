
/******************************************************************************/
/*! @File        : cwarningdataquerymodel.cpp
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

#include "cwarningdataquerymodel.h"
#include <QtMath>
#include <QSqlRecord>
#include <QDebug>
#include <QtCharts>
#include "cdatabasemanage.h"


CWarningDataQueryModel::CWarningDataQueryModel(CDatabaseManage *pTestingDB, QObject *parent)
    : QSqlQueryModel(parent), m_pTestingDB(pTestingDB)
{
    m_pDB = new CTestingInfoDatas(m_pTestingDB, this);
    setHeaderData(wdID, Qt::Horizontal, tr("ID"));
    setHeaderData(wdTestingID, Qt::Horizontal, tr("测试编号"));
    setHeaderData(WarningDateTime, Qt::Horizontal, tr("时间"));
    setHeaderData(wdWarningName, Qt::Horizontal, tr("报警索引"));
    setHeaderData(wdWarningType, Qt::Horizontal, tr("报警类型"));
    setHeaderData(wdWarningTitle, Qt::Horizontal, tr("报警内容"));
    m_pSetting = new CSettingDBOpt(this);
}

CWarningDataQueryModel::~CWarningDataQueryModel()
{
    if(m_pSetting){
        delete m_pSetting;
        m_pSetting = Q_NULLPTR;
    }

    if(m_pDB){
        delete m_pDB;
        m_pDB = Q_NULLPTR;
    }
}

QVariant CWarningDataQueryModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    // FIXME: Implement me!
    return QSqlQueryModel::headerData(section, orientation, role);
}

QVariant CWarningDataQueryModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!
    return QSqlQueryModel::data(index, role);
}

QJsonObject CWarningDataQueryModel::loadData(int nPageIndex, int iTestID)
{
    QSqlQuery query;
    int iResult = m_pDB->getWarningRecords(query, nPageIndex, m_nRowsPerPage, m_nPageCount, iTestID);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d loadData error code: %d", __FILE__, __LINE__, iResult);
        return QJsonObject({{"res", iResult}, {"nPageCount", 0}});
    }
    setQuery(query);
    return QJsonObject({{"res", CDatabaseManage::DBENoErr}, {"nPageCount", m_nPageCount}});
}

QJsonObject CWarningDataQueryModel::setRowsPerPage(int nRowsPerPage)
{
    int nPageCount = 0;
    m_nRowsPerPage = (nRowsPerPage <1) ? 1 : nRowsPerPage;

    m_nPageCount = 0;
    int nRows = 0;
    int iResult = m_pDB->getWarningRecordCount(nRows);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d getWarningRecordCount error code: %d", __FILE__, __LINE__, iResult);
        return QJsonObject({{"res", iResult}, {"nPageCount", 0}});
    }
    nPageCount = ceil(nRows / m_nRowsPerPage);
    m_nPageCount = nPageCount;

    return QJsonObject({{"res", CDatabaseManage::DBENoErr}, {"nPageCount", m_nPageCount}}) ;
}

int CWarningDataQueryModel::getPageCount()
{
    return m_nPageCount;
}

QJsonObject CWarningDataQueryModel::getRowJsonData(int nRowIndex)
{
    QSqlRecord rc = record(nRowIndex);
    //QString strWarningName = rc.value(wdWarningName).toString();

    return QJsonObject({{"warningType", rc.value("WarningType").toInt()},
                        {"textDateContent", rc.value(WarningDateTime).toDateTime().toString("yyyy/MM/dd")},
                        {"textTimeContent", rc.value(WarningDateTime).toDateTime().toString("hh:mm:ss")},
                        {"textRightContent", rc.value("WarningTitle").toString()}});
}

QJsonObject CWarningDataQueryModel::loadNoSolvedWarningPageCount(int /*iTestID*/)
{
    int nPageCount = 0;
    int iResult = m_pDB->getNoSolvedWarningRecordCount(nPageCount);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d loadData error code: %d", __FILE__, __LINE__, iResult);
        return QJsonObject({{"res", iResult}, {"nPageCount", 0}});
    }
    return QJsonObject({{"res", iResult}, {"nPageCount", nPageCount}});
}

QJsonObject CWarningDataQueryModel::loadNoSolvedWarning(QStringListModel *pModel, int nPageIndex, int iTestID)
{
    if(!pModel){
        qDebug("%s %d loadNoSolvedWarning error, object is NULL", __FILE__, __LINE__);
        return QJsonObject({{"res", CDatabaseManage::DBEDObjectIsNull}, {"nPageCount", 0}});
    }
    pModel->blockSignals(true);
    pModel->removeRows(0, pModel->rowCount());
    QSqlQuery query;
    int nPageCount = 0;
    int iResult = m_pDB->getNoSolvedWarnins(query, nPageIndex, m_nRowsPerPage, nPageCount, iTestID);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d loadData error code: %d", __FILE__, __LINE__, iResult);
        pModel->blockSignals(false);
        return QJsonObject({{"res", iResult}, {"nPageCount", 0}});
    }
    QStringList sl;
    while(query.next()){
        sl.append(QString("{alarmTextContent:%1,alarmType:%2}").arg(query.value("WarningTitle").toString()).arg(query.value("WarningType").toInt()));
    }
    pModel->setStringList(sl);
    pModel->blockSignals(false);
    return QJsonObject({{"res", iResult}, {"nPageCount", nPageCount}});
}

int CWarningDataQueryModel::getWarningSeriesByDate(QString dDate, int iTestID, QtCharts::QAbstractSeries *pWarnSeries)
{
    qDebug()<<"CWarningDataQueryModel::getWarnDataByDate dDate"<<dDate;
    if(pWarnSeries == Q_NULLPTR){
        qDebug("%s %d pWarnSeries is null!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDObjectIsNull;
    }

    QtCharts::QScatterSeries  * pCurWarnSeries = qobject_cast<QtCharts::QScatterSeries*>(pWarnSeries);
    if(!pCurWarnSeries){
        qDebug("%s %d QAbstractSeries is null!", __FILE__, __LINE__);
        return CDatabaseManage::DBEAbstractSeriesIsNull;
    }

    QSqlQuery query;
    QDate dt = QDate::fromString(dDate, "yyyy/MM/dd");
    if(!dt.isValid()){
        qDebug("%s %d date is invalid!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDateTimeisInValid;
    }
    int iResult = m_pDB->getWarningRecordByDate(iTestID, dt, query);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d getAllData return %d!", __FILE__, __LINE__, iResult);
        return CDatabaseManage::DBEDObjectIsNull;
    }
    pCurWarnSeries->blockSignals(true);
    pCurWarnSeries->clear();
    while(query.next()){
        pCurWarnSeries->append(query.value("WarningDateTime").toDateTime().toMSecsSinceEpoch(), 2000/*query.value("2000").toDouble()*/);
    }
    pCurWarnSeries->blockSignals(false);

    return iResult;
}
