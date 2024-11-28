import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtCharts 2.3
import "../publicAssembly/"

Rectangle {
    id:itemCurrentRunLeft
    width: 914
    height: 432
    color:"transparent"
    property int openType: 0;
    signal sendPageIndex(int index);
    signal drawLineType(int index);
    signal accessCurRunPage(int openPageType,var accessDate,int dataIndex, int iTestID);
    PublicDefine{id:publicDefine}
    Rectangle
    {
        id:reback
        width: 56
        height: 56
        color: "transparent"
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 10;
        opacity: 0.8
        visible: false
        Image {
            id: rebackImg
            anchors.fill:  parent
            source: "/images/icon_button_return@2x.png"
        }
        MouseArea
        {
            id:mouseArea
            anchors.fill: parent
            onClicked:
            {
                reback.visible=false;
                itemCurrentRunLeft.sendPageIndex(publicDefine.recordPageIndex.RunRecordPage);
            }
        }
    }
    ColumnLayout
    {
        id:colLay
        spacing: 16
        RowLayout
        {
            id:topLay
            spacing: 348
            DateContral{id:currentRunDate;Layout.leftMargin:67;Layout.topMargin: 16}
            FlowSpeedButton{id:currentFlowSpeedBtn;Layout.rightMargin: 16;Layout.topMargin: 16}
        }
        DrawFlowSpeedContral{id:draw;Layout.alignment: Qt.AlignHCenter}
    }   
    Connections
    {
        target: currentFlowSpeedBtn
        function onDrawLineType(index)
        {
            itemCurrentRunLeft.drawLineType(index);
            draw.setDrawLineType(index);
        }
    }
    Connections
    {
        target: itemCurrentRunLeft
        function onAccessCurRunPage(openPageType,accessDate,dataIndex, iTestID)
        {
            if(openPageType===publicDefine.openPageType.CurrentRun)
            {
                reback.visible=false;
            }
            else
            {
                reback.visible=true;
            }
            currentRunDate.setDate(accessDate);
            draw.accessCurRunPage(openPageType,accessDate,dataIndex, iTestID);
        }
    }
}
