import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

/*! @File        : DevicePowerPanelSoftwareVersion.qml
 *  @Brief       : 控制板软件版本控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Item {
    property string powerSoftwareVersion: "V01.15.0"
    id:itemPowerSoftwareVersion
    height: 26
    RowLayout
    {
        id:rowPowerSoftwareVersion
        spacing: 0
        Text
        {
            id: constText
            text: "电源板软件发布版本："
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 26
            color:"#FFFFFF"
            opacity: 0.6
        }
        Text
        {
            id: textPowerSoftwareVersion
            text: itemPowerSoftwareVersion.powerSoftwareVersion
            font.family: "OPPOSans"
            font.weight: Font.Normal
            font.pixelSize: 26
            color:"#FFFFFF"
            opacity: 1
        }
        /*!
            @Function    : onSetPowerSoftwareVersion(version)
            @Description : 设置版本号
            @Author      : likun
            @Parameter   : version string 版本号
            @Return      :
            @Output      :
            @Date        : 2024-08-18
        */
        function onSetPowerSoftwareVersion(version)
        {
            itemPowerSoftwareVersion.powerSoftwareVersion=version;
        }
    }

    onVisibleChanged: {
        if(visible) {
            itemPowerSoftwareVersion.powerSoftwareVersion=m_power.firmwareVersion();;
        }
    }
}
