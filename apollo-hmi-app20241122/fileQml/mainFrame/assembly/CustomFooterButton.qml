import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

//主页面  footer使用的 导航按钮
Rectangle
{
    required property string btnImgSource;//按钮图片
    required property string textFooterButtonContent;//按钮文字
    required property int  imgLeftMargin; //图片左边边距
    required property int textRightMargin;//文字右边边距
    required  property  int  index;//按钮点击后,发送索引
    required property var buttonGroup;
    property bool isChecked: false
//    property bool isVisible: false;
    signal sendPageIndex(int index);
    id:rectFooterButton
    width: 316
    height: 81
    color: "transparent"
    radius: 4
    ColumnLayout
    {
        id:colLayout
        spacing:-2
        Rectangle
        {
            id:rectTop
            Layout.preferredWidth :60
            Layout.preferredHeight : 5
            radius:4
            visible: btnFooterButton.checked?true:false
            color:"#D2D2D2"
            Layout.alignment: Qt.AlignHCenter
        }
        Button
        {
            id:btnFooterButton
            Layout.preferredWidth : 316
            Layout.preferredHeight :76
            ButtonGroup.group: rectFooterButton.buttonGroup
            checkable:true
            checked:rectFooterButton.isChecked
            background:Rectangle
            {
//                implicitWidth:parent.width
//                implicitHeight:parent.height
                anchors.fill:parent
                color:btnFooterButton.checked?"#2F645A":"#333333"
                border.color:btnFooterButton.checked?"#000000":"#333333"
                border.width:2
                radius:4
            }
            contentItem:RowLayout
            {
                id:rowLayoutFooterButton
//                anchors.fill:parent
                spacing:16
                Image
                {
                    id: iconFooterButton
                    Layout.leftMargin: rectFooterButton.imgLeftMargin
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    opacity:btnFooterButton.checked?1:0.8
                    source: rectFooterButton.btnImgSource
                    Layout.alignment: Qt.AlignVCenter
                }
                Text
                {
                    id: textFooterButton
                    text: rectFooterButton.textFooterButtonContent
                    opacity: btnFooterButton.checked?1:0.6
                    font.family:"OPPOSans"
                    font.weight: Font.Medium
                    font.pixelSize: 26
                    color:"#FFFFFF"
                    Layout.alignment: Qt.AlignVCenter
                    Layout.rightMargin: rectFooterButton.textRightMargin
                }
            }
            onClicked:
            {
                rectFooterButton.sendPageIndex(index);
            }
        }
    }
 }


