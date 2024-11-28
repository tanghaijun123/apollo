/******************************************************************************/
/*! @File        : main.qml
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

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.4
import Qt.labs.settings 1.1
import QtQuick.Dialogs 1.3
import QtQuick.Controls.Styles 1.4

import "./mainFrame"
import "./mainFrame/assembly"
import "./homePage"
import "./settings"
import "./warnings"
import "./warnings/publicAssembly"
import "./warnings/subcontral"
import "./warnings/warningpages"
import "./settings/settingpages"
import "./settings/subcontral"
import "./settings/subpage"
import "./recordings"
import "./recordings/recordpages"
import "./recordings/subcontral"
import "./recordings/subcontral/currentRun"
import "./recordings/subcontral/currentRun/flow"
import "./recordings/subcontral/currentRun/flowAndSpeed"
import "./recordings/subcontral/currentRun/speed"
import "./recordings/subcontral/publicAssembly"
import "./recordings/subcontral/record"
import "./recordings/subcontral/record/operationrecord"
import "./recordings/subcontral/record/publicAssembly"
import "./recordings/subcontral/record/runrecord"
import "./recordings/subcontral/record/warningrecord"
import "./recordings/subcontral/record/warningrecord/subcontral"
import QtQuick.LocalStorage 2.15
//import "./database/apolloSettingDB.js" as ApolloSettingDB
import pollo.FlowSensor 1.0
import pollo.Motor 1.0
import pollo.Power 1.0
import pollo.Keyboard 1.0
import pollo.SettingDB 1.0
//import "./homePage"
import "./mainFrame/subpage"
import "./advancedSettings"
import "./advancedSettings/subcontrol"
import QtQuick.VirtualKeyboard 2.1
import QtQuick.VirtualKeyboard.Settings 2.1
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: mainWindow
    x: 0
    y: 0
    width: 1280
    height: 800
    visible: true
    property alias popWindow: popWin
    property int globalMaxMotorSpeed:5000
    property real globalMaxflowValue:8.0
    property int globalDefMotorSpeed:0

    property date strStartRunTime: new Date()
    property string strFlowValue: "0.00"
    property string strMotorSpeedValue: "0"
    property bool bShowMotorValue: bPowerON
    property bool bShowFlowValue: bPowerON
    property bool bShowRealFlowValue: bShowFlowValue && bShowMotorValue && bPowerON
    property bool bShowMotorSpeedValue: bShowMotorValue && bPowerON

    property bool  bPowerON: false

    property string strParam_motorValue: "MotorSpeedValue"
    property int settingParam_MotorMin: 1600
    property int settingParam_MotorMax: 4700
    property string strParam_FowValue: "FlowValue"
    property real settingParam_FlowMin: 2.5
    property real settingParam_FlowMax: 4.5
    property bool bCanRotarySelected: true

    property color rotraySelectRectColor: "#37F7D2" //当前框选时的边框颜色
    property int rotraySelectBorderWidth: 4 //当前框选时的边框宽度
    property int pgCurIndex: tabBar.currentIndex //主页选中的序号
    //property int iSubPageSelectIndex: 0 //页面中选中的序号，为零时为下们工具栏按钮
    //property bool bSelInSubPage: false //在子页面中滚动
    property bool bSubComConfirmed: false
    property bool bLocked: false
    property int  iDelayLockSeconds: 15
    property bool bModifySpeedByKey: false
    property bool bModifySpeed: /*(mainWindow.pgCurIndex ===0
                                 && mainWindow.iSubPageSelectIndex === 0
                                 && mainWindow.bSubComConfirmed) ||*/ bModifySpeedByKey

    property int  curSelectedTestID: 0
    property bool  bWriteinglog: false

    property bool motorStartFlagAtInit: false
    property bool motorStopFlag: false
    property int boardTempLevelPre: 0
    property var fanSpeedLevel: [30,30,30,30,40,50,60,70,70,70]

    signal flowRangeChangedByMan(real iParamMin, real iParamMax);
    signal speedValueChanged(string strValue);
    signal flowValueChanged(string strValue);
    signal runningTimes(string strValue);
    signal havePatientValueChanged();
    /*!
    @Function    : acessPatientPage()
    @Description : 访问患者信息页面信号
    @Author      : likun
    @Parameter   :
    @Return      :
    @Date        : 2024-08-16
*/
    signal acessPatientPage();
    color: Qt.rgba(0/255, 0/255, 0/255, 1)       //"#141414"
    title: qsTr("Apollo")
    flags: Qt.Window | Qt.FramelessWindowHint
    //顶部工具栏
    header: MainToolBar {
        id: mainHeader
        enabled: true
    }
    //工具栏下面速度及流量显示栏
    DeviceRunInfo{
        id:devicerunInfo
        anchors.top:parent.top
        visible: tabBar.currentIndex==0?false:true
    }
    //几个几页面
    StackLayout {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        //主界面
        HomePage{
            id: pgHomePage
        }
        //报警设置页面
        WarningSetPage{
            id: pgWarningSettingPage
            anchors.top: parent.top
            anchors.topMargin:  189
        }
        //记录页面
        RecordPage{
            id: pgRecordPage
            anchors.top: parent.top
            anchors.topMargin: 189
        }
        //设置界面
        SetPage{
            id: pgSettingPage
            anchors.top: parent.top
            anchors.topMargin: 189
        }
    }
    ApplicationWindow {
        id: popWin
        title: "Top-Level Window"
        x: mainWindow.x + 560
        y: mainWindow.y + 80
        width: 250
        height: 70
        visible: false
        flags: Qt.WindowStaysOnTopHint | Qt.Window | Qt.FramelessWindowHint // 直接设置置顶

        background: Rectangle {
            id: backgrnd
            color: "#272727"
            anchors.fill: parent
            border.width: 1
            border.color: "#FFFFFF"
            radius: 1
        }

        Row {
            id: rowLayout
            anchors.fill: parent

            Image {
                id: imgIcon
                y: 16
                x: 16
                width: 46
                height: 46
                opacity: 0.6
                source: "qrc:/images/icon_button_lock(lock)@2x.png"
                visible: true
                anchors.verticalCenter: parent.verticalCenter
            }

            Label {
                id: lbInfomation
                text: "设备已锁定！"
                color: "#FFFFFF"
                font.pixelSize: 26
                font.weight: Font.Medium
                font.family: "OPPOSans"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter : parent.horizontalCenter
                anchors.left: imgIcon.right
                anchors.leftMargin: 16

                function updateAlignment() {
                    if (imgIcon.visible) {
                        anchors.left = imgIcon.right
                        anchors.leftMargin = 16
                        anchors.horizontalCenter = undefined

                    } else if(!imgIcon.visible) {
                        anchors.left = imgIcon.right
                        anchors.leftMargin = 0
//                        anchors.horizontalCenter = parent.horizontalCenter
                    }
                }

            }
        }

        Timer {
            id: tmrHide
            interval: 1000
            repeat: true
            running: false
            onTriggered: {
                running = false;
                popWin.visible = false;

            }
        }
        Component.onCompleted: {
               lbInfomation.updateAlignment();
           }
        function open(text, block) {
            if (closePage.visible == false) {
                tmrHide.running = true;
                lbInfomation.text = text;
                imgIcon.source = block ? "qrc:/images/icon_button_lock(lock)@2x.png" : "qrc:/images/icon_button_lock(unlock)@2x.png";
                imgIcon.visible = true;
                popWin.width = 250;
                lbInfomation.updateAlignment();
                popWin.visible = true;
            }
        }

        function openMessage(text) {
            if (closePage.visible == false) {
                tmrHide.running = true;
                lbInfomation.text = text;
                imgIcon.visible = false;
                popWin.width = 324;
                lbInfomation.updateAlignment();
                popWin.visible = true
            }
        }

        function openNoTmr(text) {
            if (closePage.visible == false) {
                lbInfomation.text = text;
                imgIcon.visible = false;
                popWin.width = 250;
                lbInfomation.updateAlignment();
                popWin.visible = true
            }
        }
    }

    Connections{
        target: swipeView;

        function onCurrentIndexChanged() {
            if(swipeView.currentIndex !== pgCurIndex){
                pgCurIndex = swipeView.currentIndex;
                bSubComConfirmed = false;
                tabBar.currentIndex = pgCurIndex;
                tabBar.setCheckedButton();
                if(swipeView.currentIndex == 2)
                {
                    pgRecordPage.refreshRecordList();
                }
            }
        }
    }
    //处理是否显示顶部的速度流量显示栏
    onPgCurIndexChanged:
    {
        if(pgCurIndex==0)
        {
            devicerunInfo.visible=false;
        }
        else
        {
            devicerunInfo.visible=true;
        }
    }

    //导航按钮区
    footer: CustomFooter{
        id: tabBar
        enabled: !mainWindow.bLocked/* && !mainWindow.bSelInSubPage*/;
    }

    property int nRunMinutes: 0
    //更新主面面的运行时长显示内容
    function updateRunTimesValue(){
        var strValue = "-h -min"
        if(bShowMotorValue && bPowerON)
        {
            var nCurMinutes = nRunMinutes % 60
            var nHours = Math.floor((nRunMinutes - nCurMinutes) / 60)
            strValue = "%1h%2min".arg(nHours).arg(nCurMinutes)
        }
        pgHomePage.showRunningTimes(strValue)

    }

    //更新流量显示值
    function updateFlowValue(){
        var strValue = "- -"
        if(bShowFlowValue && bShowMotorValue && bPowerON){
           strValue = strFlowValue
        }
        //update sub page flow values
        //pgHomePage.showFlowValue(strValue)
    }

   //更新当前时间显示
    function updateShowCurDateTime(strCurDateTime){
        var strCurDate = Qt.formatDate(strCurDateTime, "yyyy/MM/dd")
        var strCurTime = Qt.formatTime(strCurDateTime, "HH:mm:ss")
        mainHeader.showCurrentDateTime(strCurDate, strCurTime)
        //console.debug("current date %1 time %2".arg(strCurDate).arg(strCurTime))
    }

    //更新电机转速
    function updateMotorValue(){
        var strValue = "- -"
        if(bShowMotorValue)
        {
            strValue = strMotorSpeedValue
        }
        //update sub page motor speed value
        //pgHomePage.showMotorSpeedValue(strValue)

    }

    //
    Connections{
        target: mainHeader
        function onShowFlowValue(bshow)
        {
            bShowFlowValue = bshow
        }
        function onShowMotorValue(bShow)
        {
            bShowMotorValue = bShow          
            updateRunTimesValue()
        }
    }

    //连接流量传感器，显示流量值
    Connections{
        target: m_flowsensor
        function onUpdateFlowValue(connState, flow)
        {
            if(connState === false) {
                mainHeader.g_tbShowFlowValue.setClickState(false)
                strFlowValue = 0;
            }
            else
            {
                mainHeader.g_tbShowFlowValue.setClickState(true)
                strFlowValue = flow;
            }
        }
    }
    signal rotarySelected(int step);
    //连接电机转速传感器
    Connections{
        id: updateMotorStatueConnection
        target: m_motor
        //更新当前速度值及状态
        function onUpdateMotorStatusExtend(connState, errCode, motorSpeed,
                                   boardTemp, motorTemp,
                                   suspenCurrent, torqueCurrent,
                                   postResult, ctrlbFault,
                                   xPos, yPos,
                                   rotorStatus)
        {
            if(connState === false)
            {
                mainHeader.g_tbShowMotor.setClickState(false)
                mainHeader.g_tbShowPump.setClickState(false)
                //console.debug("qml onUpdateMotorStatus disconnected")
            }
            else if((errCode & 0x02) === 0x02)
            {
                mainHeader.g_tbShowMotor.setClickState(false)
            }
            else if((errCode & 0x10) === 0x10)
            {
                mainHeader.g_tbShowPump.setClickState(false)
            }
            else {
                mainHeader.g_tbShowMotor.setClickState(true)
                mainHeader.g_tbShowPump.setClickState(true)

                var boardTempLevel = Math.ceil(boardTemp / 10);

                if(boardTempLevel > 9)
                    boardTempLevel = 9;

                if(boardTempLevelPre !== boardTempLevel)
                {
                    m_power.requestUpdateFunSpeedCmd(fanSpeedLevel[boardTempLevel]);
                }

                boardTempLevelPre = boardTempLevel;

                //电机处于非停止状态
                if(rotorStatus > 0)
                {
                    if(motorSpeed < 0){
                        strMotorSpeedValue = "0";
                    }
                    else if(motorSpeed > globalMaxMotorSpeed){
                        motorSpeed = globalMaxMotorSpeed
                    }
                    else{
                        strMotorSpeedValue = motorSpeed
                        //console.debug("strMotorSpeedValue" , motorSpeed );
                        //updateMotorValue()
                    }

//                    if(motorStartFlagAtInit === false) {
//                        motorStartFlagAtInit = true;
//                        mainWindow.bPowerON = true;
//                        m_motor.setMotorStarted(true);
//                    }
                }
                else //电机处于停止状态
                {
                    //if(motorStopFlag === true) {
                    //    motorStopFlag = false
                    //    mainWindow.bPowerON = false;
                    //    m_motor.setMotorStarted(false);
                    //}
                }
            }
        }

        function onUpdateNewSelect(step)
        {
            //console.debug("onUpdateNewSelect: ", step);
            if(bCanRotarySelected && !bLocked)
            {
                rotarySelected(step);
            }
        }
    }
    signal key_Minus(int nState);
    signal key_Plus(int nState);
    signal key_Confirm();
    signal key_Start_Stop();
    signal key_Lock();
    signal key_Mute();
    signal key_RotaryConFirm();
    Connections
    {
        target: mainWindow
        function onKey_Lock()
        {
            tabBar.currentIndex = 0;
        }
    }

    //连接键盘事件
    Connections{
        target: m_keyBoard
        //处理按键消息
        function onKeyBoardMessage(code, state)
        {
            onKeyBoardMessageHandle(code, state)
        }
    }

    Connections{
        target: simulator
        //处理按键消息
        function onSimulatorKeyBoardMessage(code, state)
        {
            onKeyBoardMessageHandle(code, state)
        }
    }

    function onKeyBoardMessageHandle(code, state) {
        if(closePage.visible/* || popWindow.visible*/){
            return;
        }

        //处理锁屏按钮
        if(code === 0x66/*KeyBoard.eKEY_LOCK*/){
            //console.debug("recive eKEY_LOCK");
            if(state === 0){
                key_Lock();
            }
        } else {
            if(bLocked == false)
            {
                //console.debug("code: " + code + ",state: " + state);
                //处理向左翻页按钮消息
                if(code === 0x1c /*KeyBoard.eKEY_MINUS*/){
                    console.debug("recive eKEY_MINUS");
                    key_Minus(state);

                    if(state === 0) {
                        if(tabBar.currentIndex == 0) {
                            tabBar.currentIndex = 3;
                        } else {
                            tabBar.currentIndex--;
                        }
                        m_RunningTestManager.playKeySound();
                    }
                }
                //处理向右翻页按钮消息
                else if(code === 0xd/*KeyBoard.eKEY_PLUS*/){
                    //console.debug("recive eKEY_PLUS");
                    key_Plus(state);

                    if(state === 0) {
                        if(tabBar.currentIndex == 3) {
                            tabBar.currentIndex = 0;
                        } else {
                            tabBar.currentIndex++;
                        }
                        m_RunningTestManager.playKeySound();
                    }
                }
                //处理启停按钮消息
                else if(code === 0x69/*KeyBoard.eKEY_START_STOP*/){
                    //console.debug("recive eKEY_START_STOP");
                    if(state === 0){
                        if(tabBar.currentIndex === 0) {
                            key_Start_Stop();
                        } else {
                            popWindow.openMessage("请转主页面操作")
                        }
                        m_RunningTestManager.playKeySound();
                    }
                }
                //处理静音按钮消息
                else if(code === 0x74/*KeyBoard.eKEY_MUTE*/){
                    //console.debug("recive eKEY_MUTE");
                    if(state === 0){
                        // 如果有不可静音的报警，跳过静音操作
                        if(m_RunningTestManager.isWarningCanMuted())
                        {
                            if(mainHeader.mutevisible === false) {
                                key_Mute();
                                m_RunningTestManager.pauseSound()
                            }
                        } else {
                            popWindow.openMessage("当前报警不能静音")
                        }
                        m_RunningTestManager.playKeySound();
                    }
                }
            } else {
                //m_RunningTestManager.playKeySound();
            }
        }
    }

    signal restSelectedPage();
    //定时刷新刷新运行时间
    Timer{
        id: tmrRunTime
        interval: 1000
        repeat: true
        running: false
        onTriggered: {
            //console.debug("update run minutes!")
            var dCurDateTime = new Date()
            var nRunTimes = Math.floor((dCurDateTime.getTime() - strStartRunTime.getTime()) / 1000)
            var ncurSeconds = nRunTimes % 60
            if(ncurSeconds === 0)
            {
                nRunMinutes = Math.floor((nRunTimes - ncurSeconds) / 60)
                updateRunTimesValue()
            }
        }
    }

    //连接鼠标检测事件
    Connections
    {
        target: m_mouseDetect
        function onMouseDetected(x,y,keyCode)//开启静音槽函数
        {
            // 如果是锁定键按下进行锁定操作，不重启定时器
            if(keyCode !== 0x01000010) {
                //console.debug("onMouseDetected restart timer", tmrDelayLockWindow.interval, mainWindow.bLocked)
                reStartDelaytmrDelayLockWindow();
            }
        }
    }

    //延时锁屏定时器
    Timer{
        id: tmrDelayLockWindow
        interval: 15000
        repeat: false
        running: true
        onTriggered: {
            console.debug("Timeout lock!")
            key_Lock();
            advancedSettingsWin.close();
        }
    }

    //更新延时锁屏事件
    function reStartDelaytmrDelayLockWindow(){
        if(mainWindow.bLocked == false) {
            tmrDelayLockWindow.interval = mainWindow.iDelayLockSeconds * 1000;
            tmrDelayLockWindow.restart();
        }
    }

    //更新延时锁屏等待时间
    function updateLockTimeSetting(interval)
    {
        console.info("updateLockTimeSetting", interval)
        mainWindow.iDelayLockSeconds = interval;
        tmrDelayLockWindow.interval = mainWindow.iDelayLockSeconds * 1000;
        tmrDelayLockWindow.restart();
    }

    //设置数据库连接
    SettingDB{
        id: mainSettingDB;
    }
    Component.onCompleted: {
        //tmrRunTime.running = true;
        updateRunTimesValue(0);
        bShowMotorValue = false;
        bShowFlowValue = false;
        strFlowValue = '0.0'
        updateFlowValue();
        mainWindow.speedValueChanged("- -");
        mainWindow.flowValueChanged("- -");
        mainWindow.runningTimes("-h -min");
        bCanRotarySelected = true;
        var vDelayLock = mainSettingDB.getIniValue("Screen/Lock");
        if(vDelayLock < 1){
            vDelayLock = 15;
            mainSettingDB.setIniValue("Screen/Lock", vDelayLock);
        }

        console.debug("Time delay to lock screen", mainWindow.iDelayLockSeconds)
        mainWindow.iDelayLockSeconds = vDelayLock;
        tmrDelayLockWindow.interval = vDelayLock*1000;
        tmrDelayLockWindow.restart();

        var tmpRangMin = 0, tmpRanMax = 0;
        var res = mainSettingDB.getParam(strParam_motorValue, settingParam_MotorMin, settingParam_MotorMax);
        var json = JSON.parse(res);
        if(json.res === 0){
            settingParam_MotorMin = json.minValue;
            settingParam_MotorMax = json.maxValue;
        }
        res = mainSettingDB.getParam(strParam_FowValue, settingParam_FlowMin, settingParam_FlowMax);
        json = JSON.parse(res);
        if(json.res === 0){
            settingParam_FlowMin = json.minValue;
            settingParam_FlowMax = json.maxValue;
        }

        tmrCanUpdateParam.start();
    }

    //任务启停时触发后台任务启停
    onBPowerONChanged: {
        if(bPowerON)
        {
            strStartRunTime = new Date();
            bShowMotorValue = true;
            bShowFlowValue = true;

            m_RunningTestManager.startRunning();
            tmrRunTime.restart();
        }
        else{
            m_RunningTestManager.stopRunning();
            bShowMotorValue = false;
            bShowFlowValue = false;
            tmrRunTime.stop();
        }
        nRunMinutes = 0;
        updateRunTimesValue();
        updateFlowValue();
    }


    property bool bCanUpdateParamToDB: false
    Timer{
        id: tmrCanUpdateParam
        running: false;
        interval: 5*1000;
        repeat: false;
        onTriggered: {
            running = false;
            bCanUpdateParamToDB = true;
        }
    }

    //1 update flow value range, 0 update motor speed range
    property int m_UpdateType: 0

    Timer{
        id: tmrDelayUpdateSpeedRange
        running: false;
        interval: 2*1000;
        repeat: false;
        onTriggered: {
            running = false;
            console.debug("tmrDelayUpdateSpeedRange onTriggered")
            m_RunningTestManager.updateMotorSpeedRange(settingParam_MotorMin, settingParam_MotorMax);
        }
    }

    Timer{
        id: tmrDelayUpdateFlowRange
        running: false;
        interval: 2*1000;
        repeat: false;
        onTriggered: {
            running = false;
            console.debug("tmrDelayUpdateFlowRange onTriggered")
            m_RunningTestManager.updateFlowValueRange(settingParam_FlowMin, settingParam_FlowMax);
        }
    }

    Connections{
        target: mainWindow
        function onSettingParam_MotorMinChanged(){
            if(!bCanUpdateParamToDB)
            {
                return;
            }
            console.debug("onSettingParam_MotorMinChanged")
            tmrDelayUpdateSpeedRange.restart();
            m_UpdateType = 0;
        }
        function onSettingParam_MotorMaxChanged(){
            if(!bCanUpdateParamToDB)
            {
                return;
            }
            console.debug("onSettingParam_MotorMaxChanged")
            tmrDelayUpdateSpeedRange.restart();
            m_UpdateType = 0;
        }
        function onSettingParam_FlowMinChanged(){
            if(!bCanUpdateParamToDB)
            {
                return;
            }
            console.debug("onSettingParam_FlowMinChanged")
            tmrDelayUpdateFlowRange.restart();
            m_UpdateType = 1;
        }
        function onSettingParam_FlowMaxChanged(){
            if(!bCanUpdateParamToDB)
            {
                return;
            }
            console.debug("onSettingParam_FlowMaxChanged")
            tmrDelayUpdateFlowRange.restart();
            m_UpdateType = 1;
        }
    }

    property bool bCanCloseMainWindow: false
    onClosing: {
        if(!bCanCloseMainWindow){
            if(!closePage.open())
                closePage.open(pubCode.messageType.Question,"当前泵运行中，若泵停止将无法提供体外循环支持，确认停止？");
            if(m_RunningTestManager.isSIMULATION()){
                return;
            }

            close.accepted = false;
        }
    }

    property int inputX: 0 // 键盘x坐标(动态)
    property int inputY: mainWindow.height // 键盘y坐标(动态)

    // 嵌入式虚拟键盘
    InputPanel {
        id: inputPanel
        z: 99
        //更改x,y即可更改键盘位置
        x: inputX
        y: mainWindow.height
        //更改width即可更改键盘大小
        width: 3*mainWindow.width/4
        visible: true
        signal inputConfirm(string pageName)
        property var itemName: ""

        externalLanguageSwitchEnabled: false
        Component.onCompleted: {
            //VirtualKeyboardSettings.locale = "eesti" // 复古键盘样式
            VirtualKeyboardSettings.wordCandidateList.alwaysVisible = true
            //VirtualKeyboardSettings.styleName = "retro"                         // 复古样式
            VirtualKeyboardSettings.activeLocales = ["en_US","zh_CN","ja_JP"]
        }

        // 这种集成方式下点击隐藏键盘的按钮是没有效果的，只会改变active，因此我们自己处理一下
        onActiveChanged: {
            if(inputPanel.active === false)
            {
                visible = false
            }
        }
        onVisibleChanged: {
            if(inputPanel.visible === false)
            {
                inputConfirm(itemName)
            }
        }

        function open(posX, posY, name)
        {
            x = posX>0 ? posX : x;
            y = posY>0 ? posY : y;
            itemName = name;
            visible = true;
        }
    }

    PublicCode
    {
        id:pubCode
    }

    BusyIndicatorPage {
        id: busyIndicator
        anchors.centerIn: parent
    }

    function stopMotorRunning() {
        console.info("requestWriteMotorState: stop motor")
        mainWindow.bPowerON = false;
        m_motor.setMotorStarted(false);
        m_motor.setSpeedZero();
        m_motor.requestCmd("Stop");
        mainWindow.motorStopFlag = true;
    }

    Connections
    {
        target: closePage
        function onSendClose()
        {

            //启动任务时点击确定时执行
            if(closePage.closeMsgPos === closePage.conMPStartRunning){
                console.debug("requestWriteMotorState: Start motor")
                mainWindow.bPowerON = true;
                m_motor.setMotorStarted(true);
                // 如果用户没有设定，默认转速为2000RPM
                if(m_motor.getSettingMotorSpeed() === 0) {
                    m_motor.setSpeedDefault();
                }
                m_motor.requestCmd("Start")
                //signalRequestPaint();

            }
            //停止任务时点击确定时执行
            else if(closePage.closeMsgPos === closePage.conMPCloseRunning){
                stopMotorRunning();
            }
            //当前运行记录写入文件时，确定时执行
            else if(closePage.closeMsgPos === closePage.conMPDonwloadCurRunningRecord){
                closePage.visible = false;
                if(curSelectedTestID == 0 && !bPowerON){
                    closePage.open(pubCode.messageType.Information, "启动电机后重试！！！");
                }
                else{
                    closePage.visible = false;
                    bWriteinglog = true;
                    closePage.open(pubCode.messageType.Information, "正在导出数据...", closePage.conInformNoTime);
                    if(curSelectedTestID == 0){
                        m_RunningTestManager.upateCurParamToDB();
                    }
                    else{
                        m_LogFilesMangage.writeCurrenRuningLog(curSelectedTestID);
                    }
                }

            }
            //报警记录写入文件时，确定时执行
            else if(closePage.closeMsgPos === closePage.conMPDonwloadWaringRecord){
                closePage.visible = false;
                bWriteinglog = true;
                closePage.open(pubCode.messageType.Information, "正在导出数据...",closePage.conInformNoTime);
                m_LogFilesMangage.writeWarningsLog();
            }
            //操作记录写入文件时，确定时执行
            else if(closePage.closeMsgPos === closePage.conMPDonwloadActionRecord){

                closePage.visible = false;
                bWriteinglog = true;
                closePage.open(pubCode.messageType.Information, "正在导出数据...",closePage.conInformNoTime);
                m_LogFilesMangage.writeActionsLog();
            }
            //任务停止时，确定时执行关机
            else if(closePage.closeMsgPos === closePage.conMPPowerOffHmi){
                shutdownWindow.visible = true
                m_power.requestCmd("PowerOffHmi")
            }
        }
    }

    Connections{
        target: m_RunningTestManager
        // 实时运行数据，写入数据库后再进行保存操作
        function onUpdateCurParamToDBDone(){
            m_LogFilesMangage.writeCurrenRuningLog(0);
        }
    }

    //处理日志写入后信息提示
    Connections{
        target: m_LogFilesMangage



        //当前运行记录写入文件完成后结果处理
        function onWriteCurrenRuningLogDone(res){
            bWriteinglog = false;

            closePage.visible = false;
            if(res === 0){
                console.debug("CurrenRuningLog ok!");
                closePage.open(pubCode.messageType.Information, "保存当前运行数据成功!", closePage.conMPDonwloadCurRunningRecordDone);
            }
            else{
                console.debug("CurrenRuningLog fail!");
                if(res === 10 || res === 8){
                    closePage.open(pubCode.messageType.Information, "请确认U盘是否插好！！", closePage.conMPDonwloadCurRunningRecordDone);
                }
                else if(res === 7){
                    closePage.open(pubCode.messageType.Information, "打开保存日志文件失败！！", closePage.conMPDonwloadCurRunningRecordDone);
                }
                else if(res === 12){
                    closePage.open(pubCode.messageType.Information, "启动任务后重试！", closePage.conMPDonwloadCurRunningRecordDone);
                }
                else{
                    closePage.open(pubCode.messageType.Information, "保存日志文件失败,错误码 " + res +" ！！", closePage.conMPDonwloadCurRunningRecordDone);
                }
            }
        }

        //报警记录写入文件完成后结果处理
        function onWriteWarningsLogDone(res){
            closePage.visible = false;
            if(res === 0){
                console.debug("writeWarningsLog ok!");
                closePage.open(pubCode.messageType.Information, "保存当前报警数据成功!", closePage.conMPDonwloadWaringRecordDone);
            }

            else if(res === 10 || res === 8){
                closePage.open(pubCode.messageType.Information, "确认U盘是否插好！！", closePage.conMPDonwloadWaringRecordDone);
            }
            else if(res === 7){
                closePage.open(pubCode.messageType.Information, "打开保存日志文件失败！！", closePage.conMPDonwloadWaringRecordDone);
            }
            else{
                closePage.open(pubCode.messageType.Information, "保存日志文件失败,错误码 " + res +" ！！", closePage.conMPDonwloadWaringRecordDone);
            }
        }

         //操作记录写入文件完成后结果处理
        function onWriteActionsLogDone(res){
            closePage.visible = false;
            if(res === 0){
                console.debug("writeActionsLog ok!");
                closePage.open(pubCode.messageType.Information, "保存当前操作数据成功!", closePage.conMPDonwloadActionRecordDone);
            }
            else if(res === 10 || res === 8){
                closePage.open(pubCode.messageType.Information, "确认U盘是否插好！！", closePage.conMPDonwloadActionRecordDone);
            }
            else if(res === 7){
                closePage.open(pubCode.messageType.Information, "打开保存日志文件失败！！", closePage.conMPDonwloadActionRecordDone);
            }
            else{
                closePage.open(pubCode.messageType.Information, "保存日志文件失败,错误码 " + res +" ！！", closePage.conMPDonwloadActionRecordDone);
            }
        }
    }

    Popup {
        id: advancedSettingsWin
        width: 1280
        height: 800
        closePolicy: Popup.NoAutoClose
        modal:true
        parent: Overlay.overlay

        AdvancedSettingsMenu {
            anchors.fill: parent
        }
    }

    //消息对话窗口
    CloseMessagePage
    {
        id:closePage
        onVisibleChanged: {
            if(visible) {
                m_motor.setLocked(true);
                m_RunningTestManager.playKeySound();
            } else {
                m_motor.setLocked(false);
            }
        }
    }

    ApplicationWindow {
        id: shutdownWindow
        width: 1280
        height: 800
        visible: false
        Image {
            anchors.fill: parent
            fillMode:Image.Stretch
            source: "/images/welcome.png"
        }

        Text {
            id: name
            text: qsTr("正在关机中...")
            anchors.centerIn: parent
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 30
            color:"#FFFFFF"
            opacity: 0.6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

//    Simulator {
//        id: simulator
//    }
}
