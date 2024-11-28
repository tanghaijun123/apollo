/******************************************************************************/
/*! @File        : customsplashscreen.cpp
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

#include "customsplashscreen.h"

#include <QPixmap>
#include <QThread>
#include <QDateTime>
#include <QApplication>
#include <QProgressBar>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QDebug>

#define DELAYTIME 1000
#define SHOWNO 3

CustomSplashScreen::CustomSplashScreen(QWidget */*parent*/)
{
    QString strScreen=":/images/welcome.png";
    QFont nfont=font();
    nfont.setPixelSize(23);
    setFont(nfont);

    QPixmap loadingPix(strScreen);
    setPixmap(loadingPix.scaled(1280,800));

    m_progressBar=new QProgressBar(this);
    m_progressBar->setRange(0,100);
    m_progressBar->setValue(0);
    m_progressBar->setStyleSheet("QProgressBar{color:#008E73}");

    QLabel* label=new QLabel("加载中...");
    label->setStyleSheet("QLabel{color:#FFFFFF;font-weight:500;font-family:OPPOSans;font-size:30px;}");

    QVBoxLayout* pVB=new QVBoxLayout();
    pVB->addStretch();
    pVB->addWidget(label);
    pVB->addWidget(m_progressBar);
    setLayout(pVB);
}

void CustomSplashScreen::init()
{
// 先设置显示，再设置显示信息，如果设置完显示信息再设置显示，会看不到
    show();

    // 设置鼠标指针不转圈
    QApplication::setOverrideCursor(Qt::ArrowCursor);

    //showMessage("程序正在加载...", Qt::AlignTop|Qt::AlignRight, Qt::red);
    QDateTime time = QDateTime::currentDateTime();
    QDateTime currentTime = QDateTime::currentDateTime(); // 记录当前时间
    m_progressBar->setValue(0);
    int nInter = time.msecsTo(currentTime);
    while(nInter <= DELAYTIME)
    {
        currentTime = QDateTime::currentDateTime();
        m_progressBar->setValue(0.025*nInter);
        nInter = time.msecsTo(currentTime);
    }

    for(int i = 0; i < SHOWNO; ++i)
    {
        //showMessage(QString("请稍等%1...").arg(SHOWNO-i), Qt::AlignTop|Qt::AlignRight, Qt::red);
        showMessage(QString("").arg(SHOWNO-i), Qt::AlignTop|Qt::AlignRight, Qt::red);
        time = currentTime;
        nInter = time.msecsTo(currentTime);
        while(nInter <= DELAYTIME)
        {
            currentTime = QDateTime::currentDateTime();
            m_progressBar->setValue(25*(i+1) + 0.025*nInter);
            nInter = time.msecsTo(currentTime);
        }
    }
    m_progressBar->setValue(100);

}
