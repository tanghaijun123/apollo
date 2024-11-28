import QtQuick 2.15
/*! @File        : PublicDefine.qml
 *  @Brief       : 常量定义
 *  @Author      : likun
 *  @Date        : 2024-08-21
 *  @Version     : v1.0
*/
Item {
    //打开当前运行页面的方式 0,当前运行按钮进入;1,运行记录进入
    readonly property var openPageType: {"CurrentRun":0,"RunRecord":1};
    //无效的数据索引
    readonly property var dataIndex:{"NaN":0};
    //记录页面索引
    readonly property var recordPageIndex: {"CurrentRunPage":0,"RunRecordPage":1,"WarningRecordPage":2,"OperationRecordPage":3};
    readonly property string yearFormat: "YYYY/MM/DD";
}
