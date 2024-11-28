/******************************************************************************/
/*! @File        : MainFlowShow.qml
 *  @Brief       : 简要说明
 *  @Details     : 详细说明
 *  @Author      : han
 *  @Date        : 2024-08-13
 *  @Version     : v1.0
 *  @Copyright   : Copyright By yongrenxing, All Rights Reserved
 *
 **********************************************************
 *
 *  @Attention   :流量显示
 *  @par 修改日志:
 *  <table>
 *  <tr><th>Date       <th>Version   <th>Author    <th>Description
 *  <tr><td>2024-08-13 <td>1.0       <td>xxx     <td>创建初始版本
 *  </table>
 *
 **********************************************************
*/

import QtQuick 2.15
import QtQuick.Window 2.12
import QtQuick.Controls 2.4
import Qt.labs.settings 1.1
import QtQuick.Dialogs 1.3
import QtQuick.Controls.Styles 1.4

Item {
    id: mainFlowShow
    width: 500
    height: 550


    property int icurMargin: 10
    property string strHighLightFontColor: Qt.rgba(255/255, 255/255, 255/255, 1)// "#282828"
    property string strLowLightFontColor: Qt.rgba(190/255, 190/255, 190/255, 1)// "#282828"
    property string strDigitalOrAsciiFont: "Quicksand"
    property string strTxtFont: "OPPOSans"
    property int iToolbarHeigh: 100
    property real rFlowRangMin: 2.4
    property real rFlowRangMax: 4.5
    Rectangle {
        property string strRectColor: Qt.rgba(40/255, 40/255, 40/255, 1)// "#282828"
        property string strBorderColor: Qt.rgba(40/255, 40/255, 40/255, 1)// "#282828"
        id: rtRunTime
        x: 90
        y: 141 - iToolbarHeigh
        width: 342
        height: 74
        color: "#272727"
        radius: 4
        border.width: 1
        border.color: "#3F3F3F"
        //已连续运行速度位置
        Text {
            id: txtrunTimeCaption
            x: 106
            y: 159.5 - iToolbarHeigh
            width: 140
            height: 37
            opacity: 0.7
            text: qsTr("已连续运行")
            font.family: strTxtFont
            font.weight: Font.Light
            font.pixelSize: 28
            color: "#FFFFFF"
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.top: parent.top
            anchors.topMargin: 19
        }
        //开启开始任务运行时间
        Rectangle {
            id: rcShowRunTime 
            width: 160
            height: 46
            radius: 2
            color: "#000000"
            opacity: 1
            anchors.left: parent.left
            anchors.leftMargin: 166
            anchors.top: parent.top
            anchors.topMargin: 14

            Text {
                id: txtRunTime  
                text: qsTr("10h52min")
                opacity: 0.9
                font.family: strDigitalOrAsciiFont
                font.pixelSize: 30
                font.weight: Font.Bold
                //font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#FFFFFF"
            }

        }
    }
    property int iValueVerticalMargin: 60
    property int iFlowVerticalMargin: 1
    //流量提示
    Text {
        id: txtflowCaption
        //: 230
        y: 300 - iToolbarHeigh
        text: "流量"
        font.family: strTxtFont
        font.pixelSize: 30
        font.weight: Font.Medium
        color: "#FFFFFF"
        anchors.horizontalCenter: rtRunTime.horizontalCenter
    }

    //主界面流量显示
    Text {
        id: txtFlowValue        
        //y: 336 - iToolbarHeigh
        text:  mainWindow.bShowRealFlowValue ? mainWindow.strFlowValue : "- -"
        color: mainWindow.bShowRealFlowValue ? ( (mainWindow.strFlowValue < settingParam_FlowMin ||  mainWindow.strFlowValue > settingParam_FlowMax) ? "#F43434": "#FFFFFF") : "#FFFFFF"
        font.family: strDigitalOrAsciiFont
        font.pixelSize: 150
        font.weight: Font.DemiBold
        anchors.horizontalCenter: rtRunTime.horizontalCenter
        anchors.top: txtflowCaption.bottom
    }

    //主界面流量单位
    Text {
        id: txtFlowUnit
        //y: 482 - iToolbarHeigh
        opacity: 0.6
        text: qsTr("LPM")
        font.family: strDigitalOrAsciiFont
        font.pixelSize: 36
        font.weight: Font.Medium
        color: "#FFFFFF"
        anchors.horizontalCenter: rtRunTime.horizontalCenter
        anchors.top: txtFlowValue.bottom
    }

    //更新当前的流量显示
    function showFlowValue(strValue){
        txtFlowValue.text = strValue

        mainWindow.flowValueChanged(strValue);
    }

    //更新任务运行时间
    function showRunningTime(strValue){
        txtRunTime.text = strValue
        mainWindow.runningTimes(strValue);
    }
}
