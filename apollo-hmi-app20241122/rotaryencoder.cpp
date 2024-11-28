/******************************************************************************/
/*! @File        : ratoryencoder.cpp
 *  @Brief       : 从驱动设备读取旋转编码器数据消息
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

#include <sys/file.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/input.h>
#include <string.h>
#include <QDebug>
#include "rotaryencoder.h"

RotaryEncoder::RotaryEncoder()
{
    m_rotaryEncoder = 0;
}

void RotaryEncoder::closeThread()
{
    QMutexLocker lock(&m_Mutex);
    m_bRunning = false;
}

void RotaryEncoder::run()
{
    struct input_event ev = {0};
    int fd, rd;

    //Open Device
    if ((fd = open ("/dev/input/event1", O_RDONLY)) == -1){
        qDebug ("not a vaild device.\n");
    }


    qDebug("Rotary encoder test.\n");


    while (m_bRunning){
        memset((void*)&ev, 0, sizeof(ev));

        rd = read (fd, (void*)&ev, sizeof(ev));
        if(!m_bRunning)
        {
            break;
        }
        if (rd <= 0){
            qDebug ("rd: %d\n", rd);
            msleep(1000);
        }

        if(sizeof(struct input_event) != rd)
        {
            perror("read error");
            exit(-1);

        }

        //qDebug("type:%d code:%d value:%d\n",
        //       ev.type, ev.code, ev.value);

        if(ev.type == 2)
        {
            m_rotaryEncoder += ev.value;
            emit updateRoratyEncode(m_rotaryEncoder, ev.value);
        }
        msleep(20);
    }
    close(fd);
    qDebug("Rotary encoder exit!!.\n");
}
