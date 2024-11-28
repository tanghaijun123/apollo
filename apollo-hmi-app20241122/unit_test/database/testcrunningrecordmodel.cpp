#include "testcrunningrecordmodel.h"

TestCRunningRecordModel::TestCRunningRecordModel(QObject *parent) : QObject(parent)
{

}

void TestCRunningRecordModel::initTestCase()
{
    CDatabaseManage *m_pDB = new CDatabaseManage(DB_TESTING_NAME);
    m_cRunningModel = new CRunningRecordModel(m_pDB);
}

void TestCRunningRecordModel::testCRunningRecordModel()
{
    m_cRunningModel->loadData(0);

    qDebug() << m_cRunningModel->getPageCount();
    QJsonObject json = m_cRunningModel->getRowJsonData(0);
    qDebug() << json;
    json = m_cRunningModel->getRowMaxOrMinJsonData(0);
    qDebug() << json;
}

//QTEST_MAIN(TestCRunningRecordModel)
