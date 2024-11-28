/******************************************************************************/
/*! @File        : upgrade.cpp
 *  @Brief       : 负责执行软件更新功能
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
#include <QGuiApplication>
#include <QFile>
#include <QDebug>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlProperty>
#include "upgrade.h"
#include "database/clogfiles.h"

Upgrade::Upgrade()
{
    mProcessPersent = 0;
    mError << "";
}

int Upgrade::findPersent(QByteArray output)
{
    bool f = false;
    QString p = "";
    for(int i = 0; i < output.size(); i++)
    {
        char a = output[i];
        if(a == '@') {
            f = true;
            p = "";
        } else if(f) {
            if(a == '%') {
                f = false;
            } else {
                p += a;
            }
        }
    }

    if(p == "" || f == true) {
        p = "0";
    }

    return p.toInt();
}

QStringList Upgrade::findError(QByteArray output)
{
    bool f = false;
    QString str = "";
    QStringList result;
    bool end = false; // true - end
    int size = output.size();
    for(int i = 0; i < size; i++)
    {
        char a = output[i];
        if(a == '<') {
            f = true;  //found start token '<'
            str = "";
            /*if(size > i) {
                if(output[i+1] == '!') { //found upgrade end flag
                    end = true;
                }
            }*/
        } else if(f) {
            if(a == '>') {  //found end token '>'
                f = false;
                break;
            } else {
                if(a != '!') {
                    str += a;
                } else {
                    end = true;
                }
            }
        }
    }

    // No error found
    if(f) {
        str = "";
    } else {
        result << str;
        if(end == true) {
            result << "end";
        } else {
            result << "";
        }
    }

    return result;
}

void Upgrade::updateError(QString err, QString type)
{
    mError.clear();
    mError << err << type;
}

void Upgrade::updateError(QStringList err)
{
    mError.clear();
    mError << err;
}

void Upgrade::run()
{
    int ack;
    QStringList error;
    QProcess pprocess;
    QString exec = "bash";
    QStringList args;
    QString mode;

    args << QGuiApplication::applicationDirPath().append("/entry.sh");
    args << CLogFiles::getDrivePath();
    args << "/home/root";
    qInfo() << "Upgrade::run args: " << args;

    pprocess.setWorkingDirectory(QGuiApplication::applicationDirPath());
    pprocess.start(exec, args);
    qInfo() << "Upgrade::run entry.sh";

    if(false == pprocess.waitForStarted())
    {
        qInfo() << "Upgrade::run entry.sh failed";
        updateError("run entry.sh failed");
        return;
    }

    standardOutput = "";
    mProcessPersent = 0;
    mError.clear();
    mState = E_Init;
    int persent;

    qInfo() << "Upgrade::run upgrade.sh";

    while(!pprocess.waitForFinished(500))
    {
        standardOutput += pprocess.readAllStandardOutput();
        standardError = pprocess.readAllStandardError();
        qInfo() << "standardOutput" << standardOutput;
        if(!standardError.isEmpty())
        {
            standardOutput += '\n';
            standardOutput += standardError;
            standardError.clear();
        }

        error = findError(standardOutput);
        if(error[0] != "")
        {
            updateError(error);
        }

        switch(mState)
        {
        case E_Init:

            qInfo() << "Upgrade::run E_Init";
            break;

        case E_UpdateApp:
            qInfo() << "Upgrade::run E_UpdateApp";
            break;
        }

        // get persentage
        int persent = findPersent(standardOutput);
        if(persent > mProcessPersent)
        {
            mProcessPersent = persent;
        }
    }

    standardOutput = pprocess.readAllStandardOutput();
    qInfo() << "Upgrade::run standardOutput" << standardOutput;
    error = findError(standardOutput);
    if(error[0] != "")
    {
        updateError(error);
    }
}

bool Upgrade::createScript()
{
    QString entryFilePath = QGuiApplication::applicationDirPath().append("/entry.sh");
    QFile::remove(entryFilePath);

    QFile::copy(":/scripts/entry.sh", entryFilePath);
    QFile::setPermissions(entryFilePath, QFileDevice::ExeOther | QFileDevice::ReadOwner
                          | QFileDevice::ExeOwner | QFileDevice::ExeUser);

    return true;
}

bool Upgrade::startProcess()
{
    // create entry.sh script
    createScript();

    QFile file(QGuiApplication::applicationDirPath().append("/entry.sh"));
    qInfo() << "entry file path:" << QGuiApplication::applicationDirPath().append("/entry.sh");
    if (!file.exists()) {
        qInfo() << "Error Upgrade::startProcess Open file error!";
        return false;
    }
    this->start();
    return true;
}

QString Upgrade::getStandardOutput()
{
    QByteArray bk = standardOutput;
    standardOutput.clear();
    return QString(bk);
}

float Upgrade::processPersent()
{
    return (float)mProcessPersent/100;
}

QString Upgrade::error()
{
    if(!mError.isEmpty())
    {
        return mError[0];
    } else {
        return "";
    }
}

QString Upgrade::errorFlag()
{
    if(mError.length() > 1)
    {
        return mError[1];
    } else {
        return "";
    }
}

bool Upgrade::getStatus()
{
    return this->isRunning();
}

void Upgrade::readStandardOutput()
{

}

void Upgrade::readStandardError()
{

}

void Upgrade::finishProcess(int exitCode, QProcess::ExitStatus exitStatus)
{
    Q_UNUSED(exitCode);
    Q_UNUSED(exitStatus);
}
