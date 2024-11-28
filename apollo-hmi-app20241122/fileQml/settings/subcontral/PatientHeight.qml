import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../mainFrame/assembly"

/*! @File        : PatientHeight.qml
 *  @Brief       : 身高控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Rectangle {
    id:rectHeight
    property alias textInputHeight: textInputHeight;
    width:52+14+167
    height:64
    color:"transparent"
    RowLayout
    {
        id:rowLayout
        spacing: 14
        PublicConstText
        {
            id:textHeight
            textContent: "身高"
        }
        PublicTextInputRectangle
        {
            id:textInputHeight
            isVisible: true
            txtContent:"cm"
            textWidth:167
            textLenght:3
//            textEdit.onTextChanged:
//            {
//                mainWindow.havePatientValueChanged();
//            }
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
                textInputHeight.focus=true;
                var x=(mainWindow.width-inputPanel.width)/2;
                var y=(491-inputPanel.height)>0?491-inputPanel.height:0;
                inputPanel.open(x, y, "height")
            }
            textEdit.validator: IntValidator
            {
                bottom:0
                top:999
            }
        }
    }
    /*!
    @Function    : setHeight(height)
    @Description : 设置身高
    @Author      : likun
    @Parameter   : height int 身高
    @Return      : 返回值说明
    @Output      :
    @Date        : 2024-08-18
*/
    function setHeight(height)
    {
        textInputHeight.setText(height.toString());
    }
    /*!
    @Function    : height()
    @Description : 获取身高
    @Author      : likun
    @Parameter   :
    @Return      : int 身高
    @Output      :
    @Date        : 2024-08-18
*/
    function height()
    {
        if(textInputHeight.text().length===0)
            return 0;
        return parseInt(textInputHeight.text());
    }

//        Rectangle
//        {
//            id:rightRect
//            width:66
//            height:64
//            color:"transparent"
//        }

}
