import QtQuick 2.15
import QtQuick.Controls 2.5

/*! @File        : SingleRunRecord.qml
 *  @Brief       : 单条运行记录
 *  @Author      : likun
 *  @Date        : 2024-08-21
 *  @Version     : v1.0
*/

Rectangle {
    required property string textDate; //"2023/12/07" //日期数据
    required property string textTime; //"15:00:00"   //时间数据
    required property string textDuration;// "2.26"   //时长数据
    required property int index;
    id:root
    width: 1040
    height: 44
    color:"#2C2C2C"
    Rectangle
    {
        id:rectDate
        width: 135
        height: parent.height
        color: "transparent"
        anchors.left: parent.left
        anchors.leftMargin: 80
        Text {
            id: txtDate
            text: root.textDate
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 24
            color:"#FFFFFF"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Rectangle
    {
        id:rectTime
        width: 100
        height: parent.height
        color:"transparent"
        anchors.left: rectDate.right
        anchors.leftMargin: 48
        Text {
            id: txtTime
            text: root.textTime
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 24
            color:"#FFFFFF"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Rectangle
    {
        id:rectDuration
        width: 581
        height: parent.height
        anchors.left: rectTime.right
        anchors.leftMargin: 110
        color: "transparent"
        Text {
            id: txtDuration
            text: root.textDuration
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 24
            color:"#FFFFFF"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    /*!
    @Function    : getData()
    @Description : 获取数据
    @Author      : likun
    @Parameter   :
    @Return      : {"textDate":textDate 日期数据,"textTime":textTime 时间数据,"textDuration":textDuration  时长数据}
    @Output      :
    @Date        : 2024-08-21
*/
    function getData()
    {
        return {"textDate":textDate,"textTime":textTime,"textDuration":textDuration};
    }
}
