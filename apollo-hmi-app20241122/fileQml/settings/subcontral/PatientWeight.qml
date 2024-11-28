import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../mainFrame/assembly"

/*! @File        : PatientWeight.qml
 *  @Brief       : 体重控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Rectangle {
    id:rectWeight
    property alias textWeightInput: textWeightInput
    width:52+66+167+66
    height:64
    color:"transparent"
    RowLayout
    {
        id:mainLayout
        spacing: 0
        RowLayout
        {
            id:rowLayout
            spacing: 66
            PublicConstText
            {
                id:textWeight
                textContent: "体重"
            }
            PublicTextInputRectangle
            {
                id:textWeightInput
                isVisible: true
                txtContent:"kg"
                textWidth:167
                textLenght:5
//                textEdit.onTextChanged:
//                {
//                    mainWindow.havePatientValueChanged();
//                }
                textEdit.onPressed:
                {
                    textWeightInput.focus=true;
                    var x=(mainWindow.width-inputPanel.width)/2;
                    var y=(491-inputPanel.height)>0?491-inputPanel.height:0;

                    inputPanel.open(x, y, "weight")
                }
                textEdit.validator: DoubleValidator
                {
                    bottom: 0.0
                    top:999.9
                    decimals:1
                }
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
            }
        }
//        Rectangle
//        {
//            id:rightRect
//            width:66
//            height:64
//            color:"transparent"
//        }
    }
    /*!
    @Function    : setWeight(weight)
    @Description : 设置体重
    @Author      : likun
    @Parameter   : weight float 体重
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
    function setWeight(weight)
    {
        textWeightInput.setText(weight.toString());
    }
    /*!
    @Function    : weight()
    @Description : 获取体重
    @Author      : likun
    @Parameter   :
    @Return      : float 体重
    @Output      :
    @Date        : 2024-08-18
*/
    function weight()
    {
        if(textWeightInput.text().length==0)
            return 0;
        return parseFloat(textWeightInput.text());
    }


}
