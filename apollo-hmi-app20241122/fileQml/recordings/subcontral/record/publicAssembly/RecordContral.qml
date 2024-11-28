import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.1

/*! @File        : RecordContral.qml
 *  @Brief       : 记录页面,运行记录和操作记录,共用记录控件
 *  @Author      : likun
 *  @Date        : 2024-08-21
 *  @Version     : v1.0
*/
Rectangle {
    required property string textDateContent;//左边日期
    required property string textTimeContent;//左边时间
    required property string textMiddleContent;//中间内容
    required property string textRightContent;//右边内容
    id:root
    width: 838
    height: 44
    color:"#2C2C2C"
    RowLayout
    {
        id:layout
        spacing: 0
        anchors.fill:parent
        Rectangle
        {
            id:rectLeft
            width: 340
            height: root.height
            color:"transparent"
            Layout.alignment: Qt.AlignLeft|Qt.AlignVCenter
            RowLayout
            {
                id:dateTimeLayout
                anchors.fill:parent
                spacing: 9
                Rectangle
                {
                    id:rectDate
                    width: 135
                    height: 24
                    color:"transparent"
                    Layout.leftMargin: 62
                    Text
                    {
                        id: textDate
                        text: root.textDateContent
                        color:"#FFFFFF"
                        font.family: "OPPOSans"
                        font.weight: Font.Medium
                        font.pixelSize: 24
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                Rectangle
                {
                    id:rectTime
                    width: 100
                    height: 24
                    color:"transparent"
                    Layout.rightMargin: 24
                    Text
                    {
                        id: textTime
                        text: root.textTimeContent
                        color:"#FFFFFF"
                        font.family: "OPPOSans"
                        font.weight: Font.Medium
                        font.pixelSize: 24
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
        Rectangle
        {
            id:rectMiddle
            width:228
            height: root.height
            color:"transparent"
            Layout.alignment: Qt.AlignLeft
            Text
            {
                id:textMiddle
                text:root.textMiddleContent
                color:"#FFFFFF"
                font.family: "OPPOSans"
                font.weight: Font.Medium
                font.pixelSize: 24
                anchors.fill: parent
                anchors.left: rectMiddle.left
                anchors.leftMargin: 47
                verticalAlignment: Text.AlignVCenter
            }
        }
        Rectangle
        {
            id:rectRight
            width:268
            height: root.height
            color:"transparent"
            Text {
                id: textRight
                text: root.textRightContent
                color:"#FFFFFF"
                font.family: "OPPOSans"
                font.weight: Font.Medium
                font.pixelSize: 24
                anchors.fill: parent
                anchors.left: parent.left
                anchors.leftMargin: 85
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
