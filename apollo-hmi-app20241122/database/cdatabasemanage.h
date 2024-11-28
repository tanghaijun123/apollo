/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : cdatabasemanage.h
  Version       : 1.0
  Author        : han
  Created       : 2024-08-12
  Last Modified :
  Description   :  header file
  Function List :
  History       :
  1.Date        : 2024-08-12
    Author      : fensnote
    Modification: Created file

******************************************************************************/

#ifndef CDATABASEMANAGE_H
#define CDATABASEMANAGE_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QThread>
#include <QVariant>

class CDatabaseManage
{

public:
    /**
     * @brief The emDataBaseErr enum 数据库异常
     */
    enum emDataBaseErr{
        DBENoErr = 0,  //No error
        DBEDBIsNull = 1,  //m_pDB is null
        DBEDbisInvalid ,    // db is invalid
        DBEExecFail,   //exec fail
        DBEDBFileNotFind , // db file not find
        DBEDBRecodeNotFind , // recode not find


        DBEDObjectIsNull, //object is null

        DBELogFileopneFile, //write log file, open fail
        DBELogFileCreatePathFail, //write log file, create path fail
        DBEDateTimeisInValid, //date time is Invalid
        DBEUSBDiskNotFind, //usb disk not find
        DBEAbstractSeriesIsNull, //AbstractSeries is null;
        DBETestingIDNotFind, //Testing record not find;
    };
//设置数据库
#define DB_SETTING_NAME "setting.db"
//测试数据库
#define DB_TESTING_NAME "testing.db"
//曲线数据库
#define DB_TESTING_DETAIL_NAME "testDetail"
public:
    //数据对象
    QSqlDatabase m_dataBaseObj; //数据库指针（系统类）
    QSqlQuery *m_pQuery{Q_NULLPTR};         //数据库查询（系统类）
    //数据库查询参数
    struct  StParam
    {
        QString Name;
        QVariant Value;
        StParam() {
            Name = QString();
            Value = QVariant();
        }
        StParam(QString Name, QVariant Value ) {
            this->Name = Name;
            this->Value = Value;
        }
    };
public:
    /**
     * @brief CDatabaseManage 创建数据库连接对象
     * @param strDataBaseName 数据库名，取上面数据库名称
     * @param iThreadID //数据闸连接线程所在线程
     * @param iIndex 同一线程中不同连接的序号
     */
    explicit CDatabaseManage(QString strDataBaseName = DB_SETTING_NAME, long iThreadID = reinterpret_cast<long long>(QThread::currentThreadId()), int iIndex =0);


    ~CDatabaseManage();
public:
    /**
     * @brief execSql 执行数据库查询操作
     * @param strSQL 查询诗句
     * @param bindValues 查询参数
     * @return  emDataBaseErr
     */
    bool execSql(const QString strSQL, QList<StParam> & bindValues);
    /**
     * @brief execSql 执行数据库查询操作
     * @param query 外部传入的QSqlQuery对象
     * @param strSQL 查询诗句
     * @param bindValues 查询参数
     * @return emDataBaseErr
     */
    bool execSql(QSqlQuery &query, const QString strSQL, QList<StParam> & bindValues);
    /**
     * @brief execSqlNoLock 加锁执行数据库查询操作,数据更新时使用
     * @param strSQL 查询诗句
     * @param bindValues 查询参数
     * @return
     */
    bool execSqlNoLock(const QString strSQL, QList<StParam> & bindValues);
    /**
     * @brief execSqlNoLock 数据更新时使用
     * @param query 外部传入的QSqlQuery对象
     * @param strSQL 查询诗句
     * @param bindValues 查询参数
     * @return emDataBaseErr
     */
    bool execSqlNoLock(QSqlQuery &query, const QString strSQL, QList<StParam> & bindValues);
    /**
     * @brief isValid 数据更新时使用连接是否正常
     * @return
     */
    bool isValid();
private:
    /**
     * @brief createPasswd
     */
    void createPasswd();
private:
    //当前数据库连接名称
    /**
     * @brief m_strDataBaseName
     */
    QString m_strDataBaseName{""};

    /**
     * @brief m_iThreadID
     */
    long m_iThreadID;

};

#endif // CDATABASEMANAGE_H
