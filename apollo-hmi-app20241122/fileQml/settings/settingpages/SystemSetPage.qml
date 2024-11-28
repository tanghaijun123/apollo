import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

import "../subcontral"
import "../../mainFrame/assembly"
//import "../../database/apolloSettingDB.js" as ApolloSettingDB
import pollo.SettingDB 1.0

/*! @File        : SystemSetPage.qml
 *  @Brief       : 系统设置页面
 *  @Author      : likun
 *  @Date        : 2024-08-13
 *  @Version     : v1.0
*/

Rectangle
{
    id:sysSetPage
    /*!
    @Function    : sigUpdateCurrentDate(string strDate)
    @Description : 更新当前日期信号
    @Author      : likun
    @Parameter   : strDate 日期字符串
    @Return      :
    @Date        : 2024-08-13
    */

    signal sigUpdateCurrentDate(string strDate)
    width: 1118
    height: 432
    color:"#3D3D3D"
    
    Rectangle
    {
        id:sysSetPageLeft
        width:768
        height:316
        anchors.left: parent.left
        anchors.leftMargin:56
        anchors.top: parent.top
        anchors.topMargin: 20
        color:"transparent"
        Row
        {
            anchors.fill: parent
            spacing: 14
            Rectangle
            {
                id:rectLeft
                width: 52
                height: 316
                color:"transparent"
                Column
                {
                    id:leftCol
                    anchors.fill: parent
                    spacing: 20
                    Rectangle
                    {
                        width: 52
                        height: 64
                        color:"transparent"
                        Text
                        {
                            id: txtDate
                            anchors.centerIn: parent
                            text: "日期"
                            color:"#FFFFFF"
                            font.family: "OPPOSans"
                            font.weight: Font.Medium
                            font.pixelSize: 26
                        }
                    }
                    Rectangle
                    {
                        width: 52
                        height: 64
                        color:"transparent"
                        Text
                        {
                            id: txtTime
                            anchors.centerIn: parent
                            text: "时间"
                            color:"#FFFFFF"
                            font.family: "OPPOSans"
                            font.weight: Font.Medium
                            font.pixelSize: 26
                        }
                    }
                    Rectangle
                    {
                        width: 52
                        height: 64
                        color:"transparent"
                        Text
                        {
                            id: txtBrightness
                            anchors.centerIn: parent
                            text: "亮度"
                            color:"#FFFFFF"
                            font.family: "OPPOSans"
                            font.weight: Font.Medium
                            font.pixelSize: 26
                        }
                    }
//                    Rectangle
//                    {
//                        width: 52
//                        height: 64
//                        color:"transparent"
//                        Text
//                        {
//                            id: txtVolume
//                            anchors.centerIn: parent
//                            text: "音量"
//                            color:"#FFFFFF"
//                            font.family: "OPPOSans"
//                            font.weight: Font.Medium
//                            font.pixelSize: 26
//                        }
//                    }

                    Rectangle
                    {
                        width: 52
                        height: 64
                        color:"transparent"
                        Text
                        {
                            id: lockTime
                            anchors.centerIn: parent
                            text: "锁屏"
                            color:"#FFFFFF"
                            font.family: "OPPOSans"
                            font.weight: Font.Medium
                            font.pixelSize: 26
                        }
                    }
                }

            }
            Rectangle
            {
                id:rightRect
                width: 702
                height: 316
                color:"transparent"
                GridLayout
                {
                    id:rightGird
                    rowSpacing: 20
                    columnSpacing: 12
                    Layout.leftMargin: 0
                    Layout.topMargin: 0
                    rows:5
                    columns: 6
                    Layout.alignment: Qt.AlignVCenter|Qt.AlignTop
                    YearsComboBox{id:yCB}
                    SingleWord{contentText: "年"}
                    MonthsComboBox{id:mCB}
                    SingleWord{contentText: "月"}
                    DayComboBox{id:dCB}
                    SingleWord{contentText: "日"}
                    HoursComboBox{id:hCB}
                    SingleWord{contentText: "时"}
                    MinutesComboBox{id:minuteCB}
                    SingleWord{contentText:"分";Layout.columnSpan:3}
                    BrightnessBar{id:b1;Layout.columnSpan: 6}
                    //VolumeBar{id:v1;Layout.columnSpan: 6}
                    LockTimeComboBox{id:lockTimeSetting}
                    SingleWord{contentText: "秒";Layout.columnSpan: 5}
                }
            }
        }
    }

    Connections{
        target: m_RunningTestManager
        /*!
        @Function    : onCurRunningStatus(bRunning)
        @Description : 根据运行状态,禁止或者激活日期 年/月/日/小时/分钟 下拉菜单
        @Author      : likun
        @Parameter   : bRunning  bool  true 正在运行; false 未运行
        @Return      :
        @Date        : 2024-08-13
        */
        function onCurRunningStatus(bRunning)
        {
            yCB.enabled=!bRunning;
            mCB.enabled=!bRunning;
            dCB.enabled=!bRunning;
            hCB.enabled=!bRunning;
            minuteCB.enabled=!bRunning;
            if(bRunning)
            {
                yCB.backgroundColor="#989898";
                mCB.backgroundColor="#989898";
                dCB.backgroundColor="#989898";
                hCB.backgroundColor="#989898";
                minuteCB.backgroundColor="#989898";
            }else
            {
                yCB.backgroundColor="#585858";
                mCB.backgroundColor="#585858";
                dCB.backgroundColor="#585858";
                hCB.backgroundColor="#585858";
                minuteCB.backgroundColor="#585858";
            }
        }
    }


    property bool bCanupdateValue: false
    Timer{
        id: tmrDelayUpdateLockTime
        interval: 3*1000;
        onTriggered: {
           bCanupdateValue = true;
        }
    }

    Connections{
        target: lockTimeSetting
        /*!
        @Function    : onCurrentValueChanged
        @Description : 更新锁屏时间
        @Author      : likun
        @Parameter   :
        @Return      :
        @Date        : 2024-08-13
        */
        function onCurrentValueChanged() {
            if(bCanupdateValue){
                var value = lockTimeSetting.currentValue;
                mainWindow.updateLockTimeSetting(lockTimeSetting.currentValue)
                mainSettingDB.setIniValue("Screen/Lock", value);
            }
        }
    }

    Component.onCompleted: {
        //lockTimeSetting.currentText = mainSettingDB.getIniValue("Screen/Lock");
        var curLockTime=mainSettingDB.getIniValue("Screen/Lock");
        lockTimeSetting.setLockTime(curLockTime);        
        tmrDelayUpdateLockTime.start();
    }

    /*!
    @Function    : updateCurrentDate()
    @Description : 更新当前日期
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-13
    @Modify      :
    */
    function updateCurrentDate()
    {
        var dt = new Date(yCB.currentText, mCB.currentText - 1, dCB.currentText, hCB.currentText, minuteCB.currentText, 0, 0);
        console.debug("updateCurrentDate:", Qt.formatDateTime(dt,"yyyy-MM-dd hh:mm:ss"));
        sigUpdateCurrentDate(Qt.formatDateTime(dt,"yyyy-MM-dd hh:mm:ss"));

    }


    Connections {
        target:yCB
        /*!
        @Function    : onSendYearNumber (yearNum)
        @Description : 接收年数据槽函数
        @Author      : likun
        @Parameter   : yearNum int 当前选中年的数据
        @Return      :
        @Date        : 2024-08-13
        */
        function onSendYearNumber (yearNum)
        {
            dCB.selectYear=yearNum
            dCB.createDays(dCB.selectYear,dCB.selectMonth);
            updateCurrentDate();
        }
    }
    Connections {
        target:mCB
        /*!
        @Function    : onSendMonth (monthNum)
        @Description : 接收当前选中的月份
        @Author      : likun
        @Parameter   : monthNum 当前选中的月份
        @Return      :
        @Date        : 2024-08-13
        */
        function onSendMonth (monthNum)
        {
            dCB.selectMonth=monthNum
            dCB.createDays(dCB.selectYear,dCB.selectMonth);
            updateCurrentDate();
        }
    }
    Connections{
        target:dCB
        /*!
        @Function    : onDayChanged()
        @Description : 接收日数据变化信号
        @Author      : likun
        @Parameter   : 参数说明
        @Return      : 返回值说明
        @Date        : 2024-08-13 22:20:55
        */
        function onDayChanged(){
            updateCurrentDate();
        }
    }

    Connections{
        target:hCB
        /*!
        @Function    : onSendHourIndex(index)
        @Description : 接收选中小时索引函数
        @Author      : likun
        @Parameter   : index  选中小时索引
        @Return      :
        @Date        : 2024-08-13
        */
        function onSendHourIndex(index){
            updateCurrentDate();
        }
    }

    Connections{
        target:minuteCB
        /*!
        @Function    : onSendMinuteIndex(index)
        @Description : 接收选中分钟索引函数
        @Author      : likun
        @Parameter   : index 选中分钟索引
        @Return      :
        @Date        : 2024-08-13
        */
        function onSendMinuteIndex(index){
            updateCurrentDate();
        }
    }

}
