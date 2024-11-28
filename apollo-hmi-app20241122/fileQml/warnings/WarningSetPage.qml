import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../mainFrame/subpage"
import "./warningpages"

//警告设置页面
/*! @File        : WarningSetPage.qml
 *  @Brief       : 简要说明
 *  @Author      : likun
 *  @Date        : 2024-08-22
 *  @Version     : v1.0
*/
Rectangle
{
    id:root
    width: 1280
    height: 439//628
    color:"#3D3D3D"
    StackLayout
    {
        id:stackLayout
        width: 1280
        height: 439
        currentIndex: 0
        FlowWarningSetPage{id:flowWarning}
        SpeedWarningSetPage{id:speedWarning}
    }
//    ColumnLayout
//    {
//        id:layout
//        anchors.fill: parent
//        spacing: 0
//        DeviceRunInfo{id:deviceInfo}
//        Rectangle
//        {
//            id:bottom
//            width: root.width
//            height:439
//            color:"#3D3D3D"
//            StackLayout
//            {
//                id:stackLayout
//                anchors.fill: parent
//                currentIndex: 0
//                FlowWarningSetPage{id:flowWarning}
//                SpeedWarningSetPage{id:speedWarning}
//            }
//        }
//    }
    /*!
    @Function    : onSendIndex(index)
    @Description : 根据索引显示页面
    @Author      : likun
    @Parameter   : index int 索引
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    Connections
    {
        target: flowWarning
        function onSendIndex(index)
        {
            stackLayout.currentIndex=index;
        }
    }

    /*!
    @Function    : onSendIndex(index)
    @Description : 根据索引显示页面
    @Author      : likun
    @Parameter   : index int 索引
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    Connections
    {
        target: speedWarning
        function onSendIndex(index)
        {
            stackLayout.currentIndex=index;
        }
    }

//    property int nTabCount: 5
//    Connections{
//        target: mainWindow
//        function onRotarySelected(step){
//            //console.debug("WaringSetPage onRotarySelected.....", step);

//            if(mainWindow.pgCurIndex === 1 && mainWindow.bSelInSubPage)
//            {
//                if(!mainWindow.bSubComConfirmed)
//                {
//                    var nIndex =  mainWindow.iSubPageSelectIndex + step;
//                    if(nIndex < 0){
//                       nIndex += nTabCount;
//                    }
//                    else{
//                      nIndex =  nIndex % nTabCount;
//                    }
//                    mainWindow.iSubPageSelectIndex = nIndex;
//                    //console.debug("WaringSetPage onRotarySelected, mainWindow.pgCurIndex ", mainWindow.pgCurIndex, "mainWindow.iSubPageSelectIndex ", mainWindow.iSubPageSelectIndex);

//                    if(mainWindow.iSubPageSelectIndex > 0) {
//                        //按页显示选中按钮
//                        var subpageIndex = mainWindow.iSubPageSelectIndex - 1;
//                        stackLayout.currentIndex = subpageIndex / 2;
//                        if(stackLayout.currentIndex === 0){
//                            flowWarning.setSelSlidIndex(subpageIndex % 2);
//                        }
//                        else{
//                            speedWarning.setSelSlidIndex(subpageIndex % 2);
//                        }

//                    }
//                }
//            }

//        }
//        function onKey_Confirm()
//        {
//            //console.debug("warningSetPage onKey_Confirm, mainWindow.pgCurIndex: " , mainWindow.pgCurIndex , " mainWindow.iSubPageSelectIndex: " , mainWindow.iSubPageSelectIndex);
//            if(mainWindow.bSelInSubPage)
//            {
//                if(mainWindow.pgCurIndex == 1 && mainWindow.bSelInSubPage)
//                {
//                    if(iSubPageSelectIndex < 1)
//                        return;

//                    mainWindow.bSubComConfirmed = !mainWindow.bSubComConfirmed;
//                }
//            }
//        }
//    }

}
