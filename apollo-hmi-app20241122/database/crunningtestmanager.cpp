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
#include "crunningtestmanager.h"
#include "ctestdetaildatas.h"
#include "ctestinginfodatas.h"
//#include "power.h"
#include <QDateTime>

#ifdef TEST_CREATE_DELTIAL_DATA
#include <QRandomGenerator>
#endif

const int conDefaultMax = 100000;
const int conDefaultMin = 0;

CRunningTestManager* glb_RunningTestManager{Q_NULLPTR};
CRunningTestManager::CRunningTestManager(CDatabaseManage *pDB, QObject *parent): QObject(parent), m_pDB(pDB)
{

    connect(this, &CRunningTestManager::startRunning, this, &CRunningTestManager::onStartRunning);
    connect(this, &CRunningTestManager::stopRunning, this, &CRunningTestManager::onStopRunning);

    m_pRunningTestWorking = new CRunningTestOpt();
    m_pThead = new QThread;
    qDebug() << "CRunningTestManager CRunningTestOpt QThread = " << m_pThead;
    m_pRunningTestWorking->moveToThread(m_pThead);
    connect(this, &CRunningTestManager::processNoCloseRunning, m_pRunningTestWorking, &CRunningTestOpt::onProcessNoCloseRunning);
    connect(this, &CRunningTestManager::startRunning, m_pRunningTestWorking, &CRunningTestOpt::onStartRunning);
    connect(this, &CRunningTestManager::stopRunning, m_pRunningTestWorking, &CRunningTestOpt::onStopRunning);
    connect(this, &CRunningTestManager::receiveAction, m_pRunningTestWorking, &CRunningTestOpt::onReceiveAction);
    connect(this, &CRunningTestManager::updateFlowValueRange, m_pRunningTestWorking, &CRunningTestOpt::onUpdateFlowValueRange);
    connect(this, &CRunningTestManager::updateMotorSpeedRange, m_pRunningTestWorking, &CRunningTestOpt::onUpdateMotorSpeedRange);
    connect(this, &CRunningTestManager::updateCurFlowValue, m_pRunningTestWorking, &CRunningTestOpt::onUpdateCurFlowValue);
    connect(this, &CRunningTestManager::updateCurMotorSpeed, m_pRunningTestWorking, &CRunningTestOpt::onUpdateCurMotorSpeed);
    connect(this, &CRunningTestManager::reciveWarning, m_pRunningTestWorking, &CRunningTestOpt::onReceiveWarning);
    connect(this, &CRunningTestManager::removeWarning, m_pRunningTestWorking, &CRunningTestOpt::onRemoveWarning);
    connect(this, &CRunningTestManager::needMaxOrMinValue, m_pRunningTestWorking, &CRunningTestOpt::onNeedMaxOrMinValue);
    connect(this, &CRunningTestManager::clearWarnings, m_pRunningTestWorking, &CRunningTestOpt::onClearWarnings);

    connect(this, &CRunningTestManager::upateCurParamToDB, m_pRunningTestWorking, &CRunningTestOpt::onUpateCurParamToDB);
    connect(m_pRunningTestWorking, &CRunningTestOpt::updateCurParamToDBDone, this, &CRunningTestManager::updateCurParamToDBDone);

    connect(m_pRunningTestWorking, &CRunningTestOpt::appendWarningShow, this, &CRunningTestManager::appendWarningShow);
    connect(m_pRunningTestWorking, &CRunningTestOpt::removeWarningShow, this, &CRunningTestManager::removeWarningShow);
    //connect(m_pRunningTestWorking, &CRunningTestOpt::warnningStatus, this, &CRunningTestManager::onWarnningStatus);
    connect(m_pRunningTestWorking, &CRunningTestOpt::minWaringTypeInRunning, this, &CRunningTestManager::onMinWaringTypeInRunning);
    connect(m_pRunningTestWorking, &CRunningTestOpt::minWaringTypeInRunning, this, &CRunningTestManager::minWaringTypeInRunning);
    connect(m_pRunningTestWorking, &CRunningTestOpt::maxOrMinValueChanged, this, &CRunningTestManager::maxOrMinValueChanged);
    connect(m_pRunningTestWorking, &CRunningTestOpt::updateTesingData, this, &CRunningTestManager::updateTesingData);
    connect(m_pRunningTestWorking, &CRunningTestOpt::syncWaringNames, this, &CRunningTestManager::onSyncWaringList);
    connect(m_pRunningTestWorking, &CRunningTestOpt::curRunningIDChanged, this, &CRunningTestManager::onCurRunningIDChanged);

    connect(m_pThead, &QThread::started, m_pRunningTestWorking, &CRunningTestOpt::onInitDatas);

    m_pWarningSoundWorker = new CWarningSoundWorker();
    m_pWarningSoundThead = new QThread();
    qDebug() << "CRunningTestManager m_pWarningSoundWorker QThread = " << m_pWarningSoundThead;
    m_pWarningSoundWorker->moveToThread(m_pWarningSoundThead);
    connect(m_pRunningTestWorking, &CRunningTestOpt::minWaringTypeInRunning, m_pWarningSoundWorker, &CWarningSoundWorker::onSetSoundType);
    connect(this, &CRunningTestManager::pauseSound, m_pWarningSoundWorker, &CWarningSoundWorker::onPauseSound);
    connect(this, &CRunningTestManager::volumeChanged, m_pWarningSoundWorker, &CWarningSoundWorker::onVolumeChanged);
    connect(this, &CRunningTestManager::playKeySound, m_pWarningSoundWorker, &CWarningSoundWorker::onPlayKeySound);
#ifdef __arm__
    m_led = new Led();
    connect(m_pRunningTestWorking, &CRunningTestOpt::minWaringTypeInRunning, m_led, &Led::onSetLedPriority);
    //connect(this, &CRunningTestManager::playSound, m_led, &Led::onLedOn);
    //connect(this, &CRunningTestManager::pauseSound, m_led, &Led::onLedOff);

    m_led->start();
#endif

    m_pWarningSoundThead->start();
    m_pThead->start();

    glb_RunningTestManager = this;
}

CRunningTestManager::~CRunningTestManager()
{
    if(m_bStarted){
        emit stopRunning();
    }

#ifdef __arm__
    if(m_led){
        m_led->stop();
        m_led->quit();
        m_led->wait();
        delete m_led;
        m_led = Q_NULLPTR;
    }
#endif

    if(m_pWarningSoundThead){
        m_pWarningSoundThead->quit();
        m_pWarningSoundThead->wait();
        delete m_pWarningSoundThead;
        m_pWarningSoundThead = Q_NULLPTR;
    }

    if(m_pThead){
        m_pThead->quit();
        m_pThead->wait();
        delete m_pThead;
        m_pThead = Q_NULLPTR;
    }

    if(m_pWarningSoundWorker){
        delete m_pWarningSoundWorker;
        m_pWarningSoundWorker = Q_NULLPTR;
    }

    if(m_pRunningTestWorking){
        delete m_pRunningTestWorking;
        m_pRunningTestWorking = Q_NULLPTR;
    }
}

bool CRunningTestManager::sthaveWarning()
{
    if(!glb_RunningTestManager){
        return false;
    }
    return glb_RunningTestManager->m_bHaveWarning;
}

bool CRunningTestManager::haveWarning()
{
    return m_bHaveWarning;
}

bool CRunningTestManager::isWarningExist(QString strWarningName)
{
    //return glb_RunningTestManager->isWarningExist(strWarningName);
    QList<QString> lWarings;
    bool bExist = false;
    {
        QMutexLocker lock(&m_mtxWarnings);
        lWarings = m_strWarinngs;
    }

    for(int i = 0; i < lWarings.count(); i++){
        if(strWarningName == lWarings[i]){
            bExist = true;
            break;
        }
    }
    return bExist;
}

bool CRunningTestManager::isWarningCanMuted()
{
    return m_pRunningTestWorking->isWarningCanMuted();
}

bool CRunningTestManager::canStartMotorUnderWarning()
{
    return m_pRunningTestWorking->canStartMotorUnderWarning();
}

bool CRunningTestManager::isSIMULATION()
{
#ifdef GLOBAL_SIMULATION
    return true;
#else
    return false;
#endif
}

bool CRunningTestManager::isRunning()
{
    return m_bStarted;
}

bool CRunningTestManager::haveNocloseRecord()
{
    CTestingInfoDatas testData(m_pDB, this);
    int iTestID = 0;
    QString strDetailDataPath = "";
    int iReturn  =  testData.getRunningReCordID(iTestID, strDetailDataPath, false);
    if(iReturn != CDatabaseManage::DBENoErr){
        qWarning("%s %d getRunningReCordID false, return error: %d", __FILE__, __LINE__, iReturn);
        return false;
    }

    return iTestID > 0;
}

void CRunningTestManager::onStartRunning()
{
    m_bStarted = true;
}

void CRunningTestManager::onStopRunning()
{
    m_bStarted = false;
}

//void CRunningTestManager::onWarnningStatus(bool bHaveWarning)
//{
//    m_bHaveWarning = bHaveWarning;
//}

void CRunningTestManager::onMinWaringTypeInRunning(int iMinWaringType, bool bNew)
{
    //control sound type
    m_curWaringType = (CRunningTestOpt::emWaringType)iMinWaringType;

}

void CRunningTestManager::onSyncWaringList(QList<QString> *list)
{
    QList<QString> warings = *list;
    addWarings(warings);
}

void CRunningTestManager::addWarings(QList<QString> &list)
{
    QMutexLocker lock(& m_mtxWarnings);
    m_strWarinngs = list;
    m_bHaveWarning =  m_strWarinngs.size() > 0;
}

void CRunningTestManager::onCurRunningIDChanged(int iCurRunningID)
{
    m_iCurRunningID = iCurRunningID;
    emit curRunningStatus(m_iCurRunningID > 0);
    if(m_iCurRunningID == 0){
        emit clearWarnings(true);
    }
}

int CRunningTestManager::getCurRunningTestID()
{
    return m_iCurRunningID;
}

int CRunningTestManager::stGetCurRunningTestID()
{
    if(!glb_RunningTestManager){
        return 0;
    }
    return glb_RunningTestManager->getCurRunningTestID();
}
