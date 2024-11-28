import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    property string textLMinNumContent: "--"
    id:rectLMin
    width: 362
    height: 120
    color:"transparent"
    Row
    {
        anchors.fill: parent
        spacing:10
        Rectangle
        {
            id:rectLMinNum
            width: 221
            height: 120
            color:"transparent"
//            anchors.left: rectLMin.left
//            anchors.verticalCenter: rectLMin.verticalCenter
            Text {
                id: textLMinNum
                anchors.fill: parent
                text:textLMinNumContent
                //text: textLMinNumContent
                font.family: "Quicksand"
                font.weight: Font.DemiBold
                color:"#FFFFFF"
                font.pixelSize: 116
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
        Rectangle
        {
            id:rightrect
            width:131
            height: 120
            color:"transparent"
            Column
            {
                anchors.fill: parent
                spacing: 0
                Rectangle
                {
                    id:rightTopRect
                    width: 131
                    height: 60
                    color:"transparent"
                }
                Rectangle
                {
                    id:rectLMinUnit
                    width: 131
                    height: 60
                    color:"transparent"
                    Text {
                        id: textLMinUnit
                        anchors.fill: parent
                        text: "LPM"
                        opacity: 0.6
                        color:"#FFFFFF"
                        font.family: "Quicksand"
                        font.weight: Font.Medium
                        font.pixelSize: 48
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }




    }
}
