#include <QTest>
#include "testcdatabasemanage.h"

TestCDataBaseManage::TestCDataBaseManage(QObject *parent) : QObject(parent)
{

}

void TestCDataBaseManage::initTestCase()
{
    m_pDB = new CDatabaseManage(DB_SETTING_NAME);

    QVERIFY(m_pDB != NULL);


}

void TestCDataBaseManage::testExecSql()
{
    QSqlQuery m_WarningsQuery;
    int iWarningType = 0;
    QString strWaringTitle = "";
    if(!m_WarningsQuery.isActive()){
        QString strSQL = "SELECT"
                         "  	w.ID,"
                         "  	w.WarningType,"
                         "  	w.WarningName,"
                         "  	w.WarningTitle,"
                         "  	w.Muteable, "
                         "  	w.Latching,"
                         "      w.TrigOnRun"
                         "  FROM"
                         "  	Warnings AS w "
                         "  ORDER BY"
                         "  	w.ID ASC";
        QList<CDatabaseManage::StParam> params;

        if(!m_pDB->execSql(m_WarningsQuery, strSQL, params))
        {
        }
        if(m_WarningsQuery.next()){
            QVERIFY(m_WarningsQuery.value("WarningName").toString() == "WARN_SYSTEM_ERROR1");
        }

        if(!m_pDB->execSqlNoLock(m_WarningsQuery, strSQL, params))
        {
        }
        if(m_WarningsQuery.next()){
            QVERIFY(m_WarningsQuery.value("WarningName").toString() == "WARN_SYSTEM_ERROR1");
        }
        //qDebug("%s %d waring count: %d", __FILE__, __LINE__, n);
    }
}

void TestCDataBaseManage::testIsValid()
{
    QVERIFY(m_pDB->isValid());
}

//QTEST_MAIN(TestCDataBaseManage)
