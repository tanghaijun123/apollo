#ifndef CSHELLPROCESS_H
#define CSHELLPROCESS_H

#include <QObject>
#include <QQmlEngine>
#include <QProcess>

/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : cshellprocess.h
  Version       : 1.0
  Author        : han
  Created       : 2024-08-12
  Last Modified :
  Description   :  header file
                :  执行shell命令
  Function List :
  History       :
  1.Date        : 2024-08-12
    Author      : fensnote
    Modification: Created file

******************************************************************************/

/**
 * @brief The CShellProcess class 执行shell命令接口
 */
class CShellProcess : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString processName  READ getProcessName WRITE setProcessName NOTIFY processNameChange FINAL)
    Q_PROPERTY(QString processParams  READ getProcessParams WRITE setProcessParams NOTIFY processParamsChange FINAL)
    QML_ELEMENT
public:

    /**
     * @brief CShellProcess
     * @param parent
     */
    explicit CShellProcess(QObject *parent = nullptr);
public:

    /**
     * @brief getProcessName 获取命令名称
     * @return 返回命令名称
     */
    QString getProcessName() const;

    /**
     * @brief setProcessName 设置命令名称
     * @param processName 命令名称
     */
    void setProcessName(QString &processName);

    /**
     * @brief getProcessParams 获取参数
     * @return 返回参数
     */
    QString getProcessParams() const;

    /**
     * @brief setProcessParams 设置命令参数
     * @param processParams 参数
     */
    void setProcessParams(QString &processParams);

    /**
     * @brief playSound 播放声音
     * @param path声音路径
     * @return 返回 CDatabaseManage::emDataBaseErr
     */
    static int playSound(QString path);

signals:
    /**
     * @brief processNameChange
     */
    void processNameChange();
    /**
     * @brief processParamsChange
     */
    void processParamsChange();

    /**
     * @brief readAllStandOutput 读取命令执行后的后台数据
     * @param strOutput输出文件
     */
    void readAllStandOutput(QString strOutput);
public:

    /**
     * @brief start运行命令
     */
    Q_INVOKABLE void start();

    /**
     * @brief getBrightness 查询亮度
     * @return 返回亮度值
     */
    Q_INVOKABLE double getBrightness();

    /**
     * @brief setBrightness 设置亮度
     * @param dPercent 亮度的百分比
     * @return 成功返回0，失败返回-1
     */
    Q_INVOKABLE int setBrightness(double dPercent);

    /**
     * @brief getVoiceVolume 读取音量
     * @return 返回音量的百分比
     */
    Q_INVOKABLE double getVoiceVolume();

    /**
     * @brief setVoiceVolme 设置音量百分比
     * @param dPercent音量百分比
     * @return 成功返回0，失败返回-1
     */
    Q_INVOKABLE int setVoiceVolme(double dPercent);

    /**
     * @brief setCurDateTime 设置系统日期
     * @param strDateTime 日期的的字符串
     * @return 成功返回0，失败返回-1
     */
    Q_INVOKABLE int setCurDateTime(QString strDateTime);

    /**
     * @brief setLedOnOff 设置LED开关
     * @param lednum LED数量
     * @param onoff 开关
     * @return
     */
    Q_INVOKABLE int setLedOnOff(QString lednum, bool onoff);
private:
    /**
     * @brief m_ProcessName
     */
    QString m_ProcessName{""};

    /**
     * @brief m_ProcessParams
     */
    QString m_ProcessParams{""};

private:
    /**
     * @brief m_iMixerMin
     */
    int m_iMixerMin{0};

    /**
     * @brief m_iMixerMax
     */
    int m_iMixerMax{127};

    /**
     * @brief m_iMaxBrightness
     */
    int m_iMaxBrightness{(int)(93)};

};

#endif // CSHELLPROCESS_H
