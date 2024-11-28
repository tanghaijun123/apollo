/******************************************************************************/
/*! @File        : cshellprocess.cpp
 *  @Brief       : 简要说明
 *  @Details     : 详细说明
 *  @Author      : han
 *  @Date        : 2024-08-13
 *  @Version     : v1.0
 *  @Copyright   : Copyright By yongrenxing, All Rights Reserved
 *
 **********************************************************
 *
 *  @Attention   :
 *  @par 修改日志:
 *  <table>
 *  <tr><th>Date       <th>Version   <th>Author    <th>Description
 *  <tr><td>2024-08-13 <td>1.0       <td>xxx     <td>创建初始版本
 *  </table>
 *
 **********************************************************
*/

#include "cshellprocess.h"
#include <QProcess>
#include <QDebug>
#include <QtMath>

CShellProcess::CShellProcess(QObject *parent)
    : QObject{parent},
    m_ProcessName{""},
    m_ProcessParams{""}
{

}

QString CShellProcess::getProcessName() const
{
    return m_ProcessName;
}

void CShellProcess::setProcessName(QString &processName)
{
    m_ProcessName = processName;
    emit processNameChange();
}

QString CShellProcess::getProcessParams() const
{
    return m_ProcessParams;
}

void CShellProcess::setProcessParams(QString &processParams)
{
    m_ProcessParams = processParams;
    emit processParamsChange();
}

void CShellProcess::start()
{
    QProcess  process;
    QStringList params = m_ProcessParams.split(" ");

    process.start(m_ProcessName, params);
    if(!process.waitForFinished())
    {
        qDebug() << __FILE__ <<" " << __LINE__ << " waitForFinished fail: " << process.errorString();
    }
    else{
        emit readAllStandOutput(process.readAllStandardOutput());
    }
}

double CShellProcess::getBrightness()
{
#ifndef __arm__
    return 0;
#endif
    //get max value
    QProcess process;
    QStringList params;
    params.append("/sys/devices/soc0/backlight_lvds/backlight/backlight_lvds/max_brightness");
    process.start("cat", params);
    if(!process.waitForFinished()){
        qDebug() << __FILE__ <<" " << __LINE__ << " waitForFinished fail: " << process.errorString();
        return -1;
    }

    QString strReturn = QString(process.readAllStandardOutput());
    if(strReturn.size() < 1){
        qDebug() << __FILE__ <<" " << __LINE__ << " strReturn return is empty!!!";
        return -1;
    }
    int iMaxBrightness = strReturn.toInt();
    if(iMaxBrightness > 0){
        m_iMaxBrightness = (int)(iMaxBrightness * 0.8) ;
    }
    process.close();

    //get value
    params.clear();
    params.append("/sys/devices/soc0/backlight_lvds/backlight/backlight_lvds/brightness");
    process.start("cat", params);
    if(!process.waitForFinished()){
        qDebug() << __FILE__ <<" " << __LINE__ << " waitForFinished fail: " << process.errorString();
        return -1;
    }

    strReturn = QString(process.readAllStandardOutput());
    if(strReturn.size() < 1){
        qDebug() << __FILE__ <<" " << __LINE__ << " strReturn return is empty!!!";
        return -1;
    }
    int iBrightness = strReturn.toInt();

    return (double)(m_iMaxBrightness - iBrightness) / m_iMaxBrightness;
}

int CShellProcess::setBrightness(double dPercent)
{
#ifndef __arm__
    return 0;
#endif
    //get max value
    QProcess process;
    QStringList params;
    params.append("/sys/devices/soc0/backlight_lvds/backlight/backlight_lvds/max_brightness");
    process.start("cat", params);
    if(!process.waitForFinished()){
        qDebug() << __FILE__ <<" " << __LINE__ << " waitForFinished fail: " << process.errorString();
        return -1;
    }

    QString strReturn = QString(process.readAllStandardOutput());
    if(strReturn.size() < 1){
        qDebug() << __FILE__ <<" " << __LINE__ << " strReturn return is empty!!!";
        return -1;
    }
    int iMaxBrightness = strReturn.toInt();
    if(iMaxBrightness > 0){
        m_iMaxBrightness = (int)(iMaxBrightness * 0.8);
    }
    process.close();

    int iValue = m_iMaxBrightness - round(dPercent * m_iMaxBrightness);
    //get value
    params.clear();
    params.append("-c");
    params.append(QString("echo %1 > \"%2\"").arg(iValue).arg("/sys/devices/soc0/backlight_lvds/backlight/backlight_lvds/brightness"));

    process.start("/bin/sh", params);
    if(!process.waitForFinished()){
        qDebug() << __FILE__ <<" " << __LINE__ << " waitForFinished fail: " << process.errorString();
        return -1;
    }

    return 0;
}

double CShellProcess::getVoiceVolume()
{
#ifndef __arm__
    return 0;
#endif
    QProcess process;
    QStringList params;
    params.append("cget");
    params.append("numid=5");
    process.start("amixer", params);
    if(!process.waitForFinished()){
        qDebug() << __FILE__ <<" " << __LINE__ << " waitForFinished fail: " << process.errorString();
        return -1;
    }

    QString strReturn = QString::fromUtf8(process.readAllStandardOutput());

    QStringList slReturn = strReturn.split("\n");
    if(slReturn.size() < 4){
        qDebug() << __FILE__ <<" " << __LINE__ << " slReturn size error, count: " << slReturn.size();
        return -2;
    }

    //get range
    int iMin = 0;
    int iMax = 127;
    QStringList slRangeLine = slReturn[1].split(",");
    for(int i = 0; i < slRangeLine.size(); i++){
        qDebug() << __FILE__ <<" " << __LINE__ <<  " slRangeLine " << i << " " << slRangeLine[i];
        if(slRangeLine[i].indexOf("min=") > -1){
            iMin = slRangeLine[i].midRef(QString("min=").size()).toInt();
        }
        else if(slRangeLine[i].indexOf("max=") > -1){
            iMax = slRangeLine[i].midRef(QString("max=").size()).toInt();
        }
    }

    qDebug() << __FILE__ <<" " << __LINE__ << " value iMax:" <<iMax << ", iMin: " <<iMin;
    if(iMax - iMin < 1){
        qDebug() << __FILE__ <<" " << __LINE__ << " value range error, iMax - iMin: " << iMax - iMin;
        return -3;
    }
    m_iMixerMin = iMin;
    m_iMixerMax = iMax;

    //get value
    QStringList slValueLine = slReturn[2].split(",");
    if(slValueLine.size() <1){
        qDebug() << __FILE__ <<" " << __LINE__ << " slValueLine size error, count: " << slReturn.size();
        return -4;
    }
    int iValue = slValueLine[1].toInt();//slValueLine[0].midRef( slValueLine[0].indexOf(QString("values=").size()) + QString("values=").size()).toInt();
    qDebug() << __FILE__ <<" " << __LINE__ << " value  iValue:" <<iValue;
    return (double)iValue/(iMax - iMin);
}

int CShellProcess::setVoiceVolme(double dPercent)
{
#ifndef __arm__
    return 0;
#endif
    int iValue = round(dPercent * (m_iMixerMax - m_iMixerMin));
    QProcess process;
    QStringList params;
    params.append("cset");
    params.append("numid=5");
    params.append(QString::number(iValue));
    process.start("amixer", params);
    if(!process.waitForFinished()){
        qDebug() << __FILE__ <<" " << __LINE__ << " waitForFinished fail: " << process.errorString();
        return -1;
    }

    QString strReturn = QString(process.readAllStandardOutput());
    QStringList slReturn = strReturn.split("\n");
    if(slReturn.size() < 4){
        qDebug() << __FILE__ <<" " << __LINE__ << " slReturn size error, count: " << slReturn.size();
        return -2;
    }

    //get range
//    int iMin = 0;
//    int iMax = 127;
//    QStringList slRangeLine = slReturn[1].split(",");
//    for(int i = 0; i < slRangeLine.size(); i++){
//        if(slRangeLine[i].indexOf("min=")){
//            iMin = slRangeLine[i].midRef(QString("min=").size()).toInt();
//        }
//        else if(slRangeLine[i].indexOf("max=")){
//            iMax = slRangeLine[i].midRef(QString("max=").size()).toInt();
//        }
//    }
//    if(iMax - iMin < 1){
//        qDebug() << __FILE__ <<" " << __LINE__ << " value range error, iMax - iMin: " << iMax - iMin;
//        return -3;
//    }
//    qDebug() << __FILE__ <<" " << __LINE__ << " value range error, iMax:" <<iMax << ", iMin: " <<iMin;
    //get value
    QStringList slValueLine = slReturn[2].split(",");
    if(slValueLine.size() <1){
        qDebug() << __FILE__ <<" " << __LINE__ << " slValueLine size error, count: " << slReturn.size();
        return -4;
    }
    int iNewValue = slValueLine[1].toInt();
    qDebug() << __FILE__ <<" " << __LINE__ << " value range iValue:" <<iNewValue;
    return iNewValue == iValue ? 1 : 0;
}

int CShellProcess::setCurDateTime(QString strDateTime)
{
    QProcess process;
    QStringList params;
    params.append("-c");
    params.append(QString("date -s '%1'").arg(strDateTime));
    process.start("/bin/sh", params);
    if(!process.waitForFinished()){
        qDebug() << __FILE__ <<" " << __LINE__ << " waitForFinished fail: " << process.errorString();
        return -1;
    }
    qDebug()<< QString(process.readAll());
    process.close();
#ifdef __arm__
    params.clear();
    params.append("-c");
    params.append("hwclock -w");
    process.start("/bin/sh", params);
    if(!process.waitForFinished()){
        qDebug() << __FILE__ <<" " << __LINE__ << " waitForFinished fail: " << process.errorString();
        return -1;
    }
    qDebug()<< process.readAll();
#endif
    return 0;
}

static QProcess m_playSoundProcess;
int CShellProcess::playSound(QString path)
{
    QStringList params;
    QProcess *process = &m_playSoundProcess;
    process->kill();
    params.append("-Dhw:0,0");
    params.append("-d5");
    params.append("/unit_tests/ASRC/audio8k165.wav");
    process->start("aplay", params);
    if(!process->waitForFinished()){
        qDebug() << __FILE__ <<" " << __LINE__ << " waitForFinished fail: " << process->errorString();
        return -1;
    }
    qDebug()<< QString(process->readAll());
    process->close();
#ifdef __arm__
    process->kill();
    params.append("-Dhw:0,0");
    params.append("-d5");
    params.append("/unit_tests/ASRC/audio8k165.wav");
    process->start("aplay", params);
    if(!process->waitForFinished()){
        qDebug() << __FILE__ <<" " << __LINE__ << " waitForFinished fail: " << process->errorString();
        return -1;
    }
    qDebug()<< process->readAll();
#endif
    return 0;
}

int CShellProcess::setLedOnOff(QString lednum, bool onoff)
{
    QString strOnOff = onoff ? "1" : "0";
    QStringList params;
    QProcess *process = &m_playSoundProcess;
    process->kill();
    params.append(strOnOff);
    params.append(">");
    params.append("/sys/class/leds/"+lednum+"/brightness");
    process->start("echo", params);

    qDebug() << __FILE__ <<" " << __LINE__ << " waitForFinished fail: " << params;


    if(!process->waitForFinished()){
        qDebug() << __FILE__ <<" " << __LINE__ << " waitForFinished fail: " << process->errorString();
        return -1;
    }
    qDebug()<< QString(process->readAll());
    process->close();

    return 0;
}
