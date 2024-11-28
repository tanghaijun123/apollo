import QtQuick 2.15
import QtQuick.Controls 2.5

/*! @File        : SerialNumber.qml
 *  @Brief       : 报警序号
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle
{
    property  bool serialNumberVisible: false //序号是否可见
    required property string  serialNumberTextContent;// "2"//序号具体数字
    id:serial_number
    width:46
    height: 46
    radius: 46
    visible: serialNumberVisible
    color:Qt.rgba(255,255,255,0.6)
    Text {
        id: serial_number_text
        anchors.centerIn: parent
        text: serialNumberTextContent
        color: "#E33543"
        font.pixelSize: 32
        font.family: "OPPOSans"
        font.weight: Font.ExtraBold
    }
}
