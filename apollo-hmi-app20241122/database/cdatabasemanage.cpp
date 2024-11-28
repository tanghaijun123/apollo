#include "cdatabasemanage.h"
#include <QDebug>
#include <QApplication>
#include <QSqlError>
#include <QMutex>
#include <QMutexLocker>
#include <QDir>
#include <QSharedPointer>
#include <QMap>
#include <QFileInfo>
QMutex m_nMutexSetting;
QMutex m_nMutexTesting;
QMutex m_mMutexTestDetail;
QMap<QString, QMutex*> m_nMutexs;
QMutex m_createMutex;

/******************************************************************************/
/*! @File        : cdatabasemanage.cpp
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

CDatabaseManage::CDatabaseManage(QString strDataBaseName, long iThreadID, int iIndex)
{
    QMutexLocker locker(&m_createMutex);

    const QString strDataBasePassword = "Apollo_db_886";
    m_strDataBaseName = strDataBaseName;
    m_iThreadID = iThreadID;

    QString strPath = QString("%1/database/%2").arg(QCoreApplication::applicationDirPath(), strDataBaseName) ;

    QString strConnectionName = QString("con_%1_%2_%3").arg(strDataBaseName).arg(iThreadID).arg(iIndex);
    QFileInfo fileInfo(strPath);
    QString strCurPath = fileInfo.path();
    QDir curDir(strCurPath);
    if(!curDir.exists()){
        if(!curDir.mkpath(strCurPath))
        {
            qDebug("%s %d create path %s fail", __FILE__, __LINE__, strCurPath.toUtf8().constEnd());
            return;
        }
    }

    if(m_strDataBaseName != DB_SETTING_NAME && m_strDataBaseName != DB_TESTING_NAME){
        m_strDataBaseName = DB_TESTING_DETAIL_NAME;
    }
    if(!m_nMutexs.contains(m_strDataBaseName))
    {
        if(m_strDataBaseName == DB_SETTING_NAME){
            m_nMutexs.insert(m_strDataBaseName, &m_nMutexSetting);
        }
        else if(m_strDataBaseName == DB_TESTING_NAME){
            m_nMutexs.insert(m_strDataBaseName, &m_nMutexTesting);
        }
        else{
            m_nMutexs.insert(m_strDataBaseName, &m_mMutexTestDetail);
        }
    }
    bool bNeedCreateKey = false;

    if(QSqlDatabase::contains(strConnectionName))
    {
        m_dataBaseObj = QSqlDatabase::database(strConnectionName);
    }
    else
    {
        if(QFile::exists(strPath)){
            //delete on used
//            m_dataBaseObj = QSqlDatabase::addDatabase("QSQLITE", strConnectionName);
//            m_dataBaseObj.setDatabaseName(strPath);
//            if(m_dataBaseObj.open()){
//                m_dataBaseObj.close();
//                bNeedCreateKey = true;
//            }
//            QSqlDatabase::removeDatabase(strConnectionName);
        }
        else {
            bNeedCreateKey = true;
        }
        m_dataBaseObj = QSqlDatabase::addDatabase("SQLITECIPHER", strConnectionName);
    }
    m_dataBaseObj.setDatabaseName(strPath);
    //qDebug() << QSqlDatabase::drivers();

    if(bNeedCreateKey){
        m_dataBaseObj.setConnectOptions("QSQLITE_USE_CIPHER=aes128cbc; SQLCIPHER_LEGACY=1; SQLCIPHER_LEGACY_PAGE_SIZE=4096; QSQLITE_CREATE_KEY");
    }
    else{
       m_dataBaseObj.setConnectOptions("QSQLITE_USE_CIPHER=aes128cbc; SQLCIPHER_LEGACY=1; SQLCIPHER_LEGACY_PAGE_SIZE=4096");
    }
    m_dataBaseObj.setPassword(strDataBasePassword);

//    m_dataBaseObj.setUserName(m_strUserName);
//    m_dataBaseObj.setPassword(m_strPassword);
    if( m_dataBaseObj.open())
    {
        if(m_pQuery)
        {
            delete m_pQuery;
        }
        m_pQuery = new QSqlQuery(m_dataBaseObj);        
        // m_tLastAciveTime= QDateTime::currentDateTime();
    }    
    else
    {
        qDebug() << "CDatabaseManage" << strConnectionName << "open failed";
        m_dataBaseObj.setPassword(strDataBasePassword);
        if( m_dataBaseObj.open())
        {
            if(m_pQuery)
            {
                delete m_pQuery;
            }
            m_pQuery = new QSqlQuery(m_dataBaseObj);
            // m_tLastAciveTime= QDateTime::currentDateTime();
        }
        else{
            int iTimes = 0;
            //if(m_dataBaseObj.lastError().type() == 2006 ||  m_dataBaseObj.lastError().type() == 2013)
            while(iTimes < 3)
            {
                m_dataBaseObj.close();
                QElapsedTimer time;
                time.start();
                while(time.elapsed() < 300)
                {
                    QCoreApplication::processEvents();
                }
                //m_dataBaseObj.open();

                if(m_dataBaseObj.open())
                {
                    if(m_pQuery)
                    {
                        delete m_pQuery;
                    }
                    m_pQuery = new QSqlQuery(m_dataBaseObj);
                    return;
                }
                iTimes ++;
            }

            if(iTimes == 3) {
                qDebug() << "CDatabaseManage" << strConnectionName << "open failed";
            }
        }
    }
}

CDatabaseManage::~CDatabaseManage()
{
    if(m_dataBaseObj.isOpen()){
        m_dataBaseObj.close();
    }

    if(m_pQuery){
        delete m_pQuery;
        m_pQuery = Q_NULLPTR;
    }
}

bool CDatabaseManage::execSql(const QString strSQL, QList<StParam> &bindValues)
{
    if(!m_pQuery)
        return false;
    QMutexLocker locker(m_nMutexs[m_strDataBaseName]);

    m_pQuery->prepare(strSQL);
    foreach (StParam param, bindValues) {
        m_pQuery->bindValue(param.Name, param.Value);
    }

    return m_pQuery->exec();
}

bool CDatabaseManage::execSql(QSqlQuery &query, const QString strSQL, QList<StParam> &bindValues)
{
    QMutexLocker locker(m_nMutexs[m_strDataBaseName]);
    query = QSqlQuery(m_dataBaseObj);
    query.prepare(strSQL);
    foreach (StParam param, bindValues) {
        query.bindValue(param.Name, param.Value);
    }

    return query.exec();
}

bool CDatabaseManage::execSqlNoLock(const QString strSQL, QList<StParam> &bindValues)
{
    if(!m_pQuery)
        return false;

    m_pQuery->prepare(strSQL);
    foreach (StParam param, bindValues) {
        m_pQuery->bindValue(param.Name, param.Value);
    }

    return m_pQuery->exec();
}

bool CDatabaseManage::execSqlNoLock(QSqlQuery &query, const QString strSQL, QList<StParam> &bindValues)
{
    query = QSqlQuery(m_dataBaseObj);
    query.prepare(strSQL);
    foreach (StParam param, bindValues) {
        query.bindValue(param.Name, param.Value);
    }

    return query.exec();
}

bool CDatabaseManage::isValid()
{
    return (m_pQuery != Q_NULLPTR)  && m_dataBaseObj.isOpen();
}

void CDatabaseManage::createPasswd()
{
    //QString strSQL = "PRAGMA key = %s;";
   // execSql();
}
