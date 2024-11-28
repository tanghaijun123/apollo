import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

/*! @File        : DeviceModelName.qml
 *  @Brief       : 设备型号控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/
Item {
    property string modelName: "AP360"
    id:itemModelName
    width: 396
    height: 26
    RowLayout
    {
        id:rowModelName
        spacing: 0
        Text
        {
            id: constText
            text: "型号："
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 26
            color:"#FFFFFF"
            opacity: 0.6
        }
        Text
        {
            id: textModelName
            text: itemModelName.modelName
            font.family: "OPPOSans"
            font.weight: Font.Normal
            font.pixelSize: 26
            color:"#FFFFFF"
            opacity: 1
        }
        /*!
    @Function    : onSetModelName(name)
    @Description : 设置设备型号
    @Author      : likun
    @Parameter   : name  string  设备型号
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
        function onSetModelName(name)
        {
            itemModelName.modelName=name;
        }
    }
}
