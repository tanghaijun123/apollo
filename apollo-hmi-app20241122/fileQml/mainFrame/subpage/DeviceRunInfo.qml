import QtQuick 2.15
import QtQuick.Controls 2.5
import "../subcontral"
/*! @File        : DeviceRunInfo.qml
 *  @Brief       : 设备信息
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle {
    id:deviceRunInfo
    width: 1280
    height: 189//196
    color:"#141515"
    L_Min
    {
        id:l_min
        anchors.right: runTime.left
        anchors.rightMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 32
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
       // textLMinNumContent: mainWindow.bShowRealFlowValue ? mainWindow.strFlowValue : "- -"
    }
    RunTime
    {
        id:runTime
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 55
    }
    RPM
    {
        id: showSpeed
        anchors.left: runTime.right
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 32
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
    }

    Connections{
        target: mainWindow
        function onSpeedValueChanged(strValue){
            showSpeed.updateSpeed(strValue);
        }

        function onStrMotorSpeedValueChanged(){
            showSpeed.updateSpeed(bShowMotorSpeedValue ? strMotorSpeedValue : "- -");
        }

        function onBShowMotorSpeedValueChanged(){
            showSpeed.updateSpeed(bShowMotorSpeedValue ? strMotorSpeedValue : "- -");
        }

        function onFlowValueChanged(strValue){
            l_min.onSetTextLMinNumContent(strValue);
        }
        function onBShowRealFlowValueChanged(){
            l_min.onSetTextLMinNumContent(mainWindow.bShowRealFlowValue ? mainWindow.strFlowValue : "- -");
        }

        function onStrFlowValueChanged(){
            l_min.onSetTextLMinNumContent(mainWindow.bShowRealFlowValue ? mainWindow.strFlowValue : "- -");
        }

        function onRunningTimes(strValue){
            runTime.setRunnintTime(strValue)
        }
    }
}
