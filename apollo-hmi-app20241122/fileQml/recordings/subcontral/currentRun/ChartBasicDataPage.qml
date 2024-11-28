import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "./flow"
import "./speed"
import "./flowAndSpeed"
import "../../../mainFrame/assembly"
/*! @File        : ChartBasicDataPage.qml
 *  @Brief       : 当前运行页面,右边页面
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/

Rectangle
{
    //流量数据页面id
    property alias flowDataPage: flowDataPage;
    //转速数据页面id
    property alias speedDataPage: speedDataPage;
    //流量转速数据页面id
    property alias flowSpeedDataPage: flowSpeedDataPage;
//    //导出按钮id
//    property alias exportDataButton: exportDataButton;
    id:rightPage
    width:200
    height:432
    color:"#3D3D3D"
//    border.width: 1
//    border.color: "#FFFFFF"
    ColumnLayout
    {
        id:layout
        anchors.fill:parent
        spacing: 20
        Rectangle
        {
            id:rightTop
            width: parent.width
            height: 304
            color:"transparent"
            Layout.topMargin: 16
            Layout.alignment: Qt.AlignHCenter
            StackLayout
            {
                id:stackLay
                currentIndex: 0
                anchors.fill: parent
                FlowDataPage{id:flowDataPage;Layout.alignment: Qt.AlignHCenter}
                SpeedDataPage{id:speedDataPage;Layout.alignment: Qt.AlignHCenter}
                FlowSpeedDataPage{id:flowSpeedDataPage;Layout.alignment: Qt.AlignHCenter}
            }
        }
        ExportDataButton{id:exportDataButton;Layout.alignment: Qt.AlignHCenter
            onBtnClick:{
                closePage.open(pubCode.messageType.Question, "确定需要保存当前运行数据?", closePage.conMPDonwloadCurRunningRecord);
            }
        }
    }
    /*!
    @Function    : onChangeDataIndex(index)
    @Description : 根据索引显示不同数据
    @Author      : likun
    @Parameter   : index int 索引
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function onChangeDataIndex(index)
    {
        stackLay.currentIndex=index;
    }
}
