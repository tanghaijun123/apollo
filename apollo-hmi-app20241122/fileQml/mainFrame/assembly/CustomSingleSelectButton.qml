import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
/*! @File        : CustomSingleSelectButton.qml
 *  @Brief       : 自定义单选按钮
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle
{
    /*!
    @Function    : sendSelectIndex(int index)
    @Description : 发送选中索引
    @Author      : likun
    @Parameter   : index int 索引
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
    signal sendSelectIndex(int index);
    required property var leftTxt;
    required property var rightTxt;
    id:rectBack
    width:166
    height:64
    color: "#585858"
    radius: 4
    border.width: 1
    border.color: "#000000"
    ButtonGroup
    {
        id:btnGroup
        exclusive: true
    }

    RowLayout
    {
        id:rowLayout
        spacing: 14
        Button
        {
            id:leftBtn
            Layout.preferredWidth: 76
            Layout.preferredHeight: 56
            checkable:true
            checked:true
            ButtonGroup.group: btnGroup
            background: Rectangle
            {
                anchors.fill:parent
                color:"transparent"
            }
            Text {
                id: leftText
                anchors.fill: parent
                text: leftTxt
                font.family: "OPPOSans"
                font.weight: Font.Normal
                font.pixelSize: 26
                color: leftBtn.checked?"#FFFFFF":Qt.rgba(255,255,255,0.4)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked:
            {
                leftBtn.checked=true;
                rectBack.sendSelectIndex(0);
            }
        }
        Button
        {
            id:rightBtn
            Layout.preferredWidth: 76
            Layout.preferredHeight: 56
            checkable:true
            checked:false
            ButtonGroup.group: btnGroup
            background: Rectangle
            {
                anchors.fill:parent
                color:"transparent"
            }
            Text {
                id: rightText
                anchors.fill: parent
                text: rightTxt
                font.family: "OPPOSans"
                font.weight: Font.Normal
                font.pixelSize: 26
                color: rightBtn.checked ? "#FFFFFF" : Qt.rgba(255,255,255,0.4)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked:
            {
                rightBtn.checked=true;
                rectBack.sendSelectIndex(1);
            }
        }
    }
}
