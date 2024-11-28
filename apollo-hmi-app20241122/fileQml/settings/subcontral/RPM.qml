import QtQuick 2.15
import QtQuick.Controls 2.5

Rectangle {
    property string rmpNumContent: "--"
    id:rmpItem
    width: 282+10+101
    height: 120
    color:"transparent"
    Row
    {
        anchors.fill: parent
        spacing: 10
        Rectangle
        {
            id:left
            width: 282
            height:120
            color:"transparent"
            Text {
                id: rmpNum
                anchors.fill: parent
                text:rmpNumContent
                color:"#FFFFFF"
                font.family: "Quicksand"
                font.weight: Font.Medium
                font.pixelSize: 120
            }
        }
        Rectangle
        {
            id:right
            width: 101
            height: 120
            color: "transparent"
            Column
            {
                anchors.fill: parent
                spacing: 2
                Rectangle
                {
                    id:rightTop
                    width: 101
                    height: 82
                    color:"transparent"
                }
                Rectangle
                {
                    id:rightBottom
                    width: 101
                    height: 38
                    color:"transparent"
                    Text {
                        id: rmpDw
                        anchors.fill: parent
                        text: "RPM"
                        opacity: 0.6
                        font.family: "Quicksand"
                        font.weight: Font.Medium
                        font.pixelSize: 48
                        color:"#FFFFFF"
                    }
                }
            }
        }
    }
}
