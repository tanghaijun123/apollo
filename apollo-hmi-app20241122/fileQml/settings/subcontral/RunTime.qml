import QtQuick 2.15
import QtQuick.Controls 2.5

Rectangle {
    property string  hourText: "-"
    property string  minText: "-"
    id:runTime
    width: 342
    height:74
    color:"#3F3F3F"
    Row
    {
        height: 46
        anchors.top: parent.top
        anchors.topMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 16
        spacing: 10
        Rectangle
        {
            id:left
            width:140
            height: 46
            color:"transparent"

            Text {
                id: leftText
                text: "已连续运行"
                anchors.verticalCenter: parent.verticalCenter
                opacity: 0.7
                font.family: "OPPOSans"
                font.weight: Font.Normal
                color:"#FFFFFF"
                font.pixelSize: 28
            }
        }
        Rectangle
        {
            id:right
            width: 160
            height: 46
            color: "#000000"
            Text {
                id: rightText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                text: hourText + "h" + minText + "min"
                font.family: "Quicksand"
                font.weight: Font.DemiBold
                opacity: 0.9
                color:"#FFFFFF"
                font.pixelSize: 30
            }
        }
    }


}
