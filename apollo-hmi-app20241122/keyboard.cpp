/******************************************************************************/
/*! @File        : motor.cpp
 *  @Brief       : 物理按键板的按键消息读取
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
#include "keyboard.h"
#include "global_define.h"

typedef struct key_code {
    const char *name;
    unsigned short code;
} key_code_t;

static const key_code_t matrix_key_code[] =
{
    { "KEY_MINUS", KeyBoard::eKEY_MINUS },
    { "KEY_PLUS", KeyBoard::eKEY_PLUS },
    { "KEY_CONFIRM", KeyBoard::eKEY_CONFIRM },
    { "KEY_START_STOP", KeyBoard::eKEY_START_STOP },
    { "KEY_LOCK", KeyBoard::eKEY_LOCK },
    { "KEY_MUTE", KeyBoard::eKEY_MUTE },
    { "KEY_ROTARY_CONFIRM", KeyBoard::eKEY_ROTARY_CONFIRM },
};

KeyBoard::KeyBoard()
{

}

void KeyBoard::run()
{
    struct input_event ev;
    int fd, rd;
    int i,size;

    //Open Device
#ifdef BOARD_TQ
    if ((fd = open ("/dev/input/event4", O_RDONLY)) == -1) {
#else
    if ((fd = open ("/dev/input/event3", O_RDONLY)) == -1) {
#endif
        qDebug ("not a vaild device.\n");
    }

    size = sizeof(matrix_key_code)/sizeof(matrix_key_code[0]);
    qDebug("%d keys.\n", size);

    qDebug("Press any key.\n");


    while (1) {

        memset((void*)&ev, 0, sizeof(ev));

        rd = read (fd, (void*)&ev, sizeof(ev));

        if (rd <= 0){
            qDebug ("rd: %d\n", rd);
            msleep(1000);
        }

        if(ev.type == 1)
        {
            switch(ev.value)
            {
            case 0:
                qDebug("Key release\n");
                break;

            case 1:
                qDebug("Key press\n");
                break;

            case 2:
                qDebug("Key hold\n");
                break;

            default:
                qDebug("Undifined value\n");

            }
            qDebug("Key Code: %x\n", ev.code);
            for(i=0; i<size; i++)
            {
                if(ev.code == matrix_key_code[i].code)
                {
                    qDebug("%s\n", matrix_key_code[i].name );
                    qDebug("Code: %x\n", ev.code);
                    emit keyBoardMessage((KeyCode_t)ev.code, (KeyState_t)ev.value);
                    break;
                }
            }
        }
        msleep(10);
    }
}

