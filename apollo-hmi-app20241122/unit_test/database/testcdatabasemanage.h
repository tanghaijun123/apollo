#ifndef TESTCDATABASEMANAGE_H
#define TESTCDATABASEMANAGE_H

#include <QObject>
#include "../../database/cdatabasemanage.h"

class TestCDataBaseManage : public QObject
{
    Q_OBJECT
public:
    explicit TestCDataBaseManage(QObject *parent = nullptr);

signals:
private slots:
    void initTestCase();
    void testExecSql();
    void testIsValid();

private:
    CDatabaseManage * m_pDB;
};

#endif // TESTCDATABASEMANAGE_H
