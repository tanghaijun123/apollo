/******************************************************************************/
/*! @File        : cpatientdataopt.cpp
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
#include "cpatientdataopt.h"
#include "ctestinginfodatas.h"


CPatientDataOpt::CPatientDataOpt(CDatabaseManage *pDB, QObject *parent)
    : QObject{parent}, m_pDB(pDB)
{

}

QJsonObject CPatientDataOpt::getPatientInfo()
{
    CTestingInfoDatas db(m_pDB, this);
    QString strPatientName = "";
    QString strSex = "";
    QString strAge = "";
    QString strPatientID = "";
    QString strBloodType = "";
    double dWeight = 0;
    double dHeight = 0;
    QDateTime dImplantationTime = QDateTime();
    int iReturn = db.getFirstPatient(strPatientName, strSex, strAge, strPatientID, strBloodType, dWeight, dHeight, dImplantationTime);

    return QJsonObject({{"res", iReturn},
                        {"PatientName", strPatientName},
                        {"PatientSex", strSex},
                        {"PatientAge", strAge},
                        {"PatientID", strPatientID},
                        {"BloodType", strBloodType},
                        {"Weight", dWeight},
                        {"Height", dHeight},
                        {"ImplantationTime", dImplantationTime.toString("yyyy-MM-dd"/*"yyyy-MM-dd hh:mm:ss"*/)}});
}

int CPatientDataOpt::setPatientInfo(QString strName, QString strSex, QString strAge, QString StrImedicalNumber, QString strBloodType, int nWeight, int nHeight, QString strImplantationTime)
{
    CTestingInfoDatas db(m_pDB, this);
    int iReturn = db.updateFirstPatientInfo(strName, strSex, strAge, StrImedicalNumber, strBloodType, nWeight, nHeight,QDateTime::fromString(strImplantationTime, "yyyy-MM-dd"/*"yyyy-MM-dd hh:mm:ss"*/));
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d updateFirstPatientInfo error, error code: %d", __FILE__, __LINE__, iReturn);
    }
    return iReturn;
}
