import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.15
import "../mainFrame/subpage"
//import "./subcontral"
import "./recordpages"
import "../mainFrame/subcontral"
import "./subcontral/publicAssembly"
//import pollo.CTestingOperationRecordQueryModel 1.0
//import pollo.CRunningRecordModel 1.0
import pollo.CRunningTestOpt 1.0
import pollo.CTestDetailDataOpt 1.0
//import pollo.CWarningDataQueryModel 1.0

/*! @File        : RecordPage.qml
 *  @Brief       : 记录主页面
 *  @Author      : likun
 *  @Date        : 2024-08-19
 *  @Version     : v1.0
*/
Rectangle
{
    property var nowDate: new Date();
    property var openCurRunPageType: publicDefine.openPageType.CurrentRun
    property int data_Index:publicDefine.dataIndex.NaN
    property int iTest_ID;
    property var access_Date;
    property bool bRuning: false

    /*!
    @Function    : sigOpenCurRunPage(int openPageType,string accessDate,int dataIndex, int iTestID)
    @Description : 打开当前运行页面信号
    @Author      : likun
    @Parameter   : openPageType int 打开页面方式 0 当前运行;1 历史记录; accessDate var 访问日期; dataIndex  int  记录索引; iTestID int 记录ID
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    signal sigOpenCurRunPage(int openPageType,string accessDate,int dataIndex, int iTestID);
    /*!
    @Function    : sigAddAccessDate(string dateStr);
    @Description : 增加访问日期
    @Author      : likun
    @Parameter   : dataStr string 日期字符串
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    signal sigAddAccessDate(string dateStr);
    /*!
    @Function    : sigChangeDateAccess(string dateStr);
    @Description : 更改访问日期
    @Author      : likun
    @Parameter   : dataStr string 日期字符串
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    signal sigChangeDateAccess(string dateStr);
    id:recordPage//setPage
    width:1280
    height:628
    color:"#000000"
    PublicDefine{id:publicDefine}
    //CTestingOperationRecordQueryModel{id:cTestingModel}
    //CRunningRecordModel{id:cRunningModel}
    CTestDetailDataOpt{id:cTestDetail}
    //CWarningDataQueryModel{id:cWarningModel}
//    CRunningTestOpt{id:cRunningOpt}
    Column
    {
        anchors.fill: parent
        spacing: 0
        //DeviceRunInfo{id:deviceRunInfo}
        Row
        {
            spacing: 0
            LeftMenu
            {
                id:setPageMenu
                txtOneContent: "当前运行";
                txtTwoContent: "运行记录";
                txtThreeContent :"报警记录";
                txtFourContent : "操作记录";
                curRunBtn.onClicked:
                {
                   // openCurRunPage();
                }
            }
            StackLayout
            {
                id:setPageLayout
                width: 1118
                height: 432//628
                currentIndex:0
                CurrentRunPage{id:currentRunPage}
                RunRecordPage{id:runRecordPage}
                WarningRecordPage{id:warningRecordPage}
                OperationRecordPage{id:operationRecordPage}
            }
            /*!
@Function    : onSendPageIndex(index)
@Description : 根据索引,访问页面
@Author      : likun
@Parameter   : index int 页面索引
@Return      :
@Output      :
@Date        : 2024-08-19
*/
            Connections
            {
                target:setPageMenu
                function onSendPageIndex(index)
                {
                    setPageLayout.currentIndex=index
                    currentRunPage.parentCurIndex = index;
                    if(index===publicDefine.recordPageIndex.CurrentRunPage)
                    {
                        curSelectedTestID=0;
                        setPageMenu.curRunBtn.checked=true;

                        if(openCurRunPage() > 0) // test id
                        {
                            //busyIndicator.open();
                        }
                    }
                    else if(index===publicDefine.recordPageIndex.RunRecordPage)
                    {
                        runRecordPage.refreshList();
                    }
                    else if(index===publicDefine.recordPageIndex.WarningRecordPage)
                    {
                        warningRecordPage.refreshList();
                    }
                    else if(index===publicDefine.recordPageIndex.OperationRecordPage)
                    {
                        operationRecordPage.refreshList();
                    }
                }
            }

            /*!
    @Function    : onSigOpenCurRunPage(openPageType,accessDate,dataIndex,iTestId)
    @Description : 访问当前运行页面
    @Author      : likun
    @Parameter   : openPageType int 打开页面方式 0 当前运行;1 历史记录; accessDate var 访问日期; dataIndex  int  记录索引; iTestID int 记录ID
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
            Connections
            {
                target: recordPage
                function onSigOpenCurRunPage(openPageType,accessDate,dataIndex,iTestId)
                {
                    console.debug("onSigOpenCurRunPage",openPageType,accessDate,dataIndex,iTestId)
                    nowDate=new Date(accessDate);
                    curSelectedTestID=iTestId;
                    currentRunPage.accessCurrentRunPage(openPageType,nowDate,dataIndex, iTestId);
                    //setPageMenu.enabled=false;
                    //setPageMenu.curRunBtn.checked=true;
                    setPageLayout.currentIndex=0;
                }
            }
            /*!
    @Function    : onSendPageIndex(index)
    @Description : 当前运行页面返回按钮返回的页面索引
    @Author      : likun
    @Parameter   : index int 页面索引
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
            Connections
            {
                target:currentRunPage
                function onSendPageIndex(index)
                {
                    setPageMenu.enabled=true;
                    //setPageMenu.runRecordBtn.checked=true;
                    setPageLayout.currentIndex=index;
                    currentRunPage.parentCurIndex = index;
                }
            }
       }
    }
    Component.onCompleted:
    {
        openCurRunPage();
    }
    /*!
    @Function    : openCurRunPage()
    @Description : 打开当前运行页面
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-19
*/
    function openCurRunPage()
    {
        openCurRunPageType=publicDefine.openPageType.CurrentRun;
        setPageMenu.enabled=true;
//        setPageMenu.curRunBtn.checked=true;
        iTest_ID=m_RunningTestManager.getCurRunningTestID();
        console.debug("beginOpenCurRunPage iTest_ID", iTest_ID)

        nowDate=new Date();
        currentRunPage.accessCurrentRunPage(openCurRunPageType,nowDate,publicDefine.dataIndex.NaN, iTest_ID );
        return iTest_ID;
    }

    function refreshRecordList()
    {
        var index = setPageLayout.currentIndex;
        if(index===publicDefine.recordPageIndex.RunRecordPage)
        {
            runRecordPage.refreshList();
        }
        else if(index===publicDefine.recordPageIndex.WarningRecordPage)
        {
            warningRecordPage.refreshList();
        }
        else if(index===publicDefine.recordPageIndex.OperationRecordPage)
        {
            operationRecordPage.refreshList();
        }
    }

    Connections{
        target: m_RunningTestManager
        function onCurRunningStatus(bRunning){
            curSelectedTestID=0;
            bRuning=bRunning;
            if(setPageLayout.currentIndex===0)
            {
                setPageMenu.curRunBtn.checked=true;
            }
            openCurRunPage();
        }
    }
}
