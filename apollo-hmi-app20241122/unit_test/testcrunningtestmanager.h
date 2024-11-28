#ifndef TESTCRUNNINGTESTMANAGER_H
#define TESTCRUNNINGTESTMANAGER_H

#include <QObject>
#include <QTest>
#include "../database/crunningtestmanager.h"

class TestCRunningTestManager : public QObject
{
    Q_OBJECT
public:
    explicit TestCRunningTestManager(QObject *parent = nullptr);

signals:

private slots:
    void initTestCase();
    void testWarning();
    void testStartStopRunning();
    void testCreateNewRunningRecord();

private:
    CRunningTestManager *m_RunningTestManager;
    CRunningTestOpt *m_pRunningTestWorking{Q_NULLPTR};
};

#endif // TESTCRUNNINGTESTMANAGER_H
