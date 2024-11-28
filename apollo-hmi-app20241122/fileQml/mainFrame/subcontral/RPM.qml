import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3


/*! @File        : RPM.qml
 *  @Brief       : 设备运行信息页面  RPM控件
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle {
    property string rmpNumContent: globalMaxMotorSpeed
    id:rmpItem
    width: 282+10+101
    height: 120
    color:"transparent"
    RowLayout
    {
        anchors.fill: parent
        spacing: 10
        Rectangle
        {
            id:left
            width: 282
            height:120
            color:"transparent"
            Text {
                id: rmpNum
                anchors.fill: parent
                text: mainWindow.bShowMotorSpeedValue ? mainWindow.strMotorSpeedValue : "- -"
                color:mainWindow.bShowMotorSpeedValue ? ( (mainWindow.strMotorSpeedValue < settingParam_MotorMin ||  mainWindow.strMotorSpeedValue > settingParam_MotorMax) ? "#F43434": "#FFFFFF") : "#FFFFFF"
                font.family: "Quicksand"
                font.weight: Font.DemiBold
                font.pixelSize: 116
                horizontalAlignment: rmpNum.text==="- -" ?Text.AlignHCenter:Text.AlignRight
                verticalAlignment: Text.AlignVCenter
            }
        }
        Rectangle
        {
            id:right
            width: 101
            height: 120
            color: "transparent"
            ColumnLayout
            {
                anchors.fill: parent
                spacing: 0
                Rectangle
                {
                    id:rightTop
                    width: 101
                    height: 60
                    color:"transparent"
                }
                Rectangle
                {
                    id:rightBottom
                    width: 101
                    height: 60
                    color:"transparent"
                    Text {
                        id: rmpDw
                        anchors.fill: parent
                        text: "RPM"
                        opacity: 0.6
                        font.family: "Quicksand"
                        font.weight: Font.Medium
                        font.pixelSize: 48
                        color:"#FFFFFF"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
    /*!
    @Function    : updateSpeed(nSpeed)
    @Description : 更新转速
    @Author      : likun
    @Parameter   : nSpeed int 转速
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function updateSpeed(nSpeed){
        rmpNumContent = nSpeed;
        rmpNum.text = rmpNumContent;
    }
}
