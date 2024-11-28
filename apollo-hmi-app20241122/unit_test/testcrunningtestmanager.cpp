#include "testcrunningtestmanager.h"
#include "../database/crunningtestopt.h"
#include "../database/ctestdetaildatas.h"
#include "../database/ctestinginfodatas.h"
#include "../database/cpatientdataopt.h"
#include "../database/crunningtestmanager.h"

TestCRunningTestManager::TestCRunningTestManager(QObject *parent) : QObject(parent)
{

}

void TestCRunningTestManager::initTestCase()
{
    CDatabaseManage *m_pDB = new CDatabaseManage(DB_TESTING_NAME);
    CRunningTestManager *m_RunningTestManager = new CRunningTestManager(m_pDB);

    m_pRunningTestWorking = new CRunningTestOpt();
}

void TestCRunningTestManager::testWarning()
{
    glb_RunningTestManager->reciveWarning(Glb_define::conWarnMotorSpeedAbnormal, "");
    QVERIFY(glb_RunningTestManager->isWarningExist(Glb_define::conWarnMotorSpeedAbnormal) == true);
    glb_RunningTestManager->removeWarning(Glb_define::conWarnMotorSpeedAbnormal);
    QVERIFY(glb_RunningTestManager->isWarningExist(Glb_define::conWarnMotorSpeedAbnormal) == false);

    glb_RunningTestManager->reciveWarning(Glb_define::conWarnMotorSpeedAbnormal, "");
    glb_RunningTestManager->reciveWarning(Glb_define::conWarnBatteryTempHigh, "");
    glb_RunningTestManager->clearWarnings(true);
    QVERIFY(glb_RunningTestManager->isWarningExist(Glb_define::conWarnMotorSpeedAbnormal) == false);
    QVERIFY(glb_RunningTestManager->isWarningExist(Glb_define::conWarnMotorSpeedAbnormal) == false);
}

void TestCRunningTestManager::testStartStopRunning()
{
    glb_RunningTestManager->startRunning();
    QThread::msleep(5000);
    glb_RunningTestManager->stopRunning();
}

void TestCRunningTestManager::testCreateNewRunningRecord()
{
    int icurTestID = 0;
    QString strDetailDataPath = "";
    bool bIsNoCloseRecord = false;
    int iReturn = glb_RunningTestManager->createNewRunningRecord(icurTestID, strDetailDataPath, bIsNoCloseRecord);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d createNewRunningRecord return error, error code: %d", __FILE__, __LINE__, iReturn);
    }

    qDebug() << strDetailDataPath;

    int iPatientID = 0;
    iReturn = m_pRunningTestWorking->createNewPatient(iPatientID);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d createNewPatient return error, error code: %d", __FILE__, __LINE__, iReturn);
    }

    iReturn = m_pRunningTestWorking->updatePatientToRunningRecord(icurTestID, iPatientID);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d updatePatientToRunningRecord return error, error code: %d", __FILE__, __LINE__, iReturn);
    }

    iReturn = m_pRunningTestWorking->updateRunningStartToDB(icurTestID);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d updateRunningStartToDB return error, error code: %d", __FILE__, __LINE__, iReturn);
    }

    int iReturn = CDatabaseManage::DBENoErr;
    QDateTime dt = QDateTime::currentDateTime();
    // Save running detail parameters including current speed and flow
    iReturn = m_pRunningTestWorking->saveRunningDetailParams(dt);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d saveRunningDetailParams return error, error code: %d", __FILE__, __LINE__, iReturn);
        return iReturn;
    }
}

QTEST_MAIN(TestCRunningTestManager)
