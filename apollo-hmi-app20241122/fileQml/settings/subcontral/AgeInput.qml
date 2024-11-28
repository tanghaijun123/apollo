import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../mainFrame/assembly"
/*! @File        : AgeInput.qml
 *  @Brief       : 年龄输入控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Rectangle {
    id:rectAge
    property alias textInputAge: textInputAge
    width: 9+52+14+167
    height: 64
    color:"transparent"
    RowLayout
    {
        id:rowLayout
        spacing: 0
        Rectangle
        {
            id:rectLeft
            width:9
            height: 64
            color:rectAge.color
        }
        RowLayout
        {
            id:subRowLayout
            spacing: 14
            PublicConstText
            {
                id:constTextAge
                textContent: "年龄"
                Layout.alignment: Qt.AlignVCenter
            }
            PublicTextInputRectangle
            {
                id:textInputAge
                isVisible: true
                textWidth:167
                txtContent:"岁"
                textLenght: 3
                Layout.alignment: Qt.AlignVCenter
                /*!
    @Function    : onEditingFinished
    @Description : 接收编辑完成信号
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
                textEdit.onEditingFinished:
                {
                    mainWindow.havePatientValueChanged();
                }
                textEdit.onPressed:
                {
                    textInputAge.focus=true;
                    inputPanel.open((mainWindow.width-inputPanel.width)/2, 392, "age");
                }
                textEdit.validator: IntValidator
                {
                    bottom:0
                    top:999
                }
            }
        }
    }
    /*!
    @Function    : setAge(age)
    @Description : 设置年龄
    @Author      : likun
    @Parameter   : age int 年龄
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
    function setAge(age)
    {
        textInputAge.setText(`${age}`);
    }
    /*!
    @Function    : age()
    @Description : 获取年龄
    @Author      : likun
    @Parameter   :
    @Return      : age int 年龄
    @Output      :
    @Date        : 2024-08-18
*/
    function age()
    {
        if(textInputAge.text().length==0)
            return 0;
        return parseInt(textInputAge.text());
    }



}
