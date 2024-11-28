import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../mainFrame/assembly"

/*! @File        : HightLevelSetPassword.qml
 *  @Brief       : 设置密码控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/
Item {
    id:itemSetPwd
    width: 351
    height:64
    RowLayout
    {
        id:rowLaySetPwd
        spacing: 14
        PublicConstText{id:txtSetPwd;textContent: "输入密码";fontWeight:Font.Medium}
        PublicTextInputRectangle
        {
            id:inputSetPwd
            textWidth: 233
            textLenght:20
            textEchoMode:TextInput.Password
            textEdit.onPressed:
            {
                rowLaySetPwd.focus=true;
                inputPanel.open(0, 392, "password");
            }
        }
    }

    Connections {
        target: inputPanel
        function onInputConfirm(itemName) {
            if(inputSetPwd.text() === "836256")
            {
                advancedSettingsWin.visible = true
                inputSetPwd.setText("")
            } else {
                m_RunningTestManager.playKeySound();
                if(itemName === "password")
                {
                    popWindow.openMessage("      密码错误！", true)
                     inputSetPwd.setText("")
                }
            }
        }
    }
}
