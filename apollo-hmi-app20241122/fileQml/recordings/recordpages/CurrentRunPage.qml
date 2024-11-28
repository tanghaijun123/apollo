import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../subcontral/currentRun"

/*! @File        : CurrentRunPage.qml
 *  @Brief       : 当前运行页面
 *  @Author      : likun
 *  @Date        : 2024-08-19
 *  @Version     : v1.0
*/

Rectangle {
    /*!
    @Function    : changeDataIndex(int index)
    @Description : 切换流量,转速数据页面信号
    @Author      : likun
    @Parameter   : index int 流量,转速数据页面索引
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    signal changeDataIndex(int index)
    /*!
    @Function    : accessCurrentRunPage(int openPageType,var accessDate,int dataIndex, int iTestID);
    @Description : 访问当前运行页面信号
    @Author      : likun
    @Parameter   : openPageType int 打开页面方式 0 当前运行;1 历史记录; accessDate var 访问日期; dataIndex  int  记录索引; iTestID int 记录ID
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    signal accessCurrentRunPage(int openPageType,var accessDate,int dataIndex, int iTestID);

    /*!
    @Function    : sendPageIndex(int index);
    @Description : 发送页面index信号
    @Author      : likun
    @Parameter   : index int 页面索引
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    signal sendPageIndex(int index);
    property real maxFLow: -1//3.5;
    property real avgFLow: -1//2.25;
    property real minFLow: -1//1.0
    property int curMaxSpeed: -1//globalMaxMotorSpeed;
    property int avgSpeed: -1//4500;
    property int curMinSpeed: -1//3000;
    property real oldMaxFLow: 0;
    property real oldAvgFLow: 0;
    property real oldMinFLow: 0;
    property int oldMaxSpeed: 0;
    property int oldAvgSpeed: 0;
    property int oldMinSpeed: 0;

//    property alias rightPage:rightPage;

    property int  parentCurIndex: 0;
    property var ds:[];//日期控件所有日期
    id:currentRunPage
    width:parent.width
    height:parent.height
    color:"#3D3D3D"
    RowLayout
    {
        id:pageLayout
        spacing: 0
        ChartDisplayPage{id:leftPage}
        Rectangle
        {
            id:line
            color:"#000000"
            width: 1
            height: currentRunPage.height-1
        }
        ChartBasicDataPage{id:rightPage;}

    }

    /*!
    @Function    : onDrawLineType(index)
    @Description : 根据索引显示不同类型曲线的最大值,最小值和平均值页面
    @Author      : likun
    @Parameter   : index int 索引
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    Connections
    {
        target: leftPage
        function onDrawLineType(index)
        {
            rightPage.onChangeDataIndex(index);
        }
    }
    /*!
    @Function    : onAccessCurrentRunPage(openPageType,accessDate,dataIndex, iTestID)
    @Description : 访问当前运行页面
    @Author      : likun
    @Parameter   : openPageType int 打开页面方式 0 当前运行;1 历史记录; accessDate var 访问日期; dataIndex  int  记录索引; iTestID int 记录ID
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    Connections
    {
        target:currentRunPage
        function onAccessCurrentRunPage(openPageType,accessDate,dataIndex, iTestID)
        {
            console.debug("onAccessCurrentRunPage", accessDate)
            initData();
            if(openPageType === publicDefine.openPageType.RunRecord)
            {
                getData(dataIndex);
                setData();
                console.debug("onAccessCurRunPage dataIndex", dataIndex)
                //leftPage.drawContralIndex = 0;
            }
            else //CurRun
            {
                m_RunningTestManager.needMaxOrMinValue();
                //getData(dataIndex);
                //leftPage.drawContralIndex = 0;
            }
            leftPage.accessCurRunChartDisplayPage(openPageType,accessDate,dataIndex, iTestID);
        }
    }

    /*!
    @Function    : onSendPageIndex(index)
    @Description : 发送显示不同曲线最大值,最小值,平均值信号
    @Author      : likun
    @Parameter   : index int 页面索引
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    Connections
    {
        target:leftPage
        function onSendPageIndex(index)
        {
            currentRunPage.sendPageIndex(index);
        }
    }

    /*!
    @Function    : getData(dataIndex)
    @Description : 向后端获取最大流量,最大转速等数据
    @Author      : likun
    @Parameter   : dataIndex int 数据索引
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    function getData(dataIndex)
    {
        var data=cRunningModel.getRowMaxOrMinJsonData(dataIndex);
        console.log("CurrentRunPage*****************",JSON.stringify(data),"*****************");
        maxFLow=getFixedTwoNum(data.FlowValueMax) /*data.FlowValueMax.toFixed(2)*/;
        minFLow=getFixedTwoNum(data.FlowValueMin) /*data.FlowValueMin.toFixed(2)*/;
        curMaxSpeed=data.MotorSpeedMax;
        curMinSpeed=data.MotorSpeedMin;
        avgFLow=getFixedTwoNum(data.FlowValueAvg) /*data.FlowValueAvg.toFixed(2)*/;
        avgSpeed=data.MotorSpeedAvg;
    }

    /*!
    @Function    : setData()
    @Description : 给页面设置流量和转速等数据
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    function setData()
    {
        rightPage.flowDataPage.setMaxFlow(maxFLow>-1? maxFLow: 0);
        rightPage.flowDataPage.setAvgFlow(avgFLow>-1? avgFLow: 0);
        rightPage.flowDataPage.setMinFlow(minFLow>-1? minFLow: 0 );
        rightPage.speedDataPage.setMaxSpeed(curMaxSpeed>-1?curMaxSpeed:0);
        rightPage.speedDataPage.setAvgSpeed(avgSpeed>-1?avgSpeed:0);
        rightPage.speedDataPage.setMinSpeed(curMinSpeed>-1?curMinSpeed:0);
        rightPage.flowSpeedDataPage.setMinFlow(minFLow>-1?minFLow:0);
        rightPage.flowSpeedDataPage.setAvgFlow(avgFLow>-1?avgFLow:0);
        rightPage.flowSpeedDataPage.setMaxFlow(maxFLow>-1?maxFLow:0);
        rightPage.flowSpeedDataPage.setMinSpeed(curMinSpeed>-1?curMinSpeed:0);
        rightPage.flowSpeedDataPage.setAvgSpeed(avgSpeed>-1?avgSpeed:0);
        rightPage.flowSpeedDataPage.setMaxSpeed(curMaxSpeed>-1?curMaxSpeed:0);
        if(openCurRunPageType===0)
        {
            if(avgFLow>-1)
                oldAvgFLow=avgFLow;
            if(minFLow>-1)
                oldMinFLow=minFLow;
            if(maxFLow>-1)
                oldMaxFLow=maxFLow;
            if(avgSpeed>-1)
                oldAvgSpeed=avgSpeed;
            if(curMinSpeed>-1)
                oldMinSpeed=curMinSpeed;
            if(curMaxSpeed>-1)
                oldMaxSpeed=curMaxSpeed;
        }
        leftPage.draw.setFlowAndSpeedYAxis(minFLow,maxFLow,curMinSpeed,curMaxSpeed);

    }
    /*!
    @Function    : initData()
    @Description : 初始化数据
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    function initData()
    {
        maxFLow=-1;//3.5;
        avgFLow=-1;//2.25;
        minFLow=-1;//1.0
        curMaxSpeed=-1;//globalMaxMotorSpeed;
        avgSpeed=-1;//4500;
        curMinSpeed=-1;//3000;
    }
    /*!
    @Function    : getFixedTwoNum(num)
    @Description : 返回2位小数
    @Author      : likun
    @Parameter   : num float 数据
    @Return      : 返回2位小数的字符串
    @Output      :
    @Date        : 2024-08-19
*/
    function getFixedTwoNum(num)
    {
        let dNum=parseFloat(num).toFixed(3);
        return dNum.substring(0,dNum.toString().length-1);
    }


}
