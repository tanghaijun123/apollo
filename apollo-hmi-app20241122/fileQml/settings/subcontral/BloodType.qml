import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../mainFrame/assembly"

/*! @File        : BloodType.qml
 *  @Brief       : 血型控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Rectangle {
    id:rectBloodType
    width:52+14+167
    height: 64
    color:"transparent"
    RowLayout
    {
        id:rowLayout
        spacing: 14
        PublicConstText
        {
            id:constText
            textContent: "血型"
        }
        CustomComboBox
        {
            id:comboxBlood
            currentWidht:167
            models:["AB","A","B","O","RH"]
            currentText: "AB"
            Connections
            {
                target: comboxBlood
                /*!
    @Function    : onSendIndex(index)
    @Description : 接收下拉列表项的索引
    @Author      : likun
    @Parameter   : index int 项的索引
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
                function onSendIndex(index)
                {
                    comboxBlood.currentText=comboxBlood.models[index];
                    comboxBlood.currentIndex=index;
                    comboxBlood.changeListViewIndex();
                }
            }
            onCurrentTextChanged:
            {
                mainWindow.havePatientValueChanged();
            }
        }
    }
    /*!
    @Function    : setBloodType(bloodTypeStr)
    @Description : 设置血型
    @Author      : likun
    @Parameter   : bloodTypeStr string 血型
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
    function setBloodType(bloodTypeStr)
    {       
        for (var index=0;index<comboxBlood.models.length;index++)
        {
            if(comboxBlood.models[index]==bloodTypeStr)
            {
                comboxBlood.currentIndex=index;
                comboxBlood.currentText=bloodTypeStr;
                return;
            }
        }
    }
    /*!
    @Function    : bloodType()
    @Description : 获取血型
    @Author      : likun
    @Parameter   :
    @Return      : string 血型
    @Output      :
    @Date        : 2024-08-18
*/
    function bloodType()
    {
        return comboxBlood.currentText;
    }
}
