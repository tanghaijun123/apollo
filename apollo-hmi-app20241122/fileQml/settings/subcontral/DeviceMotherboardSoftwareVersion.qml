import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

/*! @File        : DeviceMotherboardSoftwareVersion.qml
 *  @Brief       : 主板软件版本控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Item {
    property string softwareVersion: "V1.0.0."
    id:itemSoftwareVersion
    height: 26
    RowLayout
    {
        id:rowSoftwareVersion
        spacing: 0
        Text
        {
            id: constText
            text: "主板软件发布版本："
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 26
            color:"#FFFFFF"
            opacity: 0.6
        }
        Text
        {
            id: textSoftwareVersion
            font.family: "OPPOSans"
            font.weight: Font.Normal
            font.pixelSize: 26
            color:"#FFFFFF"
            opacity: 1
        }
        /*!
    @Function    : onSetSoftwareVersion(version)
    @Description : 设置版本
    @Author      : likun
    @Parameter   : version string  版本号
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
        function onSetSoftwareVersion(version)
        {
            itemSoftwareVersion.softwareVersion=version;
        }
        Component.onCompleted: {
            textSoftwareVersion.text = "V1.0"+"(完整版本"+itemSoftwareVersion.softwareVersion+m_appInfo.appVersion()+")";
        }
    }
}
