import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../mainFrame/assembly"

/*! @File        : PatientNameInput.qml
 *  @Brief       : 患者姓名录入框
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Rectangle
{
    id:rectPatient
    property alias pubTextInput: pubTextInput
    width:104+14+233
    height:64
    color:"transparent"   
    RowLayout
    {
        id:rowLayout
        spacing: 14
        PublicConstText
        {
            id:txtPatient
            textContent:"病人姓名"
            Layout.alignment: Qt.AlignLeft|Qt.AlignVCenter
        }
        PublicTextInputRectangle {
            id:pubTextInput
            isVisible: false
//            textEdit.onTextChanged:
//            {
//                mainWindow.havePatientValueChanged();
//            }
            /*!
    @Function    : onEditingFinished
    @Description : 接收姓名输入完成信号
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
            /*!
    @Function    : onPressed
    @Description : 获取焦点,打开键盘
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
            textEdit.onPressed:
            {
                pubTextInput.focus=true;
                var x=(mainWindow.width-inputPanel.width)/2;
                var y=392;

                inputPanel.open(x, y, "patientName")
            }
        }
    }
    /*!
    @Function    : setName(name)
    @Description : 设置姓名
    @Author      : likun
    @Parameter   : name string 姓名
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
    function setName(name)
    {
        pubTextInput.setText(name);
    }
    /*!
    @Function    : name()
    @Description : 获取姓名
    @Author      : likun
    @Parameter   :
    @Return      : text string 姓名
    @Output      :
    @Date        : 2024-08-18
*/
    function name()
    {
        return pubTextInput.text();
    }
}


