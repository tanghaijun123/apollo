import QtQuick 2.15
import "../../mainFrame/assembly"

/*! @File        : MonthsComboBox.qml
 *  @Brief       : 系统设置页面  月控件
 *  @Author      : likun
 *  @Date        : 2024-08-14
 *  @Version     : v1.0
*/

CustomComboBox
{
    property var ms:[];
    property var months;
    property var contentText;
    /*!
    @Function    : sendMonth(int monthNum);
    @Description : 发送选中的月数据信号
    @Author      : likun
    @Parameter   : monthNum 选中的月数据
    @Return      :
    @Date        : 2024-08-13
    */
    signal sendMonth(int monthNum);
    /*!
    @Function    : sendMonthIndex(int index)
    @Description : 发送选中月份的索引信号
    @Author      : likun
    @Parameter   : index 选中月份的索引
    @Return      :
    @Date        : 2024-08-13
    */
    signal sendMonthIndex(int index);
    id:cbMonth
    models: months
    currentText: contentText
    Component.onCompleted:
    {
        var date=new Date();
        var currentMonth=date.getMonth() + 1;
        contentText=currentMonth.toString();
//        currentMonth=parseInt(currentMonth);
        for(var begin=1;begin<13;begin++)
        {
            var m=begin.toString();
            ms.push(m);
        }
        months=ms;
        cbMonth.sendMonth(currentMonth);
        var index=ms.indexOf(cbMonth.currentText);
        cbMonth.sendMonthIndex(index);

//        month();
    }
    Connections
    {
        target:cbMonth;
        /*!
        @Function    : onSendMonthIndex(index)
        @Description : 接收选中月份的索引
        @Author      : likun
        @Parameter   : index int 索引
        @Return      :
        @Date        : 2024-08-14
        */
        function onSendMonthIndex(index)
        {
            cbMonth.currentIndex=index;
            cbMonth.changeListViewIndex();
        }
    }

    Connections
    {
        target:cbMonth
        /*!
        @Function    : onSendIndex(index)
        @Description : 接收下拉列表项的索引
        @Author      : likun
        @Parameter   : ndex int 索引
        @Return      :
        @Date        : 2024-08-14
        */
        function onSendIndex(index)
        {
            if(index < 0)
                return;
            currentText=months[index];
            var /*let*/ currentMonth=months[index];
            currentMonth=parseInt(currentMonth);
            cbMonth.sendMonth(currentMonth);
        }
    }
    /*!
    @Function    : setMonth(month)
    @Description : 设置选中的月份
    @Author      : likun
    @Parameter   : month 选中的月份
    @Return      :
    @Date        : 2024-08-13
    */
    function setMonth(month)
    {
        cbMonth.contentText=month.toString();
        var index=ms.indexOf(month.toString());
        cbMonth.sendMonthIndex(index);
        cbMonth.sendIndex(index);
    }
    /*!
    @Function    : month()
    @Description : 获取月份
    @Author      : likun
    @Parameter   :
    @Return      : mNum int 当前选中的月份
    @Date        : 2024-08-13
    */
    function month()
    {
        var mNum=parseInt(cbMonth.currentText)
        //console.log("month:",mNum);
        return mNum//parseInt(cbMonth.contentText);
    }
}
