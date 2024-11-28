import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../../../mainFrame/assembly"
/*! @File        : OperationInstructionPage.qml
 *  @Brief       : 操作记录页面,右侧页面
 *  @Author      : likun
 *  @Date        : 2024-08-21
 *  @Version     : v1.0
*/

Rectangle
{
    id:root
    Layout.preferredWidth: 200
    Layout.preferredHeight: 432
    color:"#3D3D3D"
    ExportDataButton
    {
        id:exportBtn
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        onBtnClick: {
            closePage.open(pubCode.messageType.Question, "确定需要保存操作数据?", closePage.conMPDonwloadActionRecord);
        }
    }
}
