import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../subcontral"

/*! @File        : HightLevelSetPage.qml
 *  @Brief       : 高级设置页面
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/
Rectangle
{
    id:hilvSetPage
    color:"#3D3D3D"
    RowLayout
    {
        HightLevelSetPassword
        {
            id:setPwd
            Layout.leftMargin: 56
            Layout.topMargin: 36
    //        anchors.left: parent.left
    //        anchors.leftMargin: 56
    //        anchors.top: parent.top
    //        anchors.topMargin: 36
        }
    }
}


