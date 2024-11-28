#ifndef UPGRADE_H
#define UPGRADE_H

#include <QObject>
#include <QProcess>
#include <QCloseEvent>
#include <QThread>
#include <QFile>

class Upgrade : public QThread
{
    Q_OBJECT
public:
    explicit Upgrade();

    Q_INVOKABLE bool startProcess();
    Q_INVOKABLE QString getStandardOutput();
    Q_INVOKABLE bool getStatus();
    Q_INVOKABLE float processPersent();
    Q_INVOKABLE QString error();
    Q_INVOKABLE QString errorFlag();

    enum E_State {
        E_Init,
        E_WaitStart,
        E_FlashMCU,
        E_WaitBoot,
        E_QueryMCU,
        E_UpdateApp
    };

private:
    int findPersent(QByteArray output);
    QStringList findError(QByteArray output);

    bool createScript();
    void updateError(QStringList err);
    void updateError(QString err, QString type = "");

    QByteArray standardOutput;
    QByteArray standardError;
    int mProcessPersent;
    QStringList mError;
    E_State mState;
protected:
    void closeEvent(QCloseEvent *);
    void run();

signals:
    void message();

public slots:
    void readStandardOutput();
    void readStandardError();
    void finishProcess(int exitCode, QProcess::ExitStatus exitStatus);
};

#endif // UPGRADE_H
