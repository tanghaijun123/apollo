/******************************************************************************/
/*! @File        : MainToolBar.qml
 *  @Brief       : 简要说明
 *  @Details     : 详细说明
 *  @Author      : han
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

import QtQuick 2.15
import QtQuick.Controls 2.4
import Qt.labs.settings 1.1
import QtQuick.Dialogs 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "./assembly"
import "./subcontral"

ToolBar {
    id: myToolBar
    property int ifontsize: 15
    property string strFontColor: Qt.rgba(190/255, 190/255, 190/255, 1)
    property int iCurPowerState: -1
    //x: 0
    //y: 0
    width: parent.width
    height: 100
    antialiasing: true
    property  alias muteItem:mute //Mute item
    property alias alarms :alarmLs;
    property alias g_tbShowMotor: tbShowMotor
    property alias g_tbShowFlowValue: tbShowFlowValue
    property alias g_tbShowPump: tbPump
    property int iSeparatorHeight: height / 2
    property int iBorderWidth: 1
    property int iButtonHeight: height - iBorderWidth *3
    property string strBtnBackColor: Qt.rgba(43/255, 43/255, 43/255, 1)// "#282828"
    property string strSeparatorColor: Qt.rgba(58/255, 58/255, 58/255, 1)// "#282828"
    property alias mutevisible: mute.alarm_mute_visible// 是否显示静音
    property int mutenumbers: 120 //静音倒计时数字
    signal showMotorValue(bool bShow) // 是否显示电机转速的信号
    signal showFlowValue(bool bShow) // 是否是显示流量的信号

    background: Rectangle{
        width: parent.width
        height: parent.height
        color:"#3D3D3D"
        anchors.fill: parent
        antialiasing: true
        //border.width: 2
    }
//    leftPadding:16
    RowLayout{
        id:layout
        spacing: 0
        Customspacing{customWidth:16}


//        ToolButton{
//            id: tbMotor
//            anchors.left: parent.left
//            width: 50
//            height: iButtonHeight
//            opacity: 1
//            enabled: true
//            icon.source: "qrc:/images/on_off=on@2x.png"
//            text: qsTr("电机")
//            font.bold: true
//            font.pixelSize: ifontsize
//            flat: true
//            palette.buttonText: strFontColor
//            background: Rectangle{
//                implicitWidth: 40
//                implicitHeight: 40
//                color: strBtnBackColor
//            }
//            anchors.verticalCenter: parent.verticalCenter
//            onClicked: console.log("click")
//        }



        ToolBarBtn
        {
            id: tbShowMotor
            m_width: 64
            m_height: 64
            state_off_name:"machinery_off"
            state_on_name: "machinery_on"
            state_off_source: "/images/off=off.png"//"/images/on_off=off@2x.png"
            state_on_source: "/images/off=on.png"
            btn_id: 1
            isEnable: false
            Connections{
                target: tbShowMotor
                function onToolButtonClicked(show){
                    showMotorValue(show)
                }
            }
//            测试代码可删除
//            MouseArea
//            {
//                anchors.fill: parent
//                onClicked:
//                {
//                    setMute();
//                }
//            }
        }
        Customspacing
        {
            customWidth: 16
        }
        CustomLine
        {

        }
        Customspacing
        {
            customWidth: 16
        }


        ToolBarBtn
        {
            id:tbShowFlowValue
            m_width: 64
            m_height: 64
            state_off_name:"bar_sensor_off"
            state_on_name: "bar_sensor_on"
            state_off_source: "/images/off=off-1.png"
            state_on_source: "/images/off=on-1.png"
            btn_id: 2
            isEnable: false
            Connections{
                target: tbShowFlowValue
                function ontoolButtonClicked(show){
                    showFlowValue(show)
                }
            }
        }
        Customspacing
        {
            customWidth: 16
        }
        CustomLine{}
        Customspacing
        {
            customWidth: 16
        }
        ToolBarBtn
        {
            id: tbPump
            m_width: 64
            m_height: 64
            state_off_name:"bar_pump_off"
            state_on_name: "bar_pump_on"
            state_off_source: "/images/on_off=off@2x(2).png"
            state_on_source: "/images/on_off=on@2x(2).png"
            btn_id: 3
            isEnable: false
        }
        Customspacing
        {
            customWidth: 16
        }
        AlarmList
        {
            id:alarmLs
        }
        Customspacing
        {
            customWidth: 2
        }
        Rectangle//在静音隐藏后,定位用
        {
            id:rectMute
            width: mute.width
            height: mute.height
            color:"transparent"
            Mute
            {
                id:mute
                Layout.minimumWidth: 2
                alarm_mute_visible: false
                mute_count:myToolBar.mutenumbers              
            }
        }
        Customspacing
        {
            customWidth: 16
        }
        CustomDateTime{}
        CustomLine{}
        Customspacing
        {
            customWidth: 16
        }
        GroupBatterys{//电池组
            id: gbBatters
        }
        Customspacing
        {
            customWidth: 16
        }
        CustomLine{}
        Customspacing
        {
            customWidth: 16
        }
        ToolBarBtn
        {
            id: tbACPower
            m_width: 64
            m_height: 64
            state_off_name:"bar_AC_off"
            state_on_name: "bar_AC_on"
            state_off_source: "/images/on_off=off@2x(3).png"
            state_on_source: "/images/on_off=on@2x(3).png"
            btn_id: 4
            isEnable: false
        }
        Customspacing
        {
            customWidth: 16
        }
    }
    function showCurrentDateTime(strDate, strTime){
        //dtcurTime.text = strTime
        //dtcurDate.text = strDate
    }

    Connections{
        target: mainWindow
        function onKey_Mute()
        {
            setMute();
        }
    }
    Connections{
        target: m_power
        function onUpdatePowerStatusExtend(powerOnOff,
                                           bat1chargingState,bat2chargingState,
                                           powerType,
                                           bat1PowerLevel, bat2PowerLevel,
                                           bat1Temp, bat2Temp,
                                           bat1Voltage, bat2Voltage,
                                           bat1Current, bat2Current,
                                           bat1CycleCount,bat2CycleCount,
                                           bat1SN,bat2SN,
                                           bat1RemTime,bat2RemTime,
                                           fanSpeed,postStatus
                                            ) {
            if(powerOnOff !== iCurPowerState){
                if(powerOnOff === 1) {
                    console.info("powerOnOff:", powerOnOff)
                    //关机前需要先判断是否锁屏，再判断是否在运行，最后弹窗提示关机\
                    if(mainWindow.bLocked) {
                        m_RunningTestManager.playKeySound();
                        popWindow.open("设备已锁定！", true)
                    }
                    else if(mainWindow.bPowerON)
                    {
                        closePage.open(pubCode.messageType.Information, "需停止泵，才能进行关机", closePage.conMPStartRunning)
                    }
                    else
                    {
                        closePage.open(pubCode.messageType.Question, "是否进行关机？", closePage.conMPPowerOffHmi);
                    }
                }
                iCurPowerState = powerOnOff;
            }


            if(powerType !== 1)//设置tbACPower状态
            {
                tbACPower.setState(tbACPower.state_off_name);
            }else
            {
                tbACPower.setState(tbACPower.state_on_name);
            }

            gbBatters.barreryStateChange(powerOnOff,
                                         bat1chargingState,bat2chargingState,
                                         powerType,
                                         bat1PowerLevel, bat2PowerLevel);
        }
    }

    Component.onCompleted:{
        tbShowMotor.setClickState(true)
        tbShowFlowValue.setClickState(true)
        tbPump.setClickState(true)
//        cbox_alarm.currentIndex = 0
//        mute.alarm_mute_visible = true
        tbACPower.setClickState(true)
    }
    /*!
    @Function    : clearMute()
    @Description : 清空报警内容
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function clearMute()
    {
        alarmLs.clearMute();
    }

    /*!
    @Function    : setMute()
    @Description : 设置静音图标
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setMute()
    {
        if(alarmLs.recordModel.count>0)
            mute.alarm_mute_visible=true;
    }

    /*!
    @Function    : closeMute()
    @Description : 关闭静音图标
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function closeMute()
    {
        mute.alarm_mute_visible=false;
    }

}



