import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
//import "../publicAssembly"
import "./subcontrol"
import "../../../../mainFrame/subcontral"
import "../../../../mainFrame/assembly"

/*! @File        : OperationDetailsPage.qml
 *  @Brief       : 操作记录页面
 *  @Author      : likun
 *  @Date        : 2024-08-21
 *  @Version     : v1.0
*/

Rectangle
{

    enum Positions
    {
        Down,
        Up
    }
    property string footTextContent: "";
    readonly property int rowNumbers: 20;//一页最大行数
    property int maxPage: 0;//最大页数
    property int currentPage: 0;//当前页数
    id:root
    width: 916
    height: 432
    color:"#3D3D3D"
    ColumnLayout
    {
        id:rootLay
        anchors.fill: parent
        spacing: 0
        TitleControl
        {
            id:titleOperationRecord
            Layout.alignment: Qt.AlignLeft|Qt.AlignTop
            Layout.leftMargin : 24
            z:OperationDetailsPage.Up
        }
        Rectangle
        {
            id:rectRecords
            width: 874
            height: 368
            color: "transparent"
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin : 24
            ListModel
            {
                id:modelOperationRecord
                /*!
    @Function    : setRowInPage()
    @Description : 设置一页行数
    @Author      : likun
    @Parameter   :
    @Return      : {res: 0  成功, 非0, 失败}
    @Output      :
    @Date        : 2024-08-21
*/
                function setRowInPage()
                {
                    var rs=cTestingModel.setRowsPerPage(rowNumbers);
                    if(rs.res!==0)
                    {
                        return {res:ErrorCode.OperationRecordSetMaxRowError,msg:`errcode:${rs.res},操作记录页面，设置最大行数错误！`}
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
                    modelOperationRecord.clear();
                    maxPage=0;
                    currentPage=0;
                }

                /*!
    @Function    : getMaxPage()
    @Description : 获取最大页数
    @Author      : likun
    @Parameter   :
    @Return      : {res:0 成功,非0 失败}
    @Output      :
    @Date        : 2024-08-21
*/
                function getMaxPage()
                {
                    var rs=cTestingModel.loadData(currentPage);
                    if(rs.res!==0)
                    {
                        return rs;
                    }
                    maxPage=rs.nPageCount;
                    console.log("************maxPage:",maxPage,"rs.nPageCount:",rs.nPageCount);
                    return {res:0};
                }
                /*!
    @Function    : getCurrentPageData()
    @Description : 获取当前页面数据
    @Author      : likun
    @Parameter   :
    @Return      : {res:0 成功,非0 失败}
    @Output      :
    @Date        : 2024-08-21
*/
                function getCurrentPageData()
                {
                    var rs=getMaxPage();
                    if(rs.res!==0)
                    {
                        return {res:ErrorCode.OperationRecordGetMaxPageError,msg:`errcode:${rs.res},获取最大页数错误!`};
                    }
                    var currentRowCount=cTestingModel.rowCount();
                    if(currentRowCount===0)
                    {
                        return {res:ErrorCode.OperationRecordNoneNumberError,msg:"当前无数据"};
                    }
                    for(var i=0;i<currentRowCount;i++)
                    {
                        modelOperationRecord.append(cTestingModel.getRowJsonData(i));
                    }
                    view.positionViewAtIndex(0,ListView.atYBeginning);
                    return {res:0};
                }

                /*!
    @Function    : canForward()
    @Description : 是否允许向前翻页
    @Author      : likun
    @Parameter   :
    @Return      : bool  true 允许, false 拒绝
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
    @Return      : {res: 0  成功, 非0  失败}
    @Output      :
    @Date        : 2024-08-21
*/
                function toForward()
                {
                    modelOperationRecord.clear();
                    var rs=getCurrentPageData();
                    if(rs.res!=0)
                    {
                        return rs;
                    }
                    return {res:0};
                }
                /*!
    @Function    : refresh()
    @Description : 刷新,向后端获取第一页数据
    @Author      : likun
    @Parameter   :
    @Return      : {res: 0  成功, 非0  失败}
    @Output      :
    @Date        : 2024-08-21
*/
                function refresh()
                {
                    var rs;
                    if(canForward())
                    {
 //                       console.error("canForward currentPage:",currentPage);
                        rs=toForward();
                        return rs;
                    }
                    init();
                    rs=getCurrentPageData();
                    return rs;
                }
                /*!
    @Function    : loadMore()
    @Description : 翻页,向后端获取其他页数据
    @Author      : likun
    @Parameter   :
    @Return      : {res: 0  成功, 非0  失败}
    @Output      :
    @Date        : 2024-08-21
*/
                function loadMore()
                {
                    if(canLoadMore())
                    {
 //                       console.error("canLoadMore currentPage:",currentPage);
                        modelOperationRecord.clear();
                        var rs=getCurrentPageData();
                        return rs;
                    }
                    return {res:0};
                }
                /*!
    @Function    : canLoadMore()
    @Description : 判断是否到最后一页
    @Author      : likun
    @Parameter   :
    @Return      : bool  true 是,false 否
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
            Component
            {
                id:delegateOperationRecord
                SingleOperationRecord{}

            }
            PullListRunRecord
            {
                id:view
                width: 838
                height: parent.height
                anchors.left: parent.left
                model: modelOperationRecord
                delegate: delegateOperationRecord
                spacing: 10
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

                header:headerHold?cmpHeader:null
                onHeaderHoldChanged: {
                    if(headerHold)
                        timerRefresh.restart();
                }
                /*!
    @Function    : footText()
    @Description : 页脚文本
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
                        return ;
                    }
                    if(currentPage < maxPage-1)
                    {
                        footTextContent= "正在加载中...";
                        return ;
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
                        var rs=modelOperationRecord.refresh();
                        if(rs.res!==0)
                        {
                            showWarningPage(JSON.stringify(rs));
                        }
                        view.headerVisible=false;
                        if(view.atYBeginning)
                        {
                            view.interactive=true;
                            view.enabled=true;
                        }
                        view.interactive=true;
                        view.enabled=true;
                    }
                }
                //加载
                Timer
                {
                    id:timerLoadMore
                    interval: 1500
                    onTriggered: {

                        var rs=modelOperationRecord.loadMore();
                        if(rs.res!==0)
                        {
                            showWarningPage(JSON.stringify(rs));
                        }

                        view.footerVisible=false;
                        if(view.atYEnd)
                        {
                            view.interactive=true;
                            view.enabled=true;
                        }
                        view.interactive=true;
                        view.enabled=true;
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
                    anchors.left:view.right
                    anchors.leftMargin:20
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
                        height:98
                        color:"#D9D9D9"
                        radius:8

                    }
                }
                //               boundsBehavior: Flickable.OvershootBounds
            }


        }
    }
    Component.onCompleted:
    {
        refreshModel();
    }

    function refreshModel()
    {
        var rs=modelOperationRecord.setRowInPage();
        if(rs.res!==0)
        {
            showWarningPage(JSON.stringify(rs));
            return;
        }
        rs=modelOperationRecord.refresh();
        if(rs.res!==0)
        {
            showWarningPage(JSON.stringify(rs));
            return;
        }
    }

    //显示提示页面
    function showWarningPage(msg)
    {
        //console.log(msg);

    }
}
