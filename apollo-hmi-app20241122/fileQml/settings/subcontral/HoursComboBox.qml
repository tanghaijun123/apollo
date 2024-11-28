import QtQuick 2.15
import QtQuick.Controls 2.5
import "../../mainFrame/assembly"

/*! @File        : HoursComboBox.qml
 *  @Brief       : 系统设置  小时控件
 *  @Author      : likun
 *  @Date        : 2024-08-14
 *  @Version     : v1.0
*/

CustomComboBox {
    property var hs:[];
    /*!
    @Function    : sendHourIndex(int index)
    @Description : 发送选中小时索引信号
    @Author      : likun
    @Parameter   : index 选中小时索引
    @Return      :
    @Date        : 2024-08-13
    */
    signal sendHourIndex(int index);
    id:hours
    currentText: ""
    models: []
    Component.onCompleted:
    {
        for(var i=1;i<=24;i++)
        {
            hs.push(i.toString());
        }
        hours.models=hs;
        var date = new Date();
        var h=date.getHours();
        hours.currentText=h.toString();
        var index=hs.indexOf(hours.currentText);
        hours.sendHourIndex(index);
    }
    Connections
    {
        target: hours
        /*!
    @Function    : onSendHourIndex(index)
    @Description : 接收选中小时索引
    @Author      : likun
    @Parameter   : index int 小时索引
    @Return      :
    @Date        : 2024-08-14
*/
        function onSendHourIndex(index)
        {
            hours.currentIndex=index;
            hours.changeListViewIndex();
        }
    }
    Connections
    {
        target: hours
        /*!
    @Function    : onSendIndex(index)
    @Description : 接收下拉列表选中项的索引
    @Author      : likun
    @Parameter   : index int 项的索引
    @Return      :
    @Date        : 2024-08-14
*/
        function onSendIndex(index)
        {
            hours.currentText=hs[index];
            sendHourIndex(index);
        }
    }
}
