import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

/*! @File        : PublicTextInputRectangle.qml
 *  @Brief       : 公用文本输入框
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/
Rectangle {
    property int  textWidth:233;//文本框宽度
    property int  textHeight:64;//文本框高度
    property int textLenght : 10;//文本输入长度
    property string txtContent:"";//单位内容
    property bool isVisible:false;//单位是否可见
    property  int  textEchoMode: TextInput.Normal;//文本框输入方式
    property string pwCharacter: "*" //设置为密码时显示的样式
    property alias textEdit: textField;
    id:rectRoot
    width:rectRoot.textWidth
    height: rectRoot.textHeight
    color:"#585858"
    border.width: 1
    border.color: "#000000"
    radius: 4
    TextField
    {
        id:textField
        width: rectRoot.isVisible==true?rectRoot.textWidth-txtDW.width-20: rectRoot.width
        height: parent.height
        leftPadding:16
        maximumLength: rectRoot.textLenght
        echoMode:rectRoot.textEchoMode
        passwordCharacter:rectRoot.pwCharacter
//        topPadding:19
//        bottomPadding:19
        background: Rectangle
        {
            anchors.fill:parent
            color:"transparent"
        }
        color:"#FFFFFF"
        font.family: "OPPOSans"
        font.weight: Font.Normal
        font.pixelSize: 26
 //       Layout.alignment: Qt.AlignLeft|Qt.AlignVCenter
        onPressed: {

        }
    }
    Text {
        id: txtDW
        anchors.right: parent.right
        anchors.rightMargin: 16
//        anchors.top: parent.top
//        anchors.topMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 18
        text: rectRoot.txtContent
        font.family: "OPPOSans"
        font.weight: Font.Normal
        font.pixelSize: 26
        color:"#FFFFFF"
        opacity: 0.6
        visible: rectRoot.isVisible
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
 //       Layout.alignment: Qt.AlignVCenter
    }
    /*!
    @Function    : setText(textStr)
    @Description : 设置文本
    @Author      : likun
    @Parameter   : textStr  string 文本
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
    function setText(textStr)
    {
        textField.text=textStr;
    }
    /*!
    @Function    : text()
    @Description : 获取文本
    @Author      : likun
    @Parameter   :
    @Return      : string  文本
    @Output      :
    @Date        : 2024-08-18
*/
    function text()
    {
        return textField.text;
    }
}
