import QtQuick 2.15
import QtQuick.Controls 2.5

/*! @File        : SingleWord.qml
 *  @Brief       : 系统设置页面 单独  字控件
 *  @Author      : likun
 *  @Date        : 2024-08-14
 *  @Version     : v1.0
*/

Text
{
    required property var contentText;
    id: txtWord
    text: contentText
    font.family: "OPPOSans"
    font.weight: Font.Normal
    font.pixelSize: 26
    color:"#FFFFFF"
}
