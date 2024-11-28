/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : mousedetection.h
  Version       : 1.0
  Author        : han
  Created       : 2024-08-18
  Last Modified :
  Description   :  header file
  Function List :
  History       :
  1.Date        : 2024-08-18
    Author      : fensnote
    Modification: Created file

******************************************************************************/
#ifndef MOUSEDETECTION_H
#define MOUSEDETECTION_H

#include <QObject>
#include <QDebug>
#include <QEvent>
#include <QMouseEvent>
#include <QTouchEvent>
#include <QMouseEvent>
#include <QKeyEvent>

/**
 * @brief The MouseDetection class 程序消息过虑处理
 */

class MouseDetection : public QObject
{
    Q_OBJECT
public:
    explicit MouseDetection(QObject *parent = nullptr);

    /**
     * @brief eventFilter 过滤得到鼠标或屏幕事件
     * @param watched
     * @param event
     * @return
     */
    bool eventFilter(QObject *watched, QEvent *event) {
        bool ret = QObject::eventFilter(watched, event);;

        // 在这里，你可以检查事件的类型，并进行相应的处理
        if (event->type() == QEvent::TouchEnd/* || event->type() == QEvent::TouchBegin || event->type() == QEvent::TouchUpdate*/)
        {
            QTouchEvent *pTouchEvent = dynamic_cast<QTouchEvent *>(event);
            if(pTouchEvent){
                QList<QTouchEvent::TouchPoint> lPoints = pTouchEvent->touchPoints();
                if(lPoints.size() > 0){
                    //qDebug() << "mouseDetected pMouseEvent QEvent::TouchEnd";
                    emit mouseDetected(lPoints.at(0).pos().x(), lPoints.at(0).pos().y(), event->type() == QEvent::TouchEnd);
                }
            }
        }
        else if( event->type() == QEvent::HoverMove
                 || event->type() == QEvent::MouseButtonPress
                 || event->type() == QEvent::MouseButtonRelease
                 || event->type() == QEvent::MouseButtonDblClick){
            QMouseEvent *pMouseEvent = dynamic_cast<QMouseEvent *>(event);
            if(pMouseEvent && event->type() == QEvent::MouseButtonRelease){
                //qDebug() << "mouseDetected pMouseEvent";
                emit mouseDetected(pMouseEvent->globalX(), pMouseEvent->globalY(), 0);
            }
        }
        else if(event->type() == QEvent::KeyPress
                 || event->type() == QEvent::KeyRelease) {
            //qDebug() << "KeyPress event detected!";
            // 如果你想拦截这个事件，返回 true
            // 否则返回 false，以便其他对象能够接收到这个事件
            QKeyEvent *pKeyEvent = dynamic_cast<QKeyEvent *>(event);
            //qDebug() << "pKeyEvent->key" << pKeyEvent->key();
            if(pKeyEvent){
                qDebug() << "mouseDetected pKeyEvent";
                emit mouseDetected(0,0, pKeyEvent->key());
            }
        }

        return ret;
    }

signals:
    /**
     * @brief mouseDetected 发送按钮消息，
     * @param x
     * @param y
     * @param bRelease 是否按钮释放
     */
    void mouseDetected(int x, int y, int keyCode);
};

#endif // MOUSEDETECTION_H
