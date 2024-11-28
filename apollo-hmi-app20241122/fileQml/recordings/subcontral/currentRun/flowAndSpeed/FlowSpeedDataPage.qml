import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
/*! @File        : FlowSpeedDataPage.qml
 *  @Brief       : 当前运行页面,流量与速度选中 数据页面
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/

Rectangle {
    id:rectFlowSpeedData
    width: 168
    height: 312
    color:"transparent"
    ColumnLayout
    {
        id:dataLay
        spacing:20
        anchors.fill: parent
        Rectangle
        {
            id:topFlow
            width: parent.width
            height: 136
            color:"transparent"
            Layout.alignment: Qt.AlignHCenter
            ColumnLayout
            {
                id:topLayout
                spacing: 8
                anchors.fill: parent
                FlowSpeedMaxFlow{id:maxFlowPage;Layout.alignment: Qt.AlignHCenter;curData: maxFLow.toFixed(2)}
                FlowSpeedMinFlow{id:minFlowPage;Layout.alignment: Qt.AlignHCenter;curData:  minFLow.toFixed(2)}
                FlowSpeedAverageFlow{id:avgFlowPage;Layout.alignment: Qt.AlignHCenter;curData:  avgFLow.toFixed(2)}
            }
        }
        Rectangle
        {
            id:line
            width: 198
            height: 1
            color:"#585858"
            Layout.alignment: Qt.AlignHCenter
        }
        Rectangle
        {
            id:bottomSpeed
            width: parent.width
            height: 136
            color:"transparent"
            Layout.alignment: Qt.AlignHCenter
            ColumnLayout
            {
                id:bottomLayout
                spacing: 8
                anchors.fill: parent
                FlowSpeedMaxSpeed{id:maxSpeedPage;Layout.alignment: Qt.AlignHCenter;curData: curMaxSpeed}
                FlowSpeedMinSpeed{id:minSpeedPage;Layout.alignment: Qt.AlignHCenter;curData:  minSpeed}
                FlowSpeedAverageSpeed{id:avgSpeedPage;Layout.alignment: Qt.AlignHCenter;curData:  avgSpeed}
            }
        }
    }
    /*!
    @Function    : setMaxFlow(text)
    @Description : 设置最大流量
    @Author      : likun
    @Parameter   : text string 最大流量
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setMaxFlow(text)
    {
        maxFlowPage.setText(text);
    }
    /*!
    @Function    : setMinFlow(text)
    @Description : 设置最小流量
    @Author      : likun
    @Parameter   : text string 最小流量
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setMinFlow(text)
    {
        minFlowPage.setText(text);
    }
    /*!
    @Function    : setAvgFlow(text)
    @Description : 设置平均流量
    @Author      : likun
    @Parameter   : text string 平均流量
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setAvgFlow(text)
    {
        avgFlowPage.setText(text);
    }
    /*!
    @Function    : setMaxSpeed(text)
    @Description : 设置最大转速
    @Author      : likun
    @Parameter   : text string 最大转速
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setMaxSpeed(text)
    {
        maxSpeedPage.setText(text);
    }
    /*!
    @Function    : setMinSpeed(text)
    @Description : 设置最小转速
    @Author      : likun
    @Parameter   : text string 最小转速
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setMinSpeed(text)
    {
        minSpeedPage.setText(text);
    }
    /*!
    @Function    : setAvgSpeed(text)
    @Description : 设置平均转速
    @Author      : likun
    @Parameter   : text string 平均转速
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setAvgSpeed(text)
    {
        avgSpeedPage.setText(text);
    }
}
