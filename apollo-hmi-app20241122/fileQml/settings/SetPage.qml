import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.15
import "../mainFrame/subpage"
import "../mainFrame/subcontral"
import "./subcontral"
import "./settingpages"
//import pollo.Process 1.0

/*! @File        : SetPage.qml
 *  @Brief       : 设置页面
 *  @Author      : likun
 *  @Date        : 2024-08-13
 *  @Version     : v1.0
 *
*/

Rectangle {
//    property var  qmlObjectInOtherFile:null;
    id:setPage
    width:1280
    height:620//628
    color:"#000000"
    property bool canUpdateDate: false
    Column
    {
        anchors.fill: parent
        spacing: 0
        //DeviceRunInfo{id:deviceRunInfo}
        Row
        {
            width: parent.width
            height: 432
            spacing: 0
            LeftMenu{ id:setPageMenu}
            StackLayout
            {
                id:setPageLayout
                width: 1118
                height: 432
                currentIndex:0
                SystemSetPage{
                    id: sysSetPage
                }
                PatientInfoPage{id:patInfoPage}
                DeviceInfoPage{id:deviceInfoPage}
                HightLevelSetPage{id:hightLevelSetPage}
            }
            Connections
            {
                target:setPageMenu
                /*!
                @Function    : onSendPageIndex(index)
                @Description : 根据页面索引显示不同页面
                @Author      : likun
                @Parameter   : index int 页面索引
                @Return      :
                @Output      :
                @Date        : 2024-08-13
                @Modify      :
                */
                function onSendPageIndex(index)
                {
                    setPageLayout.currentIndex=index
                }
            }
       }
     }

    Connections{
        target: sysSetPage
        /*!
        @Function    : onSigUpdateCurrentDate(strDate)
        @Description : 更新当前日期
        @Author      : likun
        @Parameter   : strDate String  日期字符串
        @Return      :
        @Output      :
        @Date        : 2024-08-13
        @Modify      :
        */
        function onSigUpdateCurrentDate(strDate){
            if(canUpdateDate){
                var iReturn = m_ShellProcess.setCurDateTime(strDate);
                if(iReturn < 0){
                    console.debug("setCurDateTime return: ", iReturn);
                }
            }
        }

    }
    Timer{
        id: tmrDelayExeConnect;
        running: false;
        repeat: false;
        interval: 5*1000;
        onTriggered: {
            canUpdateDate = true;
        }
    }
    Component.onCompleted: {
        tmrDelayExeConnect.running = true;

    }

}
