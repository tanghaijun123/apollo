/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : cpatientdataopt.h
  Version       : 1.0
  Author        : han
  Created       : 2024-08-13
  Last Modified :
  Description   :  header file
  Function List :
  History       :
  1.Date        : 2024-08-13
    Author      : fensnote
    Modification: Created file

******************************************************************************/

#ifndef CPATIENTDATAOPT_H
#define CPATIENTDATAOPT_H

#include <QObject>
#include <QQmlEngine>
#include <QJsonObject>
#include "cdatabasemanage.h"

class CPatientDataOpt : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    /**
     * @brief CPatientDataOpt
     * @param parent
     */
    explicit CPatientDataOpt(CDatabaseManage *pDB, QObject *parent = nullptr);

    /**
     * @brief getPatientInfo 给qml返回患者信息
     * @return json数据
     * {"res" 是否有异常，CDatabaseManage::DBENoErr为正常， 异常返回查看 CDatabaseManage::emDataBaseErr
     * {"PatientName" 返回患者姓名
     * {"PatientSex" 返回患者性别
     * {"PatientAge" 返回患者年龄
     * {"PatientID" 返回患者ID号，用于查找记录使用
     * {"BloodType" 返回血型
     * {"Weight" 返回体重
     * {"Height" 返回身高
     * {"ImplantationTime" 返回植入时间
     */
    Q_INVOKABLE QJsonObject getPatientInfo();

    /**
     * @brief setPatientInfo 保存患者信息到数据库
     * @param strName  设置患者姓名
     * @param strSex 设置患者性别
     * @param strAge 设置患者年龄
     * @param StrImedicalNumber 设置住院号
     * @param strBloodType 设置血型
     * @param nWeight 设置体重
     * @param nHeight 设置身高
     * @param strImplantationTime 设置植入时间
     * @return
     */
    Q_INVOKABLE int setPatientInfo(QString strName, QString strSex,QString strAge, QString StrImedicalNumber, QString strBloodType, int nWeight, int nHeight, QString strImplantationTime);
signals:
private:
    CDatabaseManage *m_pDB{Q_NULLPTR};
};

#endif // CPATIENTDATAOPT_H
