import QtQuick 2.12
import QtQuick.Controls 2.5
//import QtGraphicalEffects 1.12

/*! @File        : CustomProcess.qml
 *  @Brief       : 自定义进度条
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Item{
    id: root
    property alias bgColor: __.bgColor
    property double processValue: parent.width > parent.height ? bar.value : 1-bar.value
    property bool canUpdateValue: false
    anchors.fill:parent
    /*!
    @Function    : updateValue();
    @Description : 更新值
    @Author      : likun
    @Parameter   :
    @Return      :
    @Date        : 2024-08-14
*/
    signal updateValue();
    QtObject{
        id: __
        property color bgColor: "#000000" //背景颜色
        property color processColor: "#E3E3E3"  //进度条前景
    }
    ProgressBar {
        id:bar
        value: 0
        width: parent.width > parent.height ? parent.width: parent.height
        height: parent.width > parent.height ? parent.height: parent.width
        rotation: parent.width > parent.height ? 0 : -90
        anchors.centerIn: parent

        contentItem: Rectangle {
            id:barBg
            Rectangle{
                anchors.fill: parent
                radius: 4 //bar.height/2
                color: __.bgColor
                opacity: 0.6
            }
            radius: 4 //bar.height/2
            layer.enabled: true
//            layer.effect: OpacityMask{
//                maskSource: Rectangle{
//                    width: barBg.width
//                    height: barBg.height
//                    radius: 4//bar.height/2
//                }
//            }
            Rectangle {
                id:forceRect
                width: bar.visualPosition * bar.width
                height: bar.height
                color: __.processColor

                Text {
                    id: _text
                    signal sendValueChange(var val);
                    text: Math.trunc(root.processValue * 100) + "%"
                    anchors.right:   forceRect.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin:12
                    font.family: "OPPOSans"
                    font.weight: Font.Medium
                    font.pixelSize: 26
                    color: '#000000'
                    visible: false
                }
            }
        }
    }



    MouseArea{
        id: mouse
        anchors.fill: parent
        QtObject{
            id: __p
            property var lastMousePos : undefined
            property bool directHor: true
            property bool valid: false
            readonly property int threshold: 5  //防误碰或点击阈值
            property int test: 0
        }
        // 处理鼠标按下事件
        onPressed: {
            //swipeView.interactive = false;
            __p.directHor = parent.width > parent.height ? true: false
            __p.lastMousePos = Qt.point(mouse.x, mouse.y)
        }
        // 处理鼠标移动事件
        onPositionChanged: {
            var point  = Qt.point(mouse.x, mouse.y)
            var curPos_ = __p.directHor ? point.x : point.y
            if( !__p.valid ){

                var tmp = __p.directHor ? __p.lastMousePos.x : __p.lastMousePos.y
                if( Math.abs(curPos_ - tmp) > __p.threshold )
                    __p.valid = true
            }
            else{
                if( curPos_ >=0 ){
                    var value = curPos_/(__p.directHor ? root.width : root.height)
                    if( !__p.directHor)
                        bar.value = 1-value
                    else
                        bar.value = value
                }
                else {
                    if( !__p.directHor)
                        bar.value = 1
                    else
                        bar.value = 0
                }
            }
            _text.sendValueChange(bar.value)
        }
        onReleased: {
            __p.valid = false
            //swipeView.interactive = true;
            updateValue();
        }
    }
    /*!
    @Function    : setPos(iPos)
    @Description : 设置位置
    @Author      : likun
    @Parameter   : iPos int 位置
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setPos(iPos){
        bar.value = iPos;
    }

    Connections
    {
        target: _text
        function onSendValueChange(val)
        {
            _text.x=val;
        }
    }
}
