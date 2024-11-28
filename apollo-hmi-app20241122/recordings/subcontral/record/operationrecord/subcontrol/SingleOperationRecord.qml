import QtQuick 2.15
import QtQuick.Controls 2.5


//单条运行记录
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
        width: 410
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
            anchors.leftMargin: 80
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
            anchors.leftMargin: 48
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Rectangle
    {
        id:rightRect
        width: 428
        height: parent.height
        color:"transparent"
        anchors.left: leftRect.right
        anchors.verticalCenter: parent.verticalCenter
        Rectangle
        {
            id:rectSetType
            width: 229
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
            width:198
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




}
