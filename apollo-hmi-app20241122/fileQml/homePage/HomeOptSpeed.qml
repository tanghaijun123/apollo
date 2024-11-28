/******************************************************************************/
/*! @File        : HomeOptSpeed.qml
 *  @Brief       : 简要说明
 *  @Details     : 详细说明
 *  @Author      : han
 *  @Date        : 2024-08-13
 *  @Version     : v1.0
 *  @Copyright   : Copyright By yongrenxing, All Rights Reserved
 *
 **********************************************************
 *
 *  @Attention   : 主页面速度显示
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
import "../warnings"
import "../warnings/warningpages"
import "../warnings/subcontral"

Item {
    width: 550
    height: 600
    property int settingMotorSpeed: 0

//连接电机转速更新消息
    Connections{
        target: m_motor
        function onUpdateSettingMotorSpeed(speed){
            //if(mainWindow.bLocked == true)
            //{
                m_RunningTestManager.playKeySound();
            //}

            //屏幕锁定不能调速
            if(popWindow.visible == false && mainWindow.bLocked || speed === -1) //speed === -1 need to refactor
            {
                popWindow.open("设备已锁定！", true);
                return;
            }

            settingMotorSpeed = speed

            reStartDelaytmrDelayLockWindow();
        }
    }

//主页面显示速度

    HomeSpeedShow{
        id: speed_car
        x: 20
        y: 20
        width: 580
        height: 580
        dial_addR: -6
        dial_longNum: 12
        dial_longLen: 15
        dial_lineWidth: 3
        btm_lineWidth: 22
        top_lineWidth: 10

        top_startAngle: 138
        btm_startAngle: top_startAngle
        btm_endAngle: 264 + btm_startAngle
        top_endAngle_current: /*slider.value*/ bShowMotorValue ?  strMotorSpeedValue / maxSpeed * (btm_endAngle - top_startAngle) + top_startAngle : top_startAngle
        top_endAngle_setting: settingMotorSpeed / maxSpeed * (btm_endAngle - top_startAngle) + top_startAngle
        iSpeedRangeMin: mainWindow.settingParam_MotorMin //正常最小值
        iSpeedRangeMax: mainWindow.settingParam_MotorMax //正常最大值

        btm_r: 150
        top_r: 254

        onTop_endAngle_currentChanged: {
            updateLoginSpeedText();
        }

        onTop_endAngle_settingChanged: {
            realValue = settingMotorSpeed
            updateLoginSpeedText()
        }
//速度字体
        Text {
            id: speed
            color: mainWindow.bShowMotorSpeedValue ? ( (mainWindow.strMotorSpeedValue < settingParam_MotorMin ||  mainWindow.strMotorSpeedValue > settingParam_MotorMax) ? "#F43434": "#FFFFFF") : "#FFFFFF"
            y: (parent.width - height) /2
            text: bShowMotorSpeedValue ?  strMotorSpeedValue : "- -"
            style: Text.Normal
            font.weight: Font.Medium
            font.capitalization: Font.MixedCase
            font.pixelSize: 130
            //font.bold: true
            font.family: "Quicksand"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.horizontalCenter
            visible: false
        }
//速度单位字体
        Text {
            id: speedUnit
            visible: bShowMotorSpeedValue
            text: qsTr("RPM")
            font.pointSize: 38
            //font.bold: true
            font.weight: Font.Medium
            font.family: "Quicksand"
            color: "#FFFFFF"
            opacity: 0.6
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.top: speed.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
//速度提示字体
        Text {
            id: speedCaption

            text: qsTr("转速")
            font.pointSize: 30
            font.weight:  Font.Medium
            //font.bold: true
            font.family: "OPPOSans"
            color: "#FFFFFF"
            opacity: 1
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.bottom: speed.top
            anchors.horizontalCenter: parent.horizontalCenter
        }


        Label {
            id: label1
            x: 140
            y: 450
            text: qsTr("0")
            color: "#FFFFFF"
            opacity: 0.7
            font.family: "Quicksand"
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 32
        }

        Label {
            id: label2
            x: 360
            y: 450
            text: globalMaxMotorSpeed
            color: "#FFFFFF"
            opacity: 0.7
            font.family: "Quicksand"
            font.weight: Font.Normal
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 32
        }

    }



    Slider {
        id: slider
        visible: false
        font.pointSize: 14
        stepSize: 1
        to: globalMaxMotorSpeed
        from: 0
        value: strMotorSpeedValue

        onValueChanged: {
            speed.color = "white"

            mainWindow.speedValueChanged((slider.value == 0)? "--" : slider.value);
        }
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
    property color btnNormalColor: "#404040"
    property color btnDisableColor: "#141515"
    //目标调速下降按钮
    CustomBtn{
        id: btnSpeedDown
        width: 180
        height: 64
        nButtonWidth: 64
        nButtonHeight: 64
        normal_source: "qrc:/images/icon_button_reduce@3x.png"
        down_source: "qrc:/images/icon_button_reduce@31x.png"
        normal_bkcolor: btnNormalColor //"#141515"
        pressed_bkcolor: "#029074"
        disable_bkcolor: btnDisableColor//"#404040"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 80
        Connections{
            target: btnSpeedDown
            function onBtnClicked(nSteps){
                m_motor.stepSpeedDown(nSteps)
                speed_car.updateLoginSpeedText();
                reStartDelaytmrDelayLockWindow();
            }
        }

    }
    //目标调速上升按钮
    CustomBtn{
        id: btnSpeedUp
        width: 180
        height: 64
        nButtonWidth: 64
        nButtonHeight: 64
        normal_source: "qrc:/images/icon_button_plus@3x.png"
        down_source: "qrc:/images/icon_button_plus@3x(2).png"
        normal_bkcolor: btnNormalColor //"#141515"
        pressed_bkcolor: "#029074"
        disable_bkcolor: btnDisableColor //"#404040"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 20
        Connections{
            target: btnSpeedUp
            function onBtnClicked(nSteps){
                m_motor.stepSpeedUp(nSteps)
                speed_car.updateLoginSpeedText();
                reStartDelaytmrDelayLockWindow();
            }
        }

    }

    function motorSpeedRuning(){
        speed_car.updateLoginSpeedText();
    }

//更新工具栏下面的电机转速
    function showMotorSpeedValue(strValue){
        if(!mainWindow.bPowerON)
        {
            slider.value =  0
            speed.visible = false;
            speedUnit.visible = false;
        }
        else if(strValue === "- -"){
            slider.value =  0
            speed.visible = true;
            speedUnit.visible = true;
        }
        else{
            slider.value = strValue;
            speed.visible = true;
            speedUnit.visible = true;
        }
    }

//开始任务或停止任务时将转速设置成0
    Connections{
        target:mainWindow
        function onBPowerONChanged()
        {
            showMotorSpeedValue(0);

        }

    }
//锁屏处理事件
    function lockSpeedBtn(bLocked){
        btnSpeedDown.enabled = !bLocked;
        btnSpeedUp.enabled = !bLocked;
        m_motor.setLocked(bLocked);
        if(!bLocked){
            reStartDelaytmrDelayLockWindow();
        }
    }
    //更新速度显示内容
    function updateCanasPaint(){
        speed_car.updateLoginSpeedText();
    }
//控件创建完成后，更新默认速度参数
    Component.onCompleted: {
        showMotorSpeedValue(globalDefMotorSpeed) ;
        settingMotorSpeed = m_motor.getSettingMotorSpeed();
    }
}
