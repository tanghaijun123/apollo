import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.4
import Qt.labs.settings 1.1
import QtQuick.Dialogs 1.3
import QtQuick.Controls.Styles 1.4

import "./mainFrame"
import "./mainFrame/assembly"
import "./homePage"
import "./alarmsetting"
import "./logs"
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

ApplicationWindow {
    id: mainWindow
    width: 1280
    height: 800
    visible: true

    property int globalMaxMotorSpeed:5000

    //enum EMPagesName{PGNHome, PGNWarningSet, PGNRecord, PNGSet}
    property date strStartRunTime: new Date()
    property string strFlowValue: "0.00"
    property string strMotorSpeedValue: "0"
    property bool bShowMotorValue: bPowerON
    property bool bShowFlowValue: bPowerON
    property bool bShowRealFlowValue: bShowFlowValue && bShowMotorValue && bPowerON
    property bool bShowMotorSpeedValue: bShowMotorValue && bPowerON

    property string strErrCode: ""
    property string strBoardTemp: ""
    property string strmotorTemp: ""
    property bool  bPowerON: false

    property string strParam_motorValue: "MotorSpeedValue"
    property int iParam_MotorMin: 1600
    property int iParam_MotorMax: 4700
    property string strParam_FowValue: "FlowValue"
    property real rParam_FlowMin: 2.5
    property real rParam_FlowMax: 4.5
    property bool bCanRotarySelected: true

    property color rotraySelectRectColor: "#37F7D2" //当前框选时的边框颜色
    property int rotraySelectBorderWidth: 4 //当前框选时的边框宽度
    property int pgCurIndex: tabBar.currentIndex //主页选中的序号
    property int iSubPageSelectIndex: 0 //页面中选中的序号，为零时为下们工具栏按钮
    property bool bSelInSubPage: false //在子页面中滚动
    property bool bSubComConfirmed: false
    property bool bLocked: false

    property bool bModifySpeedByKey: false
    property bool bModifySpeed: (mainWindow.pgCurIndex ===0
                                 && mainWindow.iSubPageSelectIndex === 0
                                 && mainWindow.bSubComConfirmed) || bModifySpeedByKey


    signal flowRangeChangedByMan(real iParamMin, real iParamMax);
    signal speedValueChanged(string strValue);
    signal flowValueChanged(string strValue);
    signal runningTimes(string strValue);


    color: Qt.rgba(0/255, 0/255, 0/255, 1)       //"#141414"
    title: qsTr("Apollo")
    flags: Qt.Window | Qt.FramelessWindowHint
    header: MainToolBar {
        id: mainHeader
        enabled: true
    }

    SwipeView {
        id: swipeView
        interactive: false
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        HomePage{
            id: pgHomePage
        }
        WarningSetPage{
            id: pgWarningSettingPage
        }
        RecordPage{
            id: pgRecordPage
        }
        SetPage{
            id: pgSettingPage
        }
    }

    footer: CustomFooter{
        id: tabBar
        enabled: !mainWindow.bLocked/* && !mainWindow.bSelInSubPage*/;
    }

    property int nRunMinutes: 0
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

    function updateFlowValue(){
        var strValue = "- -"
        if(bShowFlowValue && bShowMotorValue && bPowerON){
           strValue = strFlowValue
        }
        //update sub page flow values
        //pgHomePage.showFlowValue(strValue)
    }

    function updateShowCurDateTime(strCurDateTime){
        var strCurDate = Qt.formatDate(strCurDateTime, "yyyy/MM/dd")
        var strCurTime = Qt.formatTime(strCurDateTime, "HH:mm:ss")
        mainHeader.showCurrentDateTime(strCurDate, strCurTime)
        //console.debug("current date %1 time %2".arg(strCurDate).arg(strCurTime))
    }

    function updateMotorValue(){
        var strValue = "- -"
        if(bShowMotorValue)
        {
            strValue = strMotorSpeedValue
        }
        //update sub page motor speed value
        //pgHomePage.showMotorSpeedValue(strValue)

    }

    Connections{
        target: mainHeader
        function onShowFlowValue(bshow)
        {
            bShowFlowValue = bshow
            //updateFlowValue();
        }
        function onShowMotorValue(bShow)
        {
            bShowMotorValue = bShow          
            //updateMotorValue()
            //updateFlowValue()
            updateRunTimesValue()
        }
    }

    Connections{
        target: m_flowsensor
        function onUpdateFlowValue(flow)
        {
            strFlowValue = flow;
            //updateFlowValue()
            //console.debug("onUpdateFlowValue:"+flow)
        }
    }
    signal rotarySelected(int step);
    Connections{
        target: m_motor
        function onUpdateMotorStatus(errCode, motorSpeed, boardTemp, motorTemp)
        {
            //console.debug("onUpdateMotorStatus:", errCode, motorSpeed, boardTemp, motorTemp)
            strErrCode = errCode   //need write log
            strMotorSpeedValue = motorSpeed  //
            strBoardTemp = boardTemp
            strmotorTemp = motorTemp

            //updateMotorValue()
        }

        function onUpdateNewSelect(step)
        {
            console.debug("onUpdateNewSelect: ", step);            
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
            mainHeader.setMute();
        }

        function onBPowerONChanged()
        {
            if(bPowerON){
                //
                strStartRunTime = new Date();
                tmrRunTime.running = true;
            }
            else{
                tmrRunTime.running = false;
            }

        }
    }
    Connections
    {
        target: mainHeader.muteItem
        function onBeginMute()//开启静音槽函数
        {
            console.log("begin mute");
        }

        function onCloseMute()//关闭静音槽函数
        {
            console.log("closed mute");
        }
    }

    Connections{
        target: m_keyBoard

        function onKeyBoardMessage(code, state)
        {

            console.debug("code: " + code + ",state: " + state);
            if(code === 0x1c /*KeyBoard.eKEY_MINUS*/){
                console.debug("recive eKEY_MINUS");
                key_Minus(state);
            }
            else if(code === 0xd/*KeyBoard.eKEY_PLUS*/){
                console.debug("recive eKEY_PLUS");
                key_Plus(state);
            }
            else if(code === 0xab/*KeyBoard.eKEY_CONFIRM*/){
                console.debug("recive eKEY_CONFIRM");
                // bCanRotarySelected =!bCanRotarySelected;
                if(state === 0){
                    key_Confirm();
                }
            }
            else if(code === 0x69/*KeyBoard.eKEY_START_STOP*/){
                console.debug("recive eKEY_START_STOP");
                if(state === 0){
                    key_Start_Stop();
                }
            }
            else if(code === 0x66/*KeyBoard.eKEY_LOCK*/){
                console.debug("recive eKEY_LOCK");
                if(state === 0){
                    key_Lock();
                }
            }
            else if(code === 0x74/*KeyBoard.eKEY_MUTE*/){
                console.debug("recive eKEY_MUTE");
                if(state === 0){
                    key_Mute();
                }
            }
            else if(code === 0x6b/*KeyBoard.eKEY_ROTARY_CONFIRM*/){
                console.debug("recive eKEY_ROTARY_CONFIRM");
                //key_RotaryConFirm();
                //bCanRotarySelected =!bCanRotarySelected;
                if(state === 0){
                    key_Confirm();
                }
            }

        }
    }
    signal restSelectedPage();


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
            if(ncurSeconds == 0)
            {
                nRunMinutes = Math.floor((nRunTimes - ncurSeconds) / 60)
                updateRunTimesValue()
            }
            //updateShowCurDateTime(dCurDateTime)
        }
    }
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

//        var res = ApolloSettingDB.initDatabase();
//        if(res !== true) {return; }
//        var tmpRangMin = 0, tmpRanMax = 0;

//        var result = ApolloSettingDB.getParam(strParam_motorValue, iParam_MotorMin, iParam_MotorMax);
//        if(result.res ===true){
//            iParam_MotorMin = result.rangeMin;
//            iParam_MotorMax = result.rangeMax;
//        }

//        result = ApolloSettingDB.getParam(strParam_FowValue, rParam_FlowMin, rParam_FlowMax);
//        if(result.res ===true){
//            rParam_FlowMin = result.rangeMin;
//            rParam_FlowMax = result.rangeMax;
//        }
        var tmpRangMin = 0, tmpRanMax = 0;
        var res = mainSettingDB.getParam(strParam_motorValue, iParam_MotorMin, iParam_MotorMax);
        var json = JSON.parse(res);
        if(json.res === 0){
            iParam_MotorMin = json.minValue;
            iParam_MotorMax = json.maxValue;
        }
        res = mainSettingDB.getParam(strParam_FowValue, rParam_FlowMin, rParam_FlowMax);
        json = JSON.parse(res);
        if(json.res === 0){
            rParam_FlowMin = json.minValue;
            rParam_FlowMax = json.maxValue;
        }

    }
    onBPowerONChanged: {
        if(bPowerON)
        {
            tmrRunTime.running = true;
            tmrMotor.running = true;
            bShowMotorValue = true;
            bShowFlowValue = true;
            updateRunTimesValue();
            updateFlowValue();
        }
        else{
            bShowMotorValue = false;
            bShowFlowValue = false;
        }
    }

    Timer{
        id: tmrMotor
        property bool bRead: false
        interval: 500
        repeat: true
        running: false
        onTriggered: {
            if(bRead){
                m_motor.requestReadMotorStatus();
                bRead = false;
            }
            else
            {
                m_motor.requestUpdateMotorSpeed();
                bRead = true;

            }

            pgHomePage.motorSpeedRuning();

        }
    }

    onClosing: {
//        m_rotaryEncoder.quit()
//        m_rotaryEncoder.close()
//        m_rotaryEncoder.wait()
    }
}
