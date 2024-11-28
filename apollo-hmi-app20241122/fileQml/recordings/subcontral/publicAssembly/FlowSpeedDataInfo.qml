import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3


/*! @File        : FlowSpeedDataInfo.qml
 *  @Brief       : 当前运行页面,流量转速,显示数据控件
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/
Rectangle {
    required property string staticText;//静态文本内容
    required property string flowSpeedData;//流量转速数据
    id:rectFlowSpeedDataInfo
    width: 168
    height: 40
    color:"transparent"
    RowLayout
    {
        id:layoutFlowSpeed
        anchors.fill: parent
        spacing: 8
        Rectangle//静态文本虚拟方块
        {
            id:rectConstText
            width: 80
            height: 40
            color:"transparent"
 //           Layout.alignment:Qt.AlignHCenter
            Text
            {//显示静态文本内容
                id: constText
                text: rectFlowSpeedDataInfo.staticText
                color:"#FFFFFF"
                anchors.fill: parent
                font.family: "OPPOSans"
                font.weight: Font.Medium
                font.pixelSize: 20
//                Layout.alignment: Qt.AlignVCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        Rectangle//流量转速数据框
        {
            id:rectFlowSpeedData
            width:80
            height:40
            color:"#333333"
 //           Layout.alignment:Qt.AlignHCenter
            Text {//流量转速数据内容
                id: textFlowSpeedData
                text: rectFlowSpeedDataInfo.flowSpeedData
                anchors.fill: parent
                color: "#FFFFFF"
                font.family: "OPPOSans"
                font.weight: Font.Medium
                font.pixelSize: 24
//                lineHeight: 20
//                Layout.leftMargin: 12
//                Layout.topMargin: 10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                anchors.right: parent.right
                anchors.rightMargin: 12
            }
        }


    }

}
