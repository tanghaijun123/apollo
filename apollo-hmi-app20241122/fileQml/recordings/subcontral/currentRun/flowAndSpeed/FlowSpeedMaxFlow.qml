import QtQuick 2.15
import QtQuick.Controls 2.5
import "../../publicAssembly"
/*! @File        : FlowSpeedMaxFlow.qml
 *  @Brief       : 当前运行, 流量转速选中  最大流量控件
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/

FlowSpeedDataInfo
{
    required property string curData;
    id:mFlow
    staticText: "最大流量"
    flowSpeedData:curData
    /*!
    @Function    : setText(text)
    @Description : 设置最大流量
    @Author      : likun
    @Parameter   : text string 最大流量
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setText(text)
    {
        mFlow.curData=text.toFixed(2);
    }
}
