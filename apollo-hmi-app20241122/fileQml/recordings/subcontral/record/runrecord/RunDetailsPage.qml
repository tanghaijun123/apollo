import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../publicAssembly"
import "./subcontrol"
import "../../../../mainFrame/subcontral"
import "../../../../mainFrame/assembly"
import "../../currentRun"
import "../../../subcontral/publicAssembly"

/*! @File        : RunDetailsPage.qml
 *  @Brief       : 记录页面,运行记录页面,数据页面
 *  @Author      : likun
 *  @Date        : 2024-08-21
 *  @Version     : v1.0
*/

Rectangle{
    enum Positions
    {
        Down=0,
        Up
    }
    property string footTextContent: "";
    readonly property int rowNumbers: 20;//一页最大行数
    property int maxPage: 0;//最大页数
    property int currentPage: 0;//当前页数
    property int current: 0
    /*
        访问当前运行页面信号;
        openPageType:访问当前运行页面方式
        accessDate:访问日期
        dataIndex:数据索引
    */
    //signal openCurRunPage(int openPageType,string accessDate,int dataIndex, int iTestID);
    id:root
    width: 1118//886
    height:432
    color:"#3D3D3D"
    ColumnLayout
    {
        id:rootLayout
        anchors.fill:parent
        spacing: 0
        TitleControl
        {
            id:titile
            //            textLeftContent:"启动时间"//标题左边的文字
            //            textMiddleContent:"运行时长"//标题中间的文字
            //            textRightContent:"病人姓名"//标题右边的文字
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 15
            z:RunDetailsPage.Up
        }
        Item
        {
            id:rectRunRecords
            width:1073
            height: 368
            //           color:"transparent"
            Layout.alignment: Qt.AlignHCenter

            PullListRunRecord
            {
                id:view
                anchors.fill: parent

                ListModel
                {
                    id:modelRunRecord
                    /*!
    @Function    : setRowInPage()
    @Description : 设置页面的行数
    @Author      : likun
    @Parameter   :
    @Return      : {res : 0 成功 , 非0 失败}
    @Output      :
    @Date        : 2024-08-21
*/
                    function setRowInPage()
                    {
                        var rs=cRunningModel.setRowsPerPage(rowNumbers);
                        if(rs.res!==0)
                        {
                            return {res:ErrorCode.RunRecordSetMaxRowError,msg:`errcode:${rs.res},运行记录页面，设置最大行数错误！`};
                        }
                        return {res:0};
                    }

                    /*!
    @Function    : init()
    @Description : 初始化行数,最大行数,清空listmode数据
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-21
*/
                    function init()
                    {
                        modelRunRecord.clear();
                        maxPage=0;
                        currentPage=0;
                        current=0;
                    }
                    //获取最大页数
                    /*!
    @Function    : getMaxPage()
    @Description : 获取最大页数
    @Author      : likun
    @Parameter   :
    @Return      : {res : 0 成功 , 非0 失败}
    @Output      :
    @Date        : 2024-08-21
*/
                    function getMaxPage()
                    {
                        var rs=cRunningModel.loadData(currentPage);
                        if(rs.res!==0)
                        {
                            return rs;
                        }
                        maxPage=rs.nPageCount;
                        return {res:0};
                    }
                    /*!
    @Function    : getCurrentPageData()
    @Description : 获取当前页面数据
    @Author      : likun
    @Parameter   :
    @Return      : {res : 0 成功 , 非0 失败}
    @Output      :
    @Date        : 2024-08-21
*/
                    function getCurrentPageData()
                    {
                        var rs=getMaxPage();
                        if(rs.res!==0)
                        {
                            return {res:ErrorCode.RunRecordGetMaxPageError,msg:`errcode:${rs.res},获取最大页数错误,错误码`};
                        }
                        var currentRowCount=cRunningModel.rowCount();
                        if(currentRowCount===0)
                        {
                            return {res:ErrorCode.RunRecordNoneNumberError,msg:"当前无数据"};
                        }
                        for(var i=0;i<currentRowCount;i++)
                        {
                            var row=cRunningModel.getRowJsonData(i);
                            row.index=root.current;
                            //console.log("row is :",JSON.stringify(row));
                            modelRunRecord.append(row);
                            root.current+=1;
                        }                       
                        view.positionViewAtIndex(0,ListView.atYBeginning);
                        return {res:0};
                    }

                    /*!
    @Function    : canForward()
    @Description : 是否允许向前翻页
    @Author      : likun
    @Parameter   :
    @Return      : bool true 是, false 否
    @Output      :
    @Date        : 2024-08-21
*/
                    function canForward()
                    {
                        if(currentPage==0)
                        {
                            return false;
                        }
                        if(currentPage>=maxPage-1)
                            currentPage=maxPage-2< 0 ? 0 :maxPage-2;
                        else
                            currentPage-=1;
                        return true;
                    }
                    /*!
    @Function    : toForward()
    @Description : 向前翻页
    @Author      : likun
    @Parameter   :
    @Return      : {res : 0 成功 , 非0 失败}
    @Output      :
    @Date        : 2024-08-21
*/
                    function toForward()
                    {
                        modelRunRecord.clear();
                        current=0;
                        var rs=getCurrentPageData();
                        if(rs.res!=0)
                        {
                            return rs;
                        }
                        return {res:0};
                    }

                    /*!
    @Function    : refresh()
    @Description : 刷新,向后端获取前一页数据
    @Author      : likun
    @Parameter   :
    @Return      : {res : 0 成功 , 非0 失败}
    @Output      :
    @Date        : 2024-08-21
*/
                    function refresh()
                    {
                        var rs;
                        if(canForward())
                        {
//                            console.error("canForward currentPage:",currentPage);
                            rs=toForward();
                            return rs;
                        }
                        init();
                        rs=getCurrentPageData();
                        if(rs.res!==0)
                        {
                            return rs
                        }

                        return {res:0};
                    }

                    /*!
    @Function    : loadMore()
    @Description : 翻页,向后端获取其他页数据
    @Author      : likun
    @Parameter   :
    @Return      : {res : 0 成功 , 非0 失败}
    @Output      :
    @Date        : 2024-08-21
*/
                    function loadMore()
                    {
                        if(canLoadMore())
                        {
                            //console.error("canLoadMore currentPage:",currentPage);
                            modelRunRecord.clear();
                            current=0;
                            var rs=getCurrentPageData();
                            if(rs.res!==0)
                            {
                                return rs;
                            }
                        }
                        return {res:0};
                    }

                    /*!
    @Function    : canLoadMore()
    @Description : 判断是否到最后一页
    @Author      : likun
    @Parameter   :
    @Return      : bool true 是  false 否
    @Output      :
    @Date        : 2024-08-21
*/
                    function canLoadMore()
                    {
                        if(currentPage>=maxPage-1)
                        {
                            return false;
                        }
                        currentPage+=1;
                        return true;
                    }
                }
                model: modelRunRecord
                delegate: recordDelegate
                spacing: 10
                Component
                {
                    id:recordDelegate
                    SingleRunRecord
                    {
                        id:singleRecord
                        MouseArea {
                            anchors.fill: parent
                            onClicked:
                            {
                                openCurRunPageType=publicDefine.openPageType.RunRecord;
                                console.debug(view.currentIndex);
                                parent.PullListRunRecord.view.currentIndex = parent.index;
                                openCurrentRunPage(parent.index);
                                //console.log("index:",parent.index);
                            }
                        }
                    }
                }
                Component
                {
                    id:cmpHeader
                    Rectangle
                    {
                        id:rectHeader
                        width: view.width
                        height: 48
                        color:"transparent"
                        Text {
                            id: txtHeader
                            text: view.headerHold?"正在刷新中...":""
                            font.family: "OPPOSans"
                            font.weight: Font.Medium
                            font.pixelSize: 24
                            color:"#FFFFFF"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 5
                        }
                    }
                }

                header: headerHold?cmpHeader:null
                onHeaderHoldChanged: {
                    if(headerHold)
                        timerRefresh.restart();
                }
                /*!
    @Function    : footText()
    @Description : 脚页文本
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-21
*/
                function footText()
                {
                    if(!view.footerHold)
                    {
                        footTextContent= "";
                        return;
                    }
                    if(currentPage < maxPage-1)
                    {
                        footTextContent= "正在加载中...";
                        return;
                    }
                    footTextContent = "已经是最后一页...";
                }
                Component
                {
                    id:cmpFooter
                    Rectangle
                    {
                        id:rectFooter
                        width: view.width
                        height: 78
                        color: "transparent"
                        Text {
                            id: txtFooter
                            text: footTextContent //view.footerHold?"正在加载中...":"";
                            font.family: "OPPOSans"
                            font.weight: Font.Medium
                            font.pixelSize: 24
                            color: "#FFFFFF"
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 22
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }

                footer:footerHold?cmpFooter:null
                onFooterHoldChanged:
                {
                    if(footerHold)
                    {
                        footText();
                        timerLoadMore.restart();
                    }
                }

                //刷新
                Timer
                {
                    id:timerRefresh
                    interval: 1500
                    onTriggered: {
                        var rs=modelRunRecord.refresh();
                        if(rs.res!==0)
                        {
                            showWarningPage(JSON.stringify(rs));
                        }
                        view.headerVisible=false;
                        if(view.atYBeginning)
                        {
                            //console.log("atYBegining",view.atYBeginning);
                            //view.interactive=true;
                            view.enabled=true;
                            //console.log("view.enabled:",view.enabled);
                            //console.log("view.interactive:",view.interactive);
                        }
                        //                        view.interactive=true;
                        view.enabled=true;
//                        view.contentY=0;
//                        view.contentHeight=view.height;
                    }
                }
                //加载
                Timer
                {
                    id:timerLoadMore
                    interval: 1500
                    onTriggered: {
                        var rs=modelRunRecord.loadMore();
                        if(rs.res!==0)
                        {
                            showWarningPage(JSON.stringify(rs));
                        }
                        view.footerVisible=false;
                        if(view.atYEnd)
                        {
                            //view.interactive=true;
                            view.enabled=true;
                        }
                        //                        view.interactive=true;
                        view.enabled=true;
//                        view.contentY=0;
//                        view.contentHeight=view.height;
                    }
                }
                onEnabledChanged:
                {
                    if(!view.enabled)
                    {
                        console.log("*********view is disenable !")
                        timerViewEnable.restart();
                    }
                }

                Timer
                {
                    id:timerViewEnable
                    interval: 2500
                    running: false;
                    repeat: false;
                    onTriggered:
                    {
                        view.enabled=true;
                        console.log("*********view is enable !**********");
                    }
                }

                ScrollBar.vertical: ScrollBar
                {
                    id:scrollbar
                    width:16
                    height:view.height
                    policy:ScrollBar.AlwaysOn
                    background:Rectangle
                    {
                        id:backRect
                        width:10
                        height:378
                        color:"#2C2C2C"
                        anchors.horizontalCenter:parent.horizontalCenter
                    }
                    contentItem:Rectangle
                    {
                        id:faceRect
                        height:scrollbar.height
                        color:"#D9D9D9"
                        radius:8
                    }
                }
                //当前只有一页时，造成无法拖动
                //boundsBehavior: Flickable.OvershootBounds
            }

        }

    }
    Component.onCompleted:
    {
        refreshModel();
    }

    function refreshModel()
    {
        var rs=modelRunRecord.setRowInPage();
        if(rs.res!==0)
        {
            showWarningPage(JSON.stringify(rs));
            return;
        }
        rs=modelRunRecord.refresh();
        if(rs.res!==0)
        {
            showWarningPage(JSON.stringify(rs));
            return;
        }
    }

    PublicDefine
    {
        id:publicDefine

    }
    /*!
    @Function    : openCurrentRunPage(index)
    @Description : 打开当前运行页面
    @Author      : likun
    @Parameter   : index int  索引
    @Return      :
    @Output      :
    @Date        : 2024-08-21
*/
    function openCurrentRunPage(index)
    {
        var accessDate=modelRunRecord.get(index)["textDate"];
        var iTestID = cRunningModel.data(cRunningModel.index(index, 0));
        recordPage.sigOpenCurRunPage(publicDefine.openPageType.RunRecord, accessDate, index, iTestID);
    }

    //显示提示页面
    function showWarningPage(msg)
    {

    }
}
