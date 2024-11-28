import QtQuick 2.15
import QtQuick.Controls 2.15


/*! @File        : L_Min.qml
 *  @Brief       : 设备信息页面 LPM控件
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle
{
    //property string textLMinNumContent: "2.26"
    id:rectLMin
    width: 362
    height: 120
    color:"transparent"
    Row
    {
        anchors.fill: parent
        spacing:10
        Rectangle
        {
            id:rectLMinNum
            width: 221
            height: 120
            color:"transparent"
//            anchors.left: rectLMin.left
//            anchors.verticalCenter: rectLMin.verticalCenter
            Text {
                id: textLMinNum
                anchors.fill: parent
                text:  "- -" //  rectLMin.textLMinNumContent
                //text: textLMinNumContent
                font.family: "Quicksand"
                font.weight: Font.DemiBold
                color:mainWindow.bShowRealFlowValue ? ( (mainWindow.strFlowValue < settingParam_FlowMin ||  mainWindow.strFlowValue > settingParam_FlowMax) ? "#F43434": "#FFFFFF") : "#FFFFFF"
                font.pixelSize: 116
                horizontalAlignment: textLMinNum.text==="- -" ?Text.AlignHCenter:Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }
        }
        Rectangle
        {
            id:rightrect
            width:131
            height: 120
            color:"transparent"
            Column
            {
                anchors.fill: parent
                spacing: 0
                Rectangle
                {
                    id:rightTopRect
                    width: 131
                    height: 60
                    color:"transparent"
                }
                Rectangle
                {
                    id:rectLMinUnit
                    width: 131
                    height: 60
                    color:"transparent"
                    Text {
                        id: textLMinUnit
                        anchors.fill: parent
                        text: "LPM"
                        opacity: 0.6
                        color:"#FFFFFF"
                        font.family: "Quicksand"
                        font.weight: Font.Medium
                        font.pixelSize: 48
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
    /*!
    @Function    : onSetTextLMinNumContent(text)
    @Description : 设置流量/min的内容
    @Author      : likun
    @Parameter   : text string 流量
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function onSetTextLMinNumContent(text)
    {
        //rectLMin.textLMinNumContent=text;
        textLMinNum.text = text;
    }
}
