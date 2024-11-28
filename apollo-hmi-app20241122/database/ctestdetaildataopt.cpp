
/******************************************************************************/
/*! @File        : ctestdetaildataopt.cpp
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

#include "ctestdetaildataopt.h"
#include "ctestdetaildatas.h"
#include <QApplication>
#include <QSqlQuery>
#include <QJsonArray>
#include <QtCharts>
#include <QPointF>
#include <QDebug>


CTestDetailDataOpt::CTestDetailDataOpt(QObject *parent)
    : QObject{parent}
{
}

QJsonObject CTestDetailDataOpt::getAllData(int iTestID)
{
    CTestDetailDatas db(conDetailDBPath, iTestID, this);
    QSqlQuery query;
    int iResult = db.getAllData(iTestID, query);
    QJsonObject jResult;
    jResult["res"] = iResult;
    QJsonArray data;
    while(query.next()){
        data.append(QJsonObject({{"DateTime", query.value("RecordDate").toDateTime().toString("yyyy-hh-ss hh:mm:ss")},
                                 {"FlowVolume",query.value("FlowVolume").toDouble()},
                                 {"SpeedValue",query.value("SpeedValue").toInt()}}));
    }
    jResult["data"] = data;
    return jResult;
}

int CTestDetailDataOpt::getAllData(int iTestID, QtCharts::QAbstractSeries *pLineFlowVolume, QtCharts::QAbstractSeries *pSpeedValue)
{
    if(pLineFlowVolume == Q_NULLPTR){
        qDebug("%s %d pLineFlowVolume is null!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDObjectIsNull;
    }

    if(pSpeedValue == Q_NULLPTR){
        qDebug("%s %d pSpeedValue is null!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDObjectIsNull;
    }

    QtCharts::QLineSeries* pCurLineFlowVolume = qobject_cast<QtCharts::QLineSeries*>(pLineFlowVolume);
    QtCharts::QLineSeries* pCurSpeedValue = qobject_cast<QtCharts::QLineSeries*>(pSpeedValue);
    CTestDetailDatas db(conDetailDBPath, iTestID, this);
    QSqlQuery query;
    int iResult = db.getAllData(iTestID, query);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d getAllData return %d!", __FILE__, __LINE__, iResult);
        return CDatabaseManage::DBEDObjectIsNull;
    }
    if(pCurLineFlowVolume->parent()){
        pCurLineFlowVolume->parent()->blockSignals(true);
    }
    pCurLineFlowVolume->blockSignals(true);
    pCurSpeedValue->blockSignals(true);
    pCurLineFlowVolume->clear();
    pCurSpeedValue->clear();
    while(query.next()){
        pCurLineFlowVolume->append(query.value("RecordDate").toDateTime().toMSecsSinceEpoch()/*toDouble()*/, query.value("FlowVolume").toDouble());
        pCurSpeedValue->append(query.value("RecordDate").toDateTime().toMSecsSinceEpoch()/*toDouble()*/, query.value("SpeedValue").toInt());
    }
    pCurSpeedValue->blockSignals(false);
    pCurLineFlowVolume->blockSignals(false);
    if(pCurLineFlowVolume->parent()){
        pCurLineFlowVolume->parent()->blockSignals(false);
    }

    return CDatabaseManage::DBENoErr;
}

QJsonObject CTestDetailDataOpt::getAllDatesInTest(int iTestID)
{
    CTestDetailDatas db(conDetailDBPath, iTestID, this);
    QStringList dates;
    int iResult = db.getAllDatesInTest(iTestID, dates);
    QJsonObject jResult;
    jResult["res"] = iResult;
    QJsonArray data;
    for(int i = 0; i < dates.size(); i++){
        data.append(QJsonObject({{"date", dates[i]}}));
    }
    jResult["data"] = data;
    return jResult;
}

QJsonObject CTestDetailDataOpt::getDataByDate(QString dDate, int iTestID)
{
    CTestDetailDatas db(conDetailDBPath, iTestID, this);
    QSqlQuery query;
    int iResult = db.getDataByDate(iTestID, QDate::fromString(dDate, "yyyy/MM/dd"), query);
    QJsonObject jResult;
    jResult["res"] = iResult;
    QJsonArray data;
    while(query.next()){
        data.append(QJsonObject({{"DateTime", query.value("RecordDate").toDateTime().toString("yyyy-hh-ss hh:mm:ss")},
                                 {"FlowVolume",query.value("FlowVolume").toDouble()},
                                 {"SpeedValue",query.value("SpeedValue").toInt()}}));
    }
    jResult["data"] = data;
    return jResult;
}

int CTestDetailDataOpt::getDataByDate(QString dDate, int iTestID, QtCharts::QAbstractSeries *pLineFlowVolume, QtCharts::QAbstractSeries *pSpeedValue)
{
    //qDebug()<<"CTestDetailDataOpt::getDataByDate dDate"<<dDate;
    if(pLineFlowVolume == Q_NULLPTR){
        qDebug("%s %d pLineFlowVolume is null!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDObjectIsNull;
    }    

    if(pSpeedValue == Q_NULLPTR){
        qDebug("%s %d pSpeedValue is null!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDObjectIsNull;
    }

    QtCharts::QLineSeries* pCurLineFlowVolume = qobject_cast<QtCharts::QLineSeries*>(pLineFlowVolume);
    QtCharts::QLineSeries* pCurSpeedValue = qobject_cast<QtCharts::QLineSeries*>(pSpeedValue);
    if(!pCurLineFlowVolume || !pCurSpeedValue){
        qDebug("%s %d QAbstractSeries is null!", __FILE__, __LINE__);
        return CDatabaseManage::DBEAbstractSeriesIsNull;
    }

    CTestDetailDatas db(conDetailDBPath, iTestID, this);
    QSqlQuery query;
    QDate dt = QDate::fromString(dDate, "yyyy/MM/dd");
    if(!dt.isValid()){
        qDebug("%s %d date is invalid!", __FILE__, __LINE__);
        return CDatabaseManage::DBEDateTimeisInValid;
    }
    int iResult = db.getDataByDate(iTestID, QDate::fromString(dDate, "yyyy/MM/dd"), query);
    if(iResult != CDatabaseManage::DBENoErr){
        qDebug("%s %d getAllData return %d!", __FILE__, __LINE__, iResult);
        return CDatabaseManage::DBEDObjectIsNull;
    }
    //QtCharts::ChartDataSet *pChart = qobject_cast<QChart *>(pCurLineFlowVolume->parent());
    if(pCurLineFlowVolume->parent()){
        pCurLineFlowVolume->parent()->blockSignals(true);
    }
    pCurLineFlowVolume->blockSignals(true);
    pCurSpeedValue->blockSignals(true);
    pCurLineFlowVolume->clear();
    pCurSpeedValue->clear();
    while(query.next()){
//        qDebug()<<"query.value('RecordDate').toDateTime().toMSecsSinceEpoch():"<<query.value("RecordDate").toDateTime().toMSecsSinceEpoch();
//        qDebug()<<"query.value('FlowVolume').toDouble()"<<query.value("FlowVolume").toDouble();
//        qDebug()<<"QPointF(query.value('RecordDate').toDateTime().toMSecsSinceEpoch()"<<QPointF(query.value("RecordDate").toDateTime().toMSecsSinceEpoch(),query.value("SpeedValue").toDouble());
        pCurLineFlowVolume->append(query.value("RecordDate").toDateTime().toMSecsSinceEpoch(), query.value("FlowVolume").toDouble());
        pCurSpeedValue->append(query.value("RecordDate").toDateTime().toMSecsSinceEpoch(), query.value("SpeedValue").toDouble());
    }
    pCurSpeedValue->blockSignals(false);
    pCurLineFlowVolume->blockSignals(false);
    if(pCurLineFlowVolume->parent()){
        pCurLineFlowVolume->parent()->blockSignals(false);
    }
    return iResult;
}
