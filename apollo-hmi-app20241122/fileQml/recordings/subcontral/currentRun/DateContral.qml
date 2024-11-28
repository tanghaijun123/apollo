import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQml.Models 2.15
import "../../../mainFrame/assembly"

/*! @File        : DateContral.qml
 *  @Brief       : 当前运行页面,日期控件
 *  @Author      : likun
 *  @Date        : 2024-08-19
 *  @Version     : v1.0
*/
CustomComboBox {
    property var dates;
    /*!
    @Function    : sendDateStr(string dateStr);
    @Description : 发送日期信号
    @Author      : likun
    @Parameter   : dateStr string 日期字符串
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    signal sendDateStr(string dateStr);
    /*!
    @Function    : sendDateIndex(int index);
    @Description : 发送日期索引信号
    @Author      : likun
    @Parameter   : index int 日期索引
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    signal sendDateIndex(int index);
    property string nowDate: new Date().toLocaleDateString("yyyy-MM-dd");
    id:root
    models:dates
    currentText:""
    currentWidht: 220
    indicatorHeight:30
    indicatorWidth: 30
    height: 40

    color:"#272727"
    radius: 4
    Component.onCompleted:
    {
        //console.log("**************",nowDate,"*************");
    }
    //onContentTextChanged: root.currentText=contentText;
    /*!
    @Function    : onSendDateIndex(index)
    @Description : 显示日期
    @Author      : likun
    @Parameter   : index int 日期索引
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    Connections
    {
        target:root
        function onSendDateIndex(index)
        {
            root.currentIndex=index;
            root.changeListViewIndex();
        }
    }
    //
    /*!
    @Function    : onSendIndex (index)
    @Description : 根据索引显示日期,并发送访问日期信号
    @Author      : likun
    @Parameter   : index int 日期索引
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    Connections
    {
        target:root
        function onSendIndex (index)
        {
            currentText=dates[index]
 //           var currentDate=ds[index];
 //           root.sendDateStr(currentText);
            recordPage.sigChangeDateAccess(currentText);
        }
    }

    /*!
    @Function    : onSigAddAccessDate(curDateStr)
    @Description : 添加日期
    @Author      : likun
    @Parameter   : curDateStr string 日期
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    Connections
    {
        target:recordPage
        function onSigAddAccessDate(curDateStr)
        {
            if(ds.indexOf(curDateStr)>=0)
                return;
            ds.unshift(curDateStr);
            dates=ds;
            currentText=ds[0];
            currentIndex=0;
            root.changeListViewIndex();
           // recordPage.sigChangeDateAccess(curDateStr);
        }
    }
    /*!
    @Function    : setDate(dateStrs)
    @Description : 设置显示日期
    @Author      : likun
    @Parameter   : dateStrs array  日期列表
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    function setDate(dateStrs)
    {
        ds=[];
        dates=[]
        ds=dateStrs;
        dates=ds;
        currentText=ds[0];
        currentIndex=0;
        root.changeListViewIndex();
        //recordPage.sigChangeDateAccess(currentText);
    }

}
//Rectangle {//当前运行页面,日期控件
//    property string nowDate: new Date().toLocaleDateString("yyyy-MM-dd");
//    id:root
//    width:181
//    height:40
//    color:"#272727"
//    radius: 4
//    Text
//    {
//        id: txtDate
//        anchors.fill: parent
//        text: root.nowDate
//        color:"#BEBEBE"
//        font.family: "OPPOSans"
//        font.weight: Font.Medium
//        font.pixelSize: 24
//        horizontalAlignment: Text.AlignHCenter
//        verticalAlignment: Text.AlignVCenter
//    }
//    Component.onCompleted:
//    {
//        //console.log("**************",nowDate,"*************");
//    }

//    function setDate(dateStr)
//    {
//        txtDate.text=dateStr;
//    }

//}
