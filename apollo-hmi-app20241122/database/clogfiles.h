/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : clogfiles.h
  Version       : 1.0
  Author        : han
  Created       : 2024-08-13
  Last Modified :
  Description   :  header file
  Function List :
  History       :
  1.Date        : 2024-08-13
    Author      : fensnote
    Modification: Created file

******************************************************************************/

#ifndef CLOGFILES_H
#define CLOGFILES_H

#include <QObject>
#include <QThread>
#include "crunningtestmanager.h"


/**
 * @brief The CLogFiles class 文本日志导出类，在 CLogFilesMangage管理的m_pWriteLogThread线程中使用
 */
class CLogFiles : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief CLogFiles
     * @param parent 父对象
     */
    explicit CLogFiles(QObject *parent = nullptr);
    ~CLogFiles();
    /**
     * @brief writeCurrenRuningLog 保存当前运行及历史日志
     * @param iTestID 为0是时保存当前运行日志， 不为0是时保存选中的日志
     * @return
     */
    Q_INVOKABLE int writeCurrenRuningLog(int iTestID = 0);

    /**
     * @brief writeWarningsLog 保存报警日志文件
     * @return
     */
    Q_INVOKABLE int writeWarningsLog();

    /**
     * @brief writeActionsLog 保存动作日志
     * @return
     */
    Q_INVOKABLE int writeActionsLog();

    /**
     * @brief writeAllLog 保存所有日志，扩展使用
     * @param strFileName
     * @param iPatientID
     * @return
     */
    Q_INVOKABLE int writeAllLog(QString strFileName, int iPatientID = 0);

    static QString getDrivePath();
public slots:

    /**
     * @brief onWriteCurrenRuningLog 保存历史及当前日志的槽函数，调用writeCurrenRuningLog，执行完成 调用writeCurrenRuningLogDone返回
     * @param iPatientID
     */
    void onWriteCurrenRuningLog(int iPatientID = 0);

    /**
     * @brief onWriteWarningsLog 保存报警日志的槽函数，调用writeWarningsLog
     */
    void onWriteWarningsLog();
    /**
     * @brief onWriteActionsLog 保存动作日志的槽函数，调用writeWarningsLog
     */
    void onWriteActionsLog();

    void onInitData();
    void freeData();
signals:

    /**
     * @brief writeCurrenRuningLogDone 保存当前或历史日志完成后的返回信号
     * @param iErr
     */
    void writeCurrenRuningLogDone(int iErr);

    /**
     * @brief writeWarningsLogDone 保存报警日志完成后的返回信号
     * @param iErr
     */
    void writeWarningsLogDone(int iErr);

    /**
     * @brief writeActionsLogDone 保存动作日志完成后返回信息
     * @param iErr
     */
    void writeActionsLogDone(int iErr);
private:
    /**
     * @brief checkUSBPath 检查U盘是否存在
     * @return
     */
    QString checkUSBPath();


signals:
private:

    QString m_strMacthineType{""}; // 机器类型
    QString m_strSeriaNumber{""};  //机器序号号
    QString m_strLogPath{""};      //日志路径
    QByteArray m_strFileHead;      //日志文件头

    CDatabaseManage *m_pTestingDB{Q_NULLPTR};
};

/**
 * @brief The CLogFilesMangage class 日志书写的线程管理类，生成CLogFiles类型的m_pWriteLogWorker日志写入线程对象，及m_pWriteLogThread线程
 */
class CLogFilesMangage: public QObject
{
    Q_OBJECT
public:
    /**
     * @brief CLogFilesMangage
     * @param parent
     */
    explicit CLogFilesMangage(QObject *parent = nullptr);
    ~CLogFilesMangage();

signals:
    /**
     * @brief writeCurrenRuningLog
     * @param iTestID
     */
    void writeCurrenRuningLog(int iTestID = 0);

    /**
     * @brief writeWarningsLog
     */
    void writeWarningsLog();

    /**
     * @brief writeActionsLog
     */
    void writeActionsLog();

    /**
     * @brief writeCurrenRuningLogDone
     * @param iErr
     */
    void writeCurrenRuningLogDone(int iErr);
    /**
     * @brief writeWarningsLogDone
     * @param iErr
     */

    void writeWarningsLogDone(int iErr);
    /**
     * @brief writeActionsLogDone
     * @param iErr
     */
    void writeActionsLogDone(int iErr);
private:
    ///日志写入时工作对象
    CLogFiles *m_pWriteLogWorker{Q_NULLPTR};

    ///写入对象运行线程
    QThread *m_pWriteLogThread{Q_NULLPTR};
};

extern CRunningTestManager* glb_RunningTestManager;

#endif // CLOGFILES_H
