import QtQuick 2.15
/*! @File        : CustomLine.qml
 *  @Brief       : 自定义线
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle {
    property real lineHeight:56
    property real lineWidth:1
    property string lineColor:"#4E4E4E"
    property real lineOpacity: 1
    id: line
    height: 56
    width: lineWidth
    color:lineColor
    opacity: lineOpacity
}
