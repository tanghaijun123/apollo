import QtQuick 2.15
import QtQuick.Controls 2.5
import "../subcontral"
Rectangle {
    id:deviceRunInfo
    width: 1280
    height: 196
    color:"#141515"
    L_Min
    {
        id:l_min
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 32
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        textLMinNumContent:strFlowValue
    }
    RunTime
    {
        id:runTime
        anchors.left: l_min.right
        anchors.leftMargin: 73
        anchors.top: parent.top
        anchors.topMargin: 55
    }
    RPM
    {
        anchors.left: runTime.right
        anchors.leftMargin: 50
        rmpNumContent:strMotorSpeedValue
//        anchors.top: deviceRunInfo.top
//        anchors.topMargin: 2
//        anchors.bottom: deviceRunInfo.bottom
//        anchors.bottomMargin: 32
    }
}
