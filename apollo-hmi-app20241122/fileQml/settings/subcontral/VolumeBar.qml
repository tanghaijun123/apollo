import QtQuick 2.15
import "../../mainFrame/assembly"

/*! @File        : VolumeBar.qml
 *  @Brief       : 系统设置页面 音量控件
 *  @Author      : likun
 *  @Date        : 2024-08-14
 *  @Version     : v1.0
*/

Rectangle
{
    id:volumnRect
    width: 664
    height: 64
    color:"transparent"
    CustomProcess
    {
        id:volumnBar
        bgColor:"#585858"

        Component.onCompleted: {
            //get voice value

            //var curVoiceVolume = m_ShellProcess.getVoiceVolume();
            var curVoiceVolume = mainSettingDB.getIniValue("Sound/Volume");
            if(curVoiceVolume < 0){
                console.debug("getVoiceVolume fail, error code: ", curVoiceVolume);
                return;
            }

            volumnBar.setPos(curVoiceVolume/100);
            tmrDelayCanUpdate.running = true;
        }
        Connections{
            target: volumnBar

            /*!
            @Function    : onUpdateValue()
            @Description : 接收更新值函数
            @Author      : likun
            @Parameter   :
            @Return      :
            @Date        : 2024-08-14
            */
            function onUpdateValue(){
                if(!volumnBar.canUpdateValue){
                    return;
                }

                var vVolume = Math.round(volumnBar.processValue * 100);
                mainSettingDB.setIniValue("Sound/Volume", vVolume);
                m_RunningTestManager.volumeChanged(vVolume /100 * 20 + 80);
            }
        }

        Timer{
            id: tmrDelayCanUpdate;
            running: false;
            repeat: false;
            interval: 5*100;
            onTriggered: {
                volumnBar.canUpdateValue = true;
            }
        }
    }
}


