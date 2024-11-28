import QtQuick 2.15
import QtQuick.Layouts 1.3
/*! @File        : Customspacing.qml
 *  @Brief       : 自定义间隔
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle {
    id:root
    property real customWidth: 16
//    Layout.preferredWidth: root.customWidth
//    Layout.preferredHeight: root.customWidth
//    Layout.minimumWidth: root.customWidth
    width: root.customWidth
    height: 64
    color:"transparent"
}
