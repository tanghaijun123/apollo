import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

/*! @File        : DeviceCompanyName.qml
 *  @Brief       : 公司名称控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Item {
    property string companyName: "永仁心医疗"
    id:itemCompanyName
//    width: 396
    height: 26
    RowLayout
    {
        id:rowCompanyName
        spacing: 0
        Text
        {
            id: constText
            text: "公司名称："
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 26
            color:"#FFFFFF"
            opacity: 0.6
        }
        Text
        {
            id: textCompanyName
            text: itemCompanyName.companyName
            font.family: "OPPOSans"
            font.weight: Font.Normal
            font.pixelSize: 26
            color:"#FFFFFF"
            opacity: 1
        }
        /*!
    @Function    : onSetCompanyName(name)
    @Description : 设置公司名称
    @Author      : likun
    @Parameter   : name  string  公司名称
    @Return      : 返回值说明
    @Output      :
    @Date        : 2024-08-18
*/
        function onSetCompanyName(name)
        {
            itemCompanyName.companyName=name;
        }
    }
}
