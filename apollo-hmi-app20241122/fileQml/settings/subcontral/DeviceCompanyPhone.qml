import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

/*! @File        : DeviceCompanyPhone.qml
 *  @Brief       : 公司电话控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Item {
    property string companyPhone: "023-XXXXXXXX"
    id:itemCompanyPhone
//    width: 396
    height: 26
    RowLayout
    {
        id:rowCompanyPhone
        spacing: 0
        Text
        {
            id: constText
            text: "公司电话："
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 26
            color:"#FFFFFF"
            opacity: 0.6
        }
        Text
        {
            id: textCompanyPhone
            text: itemCompanyPhone.companyPhone
            font.family: "OPPOSans"
            font.weight: Font.Normal
            font.pixelSize: 26
            color:"#FFFFFF"
            opacity: 1
        }
        /*!
    @Function    : onSetCompanyPhone(phone)
    @Description : 设置公司电话
    @Author      : likun
    @Parameter   : phone string  电话
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
        function onSetCompanyPhone(phone)
        {
            itemCompanyPhone.companyPhone=phone;
        }
    }
}
