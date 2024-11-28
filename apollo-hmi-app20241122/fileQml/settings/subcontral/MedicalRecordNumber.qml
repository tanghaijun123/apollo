import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../mainFrame/assembly"
/*! @File        : MedicalRecordNumber.qml
 *  @Brief       : 病例号控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/
Rectangle {
    id:rectMedicalNumber
    property alias textNumberInput: textNumberInput
    width:78+40+233
    height: 64
    color:"transparent"
    RowLayout
    {
        id:rowLayout
        spacing: 40
        PublicConstText
        {
            id:txtMedicalNumber
            textContent:"病历号"
            Layout.alignment: Qt.AlignLeft|Qt.AlignVCenter
        }
        PublicTextInputRectangle
        {
            id:textNumberInput
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
                textNumberInput.focus=true;
                inputPanel.open((mainWindow.width-inputPanel.width)/2, 476, "medicalNumber")
            }
        }
    }
    /*!
    @Function    : setMedicalNumber(medicalNUmber)
    @Description : 设置病历号
    @Author      : likun
    @Parameter   : medicalNUmber  string 病历号
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
    function setMedicalNumber(medicalNUmber)
    {
        textNumberInput.setText(medicalNUmber.toString());
    }
    /*!
    @Function    : medicalNumber()
    @Description : 获取病历号
    @Author      : likun
    @Parameter   :
    @Return      : string 病历号
    @Output      :
    @Date        : 2024-08-18
*/
    function medicalNumber()
    {
        return textNumberInput.text();
    }
}
