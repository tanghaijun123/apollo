/******************************************************************************/
/*! @File        : csettingdbopt.cpp
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

#include "csettingdbopt.h"
#include <QDebug>
#include <qsqlerror.h>
#include <QSettings>
#include <QApplication>


CSettingDBOpt::CSettingDBOpt(QObject *parent)
    : QObject{parent}
{
    m_pDB = new CDatabaseManage(DB_SETTING_NAME);
    if(!m_pDB)
    {
        qDebug("%s %d CDatabaseManage create file", __FILE__, __LINE__);
        return;
    }
    if(m_pDB->isValid()){
        initTables();
    }
}

CSettingDBOpt::~CSettingDBOpt()
{
    if(m_pDB){
        delete m_pDB;
        m_pDB = Q_NULLPTR;
    }
}

QString CSettingDBOpt::getParam(const QString varName, const double &dDefaultMinValue, const double &dDefaultMaxValue)
{
    double dMinValue = 0;
    double dMaxValue = 0;
    const QString conStrReturnFmt = "{\"res\":%1,\"minValue\":%2,\"maxValue\":%3}";
    int iReturn = _getParam(varName, dMinValue, dMaxValue);
    if(iReturn == CDatabaseManage::DBEDBRecodeNotFind){
        iReturn = _insertParam(varName, dDefaultMinValue, dDefaultMaxValue);
        return QString(conStrReturnFmt).arg(iReturn).arg(dDefaultMinValue).arg(dDefaultMaxValue);
    }
    return QString(conStrReturnFmt).arg(iReturn).arg(dMinValue).arg(dMaxValue);
}

int CSettingDBOpt::getPararmByC(const QString varName, double &dMinValue, double &dMaxValue)
{
    int iReturn = _getParam(varName, dMinValue, dMaxValue);
    if(iReturn == CDatabaseManage::DBEDBRecodeNotFind){
        iReturn = _insertParam(varName, dMinValue, dMinValue);
    }
    return iReturn;
}

int CSettingDBOpt::setParam(const QString varName, const double dMinValue, const double dMaxValue)
{
    double dcurMinValue = 0;
    double dcurMaxValue = 0;
    int iReturn = _getParam(varName, dcurMinValue, dcurMaxValue);
    if(iReturn == CDatabaseManage::DBEDBRecodeNotFind){
        return _insertParam(varName, dMinValue, dMaxValue);
    }
    return _updateParam(varName, dMinValue, dMaxValue);
}

void CSettingDBOpt::initTables()
{
    QString strSQL = "CREATE TABLE IF NOT EXISTS warningseting(id INTEGER PRIMARY KEY AUTOINCREMENT, varName TEXT, rangeMin REAL, rangeMax REAL)";
    QList<CDatabaseManage::StParam> params;
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type());
        return;
    }

    strSQL = "CREATE TABLE IF NOT EXISTS appParams(id INTEGER PRIMARY KEY AUTOINCREMENT, paramName TEXT, paramTitile TEXT, paramValue TEXT)";
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type());
        return;
    }

    strSQL = "CREATE TABLE IF NOT EXISTS Actions ("
             "    ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
             "    ActionType integer,"
             "    ActionName TEXT,"
             "    ActionTitile TEXT,"
             "    params TEXT"
             "  );";
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type());
        return;
    }

    strSQL = "CREATE TABLE IF NOT EXISTS Warnings ("
             "    ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
             "    WarningType integer NOT NULL,"
             "    WarningName TEXT NOT NULL,"
             "    WarningTitle TEXT,"
             "    Muteable integer NOT NULL,"
             "    Latching integer NOT NULL"
             "  );";
    if(!m_pDB->execSql(strSQL, params))
    {
        qDebug("%s %d exec sql fail, error code: %d", __FILE__, __LINE__, m_pDB->m_pQuery->lastError().type());
        return;
    }
}

int CSettingDBOpt::checkDabaBase()
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

int CSettingDBOpt::_getParam(const QString varName, double &dMinValue, double &dMaxValue)
{
    int iReturn = checkDabaBase();
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d exec sql fail, Db check error code: %d!", __FILE__, __LINE__, iReturn);
        return iReturn;
    }

    QString strSQL= "SELECT rangeMin, rangeMax FROM warningseting WHERE varName= :varName";
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":varName", varName));
    QSqlQuery query;
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, execSql fail, error code: %d !", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }

    if(!query.next()){
        return CDatabaseManage::DBEDBRecodeNotFind;
    }

    dMinValue = query.value("rangeMin").toDouble();
    dMaxValue = query.value("rangeMax").toDouble();

    return CDatabaseManage::DBENoErr;
}

int CSettingDBOpt::_insertParam(const QString varName, const double dMinValue, const double dMaxValue)
{
    int iReturn = checkDabaBase();
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d exec sql fail, Db check error code: %d!", __FILE__, __LINE__, iReturn);
        return iReturn;
    }

    QString strSQL= "INSERT INTO warningseting(varName, rangeMin, rangeMAX) VALUES(:varName, :rangeMin, :rangeMAX)";
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":varName", varName));
    params.append(CDatabaseManage::StParam(":rangeMin", dMinValue));
    params.append(CDatabaseManage::StParam(":rangeMAX", dMaxValue));
    QSqlQuery query;
    if(!m_pDB->execSql(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, execSql fail, error code: %d !", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CSettingDBOpt::_updateParam(const QString varName, const double dMinValue, const double dMaxValue)
{
    int iReturn = checkDabaBase();
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d exec sql fail, Db check error code: %d!", __FILE__, __LINE__, iReturn);
        return iReturn;
    }

    QString strSQL= "UPDATE warningseting SET rangeMin= :rangeMin, rangeMAX= :rangeMAX WHERE varName= :varName";
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":varName", varName));
    params.append(CDatabaseManage::StParam(":rangeMin", dMinValue));
    params.append(CDatabaseManage::StParam(":rangeMAX", dMaxValue));
    QSqlQuery query;
    if(!m_pDB->execSql(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, execSql fail, error code: %d !", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

void CSettingDBOpt::setIniValue(QString strKey, QString strValue)
{
    QString iniFilePath = QApplication::applicationDirPath()+QString("/config.ini");
    QSettings setting(iniFilePath, QSettings::IniFormat);
    setting.setValue(strKey, strValue);
}

QString CSettingDBOpt::getIniValue(QString strKey)
{
    QString iniFilePath = QApplication::applicationDirPath()+QString("/config.ini");
    QSettings setting(iniFilePath, QSettings::IniFormat);
    return setting.value(strKey, "").toString();
}

QString CSettingDBOpt::getSysParam(const QString paramName, const QString defaultParamValue, const QString defaultParamTitile)
{
    const QString conStrReturnFmt = "{\"res\":%1,\"param\":%2}";
    QString strParamValue = "";
    int iResult = _getSysParam(paramName, strParamValue);
    if(iResult == CDatabaseManage::DBEDBRecodeNotFind){
        iResult = _insertSysParam(paramName, defaultParamValue, defaultParamTitile);
        return QString(conStrReturnFmt).arg(iResult).arg(defaultParamValue);
    }

    return QString(conStrReturnFmt).arg(iResult).arg(strParamValue);
}

int CSettingDBOpt::setSysParam(const QString paramName, const QString paramValue, const QString paramTitile)
{
    QString strCurParam = "";
    int iReturn = _getSysParam(paramName, strCurParam);
    if(iReturn == CDatabaseManage::DBEDBRecodeNotFind){
        return _insertSysParam(paramName, paramValue, paramTitile);
    }
    return _updateSysParam(paramName, paramValue);
}

int CSettingDBOpt::_getSysParam(const QString paramName, QString &strParmaValue)
{
    int iReturn = checkDabaBase();
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d exec sql fail, Db check error code: %d!", __FILE__, __LINE__, iReturn);
        return iReturn;
    }

    QString strSQL= "SELECT paramValue FROM appParams WHERE paramName= :paramName";
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":paramName", paramName));
    QSqlQuery query;
    if(!m_pDB->execSqlNoLock(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, execSql fail, error code: %d !", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }

    if(!query.next()){
        return CDatabaseManage::DBEDBRecodeNotFind;
    }

    strParmaValue = query.value("paramValue").toString();

    return CDatabaseManage::DBENoErr;
}

int CSettingDBOpt::_insertSysParam(const QString paramName, const QString paramTitile, const QString paramValue)
{
    int iReturn = checkDabaBase();
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d exec sql fail, Db check error code: %d!", __FILE__, __LINE__, iReturn);
        return iReturn;
    }

    QString strSQL= "INSERT INTO appParams(paramName, paramTitile, paramValue) VALUES(:paramName,:paramTitile,:paramValue)";
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":paramName", paramName));
    params.append(CDatabaseManage::StParam(":paramTitile", paramTitile));
    params.append(CDatabaseManage::StParam(":paramValue", paramValue));
    QSqlQuery query;
    if(!m_pDB->execSql(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, execSql fail, error code: %d !", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

int CSettingDBOpt::_updateSysParam(const QString paramName, const QString paramValue)
{
    int iReturn = checkDabaBase();
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d exec sql fail, Db check error code: %d!", __FILE__, __LINE__, iReturn);
        return iReturn;
    }

    QString strSQL= "UPDATE appParams SET paramValue = :paramValue WHERE paramName= :paramName";
    QList<CDatabaseManage::StParam> params;
    params.append(CDatabaseManage::StParam(":paramValue", paramName));
    params.append(CDatabaseManage::StParam(":paramName", paramValue));
    QSqlQuery query;
    if(!m_pDB->execSql(query, strSQL, params))
    {
        qDebug("%s %d exec sql fail, execSql fail, error code: %d !", __FILE__, __LINE__, query.lastError().type());
        return CDatabaseManage::DBEExecFail;
    }

    return CDatabaseManage::DBENoErr;
}

QJsonObject CSettingDBOpt::getWarningSettingByName(QString strWaringName)
{
    int iWarningType = 0;
    int iMuteable = 0;
    int iLatching = 0;
    int iTrigOnRun = 0;
    QString strWaringTitle = "";

    int iResult = getWarningSettingByName(strWaringName, iWarningType, strWaringTitle, iMuteable, iLatching, iTrigOnRun);
    return QJsonObject({{"res", iResult},{"WarningType", iWarningType}, {"WaringTitle", strWaringTitle},{"Muteable", iMuteable},{"Latching", iLatching}});
}

int CSettingDBOpt::getWarningSettingByName(QString strWaringName, int &iWarningType, QString &strWaringTitle, int &iMuteable, int &iLatching, int &iTrigOnRun)
{
    iWarningType = 0;
    strWaringTitle = "";
    if(!m_WarningsQuery.isActive()){
        QString strSQL = "SELECT"
                         "  	w.ID,"
                         "  	w.WarningType,"
                         "  	w.WarningName,"
                         "  	w.WarningTitle,"
                         "  	w.Muteable, "
                         "  	w.Latching,"
                         "      w.TrigOnRun"
                         "  FROM"
                         "  	Warnings AS w "
                         "  ORDER BY"
                         "  	w.ID ASC";
        QList<CDatabaseManage::StParam> params;
        if(!m_pDB->execSqlNoLock(m_WarningsQuery, strSQL, params))
        {
            qDebug("%s %d exec sql fail, execSql fail, error code: %d !", __FILE__, __LINE__, m_WarningsQuery.lastError().type());
            return CDatabaseManage::DBEExecFail;
        }
        int n = 0;
        while(m_WarningsQuery.next()){
           // qDebug() << m_WarningsQuery.value("WarningName").toString();
            n++;
        }
        //qDebug("%s %d waring count: %d", __FILE__, __LINE__, n);
    }

    if(m_WarningsQuery.first())
    {
        //m_WarningsQuery.previous();
        if(m_WarningsQuery.value("WarningName").toString() == strWaringName){
            iWarningType = m_WarningsQuery.value("WarningType").toInt();
            strWaringTitle = m_WarningsQuery.value("WarningTitle").toString();
            iMuteable = m_WarningsQuery.value("Muteable").toInt();
            iLatching = m_WarningsQuery.value("Latching").toInt();
            iTrigOnRun = m_WarningsQuery.value("TrigOnRun").toInt();
        }
        else{
            while(m_WarningsQuery.next()){
                if(m_WarningsQuery.value("WarningName").toString() == strWaringName){
                    iWarningType = m_WarningsQuery.value("WarningType").toInt();
                    strWaringTitle = m_WarningsQuery.value("WarningTitle").toString();
                    iMuteable = m_WarningsQuery.value("Muteable").toInt();
                    iLatching = m_WarningsQuery.value("Latching").toInt();
                    iTrigOnRun = m_WarningsQuery.value("TrigOnRun").toInt();
                    break;
                }
            }
        }
    }

    //qInfo() << "CSettingDBOpt::getWarningSettingByName" << strWaringName << strWaringTitle << iWarningType;

    return CDatabaseManage::DBENoErr;
}

QJsonObject CSettingDBOpt::getActionByName(QString strActionName)
{
    QString strActionTitle = "";
    int iResult = getActionByName(strActionName, strActionTitle);
    return QJsonObject({{"res", iResult},{"ActionTitle", strActionTitle}});
}

int CSettingDBOpt::getActionByName(QString strActionName, QString &strActionTitle)
{
    strActionTitle = "";
    if(!m_ActionsQuerys.isActive()){
        QString strSQL = "SELECT"
                         "  	a.ID,"
                         "  	a.ActionName,"
                         "  	a.ActionTitile,"
                         "  	a.params "
                         "  FROM"
                         "  	Actions AS a "
                         "  ORDER BY"
                         "  	a.ID ASC";
        QList<CDatabaseManage::StParam> params;
        if(!m_pDB->execSqlNoLock(m_ActionsQuerys, strSQL, params))
        {
            qDebug("%s %d exec sql fail, execSql fail, error code: %d !", __FILE__, __LINE__, m_ActionsQuerys.lastError().type());
            return CDatabaseManage::DBEExecFail;
        }
        int n = 0;
        while(m_ActionsQuerys.next()){
            //qDebug() << m_ActionsQuerys.value("ActionName").toString();
            n++;
        }
        //qDebug("%s %d actions count: %d", __FILE__, __LINE__, n);
    }


    if(m_ActionsQuerys.first())
    {
        //m_ActionsQuerys.previous();
        if(m_ActionsQuerys.value("ActionName").toString() == strActionName){
            strActionTitle = m_ActionsQuerys.value("ActionTitile").toString();
        }
        else{
            while(m_ActionsQuerys.next()){
                if(m_ActionsQuerys.value("ActionName").toString() == strActionName){
                    strActionTitle = m_ActionsQuerys.value("ActionTitile").toString();
                    break;
                }
            }
        }
    }

    return CDatabaseManage::DBENoErr;
}
