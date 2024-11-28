import QtQuick 2.15
import QtQuick.Controls 2.5

/*! @File        : DeviceName.qml
 *  @Brief       : 设备名称控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Item
{
    property string deviceName: "永仁心体外心室辅助系统"
    id: itemDeviceName
    height: 36
    Text
    {
        id: textDeviceName
        text: itemDeviceName.deviceName
        font.family: "OPPOSans"
        font.weight: Font.Bold
        font.pixelSize: 36
        color: "#FFFFFF"
    }
    /*!
    @Function    : onSetDeviceName(name)
    @Description : 设置设备名称
    @Author      : likun
    @Parameter   : name  string  名称
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
    function onSetDeviceName(name)
    {
        itemDeviceName.deviceName=name;
    }
}
