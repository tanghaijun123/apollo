import QtQuick 2.15
import QtQuick.Controls 2.5
import "../../mainFrame/assembly"

/*! @File        : MinutesComboBox.qml
 *  @Brief       : 系统设置页面  分钟控件
 *  @Author      : likun
 *  @Date        : 2024-08-14
 *  @Version     : v1.0
*/


CustomComboBox {
    property  var  ms: []
    /*!
    @Function    : sendMinuteIndex(int index)
    @Description : 发送选中分钟索引信号
    @Author      : likun
    @Parameter   : index 选中分钟索引
    @Return      :
    @Date        : 2024-08-13
    */
    signal sendMinuteIndex(int index);
    id:minute
    models:[]
    currentText: ""
    Component.onCompleted:
    {

        for(var i=0;i<60;i+=1)
        {
            ms.push(i.toString());
        }
        minute.models=ms;
        var date=new Date();
        var currentMinute=date.getMinutes();
        setCurrentMinute(currentMinute);


    }
    Connections
    {
        target: minute
        /*!
    @Function    : onSendMinuteIndex(index)
    @Description : 接收选中分钟索引
    @Author      : likun
    @Parameter   : 参数说明
    @Return      : index int 分钟索引
    @Date        : 2024-08-14
*/
        function onSendMinuteIndex(index)
        {
            minute.currentIndex=index;
            minute.changeListViewIndex();
        }
    }
    Connections
    {
        target:minute
        /*!
    @Function    : onSendIndex(index)
    @Description : 接收下拉列表选中项的索引
    @Author      : likun
    @Parameter   : 参数说明
    @Return      : index int 项的索引
    @Date        : 2024-08-14
*/
        function onSendIndex(index)
        {
            minute.currentText=ms[index];
            sendMinuteIndex(index);
        }
    }

    /*!
    @Function    : setCurrentMinute(currentMinute)
    @Description : 设置当前分钟数据
    @Author      : likun
    @Parameter   : currentMinute int 分钟数据
    @Return      :
    @Date        : 2024-08-14
*/
    function setCurrentMinute(currentMinute)
    {
        var index=0
        if(currentMinute===0)
        {
            index=ms.indexOf(currentMinute.toString());
            minute.sendMinuteIndex(index);
            minute.currentText=currentMinute.toString();
            return;
        }
        if(currentMinute===60)
        {
            index=ms.indexOf(currentMinute.toString());
            minute.sendMinuteIndex(index);
            minute.currentText=currentMinute.toString();
            return;
        }
        for(var i=1;i<ms.length;i++)
        {
            if(ms[i]>=currentMinute)
            {
                minute.sendMinuteIndex(i);
                minute.currentText=ms[i];
                return;
            }
        }
    }
}
