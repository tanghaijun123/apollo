import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtCharts 2.3
import "../publicAssembly/"

/*! @File        : ChartDisplayPage.qml
 *  @Brief       : 当前运行曲线页面
 *  @Author      : likun
 *  @Date        : 2024-08-19
 *  @Version     : v1.0
*/

Rectangle {
    id:itemCurrentRunLeft
    width: 914
    height: 432
    color:"transparent"
    property alias draw: curRunDraw
    //property alias drawContralIndex: drawFlowSpeedContralStackLayout.currentIndex
    property int openType: 0;
    /*!
    @Function    : sendPageIndex(int index);
    @Description : 发送页面索引信号
    @Author      : likun
    @Parameter   : index int 页面索引
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    signal sendPageIndex(int index);
    /*!
    @Function    : drawLineType(int index);
    @Description : 根据索引显示不同类型曲线信号
    @Author      : likun
    @Parameter   : index int 曲线类型索引
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    signal drawLineType(int index);
    /*!
    @Function    : accessCurRunPage(int openPageType,var accessDate,int dataIndex, int iTestID);
    @Description : 访问当前运行页面信号
    @Author      : likun
    @Parameter   : openPageType int 打开页面方式 0 当前运行;1 历史记录; accessDate var 访问日期; dataIndex  int  记录索引; iTestID int 记录ID
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    signal accessCurRunChartDisplayPage(int openPageType,var accessDate,int dataIndex, int iTestID);
    PublicDefine{id:publicDefine}

    Rectangle
    {
        id:backButton
        width: 56
        height: 56
        color: "transparent"
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 10;
        opacity: 0.8
        visible: openType!==publicDefine.openPageType.CurrentRun
        Image {
            id: backButtonImg
            anchors.fill:  parent
            source: "/images/icon_button_return@2x.png"
        }
        MouseArea
        {
            id:mouseArea
            anchors.fill: parent
            onClicked:
            {
                backButton.visible=false;
//                openCurRunPageType=publicDefine.openPageType.CurrentRun;
                itemCurrentRunLeft.sendPageIndex(publicDefine.recordPageIndex.RunRecordPage);
            }
        }
    }

    RowLayout
    {
        id:topLay
        spacing: 308
        DateContral{id:currentRunDate;Layout.leftMargin:67;Layout.topMargin: 16}
        FlowSpeedButton{id:currentFlowSpeedBtn;Layout.rightMargin: 16;Layout.topMargin: 16}
    }

    /*StackLayout {
        id: drawFlowSpeedContralStackLayout
        anchors.top:topLay.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        CurRunDrawFlowSpeedContral {
            id:curRunDraw
        }

//        DrawFlowSpeedContral {
//            id:curRecordDraw;
//        }
    }*/

    CurRunDrawFlowSpeedContral {
        id:curRunDraw
        anchors.top:topLay.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    /*!
    @Function    : onSendDateStr(dateStr)
    @Description : 根据日期访问当前运行页面
    @Author      : likun
    @Parameter   : dateStr string 日期字符串
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    Connections
    {
        target: currentRunDate
        function onSendDateStr(dateStr)
        {
            currentRunDate.currentText=dateStr;
            draw.accessCurRunRectDrawPage(openType,new Date(dateStr),data_Index, iTest_ID);
        }
    }

    /*!
    @Function    : onDrawLineType(index)
    @Description : 显示不同类型的曲线
    @Author      : likun
    @Parameter   : index int 不同类型曲线的索引
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    Connections
    {
        target: currentFlowSpeedBtn
        function onDrawLineType(index)
        {
            itemCurrentRunLeft.drawLineType(index);
//            curRunPage.accessCurRunPage(openType,access_Date,data_Index,iTest_ID);
            draw.setDrawLineType(index);
        }
    }

    /*!
    @Function    : onAccessCurRunPage(openPageType,accessDate,dataIndex, iTestID)
    @Description : 访问当前运行页面
    @Author      : likun
    @Parameter   : openPageType int 打开页面方式 0 当前运行;1 历史记录; accessDate var 访问日期; dataIndex  int  记录索引; iTestID int 记录ID
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    Connections
    {
        target: itemCurrentRunLeft
        function onAccessCurRunChartDisplayPage(openPageType,accessDate,dataIndex, iTestID)
        {
            var year=accessDate.getFullYear();
            var month=accessDate.getMonth()+1;
            var day=accessDate.getDate();
            var dateStr=year+"/"+(month<10?"0"+month:month)+"/"+(day<10?"0"+day:day);
            var dates=[];
            if(openPageType===publicDefine.openPageType.CurrentRun)
            {
                backButton.visible=false;
            }
            else
            {
                backButton.visible=true;
            }
            if(iTestID===0)
            {
                dates.unshift(dateStr);
            }
            else if(iTestID>0)
            {
                dates=getTestDetailDates(iTestID);
                if(dates.length<1)
                    dates.unshift(dateStr);
            }

            openType=openPageType;
            access_Date=accessDate;
            data_Index=dataIndex;
            iTest_ID=iTestID;

            currentRunDate.setDate(dates);
            //如果是历史记录,访问日期为dates 第一个访问日期
            if(openPageType>publicDefine.openPageType.CurrentRun)
            {
                nowDate=new Date(dates[0]);
            }
            //当前运行,历史数据,只获取当天数据
            draw.accessCurRunRectDrawPage(openPageType,nowDate,dataIndex,iTestID);
        }
    }

    /*!
    @Function    : getTestDetailDates(iTestID)
    @Description : 根据testID获取所有日期
    @Author      : likun
    @Parameter   : iTestID int 测试ID
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    function getTestDetailDates(iTestID)
    {
        var datas=[];
        var rs=cTestDetail.getAllDatesInTest(iTestID);
        if(rs.res!==0)
        {
            console.log("*************ChartDisplayPage.qml,114:",JSON.stringify(rs),"*************");
            return [];
        }
        console.log("*************ChartDisplayPage.qml,124:",JSON.stringify(rs),"*************")
        for(var i=0;i<rs.data.length;i++)
            datas.unshift(rs.data[i].date);
        return datas;
    }
}
