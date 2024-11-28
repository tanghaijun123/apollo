import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtCharts 2.3
import "../publicAssembly"
/*! @File        : DrawFlowSpeedContral.qml
 *  @Brief       : 当前运行,画流量和转速曲线控件
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/
Rectangle {

    //property var nowDate: new Date();
    property real minFlow: 0;//最小流量
    property real maxFlow: globalMaxflowValue; //3.0//6.0;//最大流量
    property int minSpeed: 1000;//最小转速
    property int maxSpeed: globalMaxMotorSpeed;//最大转速
    property int showType: 0;//曲线显示类型,0:flow,1:speed,2:both 0,1
    readonly property int iShowtickCount: openCurRunPageType>0?13:7;
    property var minDateTime:nowDate==null?new Date():nowDate; //Date.fromLocaleString(Qt.locale(),new Date(),"yyyy-MM-dd hh:mm:ss");
    property var maxDateTime:new Date(new Date(minDateTime.getFullYear(),minDateTime.getMonth(),minDateTime.getDate(),23,59,59));  //Date.fromLocaleString(Qt.locale(),"2024-06-03 23:00:00","yyyy-MM-dd hh:mm:ss");
    property var  curMinDateTime;
    property var  curMaxDateTime;
    property var preMaxX: new Date();
    enum ShowTypeEnum
    {
        Flow,
        Speed,
        FlowAndSpeed
    }
    /*!
    @Function    : accessCurRunRectDrawPage(int openPageType,var accessDate, int dataIndex, int iTestID);
    @Description : 访问当前运行页面信号
    @Author      : likun
    @Parameter   : openPageType int 打开页面方式 0 当前运行;1 历史记录; accessDate var 访问日期; dataIndex  int  记录索引; iTestID int 记录ID
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    signal accessCurRunRectDrawPage(int openPageType,var accessDate, int dataIndex, int iTestID);
    id:rectDraw
    width:880/*880*/
    height:359//334
    color:"#3D3D3D"
    //    border.width: 1
    //    border.color: "#FFFFFF"
    clip: true
    //DrawLineControl

    function setDateInteger(date)
    {
        var tmp = date
        tmp.setMinutes(0);
        tmp.setSeconds(0);
        tmp.setMilliseconds(0);
        return tmp;
    }

    Component.onCompleted:
    {
        xDateTime.min = setDateInteger(new Date());//Date.fromLocaleString(Qt.locale(),new Date(),"yyyy-MM-dd hh:mm:ss");
        xDateTime.max = new Date(xDateTime.min.getTime() + 3600*1000*6);

    }
    ScrollBar
    {
        id:scrollHor
        height: 16
        hoverEnabled: true
        active: pressed
        orientation: Qt.Horizontal
        size:1
        anchors.bottom: parent.bottom
        anchors.bottomMargin:15
        anchors.left: chartView.left
        anchors.right: chartView.right
        policy:ScrollBar.AlwaysOn
        visible: false
        z:9
        background: Rectangle
        {
            width:parent.width
            height:16
            color:Qt.rgba(167,167,167,0.4)
            opacity: 0.3
            radius:4
            anchors.horizontalCenter:parent.horizontalCenter
        }
    }
    ChartView
    {
        id:chartView
        //height: parent.height
        anchors.fill: parent
        backgroundColor: "transparent"
        margins.left: 0
        margins.top: 0
        margins.right: 0
        margins.bottom: 0
        //width: 1000
        legend.font: Qt.font({family:"OPPOSans",weight:Font.Medium,pixelSize:15})
        legend.labelColor: "#FFFFFFFF"

        DateTimeAxis
        {
            id:xDateTime

            format: "hh:mm"
            tickCount: rectDraw.iShowtickCount
            titleVisible: false
            labelsFont: Qt.font({family:"OPPOSans",weight:Font.Medium,pixelSize:18})
            labelsColor:"#FFFFFF"
            labelsVisible: true
            gridLineColor: "#515151"
            visible: true
        }

        ValueAxis
        {
            id:yAxisFlow
            //parent: chartView;
            min:rectDraw.minFlow
            max:rectDraw.maxFlow
            tickCount: 7
            labelsFont: Qt.font({family:"OPPOSans",weight:Font.Medium,pixelSize:18})
            labelsColor:"#FFFFFF"
            labelsVisible: true
            visible:true
            labelFormat: "%.2f"
        }
        ValueAxis
        {
            id:yAxisSpeed
            //parent: chartView;
            min:rectDraw.minSpeed
            max:rectDraw.maxSpeed
            tickCount: 7
            labelsFont: Qt.font({family:"OPPOSans",weight:Font.Medium,pixelSize:18})
            labelsColor:"#FFFFFF"
            labelsVisible: true
            visible:false
            labelFormat: "%d"
        }
        LineSeries
        {
            id:flowLine
            //parent: chartView;
            useOpenGL: false;
            axisX:xDateTime
            axisY: yAxisFlow
            visible:true
            color: "#cc33ff"
            width: 3
            name: "流量"
        }
        LineSeries
        {
            id:speedLine
            //parent: chartView;
            useOpenGL: false;
            axisX:xDateTime
            axisYRight:yAxisSpeed
            visible: false
            width: 3
            color: "#ff3366"
            name: "转速"
        }

        MouseArea
        {
            id:viewMouseArea
            width: parent.width
            height: parent.height-2*scrollHor.height
            acceptedButtons: Qt.LeftButton
            property int vStartx;
            property int nStepLast;
            property int ignoreCnt;
            onPressed: {
                vStartx=mouseX;
                scrollHor.visible = true
                nStepLast = 0;
                ignoreCnt = 0;
            }
            onReleased:
            {
                scrollHor.visible = false
            }
            onPositionChanged:
            {
                if(flowLine.count==0)
                    return;
                ignoreCnt++;
                if(ignoreCnt % 3 == 0)
                    return;
//                var nStep=vStartx-mouseX;
//                if(nStep>10)
//                {
//                    if(xDateTime.max.getTime()>=maxDateTime.getTime())
//                    {
//                        scrollHor.setPosition(1-scrollHor.size);
//                        return;
//                    }
//                }
//                else if(nStep<-10)
//                {
//                    if(xDateTime.min.getTime()<=minDateTime.getTime())
//                    {
//                        scrollHor.setPosition(0);
//                        return;
//                    }
//                }
//                xDateTime.min=chartView.addSecond(xDateTime.min,nStep*3600*iShowtickCount/chartView.plotArea.width);
//                xDateTime.max=chartView.addHour(xDateTime.min);
//                vStartx=mouseX;
//                if(scrollHor.size!=1)
//                {
//                    scrollHor.setPosition((xDateTime.max.getTime()-scrollStartPoint)/(scrollEndPoint-scrollStartPoint)-scrollHor.size);
//                    if(scrollHor.position>1)
//                        scrollHor.setPosition(1-scrollHor.size);
//                }
//                xDateTime.checkMinX();
//                xDateTime.checkMaxX();

                var lastPoint = flowLine.at(flowLine.count-1);
                //曲线最后1点时间
                var maxX=new Date(lastPoint.x);

                //if(maxX.getTime() - xDateTime.min.getTime() < 0)

                var nStep=Math.floor((vStartx-mouseX)/50);
                //console.debug("viewMouseArea", nStep, nStepLast, chartView.width)

                if(nStep > nStepLast && nStepLast !== nStep) {

                    if(xDateTime.max.getTime() < maxDateTime.getTime())
                    {
                        chartView.scrollRight((chartView.plotArea.width)/(iShowtickCount-1))//(Math.abs(nStep - nStepLast)*50)
                        scrollHor.setPosition(new Date(xDateTime.min).getHours()/24)
                    }
                }
                else if(nStep < nStepLast && nStepLast !== nStep) {
                    if(xDateTime.min.getTime() > minDateTime.getTime())
                    {
                        chartView.scrollLeft((chartView.plotArea.width)/(iShowtickCount-1))
                        scrollHor.setPosition(new Date(xDateTime.min).getHours()/24)
                    }
                }

                //console.debug("xDateTime.min", xDateTime.min, "xDateTime.max", xDateTime.max);

                nStepLast = nStep;
            }
        }
    }

    //曲线起点
    property real scrollStartPoint:0;
    //曲线终点
    property real scrollEndPoint: 1;
    //当天0点0分0秒
    property var zeroPoint: new Date();
    //曲线长度
    property real curveLength:0;
    //X轴长度
    property real xAxisLength:0
    /*!
    @Function    : initScrollSize()
    @Description : 初始化滚动块
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function initScrollSize()
    {
//        if(flowLine.count<2)
//        {
//            scrollHor.size=1;
//            scrollHor.setPosition(0);
//            return;
//        }
//        zeroPoint=new Date(flowLine.at(0).x);
//        zeroPoint.setHours(0,0,0);
//        zeroPoint=zeroPoint.getTime();
//        scrollStartPoint=new Date(flowLine.at(0).x).getTime();
//        scrollEndPoint=new Date(flowLine.at(flowLine.count-1).x).getTime();
//        //曲线长度
//        curveLength=flowLine.at(flowLine.count-1).x-flowLine.at(0).x;
//        //X轴长度
//        xAxisLength=xDateTime.max.getTime()-xDateTime.min.getTime();
//        //console.debug("initScrollSize============>curveLength,xAxisLength", curveLength, xAxisLength)

//        if(curveLength<=xAxisLength)
//        {
//            scrollHor.size=1;
//            scrollHor.setPosition(0);
//            return;
//        }
        scrollHor.size = openCurRunPageType > 0 ? 0.5 : 0.25//xAxisLength/curveLength;
        scrollHor.stepSize = 1/24;
        scrollHor.setPosition(new Date(xDateTime.min).getHours()/24)
//        if(openCurRunPageType===0)
//        {
//            scrollHor.setPosition((xDateTime.max.getTime()-scrollStartPoint)/curveLength-scrollHor.size);
//            if(scrollHor.position>1)
//                scrollHor.setPosition(1-scrollHor.size);
//        }
//        else
//            scrollHor.setPosition(0);
    }

    /*!
    @Function    : onAccessCurRunRectDrawPage(openPageType,accessDate,dataIndex, iTestID)
    @Description : 访问当前运行页面函数
    @Author      : likun
    @Parameter   : openPageType int 打开页面方式 0 当前运行;1 历史记录; accessDate var 访问日期; dataIndex  int  记录索引; iTestID int 记录ID
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    Connections
    {
        target:rectDraw
        function onAccessCurRunRectDrawPage(openPageType,accessDate,dataIndex, iTestID)
        {
            console.debug("onAccessCurRunRectDrawPage",openPageType,accessDate,dataIndex, iTestID)
            nowDate=accessDate;
            ininMinMaxDate();
            if(openPageType===publicDefine.openPageType.CurrentRun)
            {
                setShowLine(accessDate);
                //moveXDateTimeMin();
                //m_RunningTestManager.updateTesingData(curFlow, curSpeed, minFLow, maxFLow, curMinSpeed, curMaxSpeed, avgFLow, avgSpeed)
                //setData();
//                var curDate = new Date();
//                if(accessDate.getDate() !== curDate.getDate())
//                {
//                    accessDate.setHours(0);
//                }
//                xDateTime.min = setDateInteger(accessDate);//Date.fromLocaleString(Qt.locale(),new Date(),"yyyy-MM-dd hh:mm:ss");
//                xDateTime.max = new Date(xDateTime.min.getTime() + 3600*1000*6);
            }
            else
            {
                xDateTime.min = setDateInteger(nowDate);
                xDateTime.max = new Date(xDateTime.min.getTime() + 3600*1000*12);
                setShowLine(nowDate);
            }
            initScrollSize();
        }
    }
    /*!
    @Function    : setDrawLineType(type)
    @Description : 设置曲线显示类型
    @Author      : likun
    @Parameter   : type int 曲线显示类型
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setDrawLineType(type)
    {
        showType=type;
        if(showType===DrawFlowSpeedContral.FlowAndSpeed)
            showFlowAndSpeedLine();
        else if(showType===DrawFlowSpeedContral.Flow)
            showFlowLine();
    }
    /*!
    @Function    : showFlowLine()
    @Description : 显示流量曲线
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function showFlowLine()
    {
        flowLine.visible=true;
        yAxisFlow.visible=true;
        speedLine.axisY=null;
        speedLine.axisYRight=null;
        speedLine.visible=false;
        yAxisSpeed.visible=false;
    }

    /*!
    @Function    : showFlowAndSpeedLine()
    @Description : 显示流量和转速曲线
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function showFlowAndSpeedLine()
    {
        flowLine.visible=true;
        yAxisFlow.visible=true;
        speedLine.axisY=null;
        speedLine.axisYRight=yAxisSpeed;
        speedLine.visible=true;
        yAxisSpeed.visible=true;
    }

    Connections
    {
        target: m_RunningTestManager
        /*!
    @Function    : onUpdateTesingData(dCurFlowValue, iCurMotorSpeed, dMinFlowVolume, dMaxFlowVolume, iMinSpeedValue, iMaxSpeedValue, dAvgFlowVolume, iAvgSpeedValue)
    @Description : 更新曲线和最大值,最小值,平均值
    @Author      : likun
    @Parameter   : dMinFlowVolume double 最小流量, dMaxFlowVolume double 最大流量, iMinSpeedValue int 最小转速, iMaxSpeedValue int 最大转速, dAvgFlowVolume double 平均流量, iAvgSpeedValue int 平均转速
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
        function onUpdateTesingData(datetime, dCurFlowValue, iCurMotorSpeed, dMinFlowVolume, dMaxFlowVolume, iMinSpeedValue, iMaxSpeedValue, dAvgFlowVolume, iAvgSpeedValue)
        {
            if(openCurRunPageType !== publicDefine.openPageType.CurrentRun){
                return;
            }

            //console.debug("onUpdateTesingData ", dCurFlowValue, iCurMotorSpeed, dMinFlowVolume, dMaxFlowVolume, iMinSpeedValue, iMaxSpeedValue, dAvgFlowVolume, iAvgSpeedValue)

            //系统当前时间
            //chartView.enabled=false;
            var curDate=new Date();
            console.debug("onUpdateTesingData ", curDate.toDateString(), nowDate.toDateString());
            if(curDate.toDateString() !== nowDate.toDateString())
            {
                var year=curDate.getFullYear();
                var month=curDate.getMonth()+1;
                var day=curDate.getDate();
                var dateStr=`${year}/${month>9?month:'0'+month}/${day>9?day:'0'+day}`;
                if(ds.indexOf(dateStr)<0)
                {
                    nowDate=curDate;
                    chartView.enabled=true;
                    recordPage.sigAddAccessDate(dateStr);
                    recordPage.sigChangeDateAccess(dateStr);
                }
                else
                {
                    setCurrentRunMaxMinAvg(dMaxFlowVolume,dMinFlowVolume,iMinSpeedValue,iMaxSpeedValue,dAvgFlowVolume,iAvgSpeedValue)
                    chartView.enabled=true;
                    return;
                }
            }

            if(flowLine.count>0)
            {
                flowLine.append(datetime, dCurFlowValue);
                speedLine.append(datetime, iCurMotorSpeed);
                var firstPoint = flowLine.at(0)
                var lastPoint = flowLine.at(flowLine.count-1);
                //曲线最后1点时间
                var maxX=new Date(lastPoint.x);

                // The next day, clear line data
                if(maxX.getHours() < preMaxX.getHours())
                {
                    flowLine.clear();
                    speedLine.clear();
                    flowLine.append(datetime, dCurFlowValue);
                    speedLine.append(datetime, iCurMotorSpeed);
                    xDateTime.min = setDateInteger(new Date(maxX));
                    xDateTime.max = new Date(xDateTime.min.getTime() + 3600*1000*6);
                    console.debug("flowLine", flowLine)
                } else {
                    //console.debug("maxX",maxX.getTime(),"xDateTime.max",xDateTime.max.getTime())
                    if(maxX.getTime() - xDateTime.max.getTime() > 0)
                    {
                        xDateTime.max=new Date(xDateTime.max.getTime()+3600*1000);
                        xDateTime.min=new Date(xDateTime.min.getTime()+3600*1000);
                    }
                }

                preMaxX = maxX;



//                //空闲1小时
//                if(maxX.getHours()<23)
//                {
//                    if(curXMax.getTime()-maxX.getTime() <= 3600*1000 && curXMax.getTime()-maxX.getTime()>=0)
//                    {
//                        var maxHour=maxX.getHours()+1;
//                        xDateTime.max=new Date(maxX.getTime()+3600*1000);
//                        //xDateTime.min=chartView.decHour(xDateTime.max);
//                    }else if(maxX.getTime()>=curXMax.getTime())
//                    {
//                        xDateTime.max=new Date(maxX.getTime()+3600*1000);
//                        //xDateTime.min=chartView.decHour(xDateTime.max);
//                    }
//                }
                setCurrentRunMaxMinAvg(dMaxFlowVolume,dMinFlowVolume,iMinSpeedValue,iMaxSpeedValue,dAvgFlowVolume,iAvgSpeedValue)
                //xDateTime.checkMinX();
                //xDateTime.checkMaxX();
            } else {
                flowLine.append(datetime, dCurFlowValue);
                speedLine.append(datetime, iCurMotorSpeed);

                var firstDate = datetime;
                var lastDate = datetime;

                if(24 - firstDate.getHours() >= 6)
                {
                    xDateTime.min = setDateInteger(firstDate);//Date.fromLocaleString(Qt.locale(),new Date(),"yyyy-MM-dd hh:mm:ss");
                    xDateTime.max = new Date(xDateTime.min.getTime() + 3600*1000*6);
                }
                else
                {
                    lastDate = setDateInteger(lastDate);
                    lastDate.setHours(0);
                    xDateTime.max = new Date(lastDate.getTime() + 3600*1000*24);
                    xDateTime.min = new Date(xDateTime.max.getTime() - 3600*1000*6);
                }
            }

            //setMinDate();
            //setMaxDate();
            chartView.scrollUp(1);
            chartView.scrollUp(-1);
            chartView.enabled=true;
            initScrollSize();
            setFlowAndSpeedYAxis(dMinFlowVolume, dMaxFlowVolume, iMinSpeedValue, iMaxSpeedValue);
        }
        /*!
    @Function    : onMaxOrMinValueChanged(dMinflowVolume, dMaxFlowVolume, iMinSpeedValue, iMaxSpeedValue, dAvgFlowVolume, iAvgSpeedValue)
    @Description : 更新最大,最小和平均值
    @Author      : likun
    @Parameter   : dMinflowVolume double 最小流量, dMaxFlowVolume double 最大流量, iMinSpeedValue int 最小转速, iMaxSpeedValue int 最大转速, dAvgFlowVolume double 平均转速, iAvgSpeedValue int 平均转速
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
        function onMaxOrMinValueChanged(dMinFlowVolume, dMaxFlowVolume, iMinSpeedValue, iMaxSpeedValue, dAvgFlowVolume, iAvgSpeedValue)
        {
            var curDate=new Date();

            maxFLow=getFixedTwoNum(dMaxFlowVolume)/*dMaxflowolume.toFixed(2)*/;
            minFLow=getFixedTwoNum(dMinFlowVolume)/*dMinflowolume.toFixed(2)*/;
            curMinSpeed=iMinSpeedValue;
            curMaxSpeed=iMaxSpeedValue;
            avgFLow = getFixedTwoNum(dAvgFlowVolume)/*dAvgFlowVolume.toFixed(2)*/;
            avgSpeed = iAvgSpeedValue;
            //console.log("********************maxFLow",maxFLow,"minFLow",minFLow,"curMaxSpeed",curMaxSpeed,"avgFLow",avgFLow,"avgSpeed",avgSpeed);
            currentRunPage.setData();
            setFlowAndSpeedYAxis(dMinFlowVolume, dMaxFlowVolume, iMinSpeedValue, iMaxSpeedValue);

        }
    }
    /*!
    @Function    : setCurrentRunMaxMinAvg(dMaxFlowVolume,dMinFlowVolume,iMinSpeedValue,iMaxSpeedValue,dAvgFlowVolume,iAvgSpeedValue)
    @Description : 设置当前运行页面右边转速,流量的最大值最小值平均值
    @Author      : likun
    @Parameter   : dMinflowVolume double 最小流量, dMaxFlowVolume double 最大流量, iMinSpeedValue int 最小转速, iMaxSpeedValue int 最大转速, dAvgFlowVolume double 平均转速, iAvgSpeedValue int 平均转速
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setCurrentRunMaxMinAvg(dMaxFlowVolume,dMinFlowVolume,iMinSpeedValue,iMaxSpeedValue,dAvgFlowVolume,iAvgSpeedValue)
    {
        maxFLow=dMaxFlowVolume /*dMaxFlowVolume.toFixed(2)*/;
        minFLow=dMinFlowVolume/*dMinFlowVolume.toFixed(2)*/;
        curMinSpeed=iMinSpeedValue;
        curMaxSpeed=iMaxSpeedValue;
        avgFLow=dAvgFlowVolume/*dAvgFlowVolume.toFixed(2)*/;
        avgSpeed=iAvgSpeedValue;
        //console.log("CurrentRunPage_onUpdateTesingData_78:dAvgFlowVolue",dAvgFlowVolue,"iAvgSpeedValue",iAvgSpeedValue);
        if( openCurRunPageType===publicDefine.openPageType.CurrentRun   /*pgCurIndex === 2 && parentCurIndex === 0*/){
            currentRunPage.setData();
        }
    }

    /*!
    @Function    : onSigChangeDateAccess(dateStr)
    @Description : 更改访问日期,访问对应曲线
    @Author      : likun
    @Parameter   : dateStr string 日期
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    Connections
    {
        target: recordPage
        function onSigChangeDateAccess(dateStr)
        {
            if(openCurRunPageType===0)
            {
                if(ds.indexOf(dateStr)===0)
                    rectDraw.accessCurRunRectDrawPage(openCurRunPageType,new Date(),data_Index,iTest_ID);
                else
                    rectDraw.accessCurRunRectDrawPage(openCurRunPageType,new Date(dateStr),data_Index,iTest_ID);
            }
            else
            {
                rectDraw.accessCurRunRectDrawPage(openCurRunPageType,new Date(dateStr),data_Index,iTest_ID);
            }
        }
    }

    /*!
    @Function    : moveXDateTimeMin()
    @Description : 在当前运行状态下,移动X轴最小值
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function moveXDateTimeMin()
    {
        var tmpMinDate;
        if(flowLine.count>0)
        {
            tmpMinDate=new Date(flowLine.at(0).x);
            if(tmpMinDate.getFullYear() < nowDate.getFullYear()|| tmpMinDate.getMonth() < nowDate.getMonth()|| tmpMinDate.getDate() < nowDate.getDate())
            {
                xDateTime.min=new Date(nowDate.getFullYear(),nowDate.getMonth(),nowDate.getDate(),0,0,0);
                xDateTime.max = new Date(xDateTime.min.getTime() + 3600*1000*12);
                xDateTime.checkMaxX();
                return;
            }

            xDateTime.min=tmpMinDate;
            xDateTime.max = new Date(xDateTime.min.getTime() + 3600*1000*12);
            xDateTime.checkMaxX();
            return;
        }
        xDateTime.min=nowDate;
        xDateTime.max = new Date(xDateTime.min.getTime() + 3600*1000*12);
        xDateTime.checkMaxX();
    }

    /*!
    @Function    : setFlowAndSpeedYAxis(dMinflowVolume, dMaxFlowVolume, iMinSpeedValue, iMaxSpeedValue)
    @Description : 设置Y轴转速和流量大和最小值
    @Author      : likun
    @Parameter   : dMinflowVolume double 最小流量, dMaxFlowVolume double 最大流量, iMinSpeedValue int 最小转速, iMaxSpeedValue int 最大转速
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setFlowAndSpeedYAxis(dMinFlowVolume, dMaxFlowVolume, iMinSpeedValue, iMaxSpeedValue)
    {
        //console.debug("setFlowAndSpeedYAxis",dMinFlowVolume, dMaxFlowVolume, iMinSpeedValue, iMaxSpeedValue)
        if(!bRuning&&openCurRunPageType===0)
        {
            yAxisFlow.min=0;
            yAxisFlow.max=globalMaxflowValue;
            yAxisSpeed.min=0;
            yAxisSpeed.max=globalMaxMotorSpeed;
            return;
        }

        if(openCurRunPageType===0)
        {
            var curDate=new Date();
            if(curDate.toDateString()!==nowDate.toDateString())
                return;
        }

        //console.debug("setFlowAndSpeedYAxis",dMinFlowVolume, dMaxFlowVolume, iMinSpeedValue, iMaxSpeedValue)

        var minFlow = Math.floor(dMinFlowVolume / 3)*3;
        if(Math.abs(dMinFlowVolume-minFlow) < 0.5)
        {
            minFlow = minFlow - 3 <= 0 ? 0 : minFlow - 3;
        }
        yAxisFlow.min = minFlow;

        var maxFlow = Math.ceil(dMaxFlowVolume / 3)*3;
        if(Math.abs(dMaxFlowVolume-maxFlow) < 0.5)
        {
            maxFlow = maxFlow + 3;
        }
        yAxisFlow.max  = maxFlow;

        var minSpeed = Math.floor(iMinSpeedValue / 600)*600;
        if(Math.abs(iMinSpeedValue-minSpeed) < 100)
        {
            minSpeed = minSpeed - 600 <= 0 ? 0 : minSpeed - 600;
        }
        yAxisSpeed.min = minSpeed;

        var maxSpeed = Math.ceil(iMaxSpeedValue / 600)*600;
        if(Math.abs(iMaxSpeedValue-maxSpeed) < 100)
        {
            maxSpeed = maxSpeed + 600;
        }
        yAxisSpeed.max = maxSpeed;
    }

    /*!
    @Function    : setShowLine()
    @Description : 显示曲线
    @Author      : likun
    @Parameter   : 参数说明
    @Return      : 返回值说明
    @Output      :
    @Date        : 2024-08-20
*/
    function setShowLine(accessDate)
    {
        console.log("DrawFlowSpeedControl setShowLine: ",Qt.formatDate(accessDate,"yyyy/MM/dd"), " test ID: ", iTest_ID);
        //console.log("DrawFlowSpeedControl setShowLine: begin ");
        //busyIndicator.open();
        var result=1;
        //当前记录获取全部数据,历史记录获取当天数据
        if(flowLine.count>0)
            flowLine.clear();
        if(speedLine.count>0)
            speedLine.clear();
        //当前记录,历史记录获取当天数据
        result = cTestDetail.getDataByDate(Qt.formatDate(accessDate, "yyyy/MM/dd"), iTest_ID, flowLine, speedLine);
//        console.debug("DrawFlowSpeedContral")
//        for(var i = 0;i < flowLine.count; i++)
//        {
//            console.debug(new Date(flowLine.at(i).x).getDate(), flowLine.at(i).y)
//        }


        if(result !==0)
        {
            console.debug("cTestDetail.getDataByDate fail, return: ", result);
            return;
        }

        if(showType===DrawFlowSpeedContral.Flow )
        {
            showFlowLine();
        }
        else if(showType===DrawFlowSpeedContral.Speed)
        {
            showSpeedLine();
        }
        else if(showType===DrawFlowSpeedContral.FlowAndSpeed)
        {
            showFlowAndSpeedLine();
        }

        console.debug("setShowLine openCurRunPageType =", openCurRunPageType)
        var nCount = flowLine.count;

        if(nCount > 0)
        {
            if(openCurRunPageType > 0) // History run record
            {
                var varx = flowLine.at(0);
                var dt = new Date(varx.x);
                //console.debug("setShowLine dt = ", dt)
                xDateTime.min=setDateInteger(dt);
                xDateTime.max = new Date(xDateTime.min.getTime() + 3600*1000*(iShowtickCount-1));
            } else {
                var curDate = new Date();
                if(accessDate.getDate() !== curDate.getDate())
                {
                    accessDate.setHours(0);
                }

                var firstDate = new Date(flowLine.at(0).x);
                var lastDate = new Date(flowLine.at(nCount-1).x + 3600*1000);

                if(lastDate.getHours() - firstDate.getHours() >= 6)
                {
                    xDateTime.max = setDateInteger(lastDate)
                    xDateTime.min = new Date(xDateTime.max.getTime() - 3600*1000*6);
                }
                else if(lastDate.getHours() === 0)
                {
                    xDateTime.max = setDateInteger(lastDate)
                    xDateTime.min = new Date(xDateTime.max.getTime() - 3600*1000*6);
                }
                else
                {
                    xDateTime.min = setDateInteger(firstDate);//Date.fromLocaleString(Qt.locale(),new Date(),"yyyy-MM-dd hh:mm:ss");
                    xDateTime.max = new Date(xDateTime.min.getTime() + 3600*1000*6);
                }
            }

            chartView.update();
            chartView.scrollUp(1);
            chartView.scrollUp(-1);
        } else {
            var firstDate = setDateInteger(new Date());
            if(24 - firstDate.getHours() >= 6)
            {
                xDateTime.min = setDateInteger(firstDate);//Date.fromLocaleString(Qt.locale(),new Date(),"yyyy-MM-dd hh:mm:ss");
                xDateTime.max = new Date(xDateTime.min.getTime() + 3600*1000*6);
            }
            else
            {
                lastDate = setDateInteger(lastDate);
                lastDate.setHours(0);
                xDateTime.max = new Date(lastDate.getTime() + 3600*1000*24);
                xDateTime.min = new Date(xDateTime.max.getTime() - 3600*1000*6);
            }
        }
    }

    /*!
    @Function    : ininMinMaxDate()
    @Description : 初始化最小限值和最大限值
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function ininMinMaxDate()
    {
        minDateTime=new Date(nowDate.getFullYear(),nowDate.getMonth(),nowDate.getDate(),0,0,0);
        maxDateTime=new Date(nowDate.getFullYear(),nowDate.getMonth(),nowDate.getDate(),23,59,59);
    }

    //设置最小X点
    function setMinDate()
    {
        var minXDate=xDateTime.min;
        var zeroMinXDate= new Date(minXDate.getFullYear(),minXDate.getMonth(),minXDate.getDate(),0,0,0);
        var maxXDate=xDateTime.max;
        var lastMaxXDate=new Date(maxXDate.getFullYear(),maxXDate.getMonth(),maxXDate.getDate(),23,59,59);
        var flowfirstDate=new Date(flowLine.at(0).x);
        var flowLastDate=new Date(flowLine.at(flowLine.count-1).x);
        //是否为同一天
        if(minXDate.toDateString()===flowfirstDate.toDateString())
        {
            minDateTime=flowfirstDate;
        }else {
            minDateTime=zeroMinXDate;
        }
    }
    /*!
    @Function    : setMaxDate()
    @Description : 设置最大X点
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setMaxDate()
    {
        var minXDate=xDateTime.min;
        var zeroMinXDate= new Date(minXDate.getFullYear(),minXDate.getMonth(),minXDate.getDate(),0,0,0);
        var maxXDate=xDateTime.max;
        var lastMaxXDate=new Date(maxXDate.getFullYear(),maxXDate.getMonth(),maxXDate.getDate(),23,59,59);
        var flowfirstDate=new Date(flowLine.at(0).x);
        var flowLastDate=new Date(flowLine.at(flowLine.count-1).x);

        if(maxXDate.toDateString()===flowLastDate.toDateString())
        {
            if(openCurRunPageType===0)
            {
                if(flowLastDate.getHours()<23)
                {
                    flowLastDate.setHours(flowLastDate.getHours()+1);
                    maxDateTime=flowLastDate;
                }else
                    maxDateTime=lastMaxXDate;
            }else
                maxDateTime=flowLastDate;
        }else
            maxDateTime=lastMaxXDate;
    }
}
