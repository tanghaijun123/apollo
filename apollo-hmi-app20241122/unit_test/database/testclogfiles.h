#ifndef TESTCLOGFILES_H
#define TESTCLOGFILES_H

#include <QObject>
#include <QTest>
#include "../../database/clogfiles.h"

class TestCLogFiles : public QObject
{
    Q_OBJECT
public:
    explicit TestCLogFiles(QObject *parent = nullptr);
signals:
private slots:
    void initTestCase();
    void TestWriteCurrentRunningLog();
    void TestWriteWarningLog();
    void TestWriteActionsLog();
    void TestGetDrivePath();
private:
    CLogFiles *m_pWriteLogWorker;
    int m_testId{3};
};

#endif // TESTCLOGFILES_H
