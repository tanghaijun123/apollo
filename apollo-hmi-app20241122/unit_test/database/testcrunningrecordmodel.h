#ifndef TESTCRUNNINGRECORDMODEL_H
#define TESTCRUNNINGRECORDMODEL_H

#include <QObject>
#include <QTest>
#include "../../database/crunningrecordmodel.h"

class TestCRunningRecordModel : public QObject
{
    Q_OBJECT
public:
    explicit TestCRunningRecordModel(QObject *parent = nullptr);

signals:
private slots:
    void initTestCase();
    void testCRunningRecordModel();
private:
    CRunningRecordModel *m_cRunningModel;
};

#endif // TESTCRUNNINGRECORDMODEL_H
