import QtQuick 2.15
import "../../mainFrame/assembly"

/*! @File        : DayComboBox.qml
 *  @Brief       : 系统设置 日控件
 *  @Author      : likun
 *  @Date        : 2024-08-14
 *  @Version     : v1.0
*/

CustomComboBox
{
    property var ds:[];
    property var days;
    property var contentText;
    property int  selectMonth;
    property int selectYear;
    /*!
    @Function    : sendDaysIndex(int index)
    @Description : 发送日数据的索引
    @Author      : likun
    @Parameter   : index 日数据的索引
    @Return      :
    @Date        : 2024-08-14
*/
    signal sendDaysIndex(int index);
    /*!
    @Function    : dayChanged()
    @Description : 日数据变化信号
    @Author      : likun
    @Parameter   :
    @Return      :
    @Date        : 2024-08-13
    */
    signal dayChanged();
    id:cbDay
    models: days
    currentText: contentText
    Component.onCompleted:
    {
        var date=new Date();
        cbDay.selectYear=date.getFullYear();
        cbDay.selectMonth=date.getMonth();
        var currentDay=date.getDate();
        contentText=currentDay;
        currentDay=parseInt(currentDay);
        createDays(selectYear,selectMonth);

        //console.log("day is completed !");
    }
    Connections
    {
        target:cbDay
        /*!
    @Function    : onSendIndex (index)
    @Description : 接收下拉列表项的索引
    @Author      : likun
    @Parameter   : index int 项的索引
    @Return      :
    @Date        : 2024-08-14
*/
        function onSendIndex (index)
        {
            currentText=days[index]
            dayChanged();
            sendDaysIndex(index);
        }
    }
    Connections
    {
        target:cbDay
 /*!
    @Function    : onSendDaysIndex(index)
    @Description : 接收日数据的索引
    @Author      : likun
    @Parameter   : index 日数据的索引
    @Return      :
    @Date        : 2024-08-14
*/
        function onSendDaysIndex(index)
        {
            cbDay.currentIndex=index;
            cbDay.changeListViewIndex();
        }
    }

/*!
    @Function    : createDays(yearNum,monNum)
    @Description : 生成日数据
    @Author      : likun
    @Parameter   : yearNum int 年份; monNum int 月份
    @Return      :
    @Date        : 2024-08-14
*/
    function createDays(yearNum,monNum)
    {
        ds=[];
        var dNum=31;
        switch(monNum)
        {
        case 1:
            dNum=31;
            break;
        case 3:
            dNum=31;
            break;
        case 5:
            dNum=31;
            break;
        case 7:
            dNum=31;
            break;
        case 8:
            dNum=31;
            break;
        case 10:
            dNum=31;
            break;
        case 12:
            dNum=31;
            break;
        case 4:
            dNum=30;
            break;
        case 6:
            dNum=30;
            break;
        case 9:
            dNum=30;
            break;
        case 11:
            dNum=30;
            break;
        case 2:
            isRunyue(yearNum) ? dNum=29:dNum=28;
            break;
        default:
            dNum=0;
            break;
        }

        for(var begin=1;begin<=dNum;begin++)
        {
            var d=begin.toString();
            ds.push(d);
        }
        days=ds;
        if(dNum<currentText)
        {
            currentText=dNum.toString();
        }
        var index=ds.indexOf(cbDay.currentText);
        cbDay.sendDaysIndex(index);
    }
    /*!
    @Function    : isRunyue(year)
    @Description : 判断是否为闰月
    @Author      : likun
    @Parameter   : year int 年份
    @Return      : true  false
    @Date        : 2024-08-14
*/
    function isRunyue(year)
    {
        if(year%4==0&&year%100!=0)
            return true;
        if(year%400==0)
            return true
        return false
    }

    /*!
    @Function    : setDay(day)
    @Description : 设置日数据
    @Author      : likun
    @Parameter   : day int 日数据
    @Return      : 返回值说明
    @Date        : 2024-08-14
*/
    function setDay(day)
    {
        cbDay.contentText=day.toString();
        var index=ds.indexOf(day.toString());
        cbDay.sendDaysIndex(index);
        cbDay.sendIndex(index);
    }

    /*!
    @Function    : day()
    @Description : 获取日数据
    @Author      : likun
    @Parameter   :
    @Return      : 日数据
    @Date        : 2024-08-14
*/
    function day()
    {
        return parseInt(cbDay.currentText);
    }

}
