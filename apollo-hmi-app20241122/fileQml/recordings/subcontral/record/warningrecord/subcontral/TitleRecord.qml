import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

/*! @File        : TitleRecord.qml
 *  @Brief       : 报警设置页面,标题栏控件
 *  @Author      : likun
 *  @Date        : 2024-08-22
 *  @Version     : v1.0
*/

Rectangle
{
    required property string textLeftContent;
    required property string textRightContent;
    id:root
    width: 838
    height: 55
    color:"#3D3D3D"
    Text {
        id: textLeft
        text: root.textLeftContent
        color:"#FFFFFF"
        opacity: 0.6
        font.family: "OPPOSans"
        font.weight: Font.Medium
        font.pixelSize: 20
        anchors.left: parent.left
        anchors.leftMargin: 32
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 17
    }
    Rectangle
    {
        id:line
        width: 1
        height: 25
        color:Qt.rgba(255,255,255,0.3)
        opacity: 0.8
        anchors.left: textLeft.right
        anchors.leftMargin: 255
        anchors.verticalCenter: parent.verticalCenter
    }
    Text {
        id: textRight
        text: root.textRightContent
        color:"#FFFFFF"
        opacity: 0.6
        font.family: "OPPOSans"
        font.weight: Font.Medium
        font.pixelSize: 20
        anchors.left: line.right
        anchors.leftMargin: 68
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 17
    }


}
