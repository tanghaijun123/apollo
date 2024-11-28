/******************************************************************************/
/*! @File        : ctestinginfodatas.cpp
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

#include "ctestinginfodatas.h"
#include <qsqlerror.h>
#include <QtMath>


CTestingInfoDatas::CTestingInfoDatas(CDatabaseManage* pDataDb, QObject *parent)
    : QObject(parent), m_pDB(pDataDb)
{
//    m_pDB = new CDatabaseManage(DB_TESTING_NAME);
//    if(!m_pDB)
//    {
//        qDebug("%s %d CDatabaseManage create file", __FILE__, __LINE__);
//        return;
//    }
    initDataBase();
}

CTestingInfoDatas::~CTestingInfoDatas()
{
//    if(m_pDB){
//        delete m_pDB;
//        m_pDB = Q_NULLPTR;
//    }
}

int CTestingInfoDatas::getRunningReCordCount(int &nCount)
{
    nCount = 0;
    int iReturn = checkDabaBase();

    if(iReturn != CDatabaseManage::DBENoErr)
    {
        qDebug("%s %d getRunningReCordCount error, error code: %d", __FILE__, __LINE__, iReturn);
    }

    QString strSQL = "SELECT Count(*) AS C FROM RunningRecord";
    QList<CDatabaseManage::StParam> params;
    QSqlQuery query;
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec fail, error code: %d", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }
    if(query.next()){
        nCount = query.value("C").toInt();
    }
    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getRunningRecords(QSqlQuery &query, int nPageIndex, int nRowsInPage, int &nPageCount)
{
    int nRowCount = 0;
    int iResult = getRunningReCordCount(nRowCount);
    if(iResult != CDatabaseManage::DBENoErr)
    {
        qDebug("%s %d exec fail, getRunningReCordCount error code: %d", __FILE__, __LINE__, iResult);
        return iResult;
    }
    nPageCount = ceil((double)nRowCount / nRowsInPage);
    if(nPageIndex >= nPageCount){
        nPageIndex = nPageCount -1;
    }

    QString strSQL = "SELECT"
                     "  	r.TestingID,"
                     "  	r.PatientID,"
                     "  	r.StartDateTime,"
                     "  	r.runMinute,"
                     "  	r.TestDone,"
                     "  	r.DetailPath,"
                     "  	r.CreateDate, "
                     "  	r.FlowValueMin, "
                     "  	r.FlowValueMax, "
                     "  	r.MotorSpeedMin, "
                     "  	r.MotorSpeedMax, "
                     "  	r.FlowValueAvg, "
                     "  	r.MotorSpeedAvg "
                     "  FROM"
                     "  	RunningRecord AS r "
                     " WHERE 	r.TestDone = 1 "
                     " ORDER BY "
                     "   r.TestingID DESC  "
                     "  	LIMIT :beginLine,"
                     "  	:nRows";
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":beginLine", nPageIndex * nRowsInPage));
    params.append(CDatabaseManage::StParam(":nRows", nRowsInPage));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec fail, error code: %d", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }
    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getWarningRecordCount(int &nCount)
{
    nCount = 0;
    int iReturn = checkDabaBase();
    if(iReturn != CDatabaseManage::DBENoErr)
    {
        qDebug("%s %d getWarningRecordCount error, error code: %d", __FILE__, __LINE__, iReturn);
    }

    QString strSQL = "SELECT Count(*) AS C FROM WarningsRecord";
    QList<CDatabaseManage::StParam> params;
    QSqlQuery query;
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec fail, error code: %d", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }
    if(query.next()){
        nCount = query.value("C").toInt();
    }
    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getWarningRecords(QSqlQuery &query, int nPageIndex, int nRowsInPage, int &nPageCount, int iTestID)
{
    int nRowCount = 0;
    int iResult = getWarningRecordCount(nRowCount);
    if(iResult != CDatabaseManage::DBENoErr)
    {
        qDebug("%s %d exec fail, getWarningRecordCount error code: %d", __FILE__, __LINE__, iResult);
        return iResult;
    }
    nPageCount = ceil((double)nRowCount / nRowsInPage);
    if(nPageIndex >= nPageCount){
        nPageIndex = nPageCount -1;
    }

    QString strSQL = QString("%1%2%3").arg("SELECT"
                                           "  	w.ID,"
                                           "  	w.TestingID,"
                                           "  	w.WarningDateTime,"
                                           "  	w.WarningName, "
                                           "  	w.WarningType, "
                                           "  	w.WarningTitle "
                                           "  FROM"
                                           "  	WarningsRecord AS w ", (iTestID ==0) ? "":   "  WHERE"
                                                                 "  	(w.TestingID = :TestingID OR w.TestingID = 0) ",
                                           "  ORDER BY"
                                           "  	w.ID DESC "
                                           "  	LIMIT :beginLine,"
                                           "  	:nRows");
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    params.append(CDatabaseManage::StParam(":beginLine", nPageIndex * nRowsInPage));
    params.append(CDatabaseManage::StParam(":nRows", nRowsInPage));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec fail, error code: %d", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }
    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getWarningRecordsByTestingID(int iTestingID, QSqlQuery &query)
{
    QString strSQL = "SELECT"
                     "  	w.ID,"
                     "  	w.TestingID,"
                     "  	w.WarningDateTime,"
                     "  	w.WarningName, "
                     "  	w.WarningType, "
                     "  	w.WarningTitle "
                     "  FROM"
                     "  	WarningsRecord AS w "
                     "  WHERE"
                     "  	w.TestingID = :TestingID or w.TestingID = 0  "
                     "  ORDER BY"
                     "  	w.ID ASC ";
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":TestingID", iTestingID));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec fail, error code: %d", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }
    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getAllWarningRecords(QSqlQuery &query, bool bAsc)
{
    QString strSQL = QString("SELECT"
                     "  	w.ID,"
                     "  	w.TestingID,"
                     "  	w.WarningDateTime,"
                     "  	w.WarningName, "
                     "  	w.WarningType, "
                     "  	w.WarningTitle "
                     "  FROM"
                     "  	WarningsRecord AS w "
                     "  ORDER BY")
                     + (bAsc ? "  	w.ID ASC " : "  	w.ID DESC ");
    QList<CDatabaseManage::StParam> params;
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec fail, error code: %d", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }
    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getTestingOperateRecordCount(int &nCount)
{
    nCount = 0;
    int iReturn = checkDabaBase();
    if(iReturn != CDatabaseManage::DBENoErr)
    {
        qDebug("%s %d getTestingOperateRecordCount error, error code: %d", __FILE__, __LINE__, iReturn);
    }

    QString strSQL = "SELECT Count(*) AS C FROM ActionsRecord";
    QList<CDatabaseManage::StParam> params;
    QSqlQuery query;
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec fail, error code: %d", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }
    if(query.next()){
        nCount = query.value("C").toInt();
    }
    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getTestingOperateRecords(QSqlQuery &query, int nPageIndex, int nRowsInPage, int &nPageCount, int iTestID)
{
    int nRowCount = 0;
    int iResult = getTestingOperateRecordCount(nRowCount);
    if(iResult != CDatabaseManage::DBENoErr)
    {
        qDebug("%s %d exec fail, getTestingOperateRecordCount error code: %d", __FILE__, __LINE__, iResult);
        return iResult;
    }
    nPageCount = ceil((double)nRowCount / nRowsInPage);
    if(nPageIndex >= nPageCount){
        nPageIndex = nPageCount -1;
    }

    QString strSQL = QString("%1%2%3").arg("SELECT"
                                           "  	a.ID,"
                                           "  	a.TestingID,"
                                           "  	a.RecordingTime,"
                                           "  	a.ActionType, "
                                           "  	a.Params "
                                           "  FROM"
                                           "  	ActionsRecord AS a ", (iTestID ==0) ? "":   "  WHERE"
                                                                 "  	a.TestingID = :TestingID ",

                                           "  ORDER BY"
                                           "  	a.ID DESC "
                                           "  	LIMIT :beginLine,"
                                           "  	:nRows");
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    params.append(CDatabaseManage::StParam(":beginLine", nPageIndex * nRowsInPage));
    params.append(CDatabaseManage::StParam(":nRows", nRowsInPage));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec fail, error code: %d", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }
    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getNoSolvedWarningRecordCount(int &nCount)
{
    nCount = 0;
    int iReturn = checkDabaBase();
    if(iReturn != CDatabaseManage::DBENoErr)
    {
        qDebug("%s %d getNoSolvedWarningRecordCount error, error code: %d", __FILE__, __LINE__, iReturn);
    }

    QString strSQL = "SELECT Count(*) AS C FROM WarningsRecord where solved = 0 ";
    QList<CDatabaseManage::StParam> params;
    QSqlQuery query;
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec fail, error code: %d", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }
    if(query.next()){
        nCount = query.value("C").toInt();
    }
    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getNoSolvedWarnins(QSqlQuery &query, int nPageIndex, int nRowsInPage, int &nPageCount, int iTestID)
{
    int nRowCount = 0;
    int iResult = getNoSolvedWarningRecordCount(nRowCount);
    if(iResult != CDatabaseManage::DBENoErr)
    {
        qDebug("%s %d exec fail, getWarningRecordCount error code: %d", __FILE__, __LINE__, iResult);
        return iResult;
    }
    nPageCount = ceil((double)nRowCount / nRowsInPage);
    if(nPageIndex >= nPageCount){
        nPageIndex = nPageCount -1;
    }

    QString strSQL = QString("%1%2%3").arg("SELECT"
                                           "  	w.ID,"
                                           "  	w.TestingID,"
                                           "  	w.WarningDateTime,"
                                           "  	w.WarningName, "
                                           "  	w.WarningType, "
                                           "  	w.WarningTitle "
                                           "  FROM"
                                           "  	WarningsRecord AS w   WHERE"
                                           "  solved <> 1 ",
                                           (iTestID == 0 ) ? "" :"  AND (w.TestingID = :TestingID OR w.TestingID  = 0) ",
                                           "  ORDER BY"
                                           "  	w.WarningType ASC, "
                                           "  	w.WarningDateTime DESC "
                                           "  	LIMIT :beginLine,"
                                           "  	:nRows");
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    params.append(CDatabaseManage::StParam(":beginLine", nPageIndex * nRowsInPage));
    params.append(CDatabaseManage::StParam(":nRows", nRowsInPage));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec fail, error code: %d", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }
    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getPatientID(int &iPatientID)
{
    iPatientID = 0;
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "SELECT ID  FROM PatientInfo;";
    QSqlQuery query;
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    if(query.next()){
        iPatientID = query.value("ID").toInt();
        return CDatabaseManage::DBENoErr;
    }

    int iReturn = insertPatientInfo("", "", "", "", "", 0, 0, QDateTime::currentDateTime());
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d insertPatientInfo return error, error code: %d", __FILE__, __LINE__, iReturn);
        return iReturn;
    }

    return getPatientID(iPatientID);
}

int CTestingInfoDatas::getPatientByPatientID(int iPatientID, QString &strPatientName, QString &strSex, QString &strAge, QString &strPatientID, QString &strBloodType, double &dWeight, double &dHeight, QDateTime &dImplantationTime)
{
    //int iPatientID = 0;
    strPatientName = "";
    strSex = "";
    strAge = "";
    strPatientID = "";
    strBloodType = "";
    dWeight = 0;
    dHeight = 0;
    dImplantationTime = QDateTime();
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "SELECT"
                     "	p.ID,"
                     "	p.PatientName,"
                     "	p.Sex,"
                     "	p.Age,"
                     "	p.PatientID,"
                     "	p.BloodType,"
                     "	p.Weight,"
                     "	p.Height,"
                     "	p.ImplantationTime "
                     "FROM"
                     "	PatientInfo AS p "
                     "WHERE p.ID = :PatientID "
                     "	LIMIT 1";
    QSqlQuery query;
    params.append(CDatabaseManage::StParam(":PatientID", iPatientID));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    if(!query.next()){
        return CDatabaseManage::DBEDBRecodeNotFind;
    }

    //iPatientID = query.value("ID").toInt();
    strPatientName = query.value("PatientName").toString();
    strSex = query.value("Sex").toString();
    strAge = query.value("Age").toString();
    strPatientID = query.value("PatientID").toString();
    strBloodType = query.value("BloodType").toString();
    dWeight = query.value("Weight").toDouble();
    dHeight = query.value("Height").toDouble();
    dImplantationTime = query.value("ImplantationTime").toDateTime();

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getFirstPatient(QString &strPatientName, QString &strSex, QString &strAge, QString &strPatientID, QString &strBloodType, double &dWeight, double &dHeight, QDateTime &dImplantationTime)
{
    //int iPatientID = 0;
    strPatientName = "";
    strSex = "";
    strAge = "";
    strPatientID = "";
    strBloodType = "";
    dWeight = 0;
    dHeight = 0;
    dImplantationTime = QDateTime();
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "SELECT"
                     "	p.ID,"
                     "	p.PatientName,"
                     "	p.Sex,"
                     "	p.Age,"
                     "	p.PatientID,"
                     "	p.BloodType,"
                     "	p.Weight,"
                     "	p.Height,"
                     "	p.ImplantationTime "
                     "FROM"
                     "	PatientInfo AS p "
                     "	LIMIT 1";
    QSqlQuery query;
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    if(query.next()){
        //iPatientID = query.value("ID").toInt();
        strPatientName = query.value("PatientName").toString();
        strSex = query.value("Sex").toString();
        strAge = query.value("Age").toString();
        strPatientID = query.value("PatientID").toString();
        strBloodType = query.value("BloodType").toString();
        dWeight = query.value("Weight").toDouble();
        dHeight = query.value("Height").toDouble();
        dImplantationTime = query.value("ImplantationTime").toDateTime();
        return CDatabaseManage::DBENoErr;
    }

    int iReturn = insertPatientInfo("", "", "", "", "", 0, 0, QDateTime::currentDateTime());
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d insertPatientInfo return error, error code: %d", __FILE__, __LINE__, iReturn);
        return iReturn;
    }

    return getFirstPatient(strPatientName, strSex, strAge, strPatientID, strBloodType, dWeight, dHeight, dImplantationTime);
}

int CTestingInfoDatas::getPatientIDByTestID(int iTestID, int &iPatientID)
{
    iPatientID = 0;
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "SELECT"
                     "	r.PatientID  "
                     "FROM"
                     "	RunningRecord AS r "
                     " WHERE r.TestingID = :TestingID";
    QSqlQuery query;
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, query.lastError().type(),
               query.lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    if(query.next()){
        //iPatientID = query.value("ID").toInt();
        iPatientID = query.value("PatientID").toInt();
    }
    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::insertPatientInfo(QString strPatientName, QString strSex, QString strAge, QString strPatientID, QString strBloodType, double dWeight, double dHeight, QDateTime dImplantationTime)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "INSERT INTO PatientInfo ("
                     "                            PatientName,"
                     "                            Sex,"
                     "                            Age,"
                     "                            PatientID,"
                     "                            BloodType,"
                     "                            Weight,"
                     "                            Height,"
                     "                            ImplantationTime,"
                     "                            CreateDate"
                     "                        )"
                     "                        VALUES ("
                     "                            :PatientName,"
                     "                            :Sex,"
                     "                            :Age,"
                     "                            :PatientID,"
                     "                            :BloodType,"
                     "                            :Weight,"
                     "                            :Height,"
                     "                            :ImplantationTime,"
                     "                            datetime('now','localtime')"
                     "                        );";
    params.append(CDatabaseManage::StParam(":PatientName", strPatientName));
    params.append(CDatabaseManage::StParam(":Sex", strSex));
    params.append(CDatabaseManage::StParam(":Age", strAge));
    params.append(CDatabaseManage::StParam(":PatientID", strPatientID));
    params.append(CDatabaseManage::StParam(":BloodType", strBloodType));
    params.append(CDatabaseManage::StParam(":Weight", dWeight));
    params.append(CDatabaseManage::StParam(":Height", dHeight));
    params.append(CDatabaseManage::StParam(":ImplantationTime", dImplantationTime));
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::updateFirstPatientInfo(QString strPatientName, QString strSex, QString strAge, QString strPatientID, QString strBloodType, double dWeight, double dHeight, QDateTime dImplantationTime)
{
    int iPateintID = 0;
    int iReturn = getPatientID(iPateintID);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getPatientID error, error code: %d", __FILE__, __LINE__, iReturn);
        return iReturn;
    }

    return updatePatientInfo(iPateintID, strPatientName, strSex, strAge, strPatientID, strBloodType, dWeight, dHeight, dImplantationTime);
}

int CTestingInfoDatas::updatePatientInfo(int iID, QString strPatientName, QString strSex, QString strAge, QString strPatientID, QString strBloodType, double dWeight, double dHeight, QDateTime dImplantationTime)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "UPDATE PatientInfo"
                     "   SET PatientName = :PatientName,"
                     "       Sex = :Sex,"
                     "       Age = :Age,"
                     "       PatientID = :PatientID,"
                     "       BloodType = :BloodType,"
                     "       Weight = :Weight,"
                     "       Height = :Height,"
                     "       ImplantationTime = :ImplantationTime"
                     " WHERE ID = :ID;";
    params.append(CDatabaseManage::StParam(":PatientName", strPatientName));
    params.append(CDatabaseManage::StParam(":Sex", strSex));
    params.append(CDatabaseManage::StParam(":Age", strAge));
    params.append(CDatabaseManage::StParam(":PatientID", strPatientID));
    params.append(CDatabaseManage::StParam(":BloodType", strBloodType));
    params.append(CDatabaseManage::StParam(":Weight", dWeight));
    params.append(CDatabaseManage::StParam(":Height", dHeight));
    params.append(CDatabaseManage::StParam(":ImplantationTime", dImplantationTime));
    params.append(CDatabaseManage::StParam(":ID", iID));
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::deletePatetientInfo(int iID)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "DELETE FROM PatientInfo WHERE ID = :ID";
    params.append(CDatabaseManage::StParam(":ID", iID));
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::updateNoCloseTestDone()
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "UPDATE RunningRecord SET TestDone = 1 WHERE TestDone <> 1";
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    strSQL = "UPDATE RunningRecord SET runMinute = 1 WHERE runMinute = 0";
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getRunningReCordID(int &iTestID, QString &strDetailDataPath, bool bGetOnly)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "SELECT r.TestingID, r.DetailPath FROM RunningRecord AS r WHERE r.TestDone = 0";
    QSqlQuery query;

    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, query.lastError().type(),
               query.lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    if(query.next()){
        iTestID = query.value("TestingID").toInt();
        strDetailDataPath = query.value("DetailPath").toString();
        return CDatabaseManage::DBENoErr;
    }

    if(bGetOnly){
        iTestID = 0;
        strDetailDataPath = "";
        return CDatabaseManage::DBENoErr;
    }

    int iReturn = insertRunningRecordInfo();
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d insertRunningRecordInfo return error, error code: %d", __FILE__, __LINE__, iReturn);
        return iReturn;
    }

    return getRunningReCordID(iTestID, strDetailDataPath, bGetOnly);
}

int CTestingInfoDatas::getDetailDataPathByTestID(int iTestID, QString &strDetailDataPath)
{
    strDetailDataPath = "";
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "SELECT r.DetailPath FROM RunningRecord AS r WHERE r.TestingID = :TestingID ";
    QSqlQuery query;
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, query.lastError().type(),
               query.lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    if(query.next()){
        strDetailDataPath = query.value("DetailPath").toString();
    }
    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::insertRunningRecordInfo(int iPatientID, QDateTime dStartDateTime, int nRunMinute, bool bTestDone, QString strDetailPath)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "INSERT INTO RunningRecord ("
                     "                              PatientID,"
                     "                              StartDateTime,"
                     "                              runMinute,"
                     "                              TestDone,"
                     "                              DetailPath,"
                     "                              CreateDate "
                     "                          )"
                     "                          VALUES ("
                     "                              :PatientID,"
                     "                              :StartDateTime,"
                     "                              :runMinute,"
                     "                              :TestDone,"
                     "                              :DetailPath,"
                     "                              datetime('now','localtime')"
                     "                          );";
    params.append(CDatabaseManage::StParam(":PatientID", iPatientID));
    params.append(CDatabaseManage::StParam(":StartDateTime", dStartDateTime));
    params.append(CDatabaseManage::StParam(":runMinute", nRunMinute));
    params.append(CDatabaseManage::StParam(":TestDone", bTestDone));
    params.append(CDatabaseManage::StParam(":DetailPath", strDetailPath));

    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::updateRunningRecordInfo(int iTestingID, int iPatientID, QDateTime dStartDateTime, int nRunMinute, bool bTestDone)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "UPDATE RunningRecord"
                     "   SET PatientID = :PatientID,"
                     "       StartDateTime = :StartDateTime,"
                     "       runMinute = :runMinute,"
                     "       TestDone = :TestDone,"
                     "       DetailPath = :DetailPath,"
                     "       CreateDate = :CreateDate "
                     " WHERE TestingID = :TestingID";

    params.append(CDatabaseManage::StParam(":PatientID", iPatientID));
    params.append(CDatabaseManage::StParam(":StartDateTime", dStartDateTime));
    params.append(CDatabaseManage::StParam(":runMinute", nRunMinute));
    params.append(CDatabaseManage::StParam(":TestDone", bTestDone));
    params.append(CDatabaseManage::StParam(":TestingID", iTestingID));

    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::updateRunningReCordIDPatientID(int iTestingID, int iPatientID)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "UPDATE RunningRecord"
                     "   SET PatientID = :PatientID "
                     " WHERE TestingID = :TestingID";

    params.append(CDatabaseManage::StParam(":PatientID", iPatientID));
    params.append(CDatabaseManage::StParam(":TestingID", iTestingID));

    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::updateRunningStartToDB(int iTestingID)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "UPDATE RunningRecord"
                     "   SET StartDateTime = datetime('now', 'localtime') "
                     " WHERE TestingID = :TestingID";

    params.append(CDatabaseManage::StParam(":TestingID", iTestingID));

    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::updateRunningDone(int iTestID, double dMinFlowValue, double dMaxFlowValue, int iMinSpeedValue, int iMaxSpeedValue, double dAvgFlowValue, int iAvgSpeedValue)
{
    QList<CDatabaseManage::StParam> params;
    QSqlQuery query;
    QString strSQL = "SELECT"
                     "	r.StartDateTime "
                     "FROM"
                     "	RunningRecord AS r "
                     "WHERE"
                     "	r.TestingID = :TestingID";
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, query.lastError().type(),
               query.lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    if(!query.next()){
        qDebug("%s %d record not find!!!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDBRecodeNotFind;
    }

    QDateTime dStartDate = query.value("StartDateTime").toDateTime();
    int nMinutes = qMax((int)(dStartDate.secsTo(QDateTime::currentDateTime()) / 60), 1);
    params.clear();
    strSQL = "UPDATE RunningRecord"
             "   SET runMinute = :runMinute,"
             "       TestDone = 1, "
             "       FlowValueMin = :FlowValueMin, "
             "       FlowValueMax = :FlowValueMax, "
             "       MotorSpeedMin = :MotorSpeedMin, "
             "       MotorSpeedMax = :MotorSpeedMax, "
             "       FlowValueAvg = :FlowValueAvg, "
             "       MotorSpeedAvg = :MotorSpeedAvg "
             " WHERE TestingID = :TestingID";
    params.append(CDatabaseManage::StParam(":runMinute", nMinutes));
    params.append(CDatabaseManage::StParam(":FlowValueMin", dMinFlowValue));
    params.append(CDatabaseManage::StParam(":FlowValueMax", dMaxFlowValue));
    params.append(CDatabaseManage::StParam(":MotorSpeedMin", iMinSpeedValue));
    params.append(CDatabaseManage::StParam(":MotorSpeedMax", iMaxSpeedValue));
    params.append(CDatabaseManage::StParam(":FlowValueAvg", dAvgFlowValue));
    params.append(CDatabaseManage::StParam(":MotorSpeedAvg", iAvgSpeedValue));
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    if(!m_pDB->execSql(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, query.lastError().type(),
               query.lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::updateStatisticsValue(int iTestID, double dMinFlowValue, double dMaxFlowValue, int iMinSpeedValue, int iMaxSpeedValue, double dAvgFlowValue, int iAvgSpeedValue)
{
    QList<CDatabaseManage::StParam> params;
    QSqlQuery query;
    QString strSQL = "UPDATE RunningRecord"
             "   SET FlowValueMin = :FlowValueMin, "
             "       FlowValueMax = :FlowValueMax, "
             "       MotorSpeedMin = :MotorSpeedMin, "
             "       MotorSpeedMax = :MotorSpeedMax, "
             "       FlowValueAvg = :FlowValueAvg, "
             "       MotorSpeedAvg = :MotorSpeedAvg "
             " WHERE TestingID = :TestingID";
    params.append(CDatabaseManage::StParam(":FlowValueMin", dMinFlowValue));
    params.append(CDatabaseManage::StParam(":FlowValueMax", dMaxFlowValue));
    params.append(CDatabaseManage::StParam(":MotorSpeedMin", iMinSpeedValue));
    params.append(CDatabaseManage::StParam(":MotorSpeedMax", iMaxSpeedValue));
    params.append(CDatabaseManage::StParam(":FlowValueAvg", dAvgFlowValue));
    params.append(CDatabaseManage::StParam(":MotorSpeedAvg", iAvgSpeedValue));
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, query.lastError().type(),
               query.lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::deleteRunningRecordInfo(int iTestID)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "DELETE FROM RunningRecord WHERE TestingID = :TestingID";
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getRunningRecordList(int iPatientID, QSqlQuery &query)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "SELECT"
                     "	r.TestingID,"
                     "	r.StartDateTime,"
                     "	r.runMinute,"
                     "	r.DetailPath,"
                     "	r.FlowValueMin,"
                     "	r.FlowValueMax,"
                     "	r.MotorSpeedMin,"
                     "	r.MotorSpeedMax, "
                     "	r.FlowValueAvg,"
                     "	r.MotorSpeedAvg "
                     "FROM"
                     "	RunningRecord AS r "
                     "WHERE"
                     "	r.PatientID = :PatientID "
                     "ORDER BY"
                     "	r.TestingID ASC";
    params.append(CDatabaseManage::StParam(":PatientID", iPatientID));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, query.lastError().type(),
               query.lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getLastRunningRecord(int iPatientID, QSqlQuery &query)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "SELECT"
                     "	r.TestingID,"
                     "	r.StartDateTime,"
                     "	r.runMinute,"
                     "	r.DetailPath,"
                     "	r.FlowValueMin,"
                     "	r.FlowValueMax,"
                     "	r.MotorSpeedMin,"
                     "	r.MotorSpeedMax, "
                     "	r.FlowValueAvg,"
                     "	r.MotorSpeedAvg "
                     "FROM"
                     "	RunningRecord AS r "
                     "WHERE"
                     "	r.PatientID = :PatientID "
                     "ORDER BY"
                     "	r.TestingID DESC";
    params.append(CDatabaseManage::StParam(":PatientID", iPatientID));
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, query.lastError().type(),
               query.lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::insertActionRecord(int iTestingID, QString StrActionType, QString strParam)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "INSERT INTO ActionsRecord ("
                     "                              TestingID,"
                     "                              RecordingTime,"
                     "                              ActionType,"
                     "                              Params"
                     "                          )"
                     "                          VALUES ("
                     "                              :TestingID,"
                     "                              datetime('now','localtime'),"
                     "                              :ActionType,"
                     "                              :Params"
                     "                          );";
    params.append(CDatabaseManage::StParam(":TestingID", iTestingID));
    params.append(CDatabaseManage::StParam(":ActionType", StrActionType));
    params.append(CDatabaseManage::StParam(":Params", strParam));
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::updateActionRecord(int iID, int iTestingID, QString StrActionType, QString strParam)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "UPDATE ActionsRecord"
                     "   SET TestingID = :TestingID,"
                     "       ActionType = :ActionType,"
                     "       Params = :Params"
                     " WHERE ID = :ID;";
    params.append(CDatabaseManage::StParam(":TestingID", iTestingID));
    params.append(CDatabaseManage::StParam(":ActionType", StrActionType));
    params.append(CDatabaseManage::StParam(":Params", strParam));
    params.append(CDatabaseManage::StParam(":ID", iID));
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::deleteActionRecord(int iID)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "DELETE FROM ActionsRecord WHERE ID = :ID";
    params.append(CDatabaseManage::StParam(":ID", iID));
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getActionsByTestinID(int iTestingID, QSqlQuery &query)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "SELECT"
                     "	a.RecordingTime,"
                     "	a.ActionType,"
                     "	a.Params "
                     "FROM"
                     "	ActionsRecord AS a "
                     "WHERE"
                     "	a.TestingID = :TestingID "
                     " ORDER BY a.ID";
    params.append(CDatabaseManage::StParam(":TestingID", iTestingID));

    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, query.lastError().type(),
               query.lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getActionRecordByDate(int iTestID, QDate dDate, QSqlQuery &query)
{
    QString strSQL = "SELECT"
                     "	a.RecordingTime,"
                     "	a.ActionType,"
                     "	a.Params "
                     "FROM"
                     "	ActionsRecord AS a "
                     "WHERE"
                     "  date(a.RecordingTime) = :RecordingTime AND "
                     "	a.TestingID = :TestingID "
                     " ORDER BY a.ID";
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":RecordingTime", dDate));
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));

    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, query.lastError().type(),
               query.lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getWarningRecordByDate(int iTestID, QDate dDate, QSqlQuery &query)
{
    QString strSQL = "SELECT"
                     "  	w.ID,"
                     "  	w.TestingID,"
                     "  	w.WarningDateTime,"
                     "  	w.WarningName, "
                     "  	w.WarningType, "
                     "  	w.WarningTitle "
                     "  FROM"
                     "  	WarningsRecord AS w "
                     "  WHERE"
                     " date(w.WarningDateTime) = :WarningDateTime AND "
                     "  	(w.TestingID = :TestingID or w.TestingID  = 0) "
                     "  ORDER BY"
                     "  	w.ID ASC ";

    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":WarningDateTime", dDate));
    params.append(CDatabaseManage::StParam(":TestingID", iTestID));

    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, query.lastError().type(),
               query.lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::getAllActions(QSqlQuery &query, bool bAsc)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = QString("SELECT"
                     "	a.RecordingTime,"
                     "	a.ActionType,"
                     "	a.Params "
                     "FROM"
                             "	ActionsRecord AS a ")
                     +(bAsc ? " ORDER BY a.ID" : " ORDER BY a.ID DESC");

    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, query.lastError().type(),
               query.lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::insertWaringsRecords(int iTestingID, QString strWarningName, int iWarningType, QString strWarningTitle)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "INSERT INTO WarningsRecord ("
                     "                               TestingID,"
                     "                               WarningName,"
                     "                               WarningDateTime,"
                     "                               WarningType,"
                     "                               WarningTitle"
                     "                           )"
                     "                           VALUES ("
                     "                               :TestingID,"
                     "                               :WarningName,"
                     "                               datetime('now','localtime'),"
                     "                               :WarningType,"
                     "                               :WarningTitle"
                     "                           );";
    params.append(CDatabaseManage::StParam(":TestingID", iTestingID));
    params.append(CDatabaseManage::StParam(":WarningName", strWarningName));
    params.append(CDatabaseManage::StParam(":WarningType", iWarningType));
    params.append(CDatabaseManage::StParam(":WarningTitle", strWarningTitle));
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::updateWaringsRecords(int iID, int iTestingID, QString strWarningName, int iWarningType, QString strWarningTitle)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "UPDATE WarningsRecord"
                     "   SET TestingID = :TestingID,"
                     "       WarningName = :WarningName, "
                     "       WarningType = :WarningType, "
                     "       WarningTitle = :WarningTitle "
                     " WHERE ID = :ID";
    params.append(CDatabaseManage::StParam(":TestingID", iTestingID));
    params.append(CDatabaseManage::StParam(":WarningName", strWarningName));
    params.append(CDatabaseManage::StParam(":WarningType", iWarningType));
    params.append(CDatabaseManage::StParam(":WarningTitle", strWarningTitle));
    params.append(CDatabaseManage::StParam(":ID", iID));
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CTestingInfoDatas::deleteWaringsRecords(int iID)
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "DELETE FROM WarningsRecord WHERE ID = :ID";
    params.append(CDatabaseManage::StParam(":ID", iID));
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

void CTestingInfoDatas::initDataBase()
{
    QList<CDatabaseManage::StParam> params;
    QString strSQL = "  CREATE TABLE IF NOT EXISTS ActionsRecord ("
                     "    ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
                     "    TestingID INTEGER,"
                     "    RecordingTime DateTime,"
                     "    ActionType TEXT,"
                     "    Params TEXT"
                     "  );";
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return;
    }

    strSQL =         "  CREATE TABLE IF NOT EXISTS PatientInfo ("
                     "    ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
                     "    PatientName TEXT,"
                     "    Sex TEXT,"
                     "    Age INTEGER,"
                     "    PatientID TEXT,"
                     "    BloodType TEXT,"
                     "    Weight REAL,"
                     "    Height REAL,"
                     "    ImplantationTime DATETIME,"
                     "    CreateDate DATETIME "

             "  );";
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return;
    }

    strSQL = "  CREATE TABLE IF NOT EXISTS RunningDetailRecord ("
             "    ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
             "    TestingID INTEGER,"
             "    RecordDate DateTime,"
             "    FlowVolume real,"
             "    SpeedValue REAL"
             "  );";
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return;
    }

    strSQL = "  CREATE TABLE IF NOT EXISTS RunningRecord ("
             "    TestingID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
             "    PatientID INTEGER,"
             "    StartDateTime DateTime,"
             "    runMinute integer,"
             "    TestDone BOOLEAN,"
             "    DetailPath TEXT,"
             "    CreateDate DATETIME, "
             "    FlowValueMin REAL DEFAULT 2.4, "
             "    FlowValueMax REAL DEFAULT 4.6, "
             "    MotorSpeedMin REAL DEFAULT 1500, "
             "    MotorSpeedMax REAL DEFAULT 4600, "
             "    FlowValueAvg REAL DEFAULT 0, "
             "    MotorSpeedAvg REAL DEFAULT 0 "
             "  );";
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return;
    }

    strSQL = "  CREATE TABLE IF NOT EXISTS WarningsRecord ("
             "    ID INTEGER NOT NULL,"
             "    TestingID INTEGER,"
             "    WarningName TEXT,"
             "    WarningType INTEGER,"
             "    WarningTitle TEXT,"
             "    WarningDateTime DateTime,"
             "    solved BOOL DEFAULT 0, "
             "    PRIMARY KEY (ID)"
             "  );";
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
        return;
    }

//    strSQL = "  CREATE TABLE IF NOT EXISTS sqlite_sequence ("
//             "    name,"
//             "    seq"
//             "  );";

//    if(!m_pDB->execSql(strSQL, params))
//    {
//        qDebug("%s %d exec sql fail, error code: %d, error: %s", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type(),
//               m_pDB->m_pQuery->lastError().text().toUtf8().constData());
//        return;
//    }


}

int CTestingInfoDatas::checkDabaBase()
{
    if(m_pDB == Q_NULLPTR){
        qDebug("%s %d exec sql fail, db is null!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDBIsNull;
    }
    if(!m_pDB->isValid())
    {
        qDebug("%s %d exec sql fail, db is isValid!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDbisInvalid;
    }
    return CDatabaseManage::DBENoErr;
}
