import QtQuick 2.15
import QtQuick.Controls 2.5
/*! @File        : LeftMenu.qml
 *  @Brief       : 设置页面 左边菜单控件
 *  @Author      : likun
 *  @Date        : 2024-08-19
 *  @Version     : v1.0
*/

Rectangle {
    property string txtOneContent: "系统设置";
    property string txtTwoContent: "患者信息";
    property string txtThreeContent :"设备信息";
    property string txtFourContent : "高级设置";
    property alias curRunBtn: btnOne;
    property alias runRecordBtn: btnTwo;
    /*!
    @Function    : sendPageIndex(int index);
    @Description : 发送页面索引信号
    @Author      : likun
    @Parameter   : index int 页面索引
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    signal sendPageIndex(int index);
    id:rectLeftMenu
    width: 160
    height: 432
    color:"transparent"
    ButtonGroup{ id:btnGroups;exclusive: true;buttons: column.children}
    Column
    {
        id:column
        anchors.fill: parent
        spacing: 0
        Button
        {
            id:btnOne
            width: 160
            height: 108
            checkable:true
            checked:true
            background: Rectangle
            {
                anchors.fill:parent
                color: btnOne.checked?"#0E8F78":"#272727"//"#3D3D3D":"#272727"
            }
            contentItem: Text
            {
                id: txtOne
                text: txtOneContent
                opacity: btnOne.checked?"1":"0.6"
                color:"#FFFFFF"
                font.family: "OPPOSans"
                font.weight: Font.Medium
                font.pixelSize: 26
                verticalAlignment:Text.AlignVCenter
                horizontalAlignment:Text.AlignHCenter
            }
            onClicked: {
                rectLeftMenu.sendPageIndex(0);
            }
        }
        Button
        {
            id:btnTwo
            width: 160
            height: 108
            checkable:true
            background: Rectangle
            {
                anchors.fill:parent
                color: btnTwo.checked?"#0E8F78":"#272727"//"#3D3D3D":"#272727"
            }
            contentItem: Text
            {
                id: txtTwo
                text: txtTwoContent
                opacity: btnTwo.checked?"1":"0.6"
                color:"#FFFFFF"
                font.family: "OPPOSans"
                font.weight: Font.Medium
                font.pixelSize: 26
                verticalAlignment:Text.AlignVCenter
                horizontalAlignment:Text.AlignHCenter
            }
            onClicked: {
                rectLeftMenu.sendPageIndex(1);
            }
        }
        Button
        {
            id:btnThree
            width: 160
            height: 108
            checkable:true
            background: Rectangle
            {
                anchors.fill:parent
                color: btnThree.checked?"#0E8F78":"#272727"//"#3D3D3D":"#272727"
            }
            contentItem: Text
            {
                id: txtThree
                text: txtThreeContent
                opacity: btnThree.checked?"1":"0.6"
                color:"#FFFFFF"
                font.family: "OPPOSans"
                font.weight: Font.Medium
                font.pixelSize: 26
                verticalAlignment:Text.AlignVCenter
                horizontalAlignment:Text.AlignHCenter

            }
            onClicked: {
                rectLeftMenu.sendPageIndex(2);
            }
        }
        Button
        {
            id:btnFour
            width: 160
            height: 108
            checkable:true
            background: Rectangle
            {
                anchors.fill:parent
                color: btnFour.checked?"#0E8F78":"#272727"//"#3D3D3D":"#272727"
            }
            contentItem: Label
            {
                id: txtFour
                anchors.fill:parent
                text: txtFourContent
                opacity: btnFour.checked?"1":"0.6"
                color:"#FFFFFF"
                font.family: "OPPOSans"
                font.weight: Font.Medium
                font.pixelSize: 26
                verticalAlignment:Text.AlignVCenter
                horizontalAlignment:Text.AlignHCenter
            }
            onClicked: {
                rectLeftMenu.sendPageIndex(3);
            }
        }
    }
}
