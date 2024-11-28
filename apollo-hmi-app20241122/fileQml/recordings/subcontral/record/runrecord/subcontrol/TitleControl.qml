import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

/*! @File        : TitleControl.qml
 *  @Brief       : 标题控件
 *  @Author      : likun
 *  @Date        : 2024-08-21
 *  @Version     : v1.0
*/

Rectangle {
    id:root
    width: 1073
    height: 52
    color:"#3D3D3D"
    Rectangle
    {
        id:rectLeft
        width: 80
        height: 25
        color: "transparent"
        anchors.left: parent.left
        anchors.leftMargin: 80
        Text {
            id: txtLeft
            text: "启动时间"
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 20
            color:"#FFFFFF"
            opacity: 0.6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Rectangle
    {
        id:line
        width: 1
        height: 25
        color:Qt.rgba(255,255,255,0.3)
        opacity: 0.8
        anchors.left: rectLeft.right
        anchors.leftMargin: 250
    }
    Rectangle
    {
        id:rectRight
        width: 80
        height: 25
        color: "transparent"
        anchors.left: line.right
        anchors.leftMargin: 58
        Text {
            id: txtRight
            text: "运行时长"
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 20
            color:"#FFFFFF"
            opacity: 0.6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

}
