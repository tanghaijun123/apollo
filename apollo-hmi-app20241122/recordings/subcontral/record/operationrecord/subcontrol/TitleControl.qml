import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

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
        anchors.leftMargin: 80
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 18
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
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 18
    }

    Text {
        id: txtMiddle
        text: "调整类型"
        font.family: "OPPOSans"
        font.weight: Font.Medium
        font.pixelSize: 20
        color:"#FFFFFF"
        opacity: 0.6
        anchors.left: line.right
        anchors.leftMargin: 48
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 18
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
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 18
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
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 18
    }

}
