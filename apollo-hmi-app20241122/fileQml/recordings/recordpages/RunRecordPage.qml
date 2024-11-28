import QtQuick 2.15
import QtQuick.Controls 2.15

import QtQuick.Layouts 1.3
import Qt.labs.qmlmodels 1.0
import "../subcontral/record/runrecord"
import "../subcontral/record/runrecord/subcontrol"

/*! @File        : RunRecordPage.qml
 *  @Brief       : 运行记录页面
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/

Item {
    property alias leftPage: left;
    id:control
    width: parent.width
    height: parent.height
    RunDetailsPage{id:left}

    function refreshList()
    {
        left.refreshModel();
    }
}
