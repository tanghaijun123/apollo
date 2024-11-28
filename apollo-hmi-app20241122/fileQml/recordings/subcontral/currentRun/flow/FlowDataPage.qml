import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

/*! @File        : FlowDataPage.qml
 *  @Brief       : 当前运行页面,流量选中 数据页面
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/
Rectangle {
    id:rectFlowSDataPage
    width: 200
    height: 304
    color: "#3D3D3D"
    ColumnLayout
    {
        id:flowLay
        anchors.fill: parent
        spacing:20
        FlowMaxFlow{id:maxFlowPage;Layout.alignment: Qt.AlignHCenter;curData:maxFLow.toFixed(2)}
        FlowMinFlow{id:minFlowPage;Layout.alignment: Qt.AlignHCenter;curData: minFLow.toFixed(2)}
        FlowAverageFlow{id:avgFlowPage;Layout.alignment: Qt.AlignHCenter;curData: avgFLow.toFixed(2)}
    }
    /*!
    @Function    : setMaxFlow(text)
    @Description : 设置最大流量
    @Author      : likun
    @Parameter   : text string 流量
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
    @Parameter   : text string 流量
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
    @Parameter   : text string 流量
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setAvgFlow(text)
    {
        avgFlowPage.setText(text);
    }
}
