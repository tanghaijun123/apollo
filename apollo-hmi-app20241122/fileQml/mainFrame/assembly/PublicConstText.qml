import QtQuick 2.15
import QtQuick.Controls 2.5

/*! @File        : PublicConstText.qml
 *  @Brief       : 公共文本控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Text {
    required property string textContent;
    property int fontWeight: Font.Normal
    id: root
    text: root.textContent
    color:"#FFFFFF"
    font.family: "OPPOSans"
    font.weight: root.fontWeight
    font.pixelSize: 26
}
