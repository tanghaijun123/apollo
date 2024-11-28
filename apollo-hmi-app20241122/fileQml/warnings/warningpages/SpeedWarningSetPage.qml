import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Shapes 1.15
import "../subcontral"
/*! @File        : SpeedWarningSetPage.qml
 *  @Brief       : 转速报警设置页面
 *  @Author      : likun
 *  @Date        : 2024-08-22
 *  @Version     : v1.0
*/

Rectangle
{
    id:root
    property real dashSize: 10
    property color dashColor: "#FFFFFF"
    /*!
    @Function    : sendIndex(int index);
    @Description : 发送页面索引
    @Author      : likun
    @Parameter   : index int 索引
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    signal sendIndex(int index);    
    width: parent.width
    height: parent.height
    color:"transparent"
    Rectangle //返回按钮
    {
        id:rectReturn
        width: 56
        height: 56
        color:"transparent"
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30
        Shape
        {
            id:canvas
            width: parent.width
            height: parent.height
            ShapePath
            {
                strokeStyle: ShapePath.DashLine  //虚线
                startX: 4
                startY: 0
                dashPattern: [1, 2.5] // 点的长度为1，点与点之间的空隙长度也是3
                PathLine{x:56;y:0}
                PathLine{x:56;y:56}
                PathLine{x:4;y:56}
                PathLine{x:4;y:0}
                fillColor: "transparent"
                strokeColor: Qt.rgba(255,255,255,0.3)
                strokeWidth: 1;
            }
        }

        Image {
            id: imgReturn
            source: "/images/icon_button_return@2x.png"
            anchors.fill: parent
        }
        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                root.sendIndex(0);
            }
        }
    }
    Rectangle //文字内容
    {
        id:rectText
        width: 224
        height: 32
        color:"transparent"
        anchors.left: rectReturn.right
        anchors.leftMargin: 4
        anchors.top: rectReturn.top
        anchors.topMargin: 12
        Text {
            id: textSpeedRange
            text: "泵转速报警范围"
            color:"#FFFFFF"
            opacity: 0.8
            font.family: "OPPOSans"
            font.weight: Font.Bold
            font.pixelSize: 32
            anchors.centerIn: parent
        }
    }

    signal flowRangeChangedByMan(int fParamMin, int fParamMax);
    WarningSetControl//流量设置范围
    {
        id:speedSetControl
        fixValue:0
        fromValue: 0
        toValue: 5000
        stepValue:10
        betweenMaxAndMin:100
        firstTextValueContent: mainWindow.settingParam_MotorMin;
        secTextValueContent: mainWindow.settingParam_MotorMax;
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 165
        Connections{
            target: speedSetControl;
            function onValueChangedByMan(){
                console.debug("speedSetControl",mainWindow.settingParam_MotorMin,mainWindow.settingParam_MotorMax)
                mainWindow.settingParam_MotorMin = speedSetControl.firstTextValueContent;
                mainWindow.settingParam_MotorMax = speedSetControl.secTextValueContent;
                //speedSetControl.saveParamValue(mainWindow.strParam_motorValue, speedSetControl.firstTextValueContent, speedSetControl.secTextValueContent);
                tmrDelayUpdateSpeedParam.restart();
            }
        }

    }

    Timer{
        id: tmrDelayUpdateSpeedParam
        interval: 1 * 1000
        running:  false
        onTriggered: {
            speedSetControl.saveParamValue(mainWindow.strParam_motorValue, speedSetControl.firstTextValueContent, speedSetControl.secTextValueContent);
        }

    }
    /*!
    @Function    : setSelSlidIndex(nIndex)
    @Description : 根据索引设置滑块
    @Author      : likun
    @Parameter   : nIndex int 索引
    @Return      : 返回值说明
    @Output      :
    @Date        : 2024-08-22
*/
    function setSelSlidIndex(nIndex){
        if(nIndex === 0){
            speedSetControl.setFirstSelected()
        }
        else{
           speedSetControl.setSecondSelected()
        }
    }
}
