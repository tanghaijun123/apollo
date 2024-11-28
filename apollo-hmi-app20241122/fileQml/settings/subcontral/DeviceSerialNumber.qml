import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

/*! @File        : DeviceSerialNumber.qml
 *  @Brief       : 序列号控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/
Item {
    property string serialNumber: "20231207001"
    id:itemSerialNumber
    width: 396
    height: 26
    RowLayout
    {
        id:rowSerialNumber
        spacing: 0
        Text
        {
            id: constText
            text: "序列号："
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 26
            color:"#FFFFFF"
            opacity: 0.6
        }
        Text
        {
            id: textSerialNumber
            text: serialNumber
            font.family: "OPPOSans"
            font.weight: Font.Normal
            font.pixelSize: 26
            color:"#FFFFFF"
            opacity: 1
        }
        /*!
    @Function    : onSetSerialNumber(number)
    @Description : 设置序列化
    @Author      : likun
    @Parameter   : number string  序列号
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
        function onSetSerialNumber(number)
        {
            itemSerialNumber.serialNumber=number;
        }
    }
}
