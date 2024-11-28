import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../../../mainFrame/assembly"
/*! @File        : RightPage.qml
 *  @Brief       : 运行记录的右页面
 *  @Author      : likun
 *  @Date        : 2024-08-21
 *  @Version     : v1.0
*/
Rectangle {
    id:root
    //width:231
    height: parent.height
    color:"#3D3D3D"
    ColumnLayout
    {
        id:rootLayout
        anchors.fill: parent
        spacing: 230
        TimeSortCombobox{id : timeSortCb;Layout.alignment: Qt.AlignHCenter;Layout.topMargin: 54}
        ExportDataButton{id:exportDataBtn;Layout.alignment: Qt.AlignHCenter;Layout.bottomMargin: 20}
    }
}
