import QtQuick 2.15
import QtQuick.Controls 2.5
import "../../publicAssembly"
/*! @File        : FlowSpeedAverageSpeed.qml
 *  @Brief       : 当前运行, 流量转速选中  平均转速控件
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/
FlowSpeedDataInfo
{
    required property string curData;
    id:aSpeed
    staticText: "平均转速"
    flowSpeedData:curData
    /*!
    @Function    : setText(text)
    @Description : 设置平均转速
    @Author      : likun
    @Parameter   : text string 平均转速
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setText(text)
    {
        aSpeed.curData=text;
    }
}
