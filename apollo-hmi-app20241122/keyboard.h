#ifndef KeyBoard_H
#define KeyBoard_H
#include <QThread>

typedef enum KeyState {
    eRELEASED = 0,
    ePRESSED = 1,
    eHOLD = 2,
} KeyState_t;

class KeyBoard : public QThread
{
    Q_OBJECT
public:
    enum KeyCode_t {
        eKEY_MINUS = 0x1c,
        eKEY_PLUS = 0xd,
        eKEY_CONFIRM = 0xab,
        eKEY_START_STOP = 0x69,
        eKEY_LOCK = 0x66,
        eKEY_MUTE = 0x74,
        eKEY_ROTARY_CONFIRM = 0x6b,
    } ;
public:
    KeyBoard();

signals:
    void keyBoardMessage(int code, int/*KeyState_t*/ state);

protected:
    void run();
};

#endif // KeyBoard_H
