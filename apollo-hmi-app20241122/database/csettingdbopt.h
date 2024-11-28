/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : csettingdbopt.h
  Version       : 1.0
  Author        : han
  Created       : 2024-08-14
  Last Modified :
  Description   :  header file
  Function List :
  History       :
  1.Date        : 2024-08-14
    Author      : fensnote
    Modification: Created file

******************************************************************************/
#ifndef CSETTINGDBOPT_H
#define CSETTINGDBOPT_H

#include <QObject>
#include <QQmlEngine>
#include <QJsonObject>
#include "cdatabasemanage.h"

class CSettingDBOpt : public QObject
{
    Q_OBJECT
//    QML_ELEMENT
public:
    explicit CSettingDBOpt(QObject *parent = nullptr);
    ~CSettingDBOpt();
signals:
public:
    //获取参数接口
    Q_INVOKABLE QString getParam(const QString varName, const double &dDefaultMinValue, const double &dDefaultMaxValue);
    int getPararmByC(const QString varName, double &dMinValue, double &dMaxValue);
    //更新新参数接口
    Q_INVOKABLE int setParam(const QString varName, const double dMinValue, const double dMaxValue);
private:
    void initTables();
    ////////////////////////参数读写部分//////////////////////////////////////////////////////
    //读参数内部接口
    int checkDabaBase();
    int _getParam(const QString varName, double &dMinValue, double &dMaxValue);
    int _insertParam(const QString varName, const double dMinValue, const double dMaxValue);
    int _updateParam(const QString varName, const double dMinValue, const double dMaxValue);
public:
    Q_INVOKABLE void setIniValue(QString strKey, QString strValue);
    Q_INVOKABLE QString getIniValue(QString strKey);
public:
    //获取参数接口
    Q_INVOKABLE QString getSysParam(const QString paramName, const QString defaultParamValue, const QString defaultParamTitile = "");
    //更新新参数接口
    Q_INVOKABLE int setSysParam(const QString paramName, const QString paramValue, const QString paramTitile = "");
private:
    //读参数内部接口
    int _getSysParam(const QString paramName, QString &strParmaValue);
    //插入参数内部接口
    int _insertSysParam(const QString paramName, const QString paramTitile, const QString paramValue);
    //更新参数内部接口
    int _updateSysParam(const QString paramName, const QString paramValue);
public:
    Q_INVOKABLE QJsonObject getWarningSettingByName(QString strWaringName);
    int getWarningSettingByName(QString strWaringName, int &iWarningType, QString &strWaringTitle, int &iMuteable, int &iLatching, int &iTrigOnRun);

    Q_INVOKABLE QJsonObject getActionByName(QString strActionName);
    int getActionByName(QString strActionName, QString &strActionTitle);
private:
    QSqlQuery m_WarningsQuery;
    QSqlQuery m_ActionsQuerys;
private:
    CDatabaseManage *m_pDB{Q_NULLPTR};
};

#endif // CSETTINGDBOPT_H
