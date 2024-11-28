import QtQuick 2.15
import QtQuick.Controls 2.5
import "../../publicAssembly"

/*! @File        : FlowMaxFlow.qml
 *  @Brief       : 当前运行页面 流量选中,最大流量控件
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/

FlowDataInfo
{
    required property string curData;
    id:mFlow
    staticText: "最大流量"
    flowData:  curData
    /*!
    @Function    : setText(text)
    @Description : 设置最大流程
    @Author      : likun
    @Parameter   : text string 流量
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setText(text)
    {
        mFlow.curData=text.toFixed(2);
    }
}
