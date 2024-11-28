import QtQuick 2.15
/*! @File        : Mute.qml
 *  @Brief       : 静音
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/

Rectangle //右边静音框
{
    property  bool alarm_mute_visible:false
    property int mute_count: 120
    property  string alarm_mute_text_content:alarm_mute.mute_count.toString()+"s"//静音显示倒计时
    signal closeMute();//close mute
    signal beginMute(); // begin mute
    id:alarm_mute
    width:80
    height:96
    color:"transparent"
    visible:alarm_mute.alarm_mute_visible

    Image
    {
        id: alarm_mute_img
        source: "/images/icon_Top navigation bar_Alarm elimination@2x.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        z:0
    }
    Text
    {
        id: alarm_mute_text
        width: parent.width
        text: `${mute_count}s`
        font.weight: Font.DemiBold
        font.family: "Quicksand"
        font.pixelSize: 28
        color: "#FFFFFF"
        anchors.bottom: parent.bottom
        horizontalAlignment: Text.AlignHCenter
        bottomPadding: 5
        visible: true
        z:1
    }

    Timer
    {
        id:countDownTimer
        interval: 1000
        repeat: true
        onTriggered:
        {
            if(alarm_mute.mute_count>1)
            {
                alarm_mute.mute_count--;
                alarm_mute_text.text=`${mute_count}s`
            }
            else
            {
                alarm_mute.alarm_mute_visible=false;
                //m_RunningTestManager.playSound();
            }
        }
    }    

    onAlarm_mute_visibleChanged:
    {
        if(alarm_mute.alarm_mute_visible)
        {
            mute_count=mutenumbers;
            alarm_mute_text.text=mute_count.toString()+"s";
            alarm_mute.beginMute();
            m_RunningTestManager.pauseSound();
            countDownTimer.restart();
        }
        else
        {
            countDownTimer.stop();
        }
    }

    Connections{
        target: m_RunningTestManager
        function onMinWaringTypeInRunning(iMinWaringType: int, bNew: bool){
            // 静音状态，有新的报警，应该清除静音
            if(alarm_mute_visible === true) {
                if(iMinWaringType > -1 && bNew === true) {
                    alarm_mute_visible = false
                    countDownTimer.stop();
                }
            }
        }
    }
}
