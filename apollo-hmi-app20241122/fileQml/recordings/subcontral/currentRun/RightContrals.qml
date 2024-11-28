import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "./flow"
import "./speed"
import "./flowAndSpeed"
import "../../../mainFrame/assembly"

//当前运行页面,右边页面
Rectangle
{
    //流量数据页面id
    property alias flowDataPage: flowDataPage;
    //转速数据页面id
    property alias speedDataPage: speedDataPage;
    //流量转速数据页面id
    property alias flowSpeedDataPage: flowSpeedDataPage;
    id:rightPage
    width:200
    height:432
    color:"transparent"
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
        ExportDataButton{id:exportDataButton;Layout.alignment: Qt.AlignHCenter}
    }
    function onChangeDataIndex(index)
    {
        stackLay.currentIndex=index;
    }
}
