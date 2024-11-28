import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3


/*! @File        : TitleContral.qml
 *  @Brief       : 记录页面,标题栏
 *  @Author      : likun
 *  @Date        : 2024-08-21
 *  @Version     : v1.0
*/
Rectangle  {
    required property string textLeftContent;//标题左边的文字
    required property string textMiddleContent;//标题中间的文字
    required property string textRightContent;//标题右边的文字
    id:root
    width:838
    height:25
    color:"transparent"
    RowLayout
    {
        id:rootLay
        anchors.fill: parent
        spacing:0
        Rectangle
        {
            id:rectLeft
            width: 340
            height: root.height
            color:"transparent"
            Layout.alignment: Qt.AlignHCenter|Qt.AlignVCenter
            Text {
                id: textLeft
                text: root.textLeftContent
                color:"#FFFFFF"
                font.family: "OPPOSans"
                font.weight: Font.Medium
                font.pixelSize: 20
                opacity: 0.6
                anchors.left: parent.left
                anchors.leftMargin: 62
                verticalAlignment: Text.AlignVCenter
            }
        }
        Rectangle
        {
            id:oneLine
            width:1
            height:25
            color:Qt.rgba(255,255,255,0.3)
            opacity: 0.8
        }
        Rectangle
        {
            id:rectMiddle
            width: 228
            height: root.height
            color:"transparent"
            Text {
                id: textMiddle
                text: root.textMiddleContent
                color:"#FFFFFF"
                opacity: 0.6
                font.family: "OPPOSans"
                font.weight: Font.Medium
                font.pixelSize: 20
                anchors.left: parent.left
                anchors.leftMargin: 47
                verticalAlignment: Text.AlignVCenter
            }
        }
        Rectangle
        {
            id:twoLine
            width:1
            height:25
            color:Qt.rgba(255,255,255,0.3)
            opacity: 0.8
        }
        Rectangle
        {
            id:rectRight
            width: 268
            height: root.height
            color:"transparent"
            Text {
                id: textRight
                text: root.textRightContent
                color:"#FFFFFF"
                opacity: 0.6
                font.family: "OPPOSans"
                font.weight: Font.Medium
                font.pixelSize: 20
                anchors.left: parent.left
                anchors.leftMargin: 85
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

}
