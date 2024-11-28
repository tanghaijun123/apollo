#include "testcpatientdataopt.h"

TestCPatientDataOpt::TestCPatientDataOpt(QObject *parent) : QObject(parent)
{

}

void TestCPatientDataOpt::initTestCase()
{
    #define DB_TESTING_NAME "testing.db"
    CDatabaseManage *m_pDB = new CDatabaseManage(DB_TESTING_NAME);
    m_patientDataOpt = new CPatientDataOpt(m_pDB);
}

void TestCPatientDataOpt::TestSetGetPatientInfo()
{
    m_patientDataOpt->setPatientInfo("zhangsan", "男", "30", "102", "A", 65, 170, "2024-8-10 12:00:00");
    QJsonObject ret = m_patientDataOpt->getPatientInfo();
    qDebug() << "TestSetGetPatientInfo" << ret;
}

//QTEST_MAIN(TestCPatientDataOpt)
