import QtQuick 2.15
import QtQuick.Controls 2.5
import "../../publicAssembly"
/*! @File        : SpeedMinSpeed.qml
 *  @Brief       : 当前运行页面 转速选中,最小转速控件
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/

FlowDataInfo
{
    required property string curData;
    id:iSpeed
    staticText: "最小转速"
    flowData:  curData
    /*!
    @Function    : setText(text)
    @Description : 设置最小转速
    @Author      : likun
    @Parameter   : text string 最小转速
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setText(text)
    {
        iSpeed.curData=text;
    }
}
