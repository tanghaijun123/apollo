import QtQuick 2.15
import QtQuick.Controls 2.15

/*! @File        : ToolBarBtn.qml
 *  @Brief       : ToolBar大图标按钮
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle
{
    id: rcID
    property string state_off_name: "";//按钮关闭时状态名称
    property string state_on_name:"";//按钮打开时状态名称
    property string state_off_source:"";//按钮关闭时,图片路径
    property string state_on_source:"";//按钮打开时,图片路径
    property real m_width;
    property real m_height;
    property int btn_id;//按钮id 
    property bool isEnable: true
    width: m_width
    height: m_height
    color:"transparent"
    signal toolButtonClicked(bool down)
    Button
    {
        id: curBtn
        anchors.fill:parent
        checkable: true
        enabled: rcID.isEnable
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
        }
        background: Rectangle{
            id:btn_id
            state:state_off_name
            anchors.fill:parent
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
                anchors.fill: parent
                source: state_off_source
            }          
        }
    }
    /*!
    @Function    : setState(stateName)
    @Description : 设置状态
    @Author      : likun
    @Parameter   : stateName string 状态名称
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setState(stateName)
    {
        btn_id.state=stateName;
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
            btn_id.state=state_on_name
        }
        else{
            btn_id.state=state_off_name
        }
    }
    /*!
    @Function    : getClickState()
    @Description : 获取点击状态
    @Author      : likun
    @Parameter   :
    @Return      : bool true false
    @Output      :
    @Date        : 2024-08-25
*/
    function getClickState()
    {
        if(btn_id.state === state_on_name){
            return true
        }
        else{
            return false
        }
    }
    /*!
    @Function    : setColor(strColor, nRadius)
    @Description : 设置颜色
    @Author      : likun
    @Parameter   : strColor string 颜色, nRadius int 圆角
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setColor(strColor, nRadius){
        btn_id.color = strColor;
        btn_id.radius = nRadius;
    }
}

