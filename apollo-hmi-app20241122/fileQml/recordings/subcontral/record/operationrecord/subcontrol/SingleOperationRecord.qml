import QtQuick 2.15
import QtQuick.Controls 2.5

/*! @File        : SingleOperationRecord.qml
 *  @Brief       : 单条运行记录
 *  @Author      : likun
 *  @Date        : 2024-08-21
 *  @Version     : v1.0
*/

Rectangle {
    required property string textDate; //日期数据
    required property string textTime; //时间数据
    required property string setType;//调整类型数据
    required property string parameterData;//参数数据
    id:root
    width: 838
    height: 44
    color:"#2C2C2C"
    Rectangle
    {
        id:leftRect
        width: 330
        height: parent.height
        color:"transparent"
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        Text {
            id: txtDate
            text: root.textDate
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 24
            color:"#FFFFFF"
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            id: txtTime
            text: root.textTime
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 24
            color:"#FFFFFF"
            anchors.left: txtDate.right
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Rectangle
    {
        id:rightRect
        width: 508
        height: parent.height
        color:"transparent"
        anchors.left: leftRect.right
        anchors.verticalCenter: parent.verticalCenter
        Rectangle
        {
            id:rectSetType
            width: 320
            height: parent.height
            color: "transparent"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            Text {
                id: txtSetType
                text: root.setType
                font.family: "OPPOSans"
                font.weight: Font.Medium
                font.pixelSize: 24
                color:"#FFFFFF"
                anchors.left: parent.left
                anchors.leftMargin: 48
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle
        {
            id:rectParameter
            width:188
            height: parent.height
            color:"transparent"
            anchors.left: rectSetType.right
            anchors.verticalCenter: parent.verticalCenter
            Text {
                id: txtParameterData
                text: root.parameterData
                font.family: "OPPOSans"
                font.weight: Font.Medium
                font.pixelSize: 24
                color:"#FFFFFF"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
//    function changePixSize()
//    {
//        if(setType.length>10||parameterData.length>10)
//        {
//            txtDate.font.pixelSize=18;
//            txtTime.font.pixelSize=18;
//            txtSetType.font.pixelSize=18;
//            txtParameterData.font.pixelSize=18;
//        }
//    }
}
