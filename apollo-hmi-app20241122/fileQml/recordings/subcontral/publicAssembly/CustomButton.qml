import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
/*! @File        : CustomButton.qml
 *  @Brief       : 流量和转速自定义按钮
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/
Rectangle
{
    required property string textContent;
    property var buttonGroup: null
    property bool isChecked: false
    property bool isEnabled: true
    signal btnClick();
    id:rectCustonBtn
    width:144
    height:40
    radius: 4
    color:"transparent"
    Button
    {
        id:btnCuston
        anchors.fill: parent
        ButtonGroup.group: rectCustonBtn.buttonGroup
        background: Rectangle
        {
            color:rectCustonBtn.isChecked?"#187E6B":"#323232"//"#F1F1F1":"#333333"
            border.width:1
            border.color: isEnabled ? rectCustonBtn.isChecked?"#F1F1F1":Qt.rgba(255,255,255,0.2) : "transparent"
            radius: 4
        }
        checkable: true
        checked: rectCustonBtn.isChecked
        contentItem: Text {
            id: textBtn
            text: rectCustonBtn.textContent
            color:rectCustonBtn.isChecked?Qt.rgba(255,255,255,0.8):Qt.rgba(255,255,255,0.2)//"#000000":"#FFFFFF"
            font.family: "OPPOSans"
            font.weight: Font.Bold
            font.pixelSize: 24
            opacity: rectCustonBtn.isChecked?1:0.8
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked:
        {
            rectCustonBtn.btnClick();
        }
    }
}



