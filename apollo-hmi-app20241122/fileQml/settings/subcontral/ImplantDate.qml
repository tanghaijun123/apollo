import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../mainFrame/assembly"
/*! @File        : ImplantDate.qml
 *  @Brief       : 植入日期控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Rectangle{
    id:rectImplantDate
    width:820
    height:64
    color:"transparent"
    RowLayout
    {
        id: mainLayout
        spacing: 14
        PublicConstText
        {
            id:textImplantDate
            textContent: "手术时间"
        }
        RowLayout
        {
            id:subLayout
            spacing: 12
            YearsComboBox{
                id:yearComboBox
                onCurrentTextChanged:
                {
                    mainWindow.havePatientValueChanged();
                }
            }
            PublicConstText{id:textYear;textContent:"年"}
            MonthsComboBox{
                id:monthComboBox
                onCurrentTextChanged:
                {
                    mainWindow.havePatientValueChanged();
                }
            }
            PublicConstText{id:textMonth;textContent: "月"}
            DayComboBox{
                id:dayComboBox
                onCurrentTextChanged:
                {
                    mainWindow.havePatientValueChanged();
                }
            }
            PublicConstText{id:textDay;textContent: "日"}
        }
    }
    Connections
    {
        target:yearComboBox
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
            dayComboBox.selectYear=yearNum
            dayComboBox.createDays(dayComboBox.selectYear,dayComboBox.selectMonth);
        }
    }
    Connections
    {
        target:monthComboBox
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
            dayComboBox.selectMonth=monthNum
            dayComboBox.createDays(dayComboBox.selectYear,dayComboBox.selectMonth);
        }
    }
    /*!
    @Function    : setDate(year,month,day)
    @Description : 设置日期
    @Author      : likun
    @Parameter   : year int; month int; day int
    @Return      : 返回值说明
    @Output      :
    @Date        : 2024-08-18
*/
    function setDate(year,month,day)
    {
        yearComboBox.setYear(year);
        monthComboBox.setMonth(month);
        dayComboBox.setDay(day);
    }
    /*!
    @Function    : getDate()
    @Description : 获取日期
    @Author      : likun
    @Parameter   :
    @Return      : {"year":year,"month":month,"day":day}
    @Output      :
    @Date        : 2024-08-18
*/
    function getDate()
    {
        var year=yearComboBox.year();
        var month=monthComboBox.month();
        var day=dayComboBox.day();
        return {"year":year,"month":month,"day":day};
    }
    /*!
    @Function    : setDateTime(dDateTime)
    @Description : 设置日期
    @Author      : likun
    @Parameter   : dDateTime  Date  日期对象
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
    function setDateTime(dDateTime){

//        console.debug("ImplantDate:", dDateTime);

        yearComboBox.setYear(dDateTime.getFullYear());
        monthComboBox.setMonth(dDateTime.getMonth() + 1);
        dayComboBox.setDay(dDateTime.getDate());
    }
    /*!
    @Function    : getDateTime()
    @Description : 获取日期
    @Author      : likun
    @Parameter   :
    @Return      : dt  Date  日期对象
    @Output      :
    @Date        : 2024-08-18
*/
    function getDateTime(){
        var year=yearComboBox.year();
        var month=monthComboBox.month();
        var day=dayComboBox.day();
        var dateStr=`${year}/${month>9?month:'0'+month}/${day>9?day:'0'+day}`;
        var dt = new Date(dateStr);
//        dt.setFullYear(year);
//        dt.setMonth(month -1);
//        dt.setDate(day);

        return dt;//Qt.formatDateTime(dt, "yyyy-MM-dd hh:mm:ss");
    }


}
