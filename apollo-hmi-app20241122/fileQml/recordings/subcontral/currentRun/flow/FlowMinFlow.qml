import QtQuick 2.15
import QtQuick.Controls 2.5
import "../../publicAssembly"

/*! @File        : FlowMinFlow.qml
 *  @Brief       : 当前运行页面 流量选中,最小流量控件
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/

FlowDataInfo
{
    required property string curData;
    id:iFlow
    staticText: "最小流量"
    flowData:  curData
    /*!
    @Function    : setText(text)
    @Description : 设置最小流量
    @Author      : likun
    @Parameter   : text string 流量
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setText(text)
    {
        iFlow.curData=text.toFixed(2);
    }
}
