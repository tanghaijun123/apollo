import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.2

/*! @File        : GradientToolBtn.qml
 *  @Brief       : ToolBar大图标按钮
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Button {
    id: rcRectID
    property string state_off_name: "";//按钮关闭时状态名称
    property string state_on_name:"";//按钮打开时状态名称
    property string state_off_source:"";//按钮关闭时,图片路径
    property string state_on_source:"";//按钮打开时,图片路径
    property color inner_color: "#FFFFFF"
    property color outer_color: "#FFFFFF"
    property bool isRepaint: true;
    property int  nButtonWidth: 42
    property int nButtonHeight: 42
    property int btn_id;//按钮id
    width: 84
    height: 84
    signal toolButtonClicked(bool down)
    Button
    {
        id: curBtn
        width: nButtonWidth
        height: nButtonHeight

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        checkable: true
        onClicked:
        {
            if(btn_id.state==state_off_name)
            {
                btn_id.state=state_on_name;
                toolButtonClicked(true);
            }
            else
            {
                btn_id.state=state_off_name;
                toolButtonClicked(false);
            }
            if(isRepaint)
                canvas.requestPaint();
        }
        background: Rectangle{
            id:btn_id
            state:state_off_name
            //anchors.fill:parent
            color: "transparent"
            states: [
                State {
                    name:state_off_name
                    PropertyChanges {
                        target: img
                        source:state_off_source
                    }
                },
                State {
                    name:state_on_name
                    PropertyChanges {
                        target: img
                        source:state_on_source
                    }
                }
            ]
            Image {
                id: img
                //anchors.fill: parent
                width: nButtonWidth
                height: nButtonHeight
                source: state_off_source
                anchors.centerIn: parent.Center
            }

        }
    }
    MouseArea{
        id: maGradientBtn
        anchors.fill: parent
        onClicked: {
            curBtn.clicked()
        }
    }


    background: Rectangle{
        id: bkRectangle
        radius: 4
        border.color: Qt.rgba(255,255,255,0.3)
        border.width: 1
        color:"#000000"
        opacity: 0.8
    }
    /*!
    @Function    : setClickState(bState)
    @Description : 设置点击状态
    @Author      : likun
    @Parameter   : bState bool 状态
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setClickState(bState)
    {
        if(bState){
            btn_id.state=state_off_name
        }
        else{
            btn_id.state=state_on_name
        }

    }
    /*!
    @Function    : setColor(strColor, nRadius)
    @Description : 设置颜色
    @Author      : likun
    @Parameter   : strColor string 颜色; nRadius int 圆角
    @Return      : 返回值说明
    @Output      :
    @Date        : 2024-08-25
*/
    function setColor(strColor, nRadius){
        btn_id.color = strColor;
        btn_id.radius = nRadius;
    }
    /*!
    @Function    : btnClick()
    @Description : 按钮点击
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function btnClick(){
        curBtn.clicked();
    }

}

