import QtQuick 2.15
import QtQuick.Layouts 1.3
/*! @File        : CustomDateTime.qml
 *  @Brief       : 自定义日期控件
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle {

    width:155
    height:64
    color:"transparent"
    //color:"yellow"
    Timer
    {
        id:timer
        interval: 1000
        running: true
        repeat: true
        onTriggered:
        {
            var currentdate=new Date();
            customTimeText.text=currentdate.toLocaleTimeString(Qt.locale("zh_CN"),"HH:mm:ss");
            customDateText.text=currentdate.toLocaleDateString(Qt.locale("zh_CN"),"yyyy/MM/dd");
        }
    }

    //anchors.centerIn:parent
    //spacing: 8

    Rectangle {
        id: customTime
        height:28
        width: parent.width
        //Layout.alignment: Qt.AlignRight | Qt.AlignTop
        //Layout.rightMargin: 72
        color:"transparent"
        //color:  "red"
        Text {
            id: customTimeText
            text: "loading"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Medium
            font.family: "Quicksand"
            font.pixelSize: 28
            color:"#FFFFFF"
        }
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 16

    }
    Rectangle {
        id: customDate
        height:28
        width: parent.width
        Layout.alignment: Qt.AlignRight | Qt.AlignTop
        Layout.rightMargin: 155
        color:"transparent"
        Text {
            id: customDateText
            text: "loading"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            font.weight: Font.Normal
            font.family: "Quicksand"
            font.pixelSize: 28
            color:Qt.rgba(255,255,255,0.8)
        }
        anchors.top: customTime.bottom
        anchors.topMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 16
    }
    Component.onCompleted:
    {
        timer.start();
    }


}
