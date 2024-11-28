import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

/*! @File        : CustomBtn.qml
 *  @Brief       : ToolBar大图标按钮
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle
{
    id: rcBtn
    visible: true
    property bool buttonPressed: false
    property string normal_source: "";//按钮正常时图标
    property string down_source: "";//按钮按下时图标
    property color normal_bkcolor: "#FFFFFF"
    property color pressed_bkcolor: "#FFFFFF"
    property color disable_bkcolor: "#FFFFFF"
    property int nButtonWidth: parent.width
    property int nButtonHeight: parent.height
    color: normal_bkcolor
    radius: 4
    border.width: 1
    border.color: "#003E32"
    signal btnClicked(int nSteps)
    property int iCurAddSpeed: 10
    property int iMaxAddSpeed: 70
    property bool bAdded: false

    /*!
    @Function    : btnPressed()
    @Description : 按钮按下
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function btnPressed(){
        buttonPressed = true;
        color = pressed_bkcolor;
        iCurAddSpeed = 0;
        tmrPress.running = true;
        bAdded = false;
        mainWindow.bModifySpeedByKey = true;
    }
    /*!
    @Function    : Name
    @Description : btnReleased()
    @Author      : likun
    @Parameter   : 按钮释放
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function btnReleased(){
        buttonPressed = false;
        color = normal_bkcolor;
        tmrPress.running = false;
        mainWindow.bModifySpeedByKey = false;
        if(!bAdded){
            btnClicked(10);
        }
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        onPressed: {
            btnPressed();
        }
        onReleased: {
            btnReleased();
        }
        onEntered: {
            //border.width = 2
        }
        onExited: {
           // border.width = 1
        }
        onMouseXChanged:
        {
            //border.width = 2
        }
        onMouseYChanged:
        {
           // border.width = 2
        }
//        Timer{
//            id: msTimer
//            running: false
//            interval: 50
//            repeat: false
//            onTriggered: {
//                buttonPressed = false;
//                color = normal_bkcolor;
//                btnClicked();
//            }
//        }
//        function msClicked(){
//            buttonPressed = true;
//            color = pressed_bkcolor;
//            msTimer.running = true;
//        }
    }


    onEnabledChanged: {
        color = rcBtn.enabled ? normal_bkcolor : disable_bkcolor
    }

    Timer{
        id: tmrPress
        interval: 100
        repeat: true
        onTriggered: {
            bAdded = true;
            if(iCurAddSpeed < iMaxAddSpeed){
                iCurAddSpeed = iCurAddSpeed + 10;
            }
            else{
               iCurAddSpeed = iCurAddSpeed;
            }
            btnClicked(iCurAddSpeed);
        }
    }

    Image {
        id: btnImage
        width:   nButtonWidth
        height:  nButtonHeight
        source: buttonPressed ? down_source : normal_source
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    /*!
    @Function    : btnClick(state)
    @Description : 按钮点击
    @Author      : likun
    @Parameter   : state  int  状态
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function btnClick(state){
        if(state ===1)
        {
            btnPressed();
        }
        else if(state ===0)
        {
            btnReleased();
        }
    }

}
