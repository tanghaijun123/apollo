import QtQuick 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.5

/*! @File        : CloseMessagePage.qml
 *  @Brief       : 关闭页面
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/

Popup {
    id:root
    width: 80
    height: 80
    closePolicy: Popup.NoAutoClose
    modal:true
    background: Rectangle {
        color: "transparent"
    }
    visible: false
    Timer
    {
        id:countDown
        interval: 500
        repeat: false
        onTriggered:
        {
            root.close();
        }
    }

    BusyIndicator {
        id: busyIndicator
        running: root.visible
        width: 80
        height: 80

        contentItem: Item {
            implicitWidth: 64
            implicitHeight: 64

            Item {
                id: item
                x: parent.width / 2 - 32
                y: parent.height / 2 - 32
                width: 64
                height: 64
                opacity: busyIndicator.running ? 1 : 0

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 250
                    }
                }

                RotationAnimator {
                    target: item
                    running: busyIndicator.visible && busyIndicator.running
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1250
                }

                Repeater {
                    id: repeater
                    model: 8

                    Rectangle {
                        x: item.width / 2 - width / 2
                        y: item.height / 2 - height / 2
                        implicitWidth: 10
                        implicitHeight: 10
                        radius: 5
                        color: "#00F5FF"
                        transform: [
                            Translate {
                                y: -Math.min(item.width, item.height) * 0.5 + 5
                            },
                            Rotation {
                                angle: index / repeater.count * 360
                                origin.x: 5
                                origin.y: 5
                            }
                        ]
                    }
                }
            }
        }
    }

    /*!
    @Function    : open(curType=pubCode.messageType.Question,msg="",closePos int 位置)
    @Description : 打开关闭页
    @Author      : likun
    @Parameter   : curType int 关闭页面类型,msg string 提示语,closePos
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function open()
    {
        root.visible=true;
        countDown.running = true;
    }

}
