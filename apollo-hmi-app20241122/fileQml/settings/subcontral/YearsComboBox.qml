import QtQuick 2.15
import "../../mainFrame/assembly"

/*! @File        : YearsComboBox.qml
 *  @Brief       : 系统设置页面  年控件
 *  @Author      : likun
 *  @Date        : 2024-08-14
 *  @Version     : v1.0
*/

CustomComboBox
{
    property var ys:[];
    property var years;
    property string contentText;
    /*!
    @Function    : sendYearNumber(int yearNum)
    @Description : 发送年数据信号
    @Author      : likun
    @Parameter   : yearNum 当前选中年的数据
    @Return      :
    @Date        : 2024-08-13
    */
    signal sendYearNumber(int yearNum);
    /*!
    @Function    : sendYearIndex(int index)
    @Description : 发送年的索引
    @Author      : likun
    @Parameter   : index 当前选中年的索引
    @Return      :
    @Date        : 2024-08-13
    */
    signal sendYearIndex(int index);
    id:cbyear
    models: years
    currentText: cbyear.contentText
    Component.onCompleted:
    {
        var date=new Date();
        var /*let*/ currentYear=date.getFullYear();
        currentYear=parseInt(currentYear);
        if(currentYear < 2024)
        {
            currentYear = 2024;
        }

        for(var begin=currentYear-14;begin<currentYear+14;begin++)
        {
            var y=begin.toString();
            ys.push(y);
        }
        years=ys;       
        //year.sendYearNumber(currentYear);
        cbyear.contentText=currentYear.toString()
        var index=ys.indexOf(cbyear.currentText)
        cbyear.sendYearIndex(index);

        year();
    }
    Connections
    {
        target:cbyear
        /*!
        @Function    : onSendYearIndex(index)
        @Description : 接收年份索引
        @Author      : likun
        @Parameter   : index int 年份索引
        @Return      :
        @Date        : 2024-08-14
        */
        function onSendYearIndex(index)
        {
            cbyear.currentIndex=index;
            cbyear.changeListViewIndex();
        }
    }

    Connections
    {
        target:cbyear
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
            currentText=ys[index]
            var currentYear=ys[index];
            currentYear=parseInt(currentYear)
            cbyear.sendYearNumber(currentYear);
        }
    }

    /*!
    @Function    : setYear(year)
    @Description : 设置年份
    @Author      : likun
    @Parameter   : year int 年份
    @Return      :
    @Date        : 2024-08-14
    */
    function setYear(year)
    {
        cbyear.contentText=year.toString();
        var index = ys.indexOf(year.toString());
        cbyear.sendYearIndex(index);
        cbyear.sendIndex(index);
    }

    /*!
    @Function    : year()
    @Description : 获取年份
    @Author      : likun
    @Parameter   :
    @Return      : yNum int 年份
    @Date        : 2024-08-14
    */
    function year()
    {
        var yNum=parseInt(cbyear.currentText);
        //console.log("year:",yNum);
        return yNum;
    }
}
