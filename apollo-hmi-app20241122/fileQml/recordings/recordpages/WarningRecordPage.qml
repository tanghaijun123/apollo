import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../subcontral/record/warningrecord"

/*! @File        : WarningRecordPage.qml
 *  @Brief       : 报警记录页面
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/
Rectangle {
    id:root
    width: parent.width
    height: parent.height
    color:"transparent"
    RowLayout
    {
        id:layout
        anchors.fill: parent
        spacing: 0
        WarningDetailRecordPage{id:leftPage}
        Rectangle
        {
            id:line
            color:"#000000"
            width: 1
            height: root.height-1
        }
        WarningInstructionPage{id:rightPage}
    }

    function refreshList()
    {
        leftPage.refreshModel();
    }
}
