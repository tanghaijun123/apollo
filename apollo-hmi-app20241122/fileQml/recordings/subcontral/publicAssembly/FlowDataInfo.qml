import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

/*! @File        : FlowDataInfo.qml
 *  @Brief       : 当前运行,流量选中, 数据控件
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/

Rectangle {
    required property string staticText;
    required property string flowData;
    id:rectFlowData
    width: 168
    height: 88
    color:"transparent"
    ColumnLayout
    {
        id:colLayoutFlowData
        spacing: 12
        anchors.fill: parent
        Text {
            id: constText
            text: rectFlowData.staticText
            color:"#FFFFFF"
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 22
            Layout.alignment: Qt.AlignLeft|Qt.AlignVCenter
        }
        Rectangle
        {
            id:rectData
            width: 168
            height: 56
            color:"#333333"
            RowLayout
            {
                id:rowLayoutData
                spacing: 14
                anchors.fill: parent
                Rectangle
                {
                    id:rect1
                    width: 85
                    height: parent.height
                    color: "transparent"
                    Layout.leftMargin: 12
                    Layout.alignment: Qt.AlignLeft
                    Text
                    {
                        id: textFlowData
                        text: rectFlowData.flowData
                        anchors.fill:parent
                        color:"#FFFFFF"
                        font.family: "OPPOSans"
                        font.weight: Font.Bold
                        font.pixelSize: 32
                        verticalAlignment: Text.AlignVCenter                        
                    }
                }
                Rectangle
                {
                    id:rect2
                    width: 45
                    height: parent.height
                    color:"transparent"
//                    border.color: "#FFFFFF"
//                    border.width: 1                    
                    Layout.rightMargin: 0/*12*/
                    Text
                    {
                        id: textDW
                        text: "LPM"
                        color:"#FFFFFF"
                        font.family: "OPPOSans"
                        font.weight: Font.Medium
                        font.pixelSize: 20
                        opacity: 0.6
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 12
                    }
                }
            }
        }
    }
}
