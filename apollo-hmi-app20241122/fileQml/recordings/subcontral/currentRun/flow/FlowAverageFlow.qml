import QtQuick 2.15
import QtQuick.Controls 2.5
import "../../publicAssembly"

/*! @File        : FlowAverageFlow.qml
 *  @Brief       : 当前运行页面 流量选中,平均流量控件
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/

FlowDataInfo
{
    required property string curData;
    id:aFlow
    staticText: "平均流量"
    flowData: curData
    /*!
    @Function    : setText(text)
    @Description : 设置平均流量
    @Author      : likun
    @Parameter   : text string  平均流量
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setText(text)
    {
        aFlow.curData=text.toFixed(2);
    }
}
