/******************************************************************************/
/*! @File        : crunningtestopt.cpp
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

#include <QDebug>
#include "crunningtestopt.h"
#include "ctestdetaildatas.h"
#include "ctestinginfodatas.h"
//#include "power.h"
#include <QDateTime>

#ifdef TEST_CREATE_DELTIAL_DATA
#include <QRandomGenerator>
#endif

const int conDefaultMax = 100000;
const int conDefaultMin = 0;

CRunningTestOpt::CRunningTestOpt(QObject *parent)
    : QObject{parent}
{
    int iReturn = loadRange();
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d processRunning return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
}

CRunningTestOpt::~CRunningTestOpt()
{
    freeDatas();
}

void CRunningTestOpt::onInitDatas()
{
    m_pTestingDB = new CDatabaseManage(DB_TESTING_NAME);
    onReceiveAction(Glb_define::conActPowerOn, QString(" "));
}

void CRunningTestOpt::freeDatas()
{
    if(m_pTestingDB){
        delete m_pTestingDB;
        m_pTestingDB = Q_NULLPTR;
    }
}

bool CRunningTestOpt::appendNewWarning(QString strWarningName, int iWarningType, QString strWarningTitle, int iMuteable, int iLatching, int itrigOnRun)
{
    /*if(m_iCurRunningID == 0)
    {
        m_curWarings.clear();
        updatesyncWaringNames();
        return false;
    }*/
    /*itrigOnRun = 1该报警只能在运行的情况下触发*/
    if(m_iCurRunningID == 0 && itrigOnRun == 1)
    {
        return false;
    }

    StWaring waring(iWarningType, iMuteable, iLatching, strWarningName, strWarningTitle, QDateTime::currentDateTime());

    //如果报警已存在列表里，则不添加
    if(findWaring(strWarningName))
    {
        return false;
    }

    qInfo() << "CRunningTestOpt::appendNewWarning" << strWarningName << m_iCurRunningID << itrigOnRun << iWarningType;

    m_curWarings.append(waring);
    //qDebug() << "CRunningTestOpt::appendNewWarning" << strWarningName << strWarningTitle;
    emit appendWarningShow(strWarningName, iWarningType, strWarningTitle);
    //emit warnningStatus(m_curWarings.count() > 0);
    CRunningTestOpt::emWaringType iMinWaringType = getMinWaringTypeInList();
    qDebug() << "CRunningTestOpt::appendNewWarning" << iMinWaringType;
    emit minWaringTypeInRunning(iMinWaringType, true);
    updatesyncWaringNames();
    return true;
}

bool CRunningTestOpt::findWaring(QString strWarningName)
{
    for(int i = 0; i < m_curWarings.size(); i++){
        if(m_curWarings[i].WarningName == strWarningName){
            return true;
        }
    }
    return false;
}

bool CRunningTestOpt::removeWaring(QString strWarningName)
{
    for(int i = 0; i < m_curWarings.size(); i++){
        if(m_curWarings[i].WarningName == strWarningName){
            m_curWarings.removeAt(i);          
            emit removeWarningShow(strWarningName);
            //emit warnningStatus(m_curWarings.count() > 0);
            CRunningTestOpt::emWaringType iMinWaringType = getMinWaringTypeInList();
            emit minWaringTypeInRunning(iMinWaringType, false);
            updatesyncWaringNames();
            return true;
        }
    }
    return false;
}

bool CRunningTestOpt::isWarningExist(QString strWarningName)
{
    for(int i = 0; i < m_curWarings.size(); i++){
        if(m_curWarings[i].WarningName == strWarningName){
            return true;
        }
    }
    return false;
}

bool CRunningTestOpt::isWarningCanMuted()
{
    for(int i = 0; i < m_curWarings.size(); i++){
        if(m_curWarings[i].Muteable == 0){
            return false;
        }
    }
    return true;
}

// 只要有栓锁的报警存在，都不能启动
bool CRunningTestOpt::canStartMotorUnderWarning()
{
    for(int i = 0; i < m_curWarings.size(); i++){
        if(m_curWarings[i].Latching == 1){
            return false;
        }
    }
    return true;
}

CRunningTestOpt::emWaringType CRunningTestOpt::getMinWaringTypeInList()
{
    if(m_curWarings.isEmpty()) {
        return CRunningTestOpt::wtNoWaring;
    }

    CRunningTestOpt::emWaringType iMinWaring = (CRunningTestOpt::emWaringType)m_curWarings[0].WaringType;
    for(int i = 1;  i < m_curWarings.size(); i ++)
    {
        if(iMinWaring > m_curWarings[i].WaringType)
        {
            iMinWaring = (CRunningTestOpt::emWaringType)m_curWarings[i].WaringType;
        }
    }
    return iMinWaring;
}

void CRunningTestOpt::updatesyncWaringNames()
{
    static QList<QString> warningList;
    warningList.clear();
    for(int i = 0; i < m_curWarings.count(); i++){
        warningList.append(m_curWarings[i].WarningName);
    }
    emit syncWaringNames(&warningList);
}

void CRunningTestOpt::onClearWarnings(bool onStop)
{
    CTestingInfoDatas db(m_pTestingDB, this);
    int size = m_curWarings.size();
    int iWarningType = 0;
    int iMuteable = 0;
    int iLatching = 0;
    int iTrigOnRun = 0;
    QString strWarningTitle = "";
    QString strWarningName = "";
    bool isWarningDeleted = false;

    qInfo() << "CRunningTestOpt::onClearWarnings=====================size" << m_curWarings.size();
    for(int i = size; i > 0; i--)
    {
        strWarningName = m_curWarings[i-1].WarningName;
        // 获取报警信息属性
        int iReturn = getWarningSettingByName(strWarningName, iWarningType, strWarningTitle, iMuteable, iLatching, iTrigOnRun);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d getWarningSettingByName return error, error code: %d", __FILE__, __LINE__, iReturn);
        }
        qInfo() << "CRunningTestOpt::onClearWarnings" << strWarningName << iMuteable << iLatching << iTrigOnRun;
        if((iTrigOnRun == 1 && onStop == true) || (iLatching == 1 && onStop == false)) {

            //发送消息让QML界面移除事件
            emit removeWarningShow(strWarningName);
            m_curWarings.removeAt(i-1);
            qInfo() << "CRunningTestOpt::onClearWarnings delete:" << strWarningName;

            //将报警移除事件存储
            iReturn = db.insertWaringsRecords(m_iCurRunningID, strWarningName, iWarningType + 10, QString("%1移除").arg(strWarningTitle));
            if(iReturn != CDatabaseManage::DBENoErr){
                qDebug("%s %d insertWaringsRecords return error, error code: %d", __FILE__, __LINE__, iReturn);
            }

            iReturn = removeWaringMsg(strWarningTitle);
            if(iReturn != CDatabaseManage::DBENoErr){
                qDebug("%s %d removeWaringMsg return error, error code: %d", __FILE__, __LINE__, iReturn);
            }

            isWarningDeleted = true;
        }
    }

    if(isWarningDeleted)
    {
        CRunningTestOpt::emWaringType iMinWaringType = getMinWaringTypeInList();
        qInfo() << "CRunningTestOpt::onClearWarnings==============type" << iMinWaringType;
        emit minWaringTypeInRunning(iMinWaringType, false);
        updatesyncWaringNames();
    }
}


void CRunningTestOpt::onProcessNoCloseRunning()
{
    CTestingInfoDatas testData(m_pTestingDB, this);
    int iReturn = testData.updateNoCloseTestDone();
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d updateNoCloseTestDone return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
}

void CRunningTestOpt::onStartRunning()
{
    qDebug() << "CRunningTestOpt::onStartRunning";
    //m_bWaitMotorChangeSpeed = true;
    m_dcurTestMinFlow = conDefaultMax;
    m_dcurTestMaxFlow = conDefaultMin;
    m_dTestFlowSum = 0;
    m_iFlowCount = 0;
    m_bCurFlowValueChangeByReal = false;


    m_icurTestMinSpeed = conDefaultMax;
    m_icurTestMaxSpeed = conDefaultMin;
    m_iTestSeepSum = 0;
    m_iSpeedCount = 0;
    m_bCurMotorSpeedChangeByReal = false;

    m_bCanReportWaring = false;

    if(!m_pSettingDB){
        m_pSettingDB = new CSettingDBOpt(this);
    }
    int icurTestID = 0;
    QString strDetailDataPath = "";
    bool bIsNoCloseRecord = false;
    int iReturn = createNewRunningRecord(icurTestID, strDetailDataPath, bIsNoCloseRecord);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d createNewRunningRecord return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
    m_iCurRunningID = icurTestID;

    m_strDetailDataPath = strDetailDataPath;
    int iPatientID = 0;
    iReturn = createNewPatient(iPatientID);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d createNewPatient return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
    if(bIsNoCloseRecord){
        iReturn = addInvalidDataToDetail(m_iCurRunningID, m_strDetailDataPath);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d addInvalidDataToDetail return error, error code: %d", __FILE__, __LINE__, iReturn);
        }
    }
    else{
        iReturn = updatePatientToRunningRecord(icurTestID, iPatientID);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d updatePatientToRunningRecord return error, error code: %d", __FILE__, __LINE__, iReturn);
        }
        iReturn = updateRunningStartToDB(icurTestID);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d updateRunningStartToDB return error, error code: %d", __FILE__, __LINE__, iReturn);
        }
    }

    iReturn = getStatisticData();
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getStatisticData return error, error code: %d", __FILE__, __LINE__, iReturn);
    }

    onReceiveAction(Glb_define::conActStartPump, QString("%1 RPM").arg(m_iCurMotorSpeed));

#ifdef TEST_CREATE_DELTIAL_DATA
    createSimulaData();
#else
    startCheckWarningTmr();
    startRunningTmr();
    //m_startTime = QDateTime::currentDateTime();
    emit curRunningIDChanged(m_iCurRunningID);
#endif

}

void CRunningTestOpt::onStopRunning()
{    
    qDebug("%s %d onStopRunning", __FILE__, __LINE__);
    stopRunningTmr();
    int iReturn = updateRunningDone();
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d updateRunningDone return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
    m_iCurRunningID = 0;   
    //m_curWarings.clear();
    emit curRunningIDChanged(m_iCurRunningID);
    updatesyncWaringNames();
    onReceiveAction(Glb_define::conActStopPump, "");
}

void CRunningTestOpt::timerEvent(QTimerEvent *event)
{
    if(event->timerId() == m_hRunningTmr){
        onRunningProcessTimeOut();
        return;
    }

    if(event->timerId() == m_hCheckWarningTmr){
        onCheckWarningTimeOut();
        return;
    }
    return QObject::timerEvent(event);
}

void CRunningTestOpt::startRunningTmr()
{
    stopRunningTmr();
    m_hRunningTmr = startTimer(TESTING_RECORD_INTERVAL);
}

void CRunningTestOpt::stopRunningTmr()
{
    if(m_hRunningTmr > 0){
        killTimer(m_hRunningTmr);
    }
    m_hRunningTmr = 0;
}

void CRunningTestOpt::onRunningProcessTimeOut(bool bByMain)
{
    stopRunningTmr();
    int iReturn = processRunning(bByMain);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d processRunning return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
    //sync();
    startRunningTmr();
}

void CRunningTestOpt::startCheckWarningTmr()
{
    stopCheckWarningTmr();
    m_hCheckWarningTmr = startTimer(10 * 1000);
}

void CRunningTestOpt::stopCheckWarningTmr()
{
    if(m_hCheckWarningTmr > 0){
        killTimer(m_hCheckWarningTmr);
    }
    m_hCheckWarningTmr = 0;
}

void CRunningTestOpt::onCheckWarningTimeOut()
{
    stopCheckWarningTmr();
    m_bCanReportWaring = true;
}

int CRunningTestOpt::createNewRunningRecord(int &iTestID, QString &strDetailDataPath, bool &bIsNoCloseRecord)
{
    bIsNoCloseRecord = false;
    CTestingInfoDatas testData(m_pTestingDB, this);
    bool bGetOnly = true;
    int iReturn =  testData.getRunningReCordID(iTestID, strDetailDataPath, bGetOnly);
    if(iReturn != CDatabaseManage::DBENoErr){
        return iReturn;
    }

    if(iTestID > 0){
        bIsNoCloseRecord = true;
        return CDatabaseManage::DBENoErr;
    }
    return testData.getRunningReCordID(iTestID, strDetailDataPath, false);
}

int CRunningTestOpt::createNewPatient(int &iPatientID)
{
    CTestingInfoDatas testData(m_pTestingDB, this);
    return testData.getPatientID(iPatientID);
}

int CRunningTestOpt::updatePatientToRunningRecord(int iTestID, int iPatientID)
{
    CTestingInfoDatas testData(m_pTestingDB, this);
    return testData.updateRunningReCordIDPatientID(iTestID, iPatientID);
}

int CRunningTestOpt::addInvalidDataToDetail(int iTestID, QString strDetailDataPath)
{
    CTestDetailDatas db(strDetailDataPath, iTestID, this);
    QDateTime dt;
    int iReturn =  db.getMaxDateTime(dt);
    if(iReturn != CDatabaseManage::DBENoErr){
        qWarning("%s %d getMaxDateTime, return %d", __FILE__, __LINE__, iReturn);
        return iReturn;
    }

    if(dt.isValid()){
        QDateTime curdt = QDateTime::currentDateTime();
        if(dt.secsTo(curdt) > 2*60){
            iReturn = db.insertData(m_iCurRunningID, dt.addSecs(30), 0, 0);
            if(iReturn != CDatabaseManage::DBENoErr){
                qWarning("%s %d insertData, return %d", __FILE__, __LINE__, iReturn);
                return iReturn;
            }

            iReturn = db.insertData(m_iCurRunningID, curdt.addSecs(-30), 0, 0);
            if(iReturn != CDatabaseManage::DBENoErr){
                qWarning("%s %d insertData, return %d", __FILE__, __LINE__, iReturn);
                return iReturn;
            }
        }
    }
    return CDatabaseManage::DBENoErr;
}

int CRunningTestOpt::updateRunningStartToDB(int iTestID)
{
    CTestingInfoDatas testData(m_pTestingDB, this);
    return testData.updateRunningStartToDB(iTestID);
}

int CRunningTestOpt::createNewRunningDetail(int /*iTestID*/)
{
    return CDatabaseManage::DBENoErr;
}

int CRunningTestOpt::saveRunningDetailParams(QDateTime dt)
{
    CTestDetailDatas db(m_strDetailDataPath, m_iCurRunningID, this);
    return db.insertData(m_iCurRunningID, dt, m_dCurFlowValue, m_iCurMotorSpeed);
}

//This function is called per 30 seconds
int CRunningTestOpt::processRunning(bool bByMain)
{
    //m_bMaxOrMinChanged = false;

    int iReturn = CDatabaseManage::DBENoErr;
    QDateTime dt = QDateTime::currentDateTime();
    // Save running detail parameters including current speed and flow
    iReturn = saveRunningDetailParams(dt);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d saveRunningDetailParams return error, error code: %d", __FILE__, __LINE__, iReturn);
        return iReturn;
    }

    if(m_iFlowCount < 1){
        m_iFlowCount = 1;
    }
    if(m_iSpeedCount < 1){
        m_iSpeedCount = 1;
    }

    if(m_iCurMotorSpeed > m_icurTestMaxSpeed){
        m_icurTestMaxSpeed = m_iCurMotorSpeed;
        m_bMaxOrMinChanged = true;
    }
    if(m_iCurMotorSpeed < m_icurTestMinSpeed){
        m_icurTestMinSpeed = m_iCurMotorSpeed;
        m_bMaxOrMinChanged = true;
    }

    //qDebug() << "processRunning m_icurTestMaxSpeed:" << m_icurTestMaxSpeed;
    double dCurTestMinFlow = qAbs(m_dcurTestMinFlow - conDefaultMax) < 5 ? 0 : m_dcurTestMinFlow;
    double dCurTestMaxFlow = m_dcurTestMaxFlow  < 0 ? 0 : m_dcurTestMaxFlow;
    int icurTestMinSpeed = qAbs(m_icurTestMinSpeed - conDefaultMax) < 5 ? 0 : m_icurTestMinSpeed;
    int icurTestMaxSpeed = m_icurTestMaxSpeed  < 0 ? 0 : m_icurTestMaxSpeed;
    //save max or min average value per minutes

    if((m_dLastSaveMinMaxTime.secsTo(dt) > 60 *2) || bByMain){
        m_dLastSaveMinMaxTime = dt;
        CTestingInfoDatas db(m_pTestingDB, this);
        qDebug() << "updateStatisticsValue" << m_iCurRunningID << dCurTestMinFlow << dCurTestMaxFlow <<  icurTestMinSpeed << icurTestMaxSpeed << m_dTestFlowSum/ m_iFlowCount << m_iTestSeepSum/ m_iSpeedCount;
        iReturn = db.updateStatisticsValue(m_iCurRunningID, dCurTestMinFlow, dCurTestMaxFlow, icurTestMinSpeed, icurTestMaxSpeed, m_dTestFlowSum/ m_iFlowCount, m_iTestSeepSum/ m_iSpeedCount);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d updateStatisticsValue return error, error code: %d", __FILE__, __LINE__, iReturn);
            return iReturn;
        }
    }

    //qDebug() << "CRunningTestOpt::processRunning:bByMain" << bByMain<< dCurTestMinFlow << dCurTestMaxFlow << icurTestMinSpeed << icurTestMaxSpeed << m_icurTestMaxSpeed;
    //qDebug() << "CRunningTestOpt::processRunning:bByMain" << m_dCurFlowValue << m_iCurMotorSpeed;
    emit updateTesingData(dt, m_dCurFlowValue, m_iCurMotorSpeed,
                          dCurTestMinFlow, dCurTestMaxFlow,
                          icurTestMinSpeed, icurTestMaxSpeed,
                          m_dTestFlowSum/m_iFlowCount,  m_iTestSeepSum/m_iSpeedCount);

    m_bMaxOrMinChanged = false;
    return iReturn;
}

int CRunningTestOpt::updateRunningDone()
{
    if(m_iCurRunningID < 1)
    {
        qDebug("%s %d updateRunningDone, but m_iCurRunningID is 0", __FILE__, __LINE__);

        return CDatabaseManage::DBENoErr;
    }

    CTestingInfoDatas db(m_pTestingDB, this);

    if(m_iFlowCount < 1){
        m_iFlowCount = 1;
    }
    if(m_iSpeedCount < 1){
        m_iSpeedCount = 1;
    }

    double dCurTestMinFlow = qAbs(m_dcurTestMinFlow - conDefaultMax) < 5 ? 0 : m_dcurTestMinFlow;
    double dCurTestMaxFlow = m_dcurTestMaxFlow  < 0 ? 0 : m_dcurTestMaxFlow;
    int icurTestMinSpeed = qAbs(m_icurTestMinSpeed - conDefaultMax) < 5 ? 0 : m_icurTestMinSpeed;
    int icurTestMaxSpeed = m_icurTestMaxSpeed  < 0 ? 0 : m_icurTestMaxSpeed;

    qDebug() << "CRunningTestOpt::updateRunningDone m_icurTestMaxSpeed:" << m_icurTestMaxSpeed;

    return db.updateRunningDone(m_iCurRunningID, dCurTestMinFlow, dCurTestMaxFlow, icurTestMinSpeed, icurTestMaxSpeed, m_dTestFlowSum/ m_iFlowCount, m_iTestSeepSum/ m_iSpeedCount);
}

int CRunningTestOpt::getStatisticData()
{
    CTestDetailDatas detailDB(m_strDetailDataPath, m_iCurRunningID);
    double dMinFlowValue = 0;
    double dMaxFlowValue = 0;
    int iMinSpeedValue = 0;
    int iMaxSpeedValue = 0;
    double dSumFlowValue = 0;
    quint64 dSumSpeedVlue = 0;
    int nRecordCount = 0;
    int iReturn = detailDB.getMinMaxValue(m_iCurRunningID, dMinFlowValue, dMaxFlowValue, iMinSpeedValue, iMaxSpeedValue, dSumFlowValue, dSumSpeedVlue, nRecordCount);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d saveRunningDetailParams return error, error code: %d", __FILE__, __LINE__, iReturn);
        return iReturn;
    }
    if(nRecordCount > 0){

        m_dcurTestMinFlow = dMinFlowValue;
        m_dcurTestMaxFlow = dMaxFlowValue;
        m_icurTestMinSpeed = iMinSpeedValue;
        m_icurTestMaxSpeed = dMaxFlowValue;
        m_dTestFlowSum = dSumFlowValue;
        m_iTestSeepSum = dSumSpeedVlue;
        m_iFlowCount = nRecordCount;
        m_iSpeedCount = nRecordCount;
        m_iCurMotorSpeed = dSumSpeedVlue / nRecordCount;
        m_dCurFlowValue = m_dTestFlowSum / nRecordCount;
    }
    m_bMaxOrMinChanged = true;
    return CDatabaseManage::DBENoErr;
}
#ifdef TEST_CREATE_DELTIAL_DATA
void CRunningTestOpt::createSimulaData()
{
    static int ncreateSconds = 28 * 24 * 3600;
    QDateTime dt = QDateTime::currentDateTime();
    int nescaptSecons = 0;
    while(nescaptSecons < ncreateSconds){
        QDateTime newDate = dt.addSecs(nescaptSecons);
        double dflowValue = QRandomGenerator::global()->bounded(7);
        onUpdateCurFlowValue(dflowValue);
        m_dTestFlowSum += dflowValue;
        if(dflowValue < m_dcurTestMinFlow){
            m_dcurTestMinFlow = dflowValue;
        }
        if(dflowValue > m_dcurTestMaxFlow){
            m_dcurTestMaxFlow = dflowValue;
        }
        int nSpeed = QRandomGenerator::global()->bounded(500, 5000);
        onUpdateCurMotorSpeed(nSpeed);
        m_iTestSeepSum += nSpeed;
        if(nSpeed < m_icurTestMinSpeed){
            m_icurTestMinSpeed =nSpeed;
        }
        if(nSpeed > m_icurTestMaxSpeed){
            m_icurTestMaxSpeed =nSpeed;
        }
        m_iFlowCount ++;
        m_iSpeedCount ++;
        saveRunningDetailParams(newDate);
        nescaptSecons += 30;
    }

    ncreateSconds = ncreateSconds *2;
}
#endif

void CRunningTestOpt::onReceiveAction(QString strActionName, QString strParams)
{
//    if(Glb_define::conActUpdateSpeed == strActionName  && m_bWaitMotorChangeSpeed){
//        m_bWaitMotorChangeSpeed = false;
//    }
    QString strActionType = "";
    int iReturn = getActionByName(strActionName, strActionType);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getActionByName return error, error code: %d", __FILE__, __LINE__, iReturn);
        strActionType = strActionName;
    }

    if(strActionType == ""){
        strActionType = strActionName;
    }


    CTestingInfoDatas db(m_pTestingDB, this);

    iReturn = db.insertActionRecord(m_iCurRunningID, strActionType, strParams);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d insertActionRecord return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
}

int CRunningTestOpt::loadRange()
{
    CSettingDBOpt setting(this);
    double dMin = 1600;
    double dMax = 4700;
    int iReturn = setting.getPararmByC("MotorSpeedValue", dMin, dMax);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getParam return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
    updateMotorSpeedRange(dMin, dMax);

    dMin = 2.5;
    dMax = 4.5;
    iReturn = setting.getPararmByC("FlowValue", dMin, dMax);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getParam return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
    updateFlowValueRange(dMin, dMax);
    return iReturn;
}

void CRunningTestOpt::onUpdateFlowValueRange(double dLower, double dHigher)
{
//    if(m_iCurRunningID < 1){
//        return;
//    }
    updateFlowValueRange(dLower, dHigher);
    QString strFlowTitle = "";

    int iReturn = getActionByName(Glb_define::conActSetFlowRange, strFlowTitle);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getActionByName return error, error code: %d", __FILE__, __LINE__, iReturn);
        strFlowTitle = Glb_define::conActSetFlowRange;
    }

    if(strFlowTitle == ""){
        strFlowTitle = Glb_define::conActSetFlowRange;
    }

    CTestingInfoDatas db(m_pTestingDB, this);
    iReturn = db.insertActionRecord(m_iCurRunningID, strFlowTitle, QString("%1-%2LPM").arg(dLower,1).arg(dHigher,1));
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d insertActionRecord return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
}

void CRunningTestOpt::onUpdateCurFlowValue(double dValue)
{
    m_bCurFlowValueChangeByReal = true;
    m_dCurFlowValue = dValue;
    if(m_iCurRunningID > 0  && m_bCanReportWaring)
    {
        emRangeErr rangeErr = checkFlowValueRange();
        int iReturn = saveFlowValueOutRange(rangeErr);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d saveFlowValueOutRange return error, error code: %d", __FILE__, __LINE__, iReturn);
            return;
        }
    }
}

void CRunningTestOpt::updateFlowValueRange(double dLower, double dHigher)
{
    m_settingFlowValueLowThredhold = dLower;
    m_settingFlowValueHighThredhold = dHigher;
}

CRunningTestOpt::emRangeErr CRunningTestOpt::checkFlowValueRange()
{
    if(!m_bCurFlowValueChangeByReal){
        qInfo("%s %d checkFlowValueRange, but is not real flow value", __FILE__, __LINE__);
        return reNormal;
    }

    if(m_dCurFlowValue > m_dcurTestMaxFlow){
        m_dcurTestMaxFlow = m_dCurFlowValue;
        m_bMaxOrMinChanged = true;
    }
    if(m_dCurFlowValue < m_dcurTestMinFlow){
        m_dcurTestMinFlow = m_dCurFlowValue;
        m_bMaxOrMinChanged = true;
    }

    m_dTestFlowSum += m_dCurFlowValue;
    m_iFlowCount++;

    if(m_dCurFlowValue > m_settingFlowValueHighThredhold) {
        return reHigher;
    } else if(m_dCurFlowValue < m_settingFlowValueLowThredhold) {
        return reLower;
    } else {
        return reNormal;
    }
}

int CRunningTestOpt::saveFlowValueOutRange(emRangeErr rangErr)
{
    QString strError = (rangErr == reLower) ? Glb_define::conWarnFlowLower :((rangErr == reHigher) ? Glb_define::conWarnFlowHigher : "");
    if(strError != ""){
        int iReturn = processWaringmsg(strError);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d processWaringmsg return error, error code: %d", __FILE__, __LINE__, iReturn);
            return iReturn;
        }

        QString strRemoveError = (rangErr == reLower) ? Glb_define::conWarnFlowHigher : Glb_define::conWarnFlowLower;

        iReturn = removeWaringMsg(strRemoveError);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d removeWaringMsg return error, error code: %d", __FILE__, __LINE__, iReturn);
            return iReturn;
        }
    }
    else{

        int iReturn = removeWaringMsg(Glb_define::conWarnFlowLower);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d removeWaringMsg return error, error code: %d", __FILE__, __LINE__, iReturn);
            return iReturn;
        }

        iReturn = removeWaringMsg(Glb_define::conWarnFlowHigher);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d removeWaringMsg return error, error code: %d", __FILE__, __LINE__, iReturn);
            return iReturn;
        }
    }

    return CDatabaseManage::DBENoErr;
}


void CRunningTestOpt::onUpdateMotorSpeedRange(double dLower, double dHigher)
{
//    if(m_iCurRunningID < 1){
//        return;
//    }
    updateMotorSpeedRange(dLower, dHigher);
    QString strSpeedTitle = "";
    qDebug() << "CRunningTestOpt::onUpdateMotorSpeedRange" << Glb_define::conActSetSpeedRange;
    int iReturn = getActionByName(Glb_define::conActSetSpeedRange, strSpeedTitle);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getActionByName return error, error code: %d", __FILE__, __LINE__, iReturn);
        strSpeedTitle = Glb_define::conActSetSpeedRange;
    }

    if(strSpeedTitle == ""){
        strSpeedTitle = Glb_define::conActSetSpeedRange;
    }

    CTestingInfoDatas db(m_pTestingDB, this);
    iReturn = db.insertActionRecord(m_iCurRunningID, strSpeedTitle, QString("%1-%2RPM").arg(dLower,1).arg(dHigher,1));
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d insertActionRecord return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
}

void CRunningTestOpt::onUpdateCurMotorSpeed(int icurMotorSpeed)
{
    //qDebug() << "CRunningTestOpt::onUpdateCurMotorSpeed m_bWaitMotorChangeSpeed" << m_bWaitMotorChangeSpeed << m_iCurRunningID;

    m_bCurMotorSpeedChangeByReal = true;
    m_iCurMotorSpeed = icurMotorSpeed;
//    if(m_bWaitMotorChangeSpeed){
//        return;
//    }
    if(m_iCurRunningID < 1){
        return;
    }

    //qDebug() << "CRunningTestOpt::onUpdateCurMotorSpeed" << icurMotorSpeed;

    if(m_iCurRunningID > 0 && m_bCanReportWaring){
        emRangeErr rangeErr = checkMotorSpeedRange();
        //if(rangeErr != reNormal){
        int iReturn = saveMotorSpeedOutRange(rangeErr);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d saveMotorSpeedOutRange return error, error code: %d", __FILE__, __LINE__, iReturn);
            return;
        }
        //}
    }
}

void CRunningTestOpt::onUpateCurParamToDB()
{
    onRunningProcessTimeOut(true);
    emit updateCurParamToDBDone();
}

void CRunningTestOpt::onReceiveWarning(QString strWarningName, QString strRemoveWarningName)
{
    int iReturn = processWaringmsg(strWarningName);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d processWaringmsg return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
    if(strRemoveWarningName == ""){
        return;
    }
    iReturn = removeWaringMsg(strRemoveWarningName);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d removeWaringMsg return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
}

void CRunningTestOpt::onRemoveWarning(QString strWarningName)
{
    int iReturn = removeWaringMsg(strWarningName);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d removeWaringMsg return error, error code: %d", __FILE__, __LINE__, iReturn);
    }
}

int CRunningTestOpt::processWaringmsg(QString strWarningName)
{
#ifndef ALARM_ENABLED
    return CDatabaseManage::DBENoErr;
#endif
    CTestingInfoDatas db(m_pTestingDB, this);
    int iWarningType = 0;
    int iMuteable = 0;
    int iLatching = 0;
    int iTrigOnRun = 0;
    QString strWarningTitle = "";
    int iReturn = getWarningSettingByName(strWarningName, iWarningType, strWarningTitle, iMuteable, iLatching, iTrigOnRun);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getWarningSettingByName return error, error code: %d", __FILE__, __LINE__, iReturn);
        //return iReturn;
    }

    if(!appendNewWarning(strWarningName, iWarningType, strWarningTitle, iMuteable, iLatching, iTrigOnRun)){
        return CDatabaseManage::DBENoErr;
    }

    iReturn = db.insertWaringsRecords(m_iCurRunningID, strWarningName, iWarningType, strWarningTitle);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d insertWaringsRecords return error, error code: %d", __FILE__, __LINE__, iReturn);
        return iReturn;
    }

    return CDatabaseManage::DBENoErr;
}

int CRunningTestOpt::removeWaringMsg(QString strWarningName)
{
#ifndef ALARM_ENABLED
    return CDatabaseManage::DBENoErr;
#endif
    CTestingInfoDatas db(m_pTestingDB, this);
    int iWarningType = 0;
    int iMuteable = 0;
    int iLatching = 0;
    int iTrigOnRun = 0;
    QString strWarningTitle = "";
    int iReturn = getWarningSettingByName(strWarningName, iWarningType, strWarningTitle, iMuteable, iLatching, iTrigOnRun);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getWarningSettingByName return error, error code: %d", __FILE__, __LINE__, iReturn);
        //return iReturn;
    }

    if(!removeWaring(strWarningName)){
        return CDatabaseManage::DBENoErr;
    }

    // haveWarnning(iWarningType, strWarningTitle);
    iReturn = db.insertWaringsRecords(m_iCurRunningID, strWarningName, iWarningType + 10, QString("%1移除").arg(strWarningTitle));
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d insertWaringsRecords return error, error code: %d", __FILE__, __LINE__, iReturn);
        return iReturn;
    }
    return CDatabaseManage::DBENoErr;
}

void CRunningTestOpt::updateMotorSpeedRange(double dLower, double dHigher)
{
    m_settingMotorSpeedLowThrehold = dLower;
    m_settingMotorSpeedHighThrehold = dHigher;
}

CRunningTestOpt::emRangeErr CRunningTestOpt::checkMotorSpeedRange()
{
    if(!m_bCurMotorSpeedChangeByReal){
        qInfo("%s %d checkMotorSpeedRange, but is not real motor speed!!!", __FILE__, __LINE__);
        return reNormal;
    }

    //qDebug() << "CRunningTestOpt::checkMotorSpeedRange" << m_iCurMotorSpeed << m_icurTestMaxSpeed << m_iCurMotorSpeed << m_icurTestMinSpeed;
//    if(m_iCurMotorSpeed > m_icurTestMaxSpeed){
//        m_icurTestMaxSpeed = m_iCurMotorSpeed;
//        m_bMaxOrMinChanged = true;
//    }
//    if(m_iCurMotorSpeed < m_icurTestMinSpeed){
//        m_icurTestMinSpeed = m_iCurMotorSpeed;
//        m_bMaxOrMinChanged = true;
//    }

    //qDebug() << "checkMotorSpeedRange" << m_icurTestMinSpeed << m_icurTestMaxSpeed;

    m_iTestSeepSum += m_iCurMotorSpeed;
    m_iSpeedCount++;

    if(m_iCurMotorSpeed > m_settingMotorSpeedHighThrehold) {
        return reHigher;
    } else if(m_iCurMotorSpeed < m_settingMotorSpeedLowThrehold) {
        return reLower;
    } else {
        return reNormal;
    }
}

int CRunningTestOpt::saveMotorSpeedOutRange(emRangeErr rangErr)
{
    QString strError = (rangErr == reLower) ? Glb_define::conWarnMotorSpeedLower :((rangErr == reHigher) ? Glb_define::conWarnMotoSpeedHigher : "");
    if(strError != ""){
        int iReturn = processWaringmsg(strError);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d processWaringmsg return error, error code: %d", __FILE__, __LINE__, iReturn);
            return iReturn;
        }

        QString strRemoveError = (rangErr == reLower) ? Glb_define::conWarnMotoSpeedHigher : Glb_define::conWarnMotorSpeedLower;
        iReturn = removeWaringMsg(strRemoveError);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d removeWaringMsg return error, error code: %d", __FILE__, __LINE__, iReturn);
            return iReturn;
        }
    }
    else{
        int iReturn = removeWaringMsg(Glb_define::conWarnMotorSpeedLower);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d removeWaringMsg return error, error code: %d", __FILE__, __LINE__, iReturn);
            return iReturn;
        }

        iReturn = removeWaringMsg(Glb_define::conWarnMotoSpeedHigher);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d removeWaringMsg return error, error code: %d", __FILE__, __LINE__, iReturn);
            return iReturn;
        }
    }

    return CDatabaseManage::DBENoErr;
}


void CRunningTestOpt::onNeedMaxOrMinValue()
{
    qDebug() << "onNeedMaxOrMinValue" << m_dcurTestMinFlow << m_dcurTestMaxFlow<< m_icurTestMinSpeed<< m_icurTestMaxSpeed;
    if(m_iCurRunningID < 1){
        emit maxOrMinValueChanged(0, 0, 0, 0, 0, 0);
    }
    else{
        double dCurTestMinFlow = qAbs(m_dcurTestMinFlow - conDefaultMax) < 5 ? 0 : m_dcurTestMinFlow;
        double dCurTestMaxFlow = m_dcurTestMaxFlow  < 0 ? 0 : m_dcurTestMaxFlow;
        int icurTestMinSpeed = qAbs(m_icurTestMinSpeed - conDefaultMax) < 5 ? 0 : m_icurTestMinSpeed;
        int icurTestMaxSpeed = m_icurTestMaxSpeed  < 0 ? 0 : m_icurTestMaxSpeed;
        emit maxOrMinValueChanged(dCurTestMinFlow, dCurTestMaxFlow, icurTestMinSpeed, icurTestMaxSpeed, m_iFlowCount == 0 ? 0 : m_dTestFlowSum/m_iFlowCount,  m_iSpeedCount == 0 ? 0 :m_iTestSeepSum/m_iSpeedCount);
    }
}

int CRunningTestOpt::getActionByName(QString strActionName, QString &strActionTitle)
{
    if(!m_pSettingDB){
        m_pSettingDB = new CSettingDBOpt(this);
    }

    return m_pSettingDB->getActionByName(strActionName, strActionTitle);
}

int CRunningTestOpt::getWarningSettingByName(QString strWaringName, int &iWarningType, QString &strWarningTitle, int &iMuteable, int &iLatching, int &iTrigOnRun)
{
    if(!m_pSettingDB) {
        m_pSettingDB = new CSettingDBOpt(this);
    }

    return m_pSettingDB->getWarningSettingByName(strWaringName, iWarningType, strWarningTitle, iMuteable, iLatching, iTrigOnRun);
}

CRunningTestOpt::StWaring::StWaring(int iWaringType, int iMuteable, int iLatching, QString strWarningName, QString strWarningTitle, QDateTime dtWarningDateTime)
{
    WaringType = iWaringType;
    Muteable = iMuteable;
    Latching = iLatching;
    WarningName = strWarningName;
    WarningTitle = strWarningTitle;
    WarningDateTime = dtWarningDateTime;
}

bool CRunningTestOpt::StWaring::operator==(const StWaring &newWarning) const
{
    return newWarning.WarningTitle == WarningTitle;
}

bool CRunningTestOpt::StWaring::operator<(const StWaring &newWarning) const
{
    if(WaringType == newWarning.WaringType){
        return  WarningDateTime < newWarning.WarningDateTime;
    }

    return WaringType < newWarning.WaringType;
}

