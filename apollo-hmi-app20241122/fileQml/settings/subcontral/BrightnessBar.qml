import QtQuick 2.15
import "../../mainFrame/assembly"

/*! @File        : BrightnessBar.qml
 *  @Brief       : 系统设置 亮度控件
 *  @Author      : likun
 *  @Date        : 2024-08-14
 *  @Version     : v1.0
*/

Rectangle
{
    id:brightnessRect
    width: 664
    height: 64
    color:"transparent"

    CustomProcess
    {
        id:brightnessBar
        bgColor:"#585858"

        Component.onCompleted: {
            //get Brightness

//            var curBrightness = m_ShellProcess.getBrightness();
//            console.info("curBrightness", curBrightness);
//            if(curBrightness < 0){
//                console.debug("getBrightness fail, error code: ", curBrightness);
//                return;
//            }

            var curBrightness=mainSettingDB.getIniValue("Brightness/Value");
            if(curBrightness === "") {
                mainSettingDB.setIniValue("Brightness/Value", "0.8");
            }
            var iReturn = m_ShellProcess.setBrightness(parseFloat(curBrightness));
            if(iReturn < 0){
                console.debug("setBrightness fail, error code: ", iReturn);
            }

            brightnessBar.setPos(curBrightness);
            tmrDelayCanUpdate.running = true;
        }
        Connections{
            target: brightnessBar
            //set Brightness
            /*!
            @Function    : onUpdateValue()
            @Description : 接收更新值函数
            @Author      : likun
            @Parameter   :
            @Return      :
            @Date        : 2024-08-14
            */
            function onUpdateValue(){
                if(!brightnessBar.canUpdateValue)
                    return;
                var bright = brightnessBar.processValue;
                brightnessBar.setPos(bright);
                mainSettingDB.setIniValue("Brightness/Value", bright);
                var iReturn = m_ShellProcess.setBrightness(bright);
                if(iReturn < 0){
                    console.debug("setBrightness fail, error code: ", iReturn);
                }
            }
        }
        Timer{
            id: tmrDelayCanUpdate;
            running: false;
            repeat: false;
            interval: 5*100;
            onTriggered: {
                brightnessBar.canUpdateValue = true;
            }
        }
    }
}


