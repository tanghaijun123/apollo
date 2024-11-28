import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../subcontral"
import pollo.SettingDB 1.0

/*! @File        : DeviceInfoPage.qml
 *  @Brief       : 设备信息页面
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Rectangle {
    id:dvInfoPage
    width: 1120
    height: 432
    color:"#3D3D3D"
    Rectangle
    {
        id:rectInfo
        width:916
        height:240
        anchors.left: parent.left
        anchors.leftMargin: 56
        anchors.top: parent.top
        anchors.topMargin: 55
        color:"transparent"
        ColumnLayout
        {
            id:rowLayout
            spacing: 40
            DeviceName{id:deviceName}
            Item
            {
                id:bottomDeviceInfo
                width: 916
                GridLayout
                {
                    id:girdLayout
                    rowSpacing: 20
                    columnSpacing: 193
                    rows: 4
                    columns:2
                    DeviceModelName{id:deviceModelName}
                    DeviceCompanyName{id:deviceCompanyName}
                    DeviceSerialNumber{id:deviceSerialNumber}
                    DeviceCompanyPhone{id:deviceCompanyPhone}
                    DeviceMotherboardSoftwareVersion{id:deviceMotherboardSoftVersion;Layout.columnSpan: 2}
                    DeviceControlPanelSoftwareVersion{id:deviceControlSoftwareVersion;Layout.columnSpan: 2}
                    DevicePowerPanelSoftwareVersion{id:devicePowerSoftwareVersion;Layout.columnSpan: 2}
                }
            }
        }
    }

    SettingDB{
        id: setting
    }
    Component.onCompleted: {
        var nSN = setting.getIniValue("Sys/SerialNumber");
        if(nSN === ""){
            setting.setIniValue("Sys/SerialNumber", "");
        }
    }
}
