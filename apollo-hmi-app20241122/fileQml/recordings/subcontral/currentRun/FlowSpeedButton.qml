import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../publicAssembly"


/*! @File        : FlowSpeedButton.qml
 *  @Brief       : 当前运行  流量转速切换按钮控件
 *  @Author      : likun
 *  @Date        : 2024-08-19
 *  @Version     : v1.0
*/
Rectangle {
    /*!
    @Function    : drawLineType(int index);
    @Description : 根据索引显示曲线类型信号
    @Author      : likun
    @Parameter   : index int 曲线类型信号
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    signal drawLineType(int index);
    enum ShowTypeEnum
    {
        Flow,
        Speed,
        FlowAndSpeed
    }

    id:itmFlowSpeedBtn
    width: 304
    height:40
    color:"transparent"

    RowLayout
    {
        id:rowLayout
        Layout.preferredWidth: parent.width
        Layout.preferredHeight: parent.height
        spacing: 16
        ButtonGroup{id:btnGroup;exclusive: true}
        CustomButton
        {
            id:btnFlow
            textContent: "流量"
            buttonGroup:btnGroup
            isChecked: true
            isEnabled: false
            Connections
            {
                target: btnFlow
                function onBtnClick()
                {
//                    if(btnFlow.isChecked&&!btnSpeed.isChecked)
//                        return;
//                    btnFlow.isChecked=btnFlow.isChecked?false:true;
                    itmFlowSpeedBtn.sendIndxe();
                }
            }
        }
        CustomButton
        {
            id:btnSpeed
            textContent: "转速"
            buttonGroup: btnGroup
            isChecked:false
            Connections
            {
                target: btnSpeed
                function onBtnClick()
                {
                    if(btnSpeed.isChecked&&!btnFlow.isChecked)
                        return;
                    btnSpeed.isChecked=btnSpeed.isChecked?false:true;
                    itmFlowSpeedBtn.sendIndxe();
                }

            }

        }
    }
    /*!
    @Function    : sendIndxe()
    @Description : 发送显示曲线类型信号
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    function sendIndxe()
    {
        if(btnFlow.isChecked&&!btnSpeed.isChecked)
        {
            itmFlowSpeedBtn.drawLineType(FlowSpeedButton.Flow);
            return;
        }
        if(!btnFlow.isChecked&&btnSpeed.isChecked)
        {
            itmFlowSpeedBtn.drawLineType(FlowSpeedButton.Speed);
            return;
        }
        if(btnFlow.isChecked&&btnSpeed.isChecked)
        {
            itmFlowSpeedBtn.drawLineType(FlowSpeedButton.FlowAndSpeed);
            return;
        }
    }
}
