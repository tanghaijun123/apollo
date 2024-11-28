import QtQuick 2.15
import QtQuick.Controls 2.5

Rectangle
{
    id:exportDateRect
    width:180
    height:64
    color:"#008E73"
    radius: 4
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
    }
}
