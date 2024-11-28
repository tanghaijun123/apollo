import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../subcontral"
/*! @File        : FlowWarningSetPage.qml
 *  @Brief       : 流量报警设置页面
 *  @Author      : likun
 *  @Date        : 2024-08-22
 *  @Version     : v1.0
*/
Rectangle
{
    id:root
    /*!
    @Function    : sendIndex(int index)
    @Description : 发送页面索引信号
    @Author      : likun
    @Parameter   : index int 索引
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    signal sendIndex(int index)
    width: parent.width
    height: parent.height
    color:"transparent"
    Rectangle
    {
        id:rectL_min
        width: 202
        height: 42
        color:"transparent"
        anchors.left: root.left
        anchors.leftMargin: 30
        anchors.top: root.top
        anchors.topMargin: 30
        Text {
            id: txtL_min
            text: "泵流量-LPM"
            color:"#FFFFFF"
            opacity: 0.8
            font.family: "OPPOSans"
            font.weight: Font.Bold
            font.pixelSize: 32
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

    }
    Rectangle
    {
        id:btnOpenSpeed
        width:88
        height:88
        color: "#3D665E"
        border.color: "#1D1D1D"
        border.width: 2
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.right: parent.right
        anchors.rightMargin: 30
        radius:4
        Image {
            id: imgOpenSpeed
            source: "/images/icon_warning_more set up.png"
            anchors.fill: parent
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
        }
        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                root.sendIndex(1);
            }
        }
    }
    Rectangle//文字泵转速报警范围
    {
        id:rectSetSpeedWarning
        width: 168
        height:32
        color:"transparent"
        anchors.right:btnOpenSpeed.right
        anchors.top:btnOpenSpeed.bottom
        anchors.topMargin:10
        Text {
            id: textSetSpeedWarning
            text: "泵转速报警范围"
            color:"#FFFFFF"
            opacity: 0.8
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 24
            anchors.centerIn: parent
        }
    }

    WarningSetControl//流量设置范围
    {
        id:flowSetControl
        firstTextValueContent: mainWindow.settingParam_FlowMin
        secTextValueContent: mainWindow.settingParam_FlowMax
        stepValue:0.1
        betweenMaxAndMin:1.0/*0.4*/
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 165
        Connections{
            target: flowSetControl;
            function onValueChangedByMan(){
                mainWindow.settingParam_FlowMin = flowSetControl.firstTextValueContent;
                mainWindow.settingParam_FlowMax = flowSetControl.secTextValueContent;
                tmrDelayUpdateFlowParam.restart();
                console.debug("FlowWarningSetPage onValueChangedByMan")
                //mainWindow.flowRangeChangedByMan(mainWindow.settingParam_FlowMin, mainWindow.settingParam_FlowMax);
            }
        }
    }

    Timer{
        id: tmrDelayUpdateFlowParam
        interval: 1 * 1000
        running:  false
        repeat: false
        onTriggered: {
            console.debug("FlowWarningSetPage tmrDelayUpdateFlowParam")
            flowSetControl.saveParamValue(mainWindow.strParam_FowValue, flowSetControl.firstTextValueContent, flowSetControl.secTextValueContent);
        }

    }

    /*!
    @Function    : setSelSlidIndex(nIndex)
    @Description : 设置滑块选择状态
    @Author      : likun
    @Parameter   : nIndex int 索引
    @Return      : 返回值说明
    @Output      :
    @Date        : 2024-08-22
*/
    function setSelSlidIndex(nIndex){
//        console.debug("FlowWaringSetPage setSelSlidIndex: ", nIndex);
        if(nIndex === 0){
            flowSetControl.setFirstSelected()
        }
        else{
           flowSetControl.setSecondSelected();
        }
    }
}



