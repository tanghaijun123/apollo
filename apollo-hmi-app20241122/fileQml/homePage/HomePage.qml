/******************************************************************************/
/*! @File        : HomePage.qml
 *  @Brief       : 简要说明
 *  @Details     : 详细说明
 *  @Author      : han
 *  @Date        : 2024-08-13
 *  @Version     : v1.0
 *  @Copyright   : Copyright By yongrenxing, All Rights Reserved
 *
 **********************************************************
 *
 *  @Attention   :主页面内容
 *  @par 修改日志:
 *  <table>
 *  <tr><th>Date       <th>Version   <th>Author    <th>Description
 *  <tr><td>2024-08-13 <td>1.0       <td>xxx     <td>创建初始版本
 *  </table>
 *
 **********************************************************
*/

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.4
import Qt.labs.settings 1.1
import QtQuick.Dialogs 1.3
import QtQuick.Controls.Styles 1.4
import "../mainFrame/assembly"

Item {
    width: 1280
    height: 800
//流量显示控件
    MainFlowShow{
        id: mainFlowValueShow
        width: 474
        height: parent.height
        anchors.left: parent.left
        anchors.top: parent.top
        rFlowRangMin: mainWindow.settingParam_FlowMin
        rFlowRangMax: mainWindow.settingParam_FlowMax
    }

//锁屏按钮
    Rectangle {
        id: rtLock
        width: 120
        height: parent.height
        GradientToolBtn{
            id: btnLock
            width: 88
            height: 88
            //radius: 4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            state_off_name:"bar_sensor_off"
            state_on_name: "bar_sensor_on"
            state_off_source: "qrc:/images/icon_button_lock(unlock)@2x.png"
            state_on_source:  "qrc:/images/icon_button_lock(lock)@2x.png"
            inner_color: "#000000"//"#0D4235"
            outer_color: "#272727"//"#0D463B"
            isRepaint: false
            btn_id: 2
            nButtonWidth: 44
            nButtonHeight: 44
            Connections{
                target: btnLock
                //锁屏按钮按下后操作
                function onToolButtonClicked(down){
                    homeOptSpeed.lockSpeedBtn(down);
                    if(down){
                        m_RunningTestManager.playKeySound();
                        popWindow.open("设备已锁定！", true);
                        tmrDelayLockWindow.stop();
                    }
                    else{
                        popWindow.open("设备已解锁！", false);
                        tmrDelayLockWindow.start();
                    }

                    mainWindow.bLocked = down;
                }
            }
            Connections{
                target: mainWindow
                function onKey_Lock()
                {
                    if(bWriteinglog){
                        return;
                    }

                    btnLock.btnClick();
                }
            }
        }

        Connections
        {
            target: m_mouseDetect
            function onMouseDetected(x, y, keyCode)//开启静音槽函数
            {
                if(popWindow.visible === false && mainWindow.bLocked && closePage.visible === false)
                {
                    //tmrNeedShowLockMessage.restart();
                    //console.debug(btnLock.x," " ,btnLock.y, " ", btnLock.width, " ", btnLock.height);

                    var screenPoint = rtLock.mapToGlobal(btnLock.x, btnLock.y);
                    //console.debug(screenPoint.x," " ,screenPoint.y);
                    if(!((x >= screenPoint.x && x <= screenPoint.x + btnLock.width) && (y >= screenPoint.y && y <= screenPoint.y + btnLock.height))){
                        m_RunningTestManager.playKeySound();
                        popWindow.open("设备已锁定！", true);
                    }
                }
            }
        }
        color: Qt.rgba(0/255, 0/255, 0/255, 1)//"#282828"
        anchors.left: mainFlowValueShow.right
        anchors.top: parent.top
        property int  iTopLineBottom: 230
        property int  iBottomLineTop: 400
        property int iLineLenth: 101
//绘制按钮背景
        Canvas{
            id: canvas
            width: rtLock.width
            height: rtLock.height
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                var tmp_c = width / 2;

                ctx.lineWidth = 2;
                ctx.lineCap = "round";
                ctx.beginPath();
                var grd = ctx.createLinearGradient(tmp_c, rtLock.iTopLineBottom, tmp_c, rtLock.iTopLineBottom - rtLock.iLineLenth);
                grd.addColorStop(0, "#414141");
                grd.addColorStop(1, "#1E1E1E");
                ctx.strokeStyle = grd;
                ctx.moveTo(tmp_c, rtLock.iTopLineBottom);
                ctx.lineTo(tmp_c, rtLock.iTopLineBottom - rtLock.iLineLenth);
                ctx.stroke();

                ctx.beginPath();
                grd = ctx.createLinearGradient(tmp_c, rtLock.iBottomLineTop, tmp_c, rtLock.iBottomLineTop + rtLock.iLineLenth);
                grd.addColorStop(1, "#1E1E1E");
                grd.addColorStop(0, "#414141");
                ctx.strokeStyle = grd;
                ctx.moveTo(tmp_c, rtLock.iBottomLineTop);
                ctx.lineTo(tmp_c, rtLock.iBottomLineTop + rtLock.iLineLenth);
                ctx.stroke();
            }
        }
        function updateLine()
        {
            canvas.requestPaint()
        }
    }
//速度显示控制，对应于HomeOptSpeed.qml
    HomeOptSpeed{
        id: homeOptSpeed
        anchors.left: rtLock.right
        anchors.leftMargin: 30
        anchors.top: parent.top
    }
    function motorSpeedRuning(){
        homeOptSpeed.motorSpeedRuning();
    }

    //更新显示流量值
    function showFlowValue(strValue){
        mainFlowValueShow.showFlowValue(strValue)
    }
    //更新电机转速值
    function showMotorSpeedValue(strValue){
        homeOptSpeed.showMotorSpeedValue(strValue)
    }
    //更新运行速度值
    function showRunningTimes(strValue){
        mainFlowValueShow.showRunningTime(strValue)
    }
}
