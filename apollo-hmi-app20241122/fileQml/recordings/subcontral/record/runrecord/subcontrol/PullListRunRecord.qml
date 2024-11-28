import QtQuick 2.15

ListView {
    id:listView
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
    
    onHeaderVisibleChanged: if(!headerVisible) {headerHold = false}
    onFooterVisibleChanged: if(!footerVisible) {footerHold = false}
    onContentYChanged: {
        if(dragging || flicking)
        {
            //contentY  可以轻拂的区域左上角Y坐标 向上轻拂100像素,则contentY增加100
            moveDirection = (contentY - moveStartContentY < 0) ? PullListRunRecord.UpToDown : PullListRunRecord.DownToUp //<0,则从上到下移动,否则从下到上移动
            //            console.log("onContentYChanged:",atYBeginning,moveDirection,headerVisible)
            switch(moveDirection){
            case PullListRunRecord.UpToDown:{
                //atYBeginning 轻拂位置位于开头,则为true
                if(atYBeginning && !headerVisible && !footerVisible) {
                    headerVisible = true
                }
            }break;
            case PullListRunRecord.DownToUp:{
                //atYEnd 轻拂位置位于结尾
                if(atYEnd && !headerVisible && !footerVisible) {
                    footerVisible = true
                }
            }break;
            default:break;
            }
        }
    }
    
    //鼠标或手指拖动驱动的界面滚动
    onDraggingChanged: dragging ? pullStart() : pullEnd()
    //鼠标滚动驱动的view滚动
    onFlickingChanged: flicking ? pullStart() : pullEnd()
    
    function pullStart(){
        console.log("pullStart")
        moveStartContentY = contentY
    }
    
    function pullEnd(){
        //        console.log("pullEnd:",atYBeginning,moveDirection,headerVisible,contentY - moveStartContentY)
        
        switch(moveDirection){
        case PullListRunRecord.UpToDown:{
            if(atYBeginning && headerVisible) {
                headerHold = true
            }else if(null !== headerItem){
                headerVisible = false
                headerHold = false
            }
            
        }break;
        case PullListRunRecord.DownToUp:{
            if(atYEnd && footerVisible) {
                footerHold = true
            }else if(null !== footerItem){
                footerVisible = false
                footerHold = false
            }
        }break;
        default:break;
        }
        
        moveDirection = PullListRunRecord.NoMove
    }
}
