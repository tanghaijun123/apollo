import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.4

ApplicationWindow {
    id: simulatorWin
    width: 800
    height: 400
    visible: true
    signal simulatorKeyBoardMessage(int code, int state)
    Column {
        anchors.fill: parent
        spacing: 10
        Row {
            spacing: 10
            Button {
                text: "<-"
                width: 120
                height: 64
                onReleased: {
                    simulatorKeyBoardMessage(0x1c, 0)
                }
            }

            Button {
                text: "->"
                width: 120
                height: 64
                onReleased: {
                    simulatorKeyBoardMessage(0xd, 0)
                }
            }
        }


        Button {
            text: "启动/停止"
            width: 250
            height: 64
            onReleased: {
                simulatorKeyBoardMessage(0x69, 0)
            }
        }

        Button {
            text: "锁定/解锁"
            width: 250
            height: 64
            onReleased: {
                simulatorKeyBoardMessage(0x66, 0)
            }
        }
        Button {
            text: "静音"
            width: 250
            height: 64
            onReleased: {
                simulatorKeyBoardMessage(0x74, 0)
            }
        }
    } //Column
}
