/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : cwarningsoundworder.h
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

#ifndef CWARNINGSOUNDWORDER_H
#define CWARNINGSOUNDWORDER_H

#include <QObject>
#include <QMediaPlayer>
#include <QMediaPlaylist>
#include <QDateTime>
#include <QTimer>

/**
 * @brief The CWarningSoundWorker class
 */

class CWarningSoundWorker : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief CWarningSoundWorker
     * @param parent
     */
    explicit CWarningSoundWorker(QObject *parent = nullptr);
    /**
     *
     *
     */
    ~CWarningSoundWorker();
public slots:
    /**
     * @brief onSetSoundType
     * @param iSoundType
     */
    void onSetSoundType(int iSoundType, bool bNew);

    /**
     * @brief onPauseSound
     */
    void onPauseSound();

//    /**
//     * @brief onPlay
//     */
//    void onPlay();

    /**
     * @brief onVolumeChanged
     * @param iVolume
     */
    void onVolumeChanged(int iVolume);

    /**
     * @brief onPlayKeySound
     */
    void onPlayKeySound();

    void onMediaStatusChanged(QMediaPlayer::MediaStatus status);
    void onMediaPlayerError(QMediaPlayer::Error error);
    void onStateChanged(QMediaPlayer::State state);
    void onBufferStatusChanged(int percentFilled);
    void onCurrentMediaChanged(const QMediaContent &media);
    void onReplayTimeout();

protected:
    /**
     * @brief timerEvent
     * @param event
     */
    void timerEvent(QTimerEvent *event);
private:

    /**
     * @brief m_iDelayPlaySound
     */
    int m_iDelayPlaySound{0};

    /**
     * @brief startDelayPlayTmr
     */
    void startDelayPlayTmr();

    /**
     * @brief stopDelayPlayTmr
     */
    void stopDelayPlayTmr();

    void startReplayTmr(int interval);

    void stopReplayTmr();
    /**
     * @brief onDelayPlayTimeOut
     */
    void onDelayPlayTimeOut();
private:
    /**
     * @brief m_pMediaPlayer
     */
    QMediaPlayer *m_pMediaPlayer{Q_NULLPTR};

    /**
     * @brief m_pMedialPlayList
     */
    QMediaPlaylist *m_pMedialPlayList{Q_NULLPTR};

    /**
     * @brief m_pMediaPlayerKey
     */
    QMediaPlayer * m_pMediaPlayerKey{Q_NULLPTR};

    /**
     * @brief m_pMediaPlayerKeyList
     */
    QMediaPlaylist *m_pMediaPlayerKeyList{Q_NULLPTR};
    //int m_soundLevel {50};

    /**
     * @brief m_strSoundFileName
     */
    QList<QString> m_strSoundFileName;

    /**
     * @brief m_strKeySoundFileName
     */
    QString m_strKeySoundFileName{""};

    /**
     * @brief m_strSoundPath
     */
    QString m_strSoundPath{""};

    /**
     * @brief m_iCurSoundType
     */
    int m_iCurSoundType{-1};

    /**
     * @brief m_bSoundMuted
     */
    bool m_bSoundMuted{false};

    /**
     * @brief m_iCurVolume
     */
    int m_iCurVolume{50};

    /**
     * @brief m_bNeedPlaySound
     */
    bool m_bNeedPlaySound{true};

    /**
     * @brief m_dLastPlayKeyTime
     */
    QDateTime m_dLastPlayKeyTime{QDateTime::currentDateTime()};
    //QTimer *m_replayTimer;
    int m_timerToReplay{0};
};

#endif // CWARNINGSOUNDWORDER_H
