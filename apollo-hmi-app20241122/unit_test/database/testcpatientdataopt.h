#ifndef TESTCPATIENTDATAOPT_H
#define TESTCPATIENTDATAOPT_H

#include <QObject>
#include <QTest>
#include "../../database/cpatientdataopt.h"

class TestCPatientDataOpt : public QObject
{
    Q_OBJECT
public:
    explicit TestCPatientDataOpt(QObject *parent = nullptr);

signals:
private slots:
    void initTestCase();
    void TestSetGetPatientInfo();
private:
    CPatientDataOpt *m_patientDataOpt;
};

#endif // TESTCPATIENTDATAOPT_H
