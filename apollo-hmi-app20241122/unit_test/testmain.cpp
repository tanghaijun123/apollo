/******************************************************************************/
/*! @File        : main.cpp
 *  @Brief       : 简要说明
 *  @Details     : 详细说明
 *  @Author      : kevin
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

#include <QtQuick/QQuickView>
#include <QtCore/QDir>
#include <QtQml/QQmlEngine>
#include <QQmlApplicationEngine>
#include <QApplication>
#include <QLoggingCategory>
#include <QTextCodec>
#include <QQmlContext>
#include <QFontDatabase>
#include <QEvent>
#include <QThreadPool>
//#include <QLocale>
//#include <QTranslator>
#include "flowsensor.h"
#include "motor.h"
#include "power.h"
#include "keyboard.h"
#include "led.h"
#include "rotaryencoder.h"
#include "cshellprocess.h"
#include "./database/csettingdbopt.h"
#include "database/crunningrecordmodel.h"
#include "database/ctestingoperationrecordquerymodel.h"
#include "database/cwarningdataquerymodel.h"
#include "database/ctestdetaildataopt.h"
#include "database/crunningtestopt.h"
#include "database/cpatientdataopt.h"
#include "customsplashscreen.h"
#include <QWidget>

#include "database/cwarningdatamainlistmodel.h"
#include "database/clogfiles.h"
#include "database/crunningtestopt.h"
#include "appinfo.h"
#include "mousedetection.h"
#include "upgrade.h"
#include "unit_test/database/testcdatabasemanage.h"

//软件记录输出到文件
void myMessageOutput(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    static QMutex logLock;
    {
        QMutexLocker locker(&logLock);
        QString current_date_time = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss zzz");
        QString message = QString();
        QByteArray ba = (current_date_time + " " + msg).toLatin1();
        char *p_msg = ba.data();
        if(msg.indexOf("Message from") > -1){
            return;
        }
        if(msg.indexOf("PlayerControl") > -1){
            return;
        }
        if(msg.indexOf("QGstre") > -1){
            return;
        }
        if(msg.indexOf("source") > -1){
            return;
        }
        if(msg.indexOf("lib_mp3d") > -1){
            return;
        }
        if(msg.indexOf("Media status changed:") > -1){
            return;
        }
        if(msg.indexOf("CODEC:") > -1){
            return;
        }
        if(msg.indexOf("state changed: old:") > -1){
            return;
        }
        if(msg.indexOf("State changed:") > -1){
            return;
        }
        if(msg.indexOf("Trying to set") > -1){
            return;
        }

        switch (type) {
        case QtDebugMsg:
            fprintf(stderr, "Debug: %s (%s:%u, %s)\n", p_msg, context.file, context.line, context.function);
            message =QString( "Debug: %1 (%2:%3, %4)").arg( msg, context.file).arg(context.line).arg(context.function);
            break;
        case QtInfoMsg:
            fprintf(stderr, "Info: %s (%s:%u, %s)\n", p_msg, context.file, context.line, context.function);
            message =QString( "Info: %1 (%2:%3, %4)").arg( msg, context.file).arg(context.line).arg(context.function);
            break;
        case QtWarningMsg:
            fprintf(stderr, "Warning: %s (%s:%u, %s)\n", p_msg, context.file, context.line, context.function);
            message =QString( "Warning: %1 (%2:%3, %4)").arg( msg, context.file).arg(context.line).arg(context.function);
            break;
        case QtCriticalMsg:
            fprintf(stderr, "Critical: %s (%s:%u, %s)\n", p_msg, context.file, context.line, context.function);
            message =QString( "Critical: %1 (%2:%3, %4)").arg( msg, context.file).arg(context.line).arg(*context.function);
            break;
        case QtFatalMsg:
            fprintf(stderr, "Fatal: %s (%s:%u, %s)\n", p_msg, context.file, context.line, context.function);
            message =QString( "Fatal: %1 (%2:%3, %4)").arg( msg, context.file).arg(context.line).arg(context.function);
            abort();
        }
        QString strLogDir =  QApplication::applicationDirPath()+ "/applogs/";
        QDir dir(strLogDir);
        if(! dir.exists())
            dir.mkdir(strLogDir);

        QString strFileName = strLogDir+  QDateTime::currentDateTime().toString("yyyyMMdd") + ".txt";
        QFile file(strFileName);

        QString strFileNameInfo = strLogDir+  QDateTime::currentDateTime().toString("yyyyMMdd") + "_info.txt";
        QFile fileInfo(strFileNameInfo);

        if(type != QtInfoMsg)
        {
            if(file.open( QIODevice::WriteOnly | QIODevice::Append))
            {
                QTextStream text_stream(&file);
                text_stream <<current_date_time << " "<<message <<"\r\n";
                file.flush();
                file.close();
            }
        }
        else
        {
            if(fileInfo.open( QIODevice::WriteOnly | QIODevice::Append))
            {
                QTextStream text_stream(&fileInfo);
                text_stream <<current_date_time << " "<<message <<"\r\n";
                fileInfo.flush();
                fileInfo.close();
            }
        }
    }
}

int main(int argc, char *argv[])
{
    qDebug() << "*************************Evahear.com.cn***************************";


    QTextCodec *codec = QTextCodec::codecForName("UTF-8");
    QTextCodec::setCodecForLocale(codec);

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    // 设置环境变量以关闭QMediaPlayer的日志
    qputenv("QT_MEDIA_NO_DEBUG_OUTPUT", "1");
    QApplication a(argc, argv);
    qInstallMessageHandler(myMessageOutput);

    qInfo() << "***********" << __DATE__ << __TIME__;
    initTestCase();
    TestCDataBaseManage testCDataBaseManage;



#ifdef SPLASH_SCREEN_ENABLED
    CustomSplashScreen s;
    s.move(0,0);
    s.init();
#endif

//    QFontDatabase::addApplicationFont(":/fonts/DigitalOrAscll/Quicksand-Bold.ttf");
//    QFontDatabase::addApplicationFont(":/fonts/DigitalOrAscll/Quicksand-Light.ttf");
//    QFontDatabase::addApplicationFont(":/fonts/DigitalOrAscll/Quicksand-Medium.ttf");
//    QFontDatabase::addApplicationFont(":/fonts/DigitalOrAscll/Quicksand-Regular.ttf");
//    QFontDatabase::addApplicationFont(":/fonts/DigitalOrAscll/Quicksand-SemiBold.ttf");
//    QFontDatabase::addApplicationFont(":/fonts/Text/OPPOSans-B.ttf");
//    QFontDatabase::addApplicationFont(":/fonts/Text/OPPOSans-H.ttf");
//    QFontDatabase::addApplicationFont(":/fonts/Text/OPPOSans-M.ttf");
//    QFontDatabase::addApplicationFont(":/fonts/Text/OPPOSans-R.ttf");



    qmlRegisterType<CRunningTestOpt>("pollo.CRunningTestOpt",1,0,"CRunningTestOpt");
    qmlRegisterType<FlowSensor>("pollo.FlowSensor", 1, 0, "FlowSensor");
    qmlRegisterType<Motor>("pollo.Motor", 1, 0, "Motor");
    qmlRegisterType<Power>("pollo.Power", 1, 0, "Power");
    qmlRegisterType<KeyBoard>("pollo.Keyboard", 1, 0, "KeyBoard");
    qmlRegisterType<CShellProcess>("pollo.Process", 1, 0, "Process");
    qmlRegisterType<CSettingDBOpt>("pollo.SettingDB", 1, 0, "SettingDB");
    //qmlRegisterType<CRunningRecordModel>("pollo.CRunningRecordModel", 1, 0, "CRunningRecordModel");
    //qmlRegisterType<CTestingOperationRecordQueryModel>("pollo.CTestingOperationRecordQueryModel", 1, 0, "CTestingOperationRecordQueryModel");
    //qmlRegisterType<CWarningDataQueryModel>("pollo.CWarningDataQueryModel", 1, 0, "CWarningDataQueryModel");
    qmlRegisterType<CTestDetailDataOpt>("pollo.CTestDetailDataOpt", 1, 0, "CTestDetailDataOpt");
    //qmlRegisterType<CPatientDataOpt>("pollo.CPatientDataOpt", 1, 0, "CPatientDataOpt");
    //qmlRegisterType<CWarningDataMainListModel>("pollo.CWarningDataMainListModel", 1, 0, "CWarningDataMainListModel");
    qmlRegisterType<CLogFiles>("pollo.CLogFiles", 1, 0, "CLogFiles");
    qmlRegisterType<CLogFilesMangage>("pollo.CLogFilesMangage", 1, 0, "CLogFilesMangage");

    QQmlApplicationEngine engine;

    CDatabaseManage *m_pDB = new CDatabaseManage(DB_TESTING_NAME);

    //运行shell命令对象
    CShellProcess m_ShellProcess;

    //日志保存对象
    CLogFilesMangage m_LogFilesMangage;

    //任务管管理对象 功能 ：任务启停与运行，电机转速及流量报警判断，报警管理，记录定时写入等
    CRunningTestManager m_RunningTestManager(m_pDB);

    CRunningRecordModel cRunningModel(m_pDB);
    CTestingOperationRecordQueryModel cTestingModel(m_pDB);
    CWarningDataQueryModel  cWarningModel(m_pDB);
    CPatientDataOpt dbPatient(m_pDB);

    //CLogFiles m_LogFiles;

    //流量传感器对象
    FlowSensor m_flowsensor;


    Motor m_motor;
    Power m_power;
    KeyBoard m_keyBoard;
    //Led      m_led;
    AppInfo  m_appInfo;
    Upgrade m_upgrade;

    RotaryEncoder m_rotaryEncoder;
    MouseDetection m_mouseDetect;

#ifdef __arm__
    m_keyBoard.start();
    m_rotaryEncoder.start();
    //m_led.start();
    QObject::connect(&m_rotaryEncoder, &RotaryEncoder::updateRoratyEncode, &m_motor, &Motor::updateMotorSpeed);
#endif

    engine.rootContext()->setContextProperty("m_flowsensor", &m_flowsensor);
    engine.rootContext()->setContextProperty("m_motor", &m_motor);
    engine.rootContext()->setContextProperty("m_power", &m_power);
    engine.rootContext()->setContextProperty("m_keyBoard", &m_keyBoard);
    engine.rootContext()->setContextProperty("m_ShellProcess", &m_ShellProcess);
    engine.rootContext()->setContextProperty("m_RunningTestManager", &m_RunningTestManager);
    //engine.rootContext()->setContextProperty("m_LogFiles", &m_LogFiles);
    engine.rootContext()->setContextProperty("m_appInfo", &m_appInfo);
    engine.rootContext()->setContextProperty("m_mouseDetect", &m_mouseDetect);
    engine.rootContext()->setContextProperty("m_upgrade", &m_upgrade);
    engine.rootContext()->setContextProperty("m_LogFilesMangage", &m_LogFilesMangage);
    engine.rootContext()->setContextProperty("cRunningModel", &cRunningModel);
    engine.rootContext()->setContextProperty("cTestingModel", &cTestingModel);
    engine.rootContext()->setContextProperty("cWarningModel", &cWarningModel);
    engine.rootContext()->setContextProperty("dbPatient", &dbPatient);

    engine.setOfflineStoragePath("./");


#ifdef SPLASH_SCREEN_ENABLED
    QWidget w;
    w.move(0, 0);
#endif

    engine.load(QUrl(QStringLiteral("qrc:/fileQml/main.qml")));
    if(engine.rootObjects().isEmpty())
        return -1;
    engine.rootObjects().at(0)->installEventFilter(&m_mouseDetect);

#ifdef SPLASH_SCREEN_ENABLED
    s.finish(&w);
    w.close();
#endif

    //QApplication a(argc, argv);
    QObject::connect(&a, &QApplication::aboutToQuit, [&]()
                     {
                         qDebug() << "程序退出" ;
                         engine.rootObjects().clear();
                         engine.clearComponentCache();
                         delete m_pDB;
                         m_pDB = Q_NULLPTR;
                         qInstallMessageHandler(NULL);
                     });

    int iReturn = a.exec();
    return iReturn;
}

