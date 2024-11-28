/******************************************************************************/
/*! @File        : crunningrecordmodel.cpp
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

#include "crunningrecordmodel.h"
#include <QtMath>
#include <QSqlRecord>

CRunningRecordModel::CRunningRecordModel(CDatabaseManage* pDataDb, QObject *parent)
    : QSqlQueryModel(parent), m_pDataDb(pDataDb)
{
    m_pDB = new CTestingInfoDatas(pDataDb, this);
    m_roleNames[Qt::DisplayRole] = "display";
    m_roleNames[Qt::EditRole] = "edit";

}

CRunningRecordModel::~CRunningRecordModel()
{
    if(m_pDB){
        delete m_pDB;
        m_pDB = Q_NULLPTR;
    }
}

QVariant CRunningRecordModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    // FIXME: Implement me!
    return QSqlQueryModel::headerData(section, orientation, role);
}


QVariant CRunningRecordModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!
    if(index.row() >= rowCount()){
        return QVariant();
    }
    return QSqlQueryModel::data(index, role);
}

QHash<int, QByteArray> CRunningRecordModel::roleNames() const
{
    return m_roleNames;
}

int CRunningRecordModel::rowCount(const QModelIndex &parent) const
{
    if(m_pDB == Q_NULLPTR)
    {
        return 0;
    }
    return QSqlQueryModel::rowCount(parent);
}

int CRunningRecordModel::columnCount(const QModelIndex &parent) const
{
    if(m_pDB == Q_NULLPTR)
    {
        return 0;
    }
    return QSqlQueryModel::columnCount(parent);
}

QJsonObject CRunningRecordModel::loadData(int nPageIndex)
{    
    m_nPageCount = 0;
    QSqlQuery query;
    int iResult = m_pDB->getRunningRecords(query, nPageIndex, m_nRowsPerPage, m_nPageCount);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d loadData error code: %d", __FILE__, __LINE__, iResult);        
        return QJsonObject({{"res", iResult}, {"nPageCount", 0}});
    }

    setQuery(query);
    setHeaderData(rrcTestingID, Qt::Horizontal, tr("测试编号"));
    setHeaderData(rrcPatientID, Qt::Horizontal, tr("病人编号"));
    setHeaderData(rrcStartDateTime, Qt::Horizontal, tr("启动时间"));
    setHeaderData(rrcrunMinute, Qt::Horizontal, tr("运行时长"));
    setHeaderData(rrcTestDone, Qt::Horizontal, tr("测试完成"));
    setHeaderData(rrcDetailPath, Qt::Horizontal, tr("记录文件目录"));
    setHeaderData(rrcCreateDate, Qt::Horizontal, tr("创建日期"));
    setHeaderData(rrcFlowValueMin, Qt::Horizontal, tr("流量最小值"));
    setHeaderData(rrcFlowValueMax, Qt::Horizontal, tr("流量最大值"));
    setHeaderData(rrcMotorSpeedMin, Qt::Horizontal, tr("转速最小值"));
    setHeaderData(rrcMotorSpeedMax, Qt::Horizontal, tr("转速最大值"));
    setHeaderData(rrcFlowValueAvg, Qt::Horizontal, tr("平均流量"));
    setHeaderData(rrcMotorSpeedAvg, Qt::Horizontal, tr("平均转速"));

    return QJsonObject({{"res", CDatabaseManage::DBENoErr}, {"nPageCount", m_nPageCount}});
}

QJsonObject CRunningRecordModel::setRowsPerPage(int nRowsPerPage)
{
    int nPageCount = 0;
    if(nRowsPerPage < 1){
        m_nRowsPerPage = 1;
    }
    else{
        m_nRowsPerPage = nRowsPerPage;
    }

    m_nPageCount = 0;
    int nRows = 0;
    int iResult = m_pDB->getRunningReCordCount(nRows);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d getRunningReCordCount error code: %d", __FILE__, __LINE__, iResult);
        return QJsonObject({{"res", iResult}, {"nPageCount", 0}});
    }
    nPageCount = ceil(nRows / m_nRowsPerPage);
    m_nPageCount = nPageCount;

    return QJsonObject({{"res", CDatabaseManage::DBENoErr}, {"nPageCount", m_nPageCount}}) ;
}

int CRunningRecordModel::getPageCount()
{
    return m_nPageCount;
}

QJsonObject CRunningRecordModel::getRowJsonData(int nRowIndex)
{
    if(nRowIndex < 0 ||  nRowIndex >= rowCount()){
        QJsonObject({{"textDate", ""},
                     {"textTime", ""},
                     {"textDuration", 0}});
    }
    QSqlRecord rc = record(nRowIndex);
    return QJsonObject({{"textDate", rc.value(rrcStartDateTime).toDateTime().toString("yyyy/MM/dd")},
                        {"textTime", rc.value(rrcStartDateTime).toDateTime().toString("hh:mm:ss")},
                        {"textDuration", QString("%1h %2min").arg(rc.value(rrcrunMinute).toInt() / 60).arg(rc.value(rrcrunMinute).toInt() % 60)}});
}

QJsonObject CRunningRecordModel::getRowMaxOrMinJsonData(int nRowIndex)
{
    if(nRowIndex < 0 ||  nRowIndex >= rowCount()){
        return QJsonObject({{"FlowValueMin", 0},
                            {"FlowValueMax", 0},
                            {"MotorSpeedMin", 0},
                            {"MotorSpeedMax", 0},
                            {"FlowValueAvg", 0},
                            {"MotorSpeedAvg", 0}});
    }
    QSqlRecord rc = record(nRowIndex);

    return QJsonObject({{"FlowValueMin", rc.value(rrcFlowValueMin).toDouble()},
                        {"FlowValueMax", rc.value(rrcFlowValueMax).toDouble()},
                        {"MotorSpeedMin", rc.value(rrcMotorSpeedMin).toDouble()},
                        {"MotorSpeedMax", rc.value(rrcMotorSpeedMax).toDouble()},
                        {"FlowValueAvg", rc.value(rrcFlowValueAvg).toDouble()},
                        {"MotorSpeedAvg", rc.value(rrcMotorSpeedAvg).toDouble()}});
}

//int CRunningRecordModel::getCurRuningTestID()
//{
//    int iResult = m_pDB->getRunningRecords(query, nPageIndex, m_nRowsPerPage, m_nPageCount);
//    if(iResult != CDatabaseManage::DBENoErr){
//        qDebug("%s %d loadData error code: %d", __FILE__, __LINE__, iResult);
//        return QJsonObject({{"res", iResult}, {"nPageCount", 0}});
//    }

//    return CDatabaseManage::DBENoErr;
//}
