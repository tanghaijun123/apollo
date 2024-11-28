/******************************************************************************/
/*! @File        : cwarningdatamainlistmodel.cpp
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

#include "cwarningdatamainlistmodel.h"
#include <QSqlQuery>

CWarningDataMainListModel *CWarningDataMainListModel::m_model = Q_NULLPTR;
CWarningDataMainListModel::CWarningDataMainListModel(CDatabaseManage *pDataDb, QObject *parent)
    : QAbstractListModel(parent), m_pDataDB(pDataDb)
{
    m_pDB = new CTestingInfoDatas(pDataDb, this);
    m_pSetting = new CSettingDBOpt(this);
}

CWarningDataMainListModel::~CWarningDataMainListModel()
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

CWarningDataMainListModel *CWarningDataMainListModel::getInstance(CDatabaseManage *pDataDb, QQmlEngine *, QJSEngine *)
{
    if(m_model==nullptr)
        m_model=new CWarningDataMainListModel(pDataDb);
    return m_model;
}


int CWarningDataMainListModel::rowCount(const QModelIndex &/*parent*/) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    int nRow = m_data.count();
    return nRow;
}

QVariant CWarningDataMainListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    if(index.row() >= m_data.count())
        return QVariant();

//    if (role == Qt::DisplayRole)
//        return m_data.at(index.row());
    int iRow = index.row();
    if(role == emAlarmTextContentRole){
        return m_data[iRow].textDateContent;
    }

    if(role == emWarningTypeRole){
        return m_data[iRow].WarningType;
    }

    return QVariant();
}

void CWarningDataMainListModel::setRowsPerPage(int nRowsPerPage)
{
    m_nRowsPerPage = nRowsPerPage;
}

QJsonObject CWarningDataMainListModel::loadNoSolvedWarningPageCount(int /*iTestID*/)
{
    int nPageCount = 0;
    int iResult = m_pDB->getNoSolvedWarningRecordCount(nPageCount);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d loadData error code: %d", __FILE__, __LINE__, iResult);
        return QJsonObject({{"res", iResult}, {"nPageCount", 0}});
    }
    return QJsonObject({{"res", iResult}, {"nPageCount", nPageCount}});
}

QJsonObject CWarningDataMainListModel::loadNoSolvedWarning(int nPageIndex, int iTestID)
{
    blockSignals(true);
    m_data.clear();
    QSqlQuery query;
    int nPageCount = 0;
    int iResult = m_pDB->getNoSolvedWarnins(query, nPageIndex, m_nRowsPerPage, nPageCount, iTestID);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d loadData error code: %d", __FILE__, __LINE__, iResult);
        blockSignals(false);
        return QJsonObject({{"res", iResult}, {"nPageCount", 0}});
    }

    while(query.next()){
        //QJsonObject data ({{"alarmTextContent", iResult}, {"WarningTitle", nPageCount}})
        //m_data.append(QString("{alarmTextContent: '%1',alarmType: %2}").arg(query.value("WarningTitle").toString()).arg(query.value("WarningType").toInt()));
        //m_data.append(QJsonObject({{"alarmTextContent", query.value("WarningTitle").toString()},{"alarmType",query.value("WarningType").toInt()}}));
        m_data.append(StModelItem(query.value("WarningTitle").toString(), query.value("WarningType").toInt()));
    }
    blockSignals(false);
    return QJsonObject({{"res", iResult}, {"nPageCount", nPageCount}});
}

QHash<int, QByteArray> CWarningDataMainListModel::roleNames() const
{
    QHash<int, QByteArray> r = QAbstractListModel::roleNames();
    r[emAlarmTextContentRole] = "alarmTextContent";
    r[emWarningTypeRole] = "alarmType";
    return r;
}

QJsonObject CWarningDataMainListModel::getRowData(int iRow)
{
    if(iRow < 0 || iRow >= m_data.size()){
        return QJsonObject({{"res", -1}, {"textDateContent", ""}, {"alarmType", 0}});
    }
    return QJsonObject({{"res", 0}, {"textDateContent", m_data[iRow].textDateContent+"! ! ! 电量过低"}, {"alarmType", m_data[iRow].WarningType}});
}

void CWarningDataMainListModel::onUpdateWarningShow(QList<CRunningTestOpt::StWaring> *warings)
{
    if(!warings){
        return;
    }
    QList<CRunningTestOpt::StWaring> curWaring = *warings;
    blockSignals(true);
    m_data.clear();
    for(int i = 0; i < curWaring.size(); i++){
        m_data.append(StModelItem(curWaring[i].WarningTitle, curWaring[i].WaringType));
    }
    blockSignals(true);
    emit curdataChange();
}
