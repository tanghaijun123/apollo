/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : customsplashscreen.h
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

#ifndef CUSTOMSPLASHSCREEN_H
#define CUSTOMSPLASHSCREEN_H

#include <QObject>
#include <QWidget>
#include <QSplashScreen>

QT_FORWARD_DECLARE_CLASS(QProgressBar)


class CustomSplashScreen : public QSplashScreen
{
    Q_OBJECT
public:
    explicit CustomSplashScreen(QWidget *parent = nullptr);
    void init();

signals:
private:
    QProgressBar* m_progressBar=nullptr;

};

#endif // CUSTOMSPLASHSCREEN_H
