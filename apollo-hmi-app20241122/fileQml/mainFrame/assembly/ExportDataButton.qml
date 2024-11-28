import QtQuick 2.15
import QtQuick.Controls 2.5
/*! @File        : ExportDataButton.qml
 *  @Brief       : 系统设置 导出数据控件
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/

Rectangle
{
    id:exportDateRect
    width:168
    height:64
    color:"#008E73"
    radius: 4
    signal btnClick();
    Button
    {
        id:exportDateBtn
        background: Rectangle
        {
            anchors.fill:parent
            color:"transparent"
        }
        anchors.fill: parent
        Text {
            id: exportDateText
            anchors.fill:parent
            text: "导出数据"
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 24
            color:"#FFFFFF"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        onClicked: {
           btnClick();
        }
    }
}
