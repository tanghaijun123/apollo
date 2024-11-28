import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../../../mainFrame/assembly"


/*! @File        : WarningInstructionPage.qml
 *  @Brief       : 记录,警告记录页面,右边控件
 *  @Author      : likun
 *  @Date        : 2024-08-22
 *  @Version     : v1.0
*/
Rectangle
{
    id:rectRight
    width: 200
    height:432
    color:"#3D3D3D"
    ExportDataButton
    {
        id:exportBtn
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        onBtnClick: {
            closePage.open(pubCode.messageType.Question, "确定需要保存报警数据?", closePage.conMPDonwloadWaringRecord);
        }
    }
}
