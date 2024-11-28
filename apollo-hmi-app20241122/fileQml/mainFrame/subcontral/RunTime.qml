import QtQuick 2.15
import QtQuick.Controls 2.5

/*! @File        : RunTime.qml
 *  @Brief       : 设备运行信息页面  连续运行空间
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle {
    property string  hourText: "10"
    property string  minText: "52"
    id:runTime
    width: 342
    height:74
    color:"#3F3F3F"
    Row
    {
        height: 46
        anchors.top: parent.top
        anchors.topMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 16
        spacing: 10
        Rectangle
        {
            id:left
            width:140
            height: 46
            color:"transparent"

            Text {
                id: leftText
                text: "已连续运行"
                anchors.verticalCenter: parent.verticalCenter
                opacity: 0.7
                font.family: "OPPOSans"
                font.weight: Font.Normal
                color:"#FFFFFF"
                font.pixelSize: 28
            }
        }
        Rectangle
        {
            id:right
            width: 160
            height: 46
            color: "#000000"
            Text {
                id: rightText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: hourText + "h" + minText + "min"
                font.family: "Quicksand"
                font.weight: Font.DemiBold
                opacity: 0.9
                color:"#FFFFFF"
                font.pixelSize: 30
            }
        }
    }
    /*!
    @Function    : onSetHourText(text)
    @Description : 设置小时
    @Author      : likun
    @Parameter   : text int 小时
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function onSetHourText(text)
    {
        runTime.hourText=text;
    }
    /*!
    @Function    : onSetMinText(text)
    @Description : 设置分钟
    @Author      : likun
    @Parameter   : text string 分钟
    @Return      : 返回值说明
    @Output      :
    @Date        : 2024-08-25
*/
    function onSetMinText(text)
    {
        runTime.minText=text;
    }
    /*!
    @Function    : setRunnintTime(strValue)
    @Description : 设置运行时间
    @Author      : likun
    @Parameter   : strValue string 时间
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setRunnintTime(strValue){
        rightText.text = strValue
    }
}
