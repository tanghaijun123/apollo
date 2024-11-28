import QtQuick 2.15
/*! @File        : PullListRunRecord.qml
 *  @Brief       : listview 模版
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
ListView {
    id:listView
    readonly property int  headerHeight: 60;
    readonly property int  footerHeight: 60;
    property bool headerVisible: false;
    property bool footerVisible: false;
    property bool headerHold: false;
    property bool footerHold: false;
    
    enum MoveDirection
    {
        NoMove,
        UpToDown,
        DownToUp
    }
    property int moveDirection: PullListRunRecord.NoMove
    property real moveStartContentY: 0  //开始轻拂的坐标
    property var  moveDistance;//当前滑动距离
    property var  moveOffset;//针对起始位置便宜量

    onHeaderVisibleChanged:
    {

        if(!headerVisible) {headerHold = false}
    }
    onFooterVisibleChanged:
    {
        if(!footerVisible) {footerHold = false}
    }
    onContentYChanged: {
        if(dragging || flicking)
        {
            moveDistance=contentY-moveStartContentY;
            moveOffset=contentY-originY;
//            console.error("*****************headOne************************");
//            console.error("*************************moveDistance",moveDistance,"contentY",contentY,"moveStartContentY",moveStartContentY);
//            console.error("*************************moveOffset",moveOffset,"originY",originY);
//            console.error("*****************end************************");
            //contentY  可以轻拂的区域左上角Y坐标 向上轻拂100像素,则contentY增加100
            moveDirection = (contentY - moveStartContentY < 0) ? PullListRunRecord.UpToDown : PullListRunRecord.DownToUp //<0,则从上到下移动,否则从下到上移动
            //            console.log("onContentYChanged:",atYBeginning,moveDirection,headerVisible)
            switch(moveDirection){
            case PullListRunRecord.UpToDown:
            {
                if(atYBeginning)
                {
                    if(headerVisible)
                    {
                        listView.enabled=false;

                    }else if(footerVisible)
                    {
                        listView.enabled=false;
                    }
                    else if(!headerVisible&&Math.abs(moveDistance)>headerHeight)
                    {
                        headerVisible=true;
                        listView.contentY-=headerHeight;
                        listView.enabled=false;
                    }else
                    {
                        listView.enabled=true;
//                        moveStartContentY=0;
//                        contentY=0;
                    }

                }

            }break;
            case PullListRunRecord.DownToUp:{
                if(atYEnd)
                {
                    if(headerVisible)
                    {
                        listView.enabled=false;

                    }else if(footerVisible)
                    {
                        listView.enabled=false;
                    }else if(!footerVisible && /*Math.abs(moveDistance)>footerHeight*/moveOffset-(contentHeight-height)>footerHeight&&contentHeight>height)
                    {
                        footerVisible=true;
                        listView.contentY+=footerHeight;
                        listView.enabled=false;

                    }else
                    {
                        listView.enabled=true;
//                        moveStartContentY=0;
//                        contentY=0;
                    }

                }
            }break;
            default:break;
            }
            if(moveStartContentY<0)
                moveStartContentY=0;
//            console.error("*****************headTwo************************");
//            console.error("*************************moveDistance",moveDistance,"contentY",contentY,"moveStartContentY",moveStartContentY);
//            console.error("*************************moveOffset",moveOffset,"originY",originY);
//            console.error("*****************end************************");
        }
    }
    //限制内容拖动时的高度
    //   boundsBehavior: Flickable.DragAndOvershootBounds
    //    highlightFollowsCurrentItem:false
    //    highlightRangeMode:ListView.ApplyRange

    //    preferredHighlightBegin :0
    //    preferredHighlightEnd : 100

    focus: true

    //   snapMode:ListView.SnapOneItem

    //maximumFlickVelocity: 5
    //鼠标或手指拖动驱动的界面滚动
    onDraggingChanged:dragging ? pullStart() : pullEnd()

    //鼠标滚动驱动的view滚动
    onFlickingChanged: flicking ? pullStart() : pullEnd()



    function pullStart(){
        moveStartContentY = contentY

    }
    
    function pullEnd(){
        switch(moveDirection){
        case PullListRunRecord.UpToDown:{
            if(atYBeginning && headerVisible) {               
                headerHold = true;

            }else if(null != headerItem){
                headerVisible = false;
                headerHold=false;

            }
            
        }break;
        case PullListRunRecord.DownToUp:{
            if(atYEnd && footerVisible) {
                footerHold = true;

            }else if(null != footerItem){
                footerVisible = false;
                footerHold = false;

            }
        }break;
        default:break;
        }

        moveDirection = PullListRunRecord.NoMove
    }
    //    onOriginYChanged:
    //    {
    //        console.log("originy:",originY)
    //    }



}
