
/******************************************************************************/
/*! @File        : ctestdetaildatas.cpp
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

#include "ctestdetaildatas.h"
#include <QDir>
#include <QApplication>
#include <QSqlError>
#include <QDateTime>
#include <QDebug>
#ifdef GLOBAL_SIMULATION
#include <QRandomGenerator>
#endif


CTestDetailDatas::CTestDetailDatas(QString strDataPath, int iTestID, QObject *parent)
    : QObject{parent}
{
    QString strDetailDBName = QString("%1/%2.db").arg(strDataPath).arg(iTestID, 8, 10, QLatin1Char('0'));
    m_pDB = new CDatabaseManage(strDetailDBName);
    if(!m_pDB)
    {
        qDebug("%s %d CDatabaseManage create file", __FILE__, __LINE__);
        return;
    }
    initDataBase();
}

CTestDetailDatas::~CTestDetailDatas()
{
    if(m_pDB){
        delete m_pDB;
        m_pDB = Q_NULLPTR;
    }
}

int CTestDetailDatas::getAllData(int iTestID, QSqlQuery &query, bool bAsc)
{
    int iResult = checkDabaBase();
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d CDatabaseManage return error: %d", __FILE__, __LINE__, iResult);
        return iResult;
    }

    QString strSQL = QString("SELECT"
                     "	d.ID,"
                     "	d.TestingID,"
                     "	d.RecordDate,"
                     "	d.FlowVolume,"
                     "	d.SpeedValue "
                     "FROM"
                     "	RunningDetailRecord AS d "
                     "WHERE"
                     "	d.TestingID = :TestingID "
                             "ORDER BY ")
                             +
                     (bAsc ? "	d.ID ASC" : " d.ID DESC");
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestDetailDatas::getAllDatesInTest(int iTestID, QStringList &dates)
{
    dates.clear();
    int iResult = checkDabaBase();
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d CDatabaseManage return error: %d", __FILE__, __LINE__, iResult);
        return iResult;
    }

    QString strSQL = "SELECT DISTINCT "
                     "	date(d.RecordDate) AS dt "
                     "FROM"
                     "	RunningDetailRecord AS d "
                     "WHERE"
                     "	d.TestingID = :TestingID "
                     "ORDER BY"
                     "	dt ASC";
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    //qDebug()<<"strSQL:"<<strSQL;
    QSqlQuery query;
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type());
        return CDatabaseManage::DBEExecFail;
    }

    while(query.next()){
        dates.append(query.value("dt").toDate().toString("yyyy/MM/dd"));
    }

    return CDatabaseManage::DBENoErr;
}

int CTestDetailDatas::getDataByDate(int iTestID, QDate dDate, QSqlQuery &query)
{
    int iResult = checkDabaBase();
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d CDatabaseManage return error: %d", __FILE__, __LINE__, iResult);
        return iResult;
    }
//#ifdef GLOBAL_SIMULATION
//    {
//        QString strSQL = "select count(*) AS C from RunningDetailRecord where date(RecordDate) = :RecordDate and TestingID = :TestingID  ";
//        QList<CDatabaseManage::StParam> params;
//        params.append(CDatabaseManage::StParam(":TestingID", iTestID));
//        params.append(CDatabaseManage::StParam(":RecordDate", dDate));
//        if(!m_pDB->execSql(strSQL, params))
//        {
//            qDebug("%s %d exec sql fail, error code: %d", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type());
//            return CDatabaseManage::DBEExecFail;
//        }
//        int nCount = 0;
//        if(m_pDB->m_pQuery->next()){
//            nCount = m_pDB->m_pQuery->value("C").toInt();
//        }
//        if(nCount <1){
//            createRandomData(dDate, iTestID);
//        }
//    }
//#endif
    QString strSQL = "SELECT"
                     "	d.ID,"
                     "	d.TestingID,"
                     "	d.RecordDate,"
                     "	d.FlowVolume,"
                     "	d.SpeedValue "
                     "FROM"
                     "	RunningDetailRecord AS d "
                     "WHERE"
                     //"	strftime('%Y-%m-%d',d.RecordDate) = :RecordDate AND "
                     "	date(d.RecordDate) = :RecordDate AND "
                     "	d.TestingID = :TestingID "
                     "ORDER BY"
                     "	d.ID ASC";
    //qDebug()<<"strSQL:"<<strSQL;
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":RecordDate", dDate));
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    //qDebug()<<"strSQL:"<<strSQL<<"dDate:"<<dDate<<"iTestID:"<<iTestID;
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestDetailDatas::insertData(int iTestID, QDateTime dDateTime, double dFlowVolume, double dSpeedValue)
{
    int iResult = checkDabaBase();
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d CDatabaseManage return error: %d", __FILE__, __LINE__, iResult);
        return iResult;
    }

    QString strSQL = " INSERT INTO RunningDetailRecord(TestingID, RecordDate, FlowVolume, SpeedValue) VALUES(:TestingID, :RecordDate, :FlowVolume, :SpeedValue) ";
    QList<CDatabaseManage::StParam> params;

    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    params.append(CDatabaseManage::StParam(":RecordDate", dDateTime));
    params.append(CDatabaseManage::StParam(":FlowVolume", dFlowVolume));
    params.append(CDatabaseManage::StParam(":SpeedValue", dSpeedValue));
    bool b = m_pDB->m_dataBaseObj.transaction();

    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type());
        if(b){
            if(!m_pDB->m_dataBaseObj.commit())
            {
                m_pDB->m_dataBaseObj.rollback();
            }
        }
        return CDatabaseManage::DBEExecFail;
    }
    if(b){
        if(!m_pDB->m_dataBaseObj.commit())
        {
            m_pDB->m_dataBaseObj.rollback();
        }
    }
    return CDatabaseManage::DBENoErr;
}

int CTestDetailDatas::getMinMaxValue(int iTestID, double &dMinFlowValue, double &dMaxFlowValue, int &iMinSpeedValue, int &iMaxSpeedValue, double &dSumFlowValue, quint64 &iSumSpeedValue, int &iRecordCount)
{
    dMinFlowValue = 0;
    dMaxFlowValue = 0;
    iMinSpeedValue = 0;
    iMaxSpeedValue = 0;
    QString strSQL = "SELECT"
                     "	Min( d.FlowVolume ) AS minFlowVolume,"
                     "	Max( d.FlowVolume ) AS maxFlowVolume,"
                     "	Min( d.SpeedValue ) AS minSpeedValue,"
                     "	Max( d.SpeedValue ) AS maxSpeedValue, "
                     "	Sum( d.FlowVolume ) AS sumFlowVolume, "
                     "	Sum( d.SpeedValue ) AS sumSpeedValue, "
                     "	count( d.ID ) AS recordCount "
                     "FROM"
                     "	RunningDetailRecord AS d "
                     "WHERE"
                     "	d.TestingID = :TestingID";

    QList<CDatabaseManage::StParam> params;
    QSqlQuery query;
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type());
        return CDatabaseManage::DBEExecFail;
    }

    if(query.next()){
        dMinFlowValue = query.value("minFlowVolume").toDouble();
        dMaxFlowValue = query.value("maxFlowVolume").toDouble();
        iMinSpeedValue = query.value("minSpeedValue").toInt();
        iMaxSpeedValue = query.value("maxSpeedValue").toInt();
        dSumFlowValue = query.value("sumFlowVolume").toDouble();
        iSumSpeedValue = query.value("sumSpeedValue").toInt();
        iRecordCount = query.value("recordCount").toInt();
    }
    return CDatabaseManage::DBENoErr;
}

int CTestDetailDatas::getMaxDateTime(QDateTime &dDateTime)
{
    dDateTime = QDateTime();
    QString strSQL = "SELECT"
                     "	Max( d.RecordDate ) AS RecordDate "
                     "FROM"
                     "	RunningDetailRecord AS d ";

    QList<CDatabaseManage::StParam> params;
    QSqlQuery query;

    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type());
        return CDatabaseManage::DBEExecFail;
    }

    if(query.next()){
        dDateTime = query.value("RecordDate").toDateTime();
    }
    return CDatabaseManage::DBENoErr;
}

void CTestDetailDatas::initDataBase()
{
    QString strSQL =
                     "  CREATE TABLE IF NOT EXISTS RunningDetailRecord ("
                     "    ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
                     "    TestingID INTEGER,"
                     "    RecordDate DateTime,"
                     "    FlowVolume real,"
                     "    SpeedValue REAL"
                     "  );";
    QList<CDatabaseManage::StParam> params;
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type());
        return;
    }
}

int CTestDetailDatas::checkDabaBase()
{
    if(m_pDB == Q_NULLPTR){
        qDebug("%s %d exec sql fail, db is null!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDBIsNull;
    }
    if(!m_pDB->isValid())
    {
        qDebug("%s %d exec sql fail, db is null!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDbisInvalid;
    }
    return CDatabaseManage::DBENoErr;
}

#ifdef GLOBAL_SIMULATION
int CTestDetailDatas::createRandomData(QDate curDate, int iTestID)
{
    QDateTime dt;
    dt.setDate(curDate);
    dt.setTime(QTime(1,0,0,0));
    for(int i = 0; i < 10000; i++){
        insertData(iTestID, dt, QRandomGenerator::global()->bounded(20.0), QRandomGenerator::global()->bounded(2000));
        dt = dt.addSecs(5);
    }
    return CDatabaseManage::DBENoErr;
}
#endif
