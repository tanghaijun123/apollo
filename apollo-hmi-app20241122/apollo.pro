QT += serialbus widgets quick qml charts sql multimedia
requires(qtConfig(combobox))
DEFINES += QT_MESSAGELOGCONTEXT
qtConfig(modbus-serialport): QT += serialport
QT_LOGGING_RULES="qt.qml.connections=false"

TARGET = apollo-hmi-app
TEMPLATE = app
CONFIG += c++11


SOURCES += \
    cshellprocess.cpp \
    customsplashscreen.cpp \
    cwarningsoundworder.cpp \
    database/cdatabasemanage.cpp \
    database/clogfiles.cpp \
    database/cpatientdataopt.cpp \
    database/crunningrecordmodel.cpp \
    database/crunningtestmanager.cpp \
    database/crunningtestopt.cpp \
    database/csettingdbopt.cpp \
    database/ctestdetaildataopt.cpp \
    database/ctestdetaildatas.cpp \
    database/ctestinginfodatas.cpp \
    database/ctestingoperationrecordquerymodel.cpp \
    database/cwarningdatamainlistmodel.cpp \
    database/cwarningdataquerymodel.cpp \
    database/cwarnningdataopt.cpp \
    global_define.cpp \
    main.cpp\
    flowsensor.cpp \
    motor.cpp \
    power.cpp \
    uartport.cpp \
    keyboard.cpp \
    rotaryencoder.cpp \
    cgpioapi.cpp \
    led.cpp \
    mousedetection.cpp \
    appinfo.cpp \
    upgrade.cpp

HEADERS += \
    cshellprocess.h \
    customsplashscreen.h \
    cwarningsoundworder.h \
    database/CRunningTestManager.h \
    database/cdatabasemanage.h \
    database/clogfiles.h \
    database/cpatientdataopt.h \
    database/crunningrecordmodel.h \
    database/crunningtestmanager.h \
    database/crunningtestopt.h \
    database/csettingdbopt.h \
    database/ctestdetaildataopt.h \
    database/ctestdetaildatas.h \
    database/ctestinginfodatas.h \
    database/ctestingoperationrecordquerymodel.h \
    database/cwarningdatamainlistmodel.h \
    database/cwarningdataquerymodel.h \
    database/cwarnningdataopt.h \
    global_define.h \
    flowsensor.h \
    motor.h \
    power.h \
    uartport.h \
    keyboard.h \
    rotaryencoder.h \
    cgpioapi.h \
    led.h \
    mousedetection.h \
    appinfo.h \
    upgrade.h


CONFIG += debug_and_release
CONFIG(debug, debug|release){  //处理debug
    win32{
    }
    unix{
        contains(QT_ARCH, arm){
                        message("ARM")
DESTDIR = $$PWD/../apollo-bin-arm/debug
target.path = /opt/apollo
INSTALLS += target
                        }else{
                        message("X86")
DESTDIR = $$PWD/../apollo-bin-x86/debug
target.path = $$PWD/../apollo-bin-x86/debug
                        }
    }
}else{     //处理release
    win32{
    }
    unix{
        contains(QT_ARCH, arm){
                        message("ARM")
DESTDIR = $$PWD/../apollo-bin-arm/release
target.path = /opt/apollo
INSTALLS += target
                        }else{
                        message("X86")
DESTDIR = $$PWD/../apollo-bin-x86/release
target.path = $$PWD/../apollo-bin-x86/release
INSTALLS += target
                        }
    }
}

RESOURCES += \
    apollo.qrc



exists (./.git) {
    GIT_BRANCH   = $$system(git rev-parse --abbrev-ref HEAD)
    GIT_TIME     = $$system(git show --oneline --format=\"%ci%H\" -s HEAD)
    GIT_COMMITID = $$system(git rev-parse HEAD)
    APP_VERSION = "$${GIT_COMMITID}"
} else {
    GIT_BRANCH      = None
    GIT_TIME        = None
    GIT_COMMITID    = None
    APP_VERSION     = "1"
}

DEFINES += GIT_BRANCH=\"\\\"$$GIT_BRANCH\\\"\"
DEFINES += GIT_TIME=\"\\\"$$GIT_TIME\\\"\"
DEFINES += APP_VERSION=\"\\\"$$APP_VERSION\\\"\"


CONFIG += link_pkgconfig

# 使用静态插件
static {
    QT += svg
    QTPLUGIN += qtvirtualkeyboardplugin
}
