import QtQuick 2.15
import QtQuick.Controls 2.5
import QtCharts 2.3
//import QtQml 2.15

/*! @File        : DrawLineControl.qml
 *  @Brief       : 画线控件
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/

ChartView
{
    readonly property real singleInterval: 120//x轴2点之间的间距
    readonly property real xNumbers: 25;//0:00-24:00,公共多少个点数
    property var minDateTime;
    property var maxDateTime;
    property alias xAxis: xDateTime;
    readonly property int iShowtickCount: 6;

    property var curDate;//需要显示数据的日期
    property var curDateTime;
    property int chartX: 0//在chartview图表内的x轴数值
    property int dateX:0//在DateTime图表内X轴数值
    readonly property point leftBottomPoint: Qt.point(51,0)
    readonly property point rightBottomPoint: Qt.point(880,0)
    property var startDateX;//在Datetime图表内按下时,X轴数值
    property var endDateX;//在Datetime图表内释放时,X轴数值
    readonly property int hourMilliSeconds: 3600000
    property int dragDirection:0;

    id:root
    animationDuration: 3000
    visible: true

    enum DragDirection
    {
        LeftToRight=1,
        RightToLeft
    }

    DateTimeAxis
    {
        id:xDateTime

        format: "hh:00"
        min:minDateTime
        max: maxDateTime;
        tickCount: iShowtickCount
        titleVisible: false
        labelsFont: Qt.font({family:"OPPOSans",weight:Font.Medium,pixelSize:20})
        labelsColor:"#FFFFFF"
        labelsVisible: true
        gridLineColor: "#515151"
        visible: true
        onMinChanged:
        {
            root.update();
        }
        onMaxChanged:
        {
            root.update();
        }
    }
    MouseArea{
        id:mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onPressed:
        {
            chartX=mouse.x;      
            startDateX=root.mapToValue( Qt.point(chartX,0), xAxis).x;
        }
        onPositionChanged:
        {
            //在窗口需要移动X的距离
            var chartMoveX=mouse.x-chartX;
            //console.log("chartMoveX:",chartMoveX)
            if(chartMoveX==0)
            {
                return;
            }
            if(chartMoveX>0)
            {
                dragDirection=DrawLineControl.LeftToRight;
            }
            else if(chartMoveX<0)
            {
                dragDirection=DrawLineControl.RightToLeft;
            }

            endDateX= root.mapToValue( Qt.point(mouse.x,0), xAxis).x;
            var startTime=new Date(startDateX).getTime();
            var endTime=new Date(endDateX).getTime();
            var moveTime=endTime-startTime;

            mouseArea.setAxisX(moveTime);
            root.update();
        }

        onReleased:
        {

        }
        /*!
        @Function    : setAxisX(moveTime)
        @Description : 设置X轴移动距离
        @Author      : likun
        @Parameter   : moveTime int 移动距离
        @Return      :
        @Output      :
        @Date        : 2024-08-20
        */
        function setAxisX(moveTime)
        {
            //x轴滚动时间,3分钟
            var scrollTime=3*60000;
            //console.log("moveTime:",moveTime);
            if(dragDirection===DrawLineControl.LeftToRight)
            {
                moveTime=-scrollTime;
            }
            if(dragDirection===DrawLineControl.RightToLeft)
            {
                moveTime=scrollTime;
            }
            var newMinTime=xAxis.min.getTime()+moveTime;
            if(newMinTime<=minDateTime.getTime())
            {
                xAxis.min=new Date(curDate.getFullYear(),curDate.getMonth(),curDate.getDate(),0,0,0);
                xAxis.max=new Date(curDate.getFullYear(),curDate.getMonth(),curDate.getDate(),5,0,0);
                return;
            }
            var newMaxTime=xAxis.max.getTime()+moveTime;
            if(newMaxTime>=maxDateTime.getTime())
            {
                xAxis.min=new Date(curDate.getFullYear(),curDate.getMonth(),curDate.getDate(),19,0,0);
                xAxis.max=new Date(curDate.getFullYear(),curDate.getMonth(),curDate.getDate(),24,0,0);
                return;
            }
            var newMinDate=new Date(newMinTime);
            xAxis.min=new Date(newMinDate.getFullYear(),newMinDate.getMonth(),newMinDate.getDate(),newMinDate.getHours(),newMinDate.getMinutes(),newMinDate.getSeconds());

            var newMaxDate=new Date(newMaxTime);
            xAxis.max=new  Date(newMaxDate.getFullYear(),newMaxDate.getMonth(),newMaxDate.getDate(),newMaxDate.getHours(),newMaxDate.getMinutes(),newMaxDate.getSeconds());

        }

    }

    function setDate(dateStr)
    {
        curDate=new Date(dateStr);
    }

}
