import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../../../mainFrame/assembly"

/*! @File        : TimeSortCombobox.qml
 *  @Brief       : 排序控件
 *  @Author      : likun
 *  @Date        : 2024-08-21
 *  @Version     : v1.0
*/
CustomComboBox
{
    property var sortTypes: ["时间正序","时间倒序"]
    property string contentText;
    signal sendSortNumber(int index);
    signal sendSortIndex(int index);
    id:timeSortComboBox
    models: timeSortComboBox.sortTypes
    currentText: "时间正序"
    currentWidht:180
    contentHeight: 120
    borderWidth:0
    borderColor: "#2C2C2C"//整个控件边框
    contralColor: "#2C2C2C"//整个控件颜色
    backgroundColor: "#2C2C2C"
    indicatorColor: "#2C2C2C"//下拉框颜色
    indicatorImg: "/images/icon_button_drop-down @2x.png"//下拉框图标
    popupHeight:120
    popupBackgroundColor:"#2c2c2c"
//    Connections
//    {
//        target:timeSortComboBox
//        function onSendSortIndex(index)
//        {
//            timeSortComboBox.currentIndex=index;
//            timeSortComboBox.changeListViewIndex();
//        }
//    }

    Connections
    {
        target:timeSortComboBox
        function onSendIndex (index)
        {
            currentText=timeSortComboBox.sortTypes[index]
            timeSortComboBox.sendSortNumber(index);
        }
    }
}
