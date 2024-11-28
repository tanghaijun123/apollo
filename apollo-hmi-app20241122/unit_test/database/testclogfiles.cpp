#include "testclogfiles.h"

TestCLogFiles::TestCLogFiles(QObject *parent) : QObject(parent)
{

}

void TestCLogFiles::initTestCase()
{
    m_pWriteLogWorker = new CLogFiles;
}

void TestCLogFiles::TestWriteCurrentRunningLog()
{
    m_pWriteLogWorker->writeCurrenRuningLog(m_testId);
}

void TestCLogFiles::TestWriteWarningLog()
{
    m_pWriteLogWorker->writeWarningsLog();
}

void TestCLogFiles::TestWriteActionsLog()
{
    m_pWriteLogWorker->writeActionsLog();
}

void TestCLogFiles::TestGetDrivePath()
{
    m_pWriteLogWorker->getDrivePath();
}


//QTEST_MAIN(TestCLogFiles)
