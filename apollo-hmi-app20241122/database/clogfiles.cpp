#include "clogfiles.h"
#include "ctestinginfodatas.h"
#include "cdatabasemanage.h"
#include "ctestdetaildatas.h"
#include "csettingdbopt.h"
#include "global_define.h"

#include <QFile>
#include <QTextStream>
#include <QFileInfo>
#include <QDir>
#include <unistd.h>
#include <QApplication>
#include <QProcess>

/******************************************************************************/
/*! @File        : clogfiles.cpp
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

#define MAX_FILE_INDEX 1000

CLogFiles::CLogFiles(QObject *parent)
    : QObject{parent}
{
    CSettingDBOpt setting;
    QString strParam = "";
    strParam = setting.getIniValue("Sys/MacthineType");
    if(strParam == ""){
        strParam= "MacthineType";
        setting.setIniValue("Sys/MacthineType", strParam);
    }
    m_strMacthineType = strParam;

    strParam = setting.getIniValue("Sys/SerialNumber");
    if(strParam == ""){
        strParam = "123456";
        setting.setIniValue("Sys/SerialNumber", strParam);
    }
    m_strSeriaNumber = strParam;

    strParam = setting.getIniValue("Sys/LogPath");
    if(strParam == ""){
        //strParam = QApplication::applicationDirPath() + "/log";
        strParam = "/run/media/sda1";
        setting.setIniValue("Sys/LogPath", strParam);
    }    
    m_strLogPath = strParam;

    m_strFileHead.resize(3);
    m_strFileHead[0] = 0xEF;
    m_strFileHead[1] = 0xBB;
    m_strFileHead[2] = 0xBF;
}

CLogFiles::~CLogFiles()
{
    freeData();
}

int CLogFiles::writeCurrenRuningLog( int iTestID)
{
    qInfo("%s %d begin write current run log!", __FILE__, __LINE__);
    QString strPath = getDrivePath();
    if(strPath == ""){
        qDebug("%s %d usb disk not find!", __FILE__, __LINE__);
        return CDatabaseManage::DBEUSBDiskNotFind;
    }
    if(m_strLogPath != strPath){
        m_strLogPath = strPath;
    }
    QDir dir(m_strLogPath);
    if(! dir.exists()){
        if(!dir.mkpath(m_strLogPath)){
            qDebug("%s %d file create path %s fail!", __FILE__, __LINE__, m_strLogPath.toUtf8().constData());
            return CDatabaseManage::DBELogFileCreatePathFail;
        }
    }

    QString strFileName;
    for(int i= 1; i < MAX_FILE_INDEX; i++){
        strFileName = QString("%1/record-%2-%3.csv").arg(m_strLogPath, QDate::currentDate().toString("yyyy-MM-dd")).arg(i, 3 , 10, QLatin1Char('0'));
        if(!QFile::exists(strFileName))
        {
            break;
        }
    }
    if(QFile::exists(strFileName)){
        QFile::remove(strFileName);
    }


    QFile file(strFileName);
    if (!file.open(QIODevice::WriteOnly)) {
        // 处理错误，例如可以抛出异常或者返回错误标志
        qDebug("%s %d file open fail: %s!", __FILE__, __LINE__, file.errorString().toUtf8().constData());
        return CDatabaseManage::DBELogFileopneFile;
    }
    QTextStream out(&file);
    out.setCodec("utf-8");
    out << m_strFileHead;


    CTestingInfoDatas db(m_pTestingDB, this);
    int iPatientID = 0;
    QString strDetailDataPath = "";
    if(iTestID == 0){

//        int iReturn = db.getPatientID(iPatientID);
//        if(iReturn != CDatabaseManage::DBENoErr){
//            qDebug("%s %d getPatientID return error: %d!", __FILE__, __LINE__, iReturn);
//            file.close();
//            return iReturn;
//        }

        int iReturn = db.getRunningReCordID(iTestID, strDetailDataPath, true);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d getRunningReCordID return error: %d!", __FILE__, __LINE__, iReturn);
            file.close();
            return iReturn;
        }

        if(iTestID == 0){
            qDebug("%s %d testing record not find!!", __FILE__, __LINE__);
            file.close();
            return CDatabaseManage::DBETestingIDNotFind;
        }
        out << tr("当前运行导出内容:\n");
    }
    else{
        int iReturn = db.getDetailDataPathByTestID(iTestID, strDetailDataPath);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d getDetailDataPathByTestID return error: %d!", __FILE__, __LINE__, iReturn);
            file.close();
            return iReturn;
        }
        out << tr("运行记录导出内容:\n");
    }

     out << "=========================================\n";

    int iReturn = db.getPatientIDByTestID(iTestID, iPatientID);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getPatientID return error: %d!", __FILE__, __LINE__, iReturn);
        file.close();
        return iReturn;
    }


    QString strPatientName = "";
    QString strSex = "";
    QString strAge = "";
    QString strPatientID = "";
    QString strBloodType = "";
    double dWeight = 0;
    double dHeight = 0;
    QDateTime dImplantationTime = QDateTime();
    iReturn = db.getPatientByPatientID(iPatientID, strPatientName, strSex, strAge, strPatientID, strBloodType, dWeight, dHeight, dImplantationTime);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getPatientByPatientID return error: %d!", __FILE__, __LINE__, iReturn);
        file.close();
        return iReturn;
    }

    out << "=========================================\n";
    out << tr("病人 ID:%1\n").arg(strPatientName.replace(2,1,"*"));
    //out << QString("病人 ID:%1, 性别: %2 年龄: %3").arg(strPatientName, strSex, strAge);
//    out << QString(" 病历号:%1, 血型: %2").arg(strPatientID, strBloodType);
//    out << QString(" 体重:%1, 身高: %2").arg(strPatientID, strBloodType);
    out << tr("手术时间:%1\n").arg(dImplantationTime.toString("yyyy年MM月dd日"));

//    QSqlQuery qryRunningRecord;
//    iReturn = db.getLastRunningRecord(iPatientID, qryRunningRecord);
//    if(iReturn != CDatabaseManage::DBENoErr){
//        qDebug("%s %d getRunningRecordList return error: %d!", __FILE__, __LINE__, iReturn);
//        file.close();
//        return iReturn;
//    }

    //if(qryRunningRecord.next()){
        out << "=========================================\n";
        //int nTestingID = qryRunningRecord.value("TestingID").toInt();
        //int nRunMinutes = qryRunningRecord.value("runMinute").toInt();
//        out << QString("开始时间: %1, 时长: %2H%3MIN").arg(qryRunningRecord.value("StartDateTime").toDateTime().toString("yyyy-MM-dd hh:mm:ss"))
//                     .arg(nRunMinutes/20).arg(nRunMinutes %60);
//        out << QString("流量最小值: %1LPM, 流量最大值: %2LPM").arg(qryRunningRecord.value("FlowValueMin").toDouble(), 2, 'f')
//                     .arg(qryRunningRecord.value("FlowValueMax").toDouble(), 2, 'f');
//        out << QString("转速最小值: %1RPM, 转速最大值: %2RPM").arg(qryRunningRecord.value("FlowValueMin").toDouble(), 2, 'f')
//                                                                           .arg(qryRunningRecord.value("FlowValueMax").toDouble(), 2, 'f');
//        out << "";
        //detail data
        //out << "运行记录导";
        out << tr("时间 转速 流量\n");

        CTestDetailDatas detialDB( strDetailDataPath,  iTestID);
        QSqlQuery qryDetail;
        iReturn = detialDB.getAllData(iTestID, qryDetail, false);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d getRunningRecordList return error: %d!", __FILE__, __LINE__, iReturn);
            file.close();
            return iReturn;
        }

        while(qryDetail.next()){
            QString strLog =  QString("%1 %2 RPM %3 LPM\n").arg(qryDetail.value("RecordDate").toDateTime().toString("yyyy-MM-dd hh:mm:ss"))
                       .arg(qryDetail.value("SpeedValue").toDouble(), 0, 'f', 0)
                       .arg(qryDetail.value("FlowVolume").toDouble(), 0, 'f', 2);
            //qInfo("%s %d write log %s", __FILE__, __LINE__, strLog.toUtf8().constData());
            out << strLog;
        }

    //}
    if(!file.flush()){
        qDebug("%s %d flush fail!!", __FILE__, __LINE__);
    }
    if(fsync(file.handle()) == -1){
        qDebug("%s %d fsync fail!!", __FILE__, __LINE__);
    }
    file.close();
    sync();
    qInfo("%s %d write current run done!", __FILE__, __LINE__);

    return CDatabaseManage::DBENoErr;
}

int CLogFiles::writeWarningsLog()
{
    qInfo("%s %d begin write warning log!", __FILE__, __LINE__);
    QString strPath = getDrivePath();
    if(strPath == ""){
        qDebug("%s %d usb disk not find!", __FILE__, __LINE__);
        return CDatabaseManage::DBEUSBDiskNotFind;
    }
    if(m_strLogPath != strPath){
        m_strLogPath = strPath;
    }
    QDir dir(m_strLogPath);
    if(! dir.exists()){
        if(!dir.mkpath(m_strLogPath)){
            qDebug("%s %d file create path %s fail!", __FILE__, __LINE__, m_strLogPath.toUtf8().constData());
            return CDatabaseManage::DBELogFileCreatePathFail;
        }
    }
    QString strFileName;
    for(int i= 1; i < MAX_FILE_INDEX; i++){
        strFileName = QString("%1/Warning-%2-%3.csv").arg(m_strLogPath, QDate::currentDate().toString("yyyy-MM-dd")).arg(i, 3 , 10, QLatin1Char('0'));
        if(!QFile::exists(strFileName))
        {
            break;
        }
    }
    if(QFile::exists(strFileName)){
        QFile::remove(strFileName);
    }


    QFile file(strFileName);
    if (!file.open(QIODevice::WriteOnly)) {
        // 处理错误，例如可以抛出异常或者返回错误标志
        qDebug("%s %d file open fail: %s!", __FILE__, __LINE__, file.errorString().toUtf8().constData());
        return CDatabaseManage::DBELogFileopneFile;
    }
    QTextStream out(&file);
    out.setCodec("utf-8");
    out << m_strFileHead;
    out << tr("报警记录导出内容:\n");
    out << "=========================================\n";
    out << tr("设备型号: %1\n").arg(m_strMacthineType);
    out << tr("设备序列号: %1\n").arg(m_strSeriaNumber);
    out << "\n";
    out << tr("时间 报警内容\n");
    CTestingInfoDatas db(m_pTestingDB, this);

    QSqlQuery qryWaring;
    int iReturn = db.getAllWarningRecords(qryWaring, false);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getWarningRecordsByTestingID return error: %d!", __FILE__, __LINE__, iReturn);
        file.close();
        return iReturn;
    }
    while(qryWaring.next()){
        QString strLog =  QString("%1 %21\n").arg(qryWaring.value("WarningDateTime").toDateTime().toString("yyyy-MM-dd HH:mm:ss"))
                /*.arg(qryWaring.value("WarningType").toInt())*/.arg(qryWaring.value("WarningTitle").toString());
        //qInfo("%s %d write log %s", __FILE__, __LINE__, strLog.toUtf8().constData());
        out <<  strLog;

    }
    if(!file.flush()){
        qDebug("%s %d flush fail!!", __FILE__, __LINE__);
    }
    if(fsync(file.handle()) == -1){
        qDebug("%s %d fsync fail!!", __FILE__, __LINE__);
    }
    file.close();   
    sync();
    qInfo("%s %d write warning log done!", __FILE__, __LINE__);
    return CDatabaseManage::DBENoErr;
}

int CLogFiles::writeActionsLog()
{
    qInfo("%s %d begin write action log!", __FILE__, __LINE__);
    QString strPath = getDrivePath();
    if(strPath == ""){
        qDebug("%s %d usb disk not find!", __FILE__, __LINE__);
        return CDatabaseManage::DBEUSBDiskNotFind;
    }
    if(m_strLogPath != strPath){
        m_strLogPath = strPath;
    }
    QDir dir(m_strLogPath);
    if(! dir.exists()){
        if(!dir.mkpath(m_strLogPath)){
            qDebug("%s %d file create path %s fail!", __FILE__, __LINE__, m_strLogPath.toUtf8().constData());
            return CDatabaseManage::DBELogFileCreatePathFail;
        }
    }
    QString strFileName;
    for(int i= 1; i < MAX_FILE_INDEX; i++){
        strFileName = QString("%1/Action-%2-%3.csv").arg(m_strLogPath, QDate::currentDate().toString("yyyy-MM-dd")).arg(i, 3 , 10, QLatin1Char('0'));
        if(!QFile::exists(strFileName))
        {
            break;
        }
    }
    if(QFile::exists(strFileName)){
        QFile::remove(strFileName);
    }


    QFile file(strFileName);
    if (!file.open(QIODevice::WriteOnly)) {
        // 处理错误，例如可以抛出异常或者返回错误标志
        qDebug("%s %d file open fail: %s!", __FILE__, __LINE__, file.errorString().toUtf8().constData());
        return CDatabaseManage::DBELogFileopneFile;
    }
    QTextStream out(&file);
    out.setCodec("utf-8");
    out << m_strFileHead;
    out << tr("操作记录导出内容:\n");
    out << "=========================================\n";
    out << tr("设备型号: %1\n").arg(m_strMacthineType);
    out << tr("设备序列号: %1\n").arg(m_strSeriaNumber);
    out << "\n";
    out << tr("时间 操作描述 参数\n");
    CTestingInfoDatas db(m_pTestingDB, this);

    QSqlQuery qryAction;
    int iReturn = db.getAllActions(qryAction, false);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getWarningRecordsByTestingID return error: %d!", __FILE__, __LINE__, iReturn);
        file.close();
        return iReturn;
    }
    while(qryAction.next()){
        QString strLog = QString("%1 %2 %3\n").arg(qryAction.value("RecordingTime").toDateTime().toString("yyyy-MM-dd hh:mm:ss"),
                                                   qryAction.value("ActionType").toString(), qryAction.value("Params").toString());
        qInfo("%s %d write log %s", __FILE__, __LINE__, strLog.toUtf8().constData());
        out << strLog;
    }
    if(!file.flush()){
        qDebug("%s %d flush fail!!", __FILE__, __LINE__);
    }
    if(fsync(file.handle()) == -1){
        qDebug("%s %d fsync fail!!", __FILE__, __LINE__);
    }
    file.close();
    sync();
    qInfo("%s %d write action done!", __FILE__, __LINE__);
    return CDatabaseManage::DBENoErr;
}

int CLogFiles::writeAllLog(QString strFileName, int iPatientID)
{
    QFileInfo info(strFileName);
    QDir dir(info.path());
    if(!dir.exists()){
        dir.mkpath(info.path());
    }

    QFile file(strFileName);
    if (!file.open(QIODevice::WriteOnly)) {
        // 处理错误，例如可以抛出异常或者返回错误标志
        qDebug("%s %d file open fail: %s!", __FILE__, __LINE__, file.errorString().toUtf8().constData());
        return CDatabaseManage::DBELogFileopneFile;
    }
    QTextStream out(&file);
    out.setCodec("utf-8");
    out << m_strFileHead;
    out << tr("运行记录导出内容:\n");
    out << "==========================\n";
    CTestingInfoDatas db(m_pTestingDB, this);
    if(iPatientID == 0){
        int iReturn = db.getPatientID(iPatientID);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d getPatientID return error: %d!", __FILE__, __LINE__, iReturn);
            file.close();
            return iReturn;
        }
    }

    QString strPatientName = "";
    QString strSex = "";
    QString strAge = "";
    QString strPatientID = "";
    QString strBloodType = "";
    double dWeight = 0;
    double dHeight = 0;
    QDateTime dImplantationTime = QDateTime();
    int iReturn = db.getPatientByPatientID(iPatientID, strPatientName, strSex, strAge, strPatientID, strBloodType, dWeight, dHeight, dImplantationTime);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getPatientByPatientID return error: %d!", __FILE__, __LINE__, iReturn);
        file.close();
        return iReturn;
    }

    out << tr("病人 ID:%1, 性别: %2 年龄: %3\n").arg(strPatientName.replace(2,1,"*"), strSex, strAge);
    out << tr(" 病历号:%1, 血型: %2\n").arg(strPatientID, strBloodType);
    out << tr(" 体重:%1, 身高: %2\n").arg(strPatientID, strBloodType);
    out << tr(" 手术时间:%1\n").arg(dImplantationTime.toString("yyyy年MM月dd日"));

    QSqlQuery qryRunningRecord;
    iReturn = db.getRunningRecordList(iPatientID, qryRunningRecord);
    if(iReturn != CDatabaseManage::DBENoErr){
        qDebug("%s %d getRunningRecordList return error: %d!", __FILE__, __LINE__, iReturn);
        file.close();
        return iReturn;
    }

    while(qryRunningRecord.next()){
        out << "==========================\n";
        int nTestingID = qryRunningRecord.value("TestingID").toInt();
        int nRunMinutes = qryRunningRecord.value("runMinute").toInt();
        out << tr("开始时间: %1, 时长: %2H%3MIN\n").arg(qryRunningRecord.value("StartDateTime").toDateTime().toString("yyyy-MM-dd hh:mm:ss"))
                     .arg(nRunMinutes/20).arg(nRunMinutes %60);
        out << tr("流量最小值: %1LPM, 流量最大值: %2LPM\n").arg(qryRunningRecord.value("FlowValueMin").toDouble(), 0, 'f', 2)
                     .arg(qryRunningRecord.value("FlowValueMax\n").toDouble(), 0, 'f', 2);
        out << tr("转速最小值: %1RPM, 转速最大值: %2RPM").arg(qryRunningRecord.value("FlowValueMin").toDouble(), 0, 'f', 2)
                                                                           .arg(qryRunningRecord.value("FlowValueMax").toDouble(), 0, 'f', 2);
        out << "\n";
        //detail data
        out << tr("运行记录导\n");

        CTestDetailDatas detialDB( qryRunningRecord.value("DetailPath").toString(),
                                  qryRunningRecord.value("TestingID").toInt());
        QSqlQuery qryDetail;
        iReturn = detialDB.getAllData(nTestingID, qryDetail, false);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d getRunningRecordList return error: %d!", __FILE__, __LINE__, iReturn);
            file.close();
            return iReturn;
        }

        while(qryDetail.next()){
            out << QString("%1 %2RPM %3LPM\n").arg(qryDetail.value("RecordDate").toDateTime().toString("yyyy-MM-dd hh:mm:ss"))
                       .arg(qryDetail.value("SpeedValue").toDouble(), 0, 'f', 2)
                       .arg(qryDetail.value("FlowVolume").toDouble(), 0, 'f', 2);
        }

        //warning
        out << tr("报警记录导出内容:\n");
        out << "==========================\n";
        QSqlQuery qryWaring;
        iReturn = db.getWarningRecordsByTestingID(nTestingID, qryWaring);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d getWarningRecordsByTestingID return error: %d!", __FILE__, __LINE__, iReturn);
            file.close();
            return iReturn;
        }

        while(qryWaring.next()){
            out << tr("%1 类型: %2, 内容:%3\n").arg(qryDetail.value("WarningDateTime").toDateTime().toString("yyyy-MM-dd hh:mm:ss"))
                       .arg(qryDetail.value("WarningType").toInt())
                       .arg(qryDetail.value("WarningTitle").toString());
        }

        //Action
        out << "操作记录导出内容:\n";
        out << "==========================\n";
        QSqlQuery qryAction;
        iReturn = db.getActionsByTestinID(nTestingID, qryAction);
        if(iReturn != CDatabaseManage::DBENoErr){
            qDebug("%s %d getWarningRecordsByTestingID return error: %d!", __FILE__, __LINE__, iReturn);
            file.close();
            return iReturn;
        }

        while(qryAction.next()){
            out << tr("%1 操作: %2RPM 参数: %3\n").arg(qryAction.value("RecordingTime").toDateTime().toString("yyyy-MM-dd hh:mm:ss"))
                       .arg(qryAction.value("ActionType").toDouble(), 0, 'f', 0)
                       .arg(qryAction.value("Params").toDouble(), 0, 'f', 2);
        }
    }

    if(!file.flush()){
        qDebug("%s %d flush fail!!", __FILE__, __LINE__);
    }
    if(fsync(file.handle()) == -1){
        qDebug("%s %d fsync fail!!", __FILE__, __LINE__);
    }
    file.close();

    return CDatabaseManage::DBENoErr;
}

void CLogFiles::onWriteCurrenRuningLog(int iPatientID)
{
    int iResult = writeCurrenRuningLog(iPatientID);
    qInfo("%s %d writeCurrenRuningLog, return: %d", __FILE__, __LINE__, iResult);
    if(iPatientID == 0)
        emit glb_RunningTestManager->receiveAction(Glb_define::conActExportLog, QString("当前运行"));
    else
        emit glb_RunningTestManager->receiveAction(Glb_define::conActExportLog, QString("运行记录"));
    emit writeCurrenRuningLogDone(iResult);
}

void CLogFiles::onWriteWarningsLog()
{
    int iResult = writeWarningsLog();
    qInfo("%s %d writeWarningsLog, return: %d", __FILE__, __LINE__, iResult);
    emit glb_RunningTestManager->receiveAction(Glb_define::conActExportLog, QString("报警记录"));
    emit writeWarningsLogDone(iResult);
}

void CLogFiles::onWriteActionsLog()
{
    int iResult = writeActionsLog();
    qInfo("%s %d writeActionsLog, return: %d", __FILE__, __LINE__, iResult);
    emit glb_RunningTestManager->receiveAction(Glb_define::conActExportLog, QString("操作记录"));
    emit writeActionsLogDone(iResult);
}

void CLogFiles::onInitData()
{
    m_pTestingDB = new CDatabaseManage(DB_TESTING_NAME);
}

void CLogFiles::freeData()
{
    if(m_pTestingDB){
        delete m_pTestingDB;
        m_pTestingDB = Q_NULLPTR;
    }
}

QString CLogFiles::checkUSBPath()
{
    QFile file("/proc/mounts");
    file.open(QIODevice::ReadOnly);
    QString strMountInfo = file.readAll();
    qDebug()<<strMountInfo;
    file.close();

    QStringList list = strMountInfo.split("\n");
    for(int i = 0 ; i < list.count(); i++)
    {
        if(list[i].startsWith("/dev/sd1",Qt::CaseInsensitive) || list[i].startsWith("/dev/sd2",Qt::CaseInsensitive))
        {
            QStringList sl = list[i].split(" ");
            if(sl.size() > 2){

                qDebug("%s %d %s", __FILE__, __LINE__, sl.at(1).toUtf8().constData());
                return sl[1];

            }

        }
    }
    QDir dir("/dev/sda1");
    if(!dir.exists("/dev/sda1")){
        return "";
    }
    if(!dir.mkpath(m_strLogPath))
    {
        return "";
    }
    QProcess process;
    QStringList params;
    params.append("/dev/sda1");
    params.append(m_strLogPath);
    process.execute("mount", params);
    return m_strLogPath;
}

QString CLogFiles::getDrivePath()
{

//    Device names of flash drives
//    A flash drive can be connected
//    via USB (typically a USB stick or a memory card via a USB adapter)
//    the device name is the same as for SATA drives, /dev/sdx
//    and partitions are named /dev/sdxn
//    where x is the device letter and n the partition number, for example /dev/sda1
//    via PCI (typically a memory card in a built-in slot in a laptop)
//    the device name is /dev/mmcblkm
//    and partitions are named /dev/mmcblkmpn
//    where m is the device number and n the partition number, for example /dev/mmcblk0p1
//    Example with an SSD, HDD, USB pendrive and an SD card

#if 0
    QDir dir;

    dir.setPath("/dev/disk/by-path/");

    QFileInfoList list = dir.entryInfoList();
    QString drive = "";

    for(int i = 0; i < list.size(); i++) {
        QFileInfo fileInfo = list.at(i);
        QString baseName = fileInfo.readLink();
         qDebug() << "File::getDrivePath " << baseName;
         QStringList nameList = baseName.split('/');
        if(baseName.contains("sd"))
        {
            drive = "/run/media/" + nameList.at(2);
            qDebug() << "File::getDriver: " << drive;
            //break;
        }
    }
    qDebug() << "CLogFiles::getDriver: " << drive;

    return drive;
#else
    // 创建 QProcess 对象来执行系统命令
    QProcess process;

    // 执行 lsblk 命令
    process.start("lsblk -o NAME,MOUNTPOINT");
    process.waitForFinished();

    // 获取命令输出
    QString output = process.readAllStandardOutput();

    // 查找 U 盘挂载点，通常是 /dev/sdX
    QStringList lines = output.split("\n");
    QString dirName = "";
    foreach (QString line, lines) {
        if (line.contains("sd") ) {
            // 找到挂载的设备
            QStringList lineList = line.split(' ');
            dirName = lineList.at(0);
            qDebug() << "clogfile dirName" << dirName;
            break;
        }
    }

    if(dirName == "") {
        return "";
    }

    dirName += "1";

    QString path = "/dev/" + dirName;
    QDir dir(path);
    if(dir.exists(path) == false){
        return "";
    }
    QString destDir = "/run/media/"+dirName;
    if(dir.mkpath(destDir) == false)
    {
        return "";
    }
    QStringList params;
    params.append(path);
    params.append(destDir);
    qDebug() << "clogfile mount" << params;
    process.execute("mount", params);
    return destDir;
#endif
}

CLogFilesMangage::CLogFilesMangage(QObject *parent): QObject(parent)
{
    m_pWriteLogWorker = new CLogFiles();
    m_pWriteLogThread = new QThread;
    m_pWriteLogWorker->moveToThread(m_pWriteLogThread);
    connect(this, &CLogFilesMangage::writeCurrenRuningLog, m_pWriteLogWorker, &CLogFiles::onWriteCurrenRuningLog);
    connect(this, &CLogFilesMangage::writeWarningsLog, m_pWriteLogWorker, &CLogFiles::onWriteWarningsLog);
    connect(this, &CLogFilesMangage::writeActionsLog, m_pWriteLogWorker, &CLogFiles::onWriteActionsLog);

    connect(m_pWriteLogWorker, &CLogFiles::writeCurrenRuningLogDone, this, &CLogFilesMangage::writeCurrenRuningLogDone);
    connect(m_pWriteLogWorker, &CLogFiles::writeWarningsLogDone, this, &CLogFilesMangage::writeWarningsLogDone);
    connect(m_pWriteLogWorker, &CLogFiles::writeActionsLogDone, this, &CLogFilesMangage::writeActionsLogDone);
    connect(m_pWriteLogThread, &QThread::started, m_pWriteLogWorker, &CLogFiles::onInitData);
    m_pWriteLogThread->start();
}

CLogFilesMangage::~CLogFilesMangage()
{
    if(m_pWriteLogThread){
        m_pWriteLogThread->quit();
        m_pWriteLogThread->wait();
        delete m_pWriteLogThread;
        m_pWriteLogThread = Q_NULLPTR;
    }

    if(m_pWriteLogWorker){
        delete m_pWriteLogWorker;
        m_pWriteLogWorker = Q_NULLPTR;
    }
}
