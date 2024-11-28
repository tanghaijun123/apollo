/******************************************************************************/
/*! @File        : cwarningsoundworder.cpp
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

#include "cwarningsoundworder.h"
#include <QMediaPlayer>
#include <QSettings>
#include <QApplication>
#include <QFile>
#include <QDebug>
#include <QDir>
#include <QtMath>
#include "global_define.h"

/******************************************************************************/
    /*! @File        : cwarningsoundworder.cpp
 *  @Brief       : 简要说明
 *  @Details     : 详细说明
 *  @Author      : han
 *  @Date        : 2024-08-04
 *  @Version     : v1.0
 *  @Copyright   : Copyright By yongrenxing, All Rights Reserved
 *
 **********************************************************
 *
 *  @Attention   :
 *  @par 修改日志:
 *  <table>
 *  <tr><th>Date       <th>Version   <th>Author    <th>Description
 *  <tr><td>2024-08-04 <td>1.0       <td>xxx     <td>创建初始版本
 *  </table>
 *
 **********************************************************
*/

/**
 * @brief CWarningSoundWorker::CWarningSoundWorker
 * 加载声音播放的默认参数
 * @param parent
 */
CWarningSoundWorker::CWarningSoundWorker(QObject *parent)
    : QObject{parent}
{
    QString iniFilePath = QApplication::applicationDirPath() + QString("/config.ini");
    QSettings setting(iniFilePath, QSettings::IniFormat);
    m_strSoundPath= QApplication::applicationDirPath() + "/sound/";
    QDir dir(m_strSoundPath);
    if(!dir.exists()){
        dir.mkpath(m_strSoundPath);
    }
    for(int i = 0; i < MAX_WARNING_TYPE_COUNT; i++){
        QString strKeyName = QString("Sound/file%1").arg(i);
        QString strFile = setting.value((strKeyName)).toString();
        if(strFile == ""){
            setting.setValue(strKeyName, strFile);
        }
        m_strSoundFileName.append(strFile);
    }
    QString strKeyName = QString("Sound/Volume");
    int icurSoundVolume = 80 + round(setting.value(strKeyName, "-1").toFloat())/100 * 20;
    if(icurSoundVolume == -1){
        icurSoundVolume = 50;
        setting.setValue(strKeyName, icurSoundVolume);
    }
    if(icurSoundVolume < 0){
        icurSoundVolume = 0;
    }
    else if(icurSoundVolume > 100)
    {
        icurSoundVolume = 100;
    }
    m_iCurVolume = icurSoundVolume;

    strKeyName = QString("Sound/NeedPlaySound");
    int iNeedPlaySound =  setting.value(strKeyName, "-1").toInt();
    if(iNeedPlaySound == -1){
        iNeedPlaySound = 1;
        setting.setValue(strKeyName, iNeedPlaySound);
    }
    m_bNeedPlaySound = iNeedPlaySound > 0;

    strKeyName = QString("Sound/KeySound");
    QString strKeySound =  setting.value(strKeyName, "").toString();
    if(strKeySound == ""){
        strKeySound = "";
        setting.setValue(strKeyName, strKeySound);
    }
    m_strKeySoundFileName = strKeySound;


}
/**
 * @brief CWarningSoundWorker::~CWarningSoundWorker
 * 释放声音类资源
 */
CWarningSoundWorker::~CWarningSoundWorker()
{
    if(m_pMediaPlayer){
        if(m_pMediaPlayer->state() == QMediaPlayer::PlayingState){
            m_pMediaPlayer->stop();
        }
        m_pMediaPlayer->setParent(nullptr);
        delete m_pMediaPlayer;
        m_pMediaPlayer = Q_NULLPTR;
    }

    if(m_pMediaPlayerKey){
        if(m_pMediaPlayerKey->state() == QMediaPlayer::PlayingState){
            m_pMediaPlayerKey->stop();
        }
        m_pMediaPlayerKey->setParent(nullptr);
        delete m_pMediaPlayerKey;
        m_pMediaPlayerKey = Q_NULLPTR;
    }


    if(m_pMedialPlayList){
        //m_pMedialPlayList->clear();
        m_pMedialPlayList->setParent(nullptr);
        delete m_pMedialPlayList;
        m_pMedialPlayList = Q_NULLPTR;
    }

    if(m_pMediaPlayerKeyList){
        //m_pMediaPlayerKeyList->clear();
        m_pMediaPlayerKeyList->setParent(nullptr);
        delete m_pMediaPlayerKeyList;
        m_pMediaPlayerKeyList = Q_NULLPTR;
    }

}
/**
 * @brief CWarningSoundWorker::onSetSoundType
 * 按当前报警级别修改播放的报警声音类型
 * @param iSoundType 按当前报警级别
 * -1 : 静音
 * 0  : 高优先级
 * 1  : 中优先级
 * 2  : 低优先级
 */
void CWarningSoundWorker::onSetSoundType(int iSoundType, bool bNew)
{
    qInfo() << "CWarningSoundWorker::onSetSoundType" << iSoundType;

    //同样的优先级报警，在静音后可以重新播放,所以去除该代码
//    if(m_iCurSoundType == iSoundType){
//        return;
//    }

    //在静音状态下，删除报警不触发新的报警声音
    qInfo() << "Remove alarm at muted" << m_bSoundMuted << iSoundType << bNew;
    if(m_bSoundMuted == true && iSoundType >= 0 && bNew == false) {
        m_iCurSoundType = iSoundType;
        return;
    }
    m_bSoundMuted = false;
    m_iCurSoundType = iSoundType;

    if(!m_bNeedPlaySound){
        return;
    }

    if(iSoundType < 0){
        if(m_pMediaPlayer) {
            // 关闭报警声音
            m_pMediaPlayer->stop();
            m_replayTimer->stop();
        }
    }
    else{        
        if(iSoundType >= MAX_WARNING_TYPE_COUNT){
            iSoundType = MAX_WARNING_TYPE_COUNT -1;
        }


        //检查声音文件是否存在
        if(m_strSoundFileName.size() < MAX_WARNING_TYPE_COUNT){
            qDebug("%s %d media file name exist!", __FILE__, __LINE__);
            return;
        }

        //添加播放文件列表
        if(!m_pMedialPlayList){
            m_pMedialPlayList = new QMediaPlaylist(this);
            m_pMedialPlayList->clear();
            //添加音频文件
            for(uint8_t i = 0; i < 3; i++)
            {
                QString strSoundName = QString("%1%2").arg(m_strSoundPath, m_strSoundFileName[i]);
                if(QFile::exists(strSoundName))
                {
                    m_pMedialPlayList->addMedia(QUrl::fromLocalFile(strSoundName));
                }
            }
        }

        // 创建播放器
        if(!m_pMediaPlayer){
            m_pMediaPlayer = new QMediaPlayer(this);
            connect(m_pMediaPlayer, &QMediaPlayer::mediaStatusChanged, this, &CWarningSoundWorker::onMediaStatusChanged);
            connect(m_pMediaPlayer, &QMediaPlayer::stateChanged, this, &CWarningSoundWorker::onStateChanged);
            connect(m_pMediaPlayer, QOverload<QMediaPlayer::Error>::of(&QMediaPlayer::error),
                 [=](QMediaPlayer::Error error){ qDebug() << "CWarningSoundWorker::QMediaPlayerError" << error;  });
            connect(m_pMediaPlayer, &QMediaPlayer::currentMediaChanged, this, &CWarningSoundWorker::onCurrentMediaChanged);

            connect(m_pMediaPlayer, &QMediaPlayer::bufferStatusChanged, this, &CWarningSoundWorker::onBufferStatusChanged);
        }

        if(!m_replayTimer) {
            m_replayTimer = new QTimer();
            //m_replayTimer->setSingleShot(true);
            connect(m_replayTimer, &QTimer::timeout, this, &CWarningSoundWorker::onReplayTimeout);
        }

        if(m_pMediaPlayer->state() == QMediaPlayer::PlayingState){
            m_pMediaPlayer->stop();
            m_replayTimer->stop();
        }

        qInfo() << "Media play";
        m_pMediaPlayer->setPlaylist(m_pMedialPlayList);
        m_pMedialPlayList->setCurrentIndex(m_iCurSoundType);
        m_pMedialPlayList->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);
        m_pMediaPlayer->setVolume(m_iCurVolume);
        m_pMediaPlayer->setPosition(0);
        m_pMediaPlayer->play();
        quint32 interval[3] = {5000, 8000, 20000};
        m_replayTimer->start(interval[m_iCurSoundType]);
    }
}

/**
 * @brief CWarningSoundWorker::onMediaStatusChanged
 * 暂停报警播放声音
 */
void CWarningSoundWorker::onMediaStatusChanged(QMediaPlayer::MediaStatus status)
{
    //qDebug() << "CWarningSoundWorker::onMediaStatusChanged" << status << m_pMediaPlayer->state();

    if(status == QMediaPlayer::EndOfMedia)
    {
//        if(m_pMediaPlayer->state() == QMediaPlayer::PlayingState){
//            m_pMediaPlayer->stop();
//        }

//        qInfo() << "onMediaStatusChanged Media play";
//        m_pMediaPlayer->setPlaylist(m_pMedialPlayList);
//        m_pMedialPlayList->setCurrentIndex(m_iCurSoundType);
//        m_pMedialPlayList->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);
//        m_pMediaPlayer->setPosition(0);
//        m_pMediaPlayer->play();
        //m_pMediaPlayer->stop();
        //m_replayTimer->start(500);
    }
}

void CWarningSoundWorker::onReplayTimeout()
{
    //qDebug() << "CWarningSoundWorker::onReplayTimeout" << m_pMediaPlayer->state();
    if(m_pMediaPlayer->state() == QMediaPlayer::PlayingState){
        m_pMediaPlayer->stop();
    }
    //qInfo() << "onReplayTimeout Media play";
    m_pMediaPlayer->setPlaylist(m_pMedialPlayList);
    m_pMedialPlayList->setCurrentIndex(m_iCurSoundType);
    m_pMedialPlayList->setPlaybackMode(QMediaPlaylist::CurrentItemOnce);
    m_pMediaPlayer->setPosition(0);
    m_pMediaPlayer->play();
}

void CWarningSoundWorker::onMediaPlayerError(QMediaPlayer::Error error)
{
    qDebug() << "QMediaPlayer::Error" << error;
}

void CWarningSoundWorker::onBufferStatusChanged(int percentFilled)
{
        //qDebug() << "QMediaPlayer::onBufferStatusChanged" << percentFilled;
}

void CWarningSoundWorker::onCurrentMediaChanged(const QMediaContent &media)
{
        //qDebug() << "QMediaPlayer::onCurrentMediaChanged" << media.isNull();
}


void CWarningSoundWorker::onStateChanged(QMediaPlayer::State state)
{
    //qDebug() << "QMediaPlayer::State" << state;
    if(state == QMediaPlayer::StoppedState)
    {
        //m_pMediaPlayer->setPlaylist(m_pMedialPlayList);
        //m_pMedialPlayList->setCurrentIndex(m_iCurSoundType);
        //m_pMedialPlayList->setPlaybackMode(QMediaPlaylist::CurrentItemInLoop);
        //m_pMediaPlayer->setPosition(0);
        //m_pMediaPlayer->play();
    }
}

/**
 * @brief CWarningSoundWorker::onPauseSound
 * 暂停报警播放声音
 */
void CWarningSoundWorker::onPauseSound()
{
    qInfo() << "CWarningSoundWorker::onPauseSound";
    if(!m_bNeedPlaySound){
        return;
    }
    if(!m_pMediaPlayer){
        qDebug("%s %d m_pMediaPlayer is null!", __FILE__, __LINE__);
        return;
    }
    //qDebug("%s %d m_pMediaPlayer onPauseSound, status: %d!", __FILE__, __LINE__, m_pMediaPlayer->state());
    if(m_pMediaPlayer->state() == QMediaPlayer::PlayingState){
        m_pMediaPlayer->stop();

        qDebug() << "CWarningSoundWorker::onPauseSound m_pMediaPlayer->pause";
    }
    m_replayTimer->stop();
    m_bSoundMuted = true;

    startDelayPlayTmr();
}
///**
// * @brief CWarningSoundWorker::onPlay
// * 暂停后继续播放报警声音
// */
//void CWarningSoundWorker::onPlay()
//{
//#ifdef AUDIO_ENABLED
//    qInfo() << "CWarningSoundWorker::onPlay";
//    //return;
//    if(!m_bNeedPlaySound){
//        return;
//    }
//    if(!m_pMediaPlayer){
//        qWarning("%s %d m_pMediaPlayer is null!", __FILE__, __LINE__);
//        return;
//    }

//    m_bSoundMuted = false;

//   // qDebug("%s %d m_pMediaPlayer onPlay, status: %d!", __FILE__, __LINE__, m_pMediaPlayer->state());
//    if(m_pMediaPlayer->state() != QMediaPlayer::PlayingState){
//        //m_pMediaPlayer->stop();
//        //m_pMediaPlayer->setPosition(0);
//        m_pMediaPlayer->play();
//    }
//    else{
//        int icurSoundType =  m_iCurSoundType;
//        m_iCurSoundType = -1;
//        qDebug() << "CWarningSoundWorker::onPlay onSetSoundType m_iCurSoundType = -1";
//        onSetSoundType(icurSoundType, true);
//    }
//#endif
//}
/**
 * @brief CWarningSoundWorker::onVolumeChanged
 * 修改音量大小
 * @param iVolume
 */
void CWarningSoundWorker::onVolumeChanged(int iVolume)
{
    if(!m_bNeedPlaySound){
        return;
    }
    if(!m_pMediaPlayer){
        qDebug("%s %d m_pMediaPlayer is null!", __FILE__, __LINE__);
        return;
    }
    m_iCurVolume = iVolume;
    if(m_pMediaPlayer->state() == QMediaPlayer::PlayingState){
        m_pMediaPlayer->stop();
        m_pMediaPlayer->setVolume(iVolume);
        m_pMediaPlayer->play();
    }

}
/**
 * @brief CWarningSoundWorker::onPlayKeySound
 * 插入按键声音
 */
void CWarningSoundWorker::onPlayKeySound()
{

#if 0
#ifdef AUDIO_ENABLED
    QDateTime curDateTime = QDateTime::currentDateTime();
    //if(m_dLastPlayKeyTime.msecsTo(curDateTime) < 500){
    //    return;
    //}
    m_dLastPlayKeyTime = curDateTime;
    if(!m_pMediaPlayerKeyList){
        m_pMediaPlayerKeyList = new QMediaPlaylist(this);

        QString strSoundName = QString("%1%2").arg(m_strSoundPath, m_strKeySoundFileName);
        if(QFile::exists(strSoundName)){
            m_pMediaPlayerKeyList->addMedia(QUrl::fromLocalFile(strSoundName));
        }
    }
    if(m_pMediaPlayerKeyList->mediaCount() < 1 ){
        qDebug("%s %d media count not enough!", __FILE__, __LINE__);
        return;
    }

    m_pMediaPlayerKeyList->setCurrentIndex(0);
    if(!m_pMediaPlayerKey){
        m_pMediaPlayerKey = new QMediaPlayer(this);
        //        connect(m_pMediaPlayer, &QMediaPlayer::mediaStatusChanged, this, [&](QMediaPlayer::MediaStatus status) {
        //            if (status == QMediaPlayer::EndOfMedia) {
        //                m_pMediaPlayer->setPosition(0);
        //                m_pMediaPlayer->play(); // 当媒体播放结束时，重新开始播放
        //            }
        //        });

        //m_pMediaPlayer->setPlaybackRate(QMediaPlaylist::CurrentItemInLoop);
        m_pMediaPlayerKey->setVolume(m_iCurVolume);
        m_pMediaPlayerKey->setPlaylist(m_pMediaPlayerKeyList);
    }

    if(m_pMediaPlayerKeyList->mediaCount() > 0){
#if 0
        if(m_pMediaPlayerKey->state() == QMediaPlayer::PlayingState){
            m_pMediaPlayerKey->stop();
            m_pMediaPlayerKey->setPosition(0);
        }
        m_pMediaPlayerKey->play();
#else
        if(m_pMediaPlayerKey->state() != QMediaPlayer::PlayingState){
            m_pMediaPlayerKey->play();
        }
#endif
    }
#endif

#else
    QDateTime curDateTime = QDateTime::currentDateTime();
    if(m_dLastPlayKeyTime.msecsTo(curDateTime) < 50){
        return;
    }
    m_dLastPlayKeyTime = curDateTime;

    if(m_pMediaPlayerKey->state() == QMediaPlayer::PlayingState){
        m_pMediaPlayerKey->stop();
    } else {
        m_pMediaPlayerKey->play();
    }

#endif

}

void CWarningSoundWorker::timerEvent(QTimerEvent *event)
{
    if(event->timerId() == m_iDelayPlaySound){
        onDelayPlayTimeOut();
        return;
    }
    QObject::timerEvent(event);
}

void CWarningSoundWorker::startDelayPlayTmr()
{
    stopDelayPlayTmr();
    m_iDelayPlaySound = startTimer(2*60*1000);
}

void CWarningSoundWorker::stopDelayPlayTmr()
{
    if(m_iDelayPlaySound > 0){
        killTimer(m_iDelayPlaySound);
    }
    m_iDelayPlaySound = 0;
}

void CWarningSoundWorker::onDelayPlayTimeOut()
{
    stopDelayPlayTmr();
    int icurSoundType =  m_iCurSoundType;
    m_iCurSoundType = -1;
    onSetSoundType(icurSoundType, true);
}
