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
    width: 874
    height: 52
    color:"#3D3D3D"

    Text {
        id: txtLeft
        text: "时间"
        font.family: "OPPOSans"
        font.weight: Font.Medium
        font.pixelSize: 20
        color:"#FFFFFF"
        opacity: 0.6
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle
    {
        id:line
        width: 1
        height: 20
        color:Qt.rgba(255,255,255,0.3)
        opacity: 0.8
        anchors.left: txtLeft.right
        anchors.leftMargin: 290
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: txtMiddle
        text: "操作描述"
        font.family: "OPPOSans"
        font.weight: Font.Medium
        font.pixelSize: 20
        color:"#FFFFFF"
        opacity: 0.6
        anchors.left: line.right
        anchors.leftMargin: 48
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle
    {
        id:line1
        width: 1
        height: 20
        color:Qt.rgba(255,255,255,0.3)
        opacity: 0.8
        anchors.left: txtMiddle.right
        anchors.leftMargin: 155
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: txtRight
        text: "参数"
        font.family: "OPPOSans"
        font.weight: Font.Medium
        font.pixelSize: 20
        color:"#FFFFFF"
        opacity: 0.6
        anchors.left: line1.right
        anchors.leftMargin: 76
        anchors.verticalCenter: parent.verticalCenter
    }

}
