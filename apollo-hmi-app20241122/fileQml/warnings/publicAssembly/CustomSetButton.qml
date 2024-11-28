import QtQuick 2.15
import QtQuick.Controls 2.5
//import QtQuick.Layouts 1.1

/*! @File        : CustomSetButton.qml
 *  @Brief       : 警报设置页面,  自定义添加或减少的抽象按钮
 *  @Author      : likun
 *  @Date        : 2024-08-22
 *  @Version     : v1.0
*/
Rectangle {
    required property string imgSource;//图标路径
    property string releaseColor:"#4B5D59";
    property string pressColor:"#0D8F77"
    required property real stepValue;
    /*!
    @Function    : changeValues(real value);
    @Description : 更改值信号
    @Author      : likun
    @Parameter   : value real 值
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    signal  changeValues(real value);
    id:rectCustomsetBtn
    width: 170
    height: 60
    color:rectCustomsetBtn.releaseColor
    border.color: "#1E8E79"
    border.width: 2
    radius: 4
    states: [
        State {
            name: "press"
            PropertyChanges {
                target: rectCustomsetBtn;color:rectCustomsetBtn.pressColor;border.color: rectCustomsetBtn.pressColor}
        },
        State {
            name: "release"
            PropertyChanges {
                target: rectCustomsetBtn;color:rectCustomsetBtn.releaseColor;border.color: "#1E8E79"}
        }
    ]
    state: "release"

    Image
    {
        id: img
        source: rectCustomsetBtn.imgSource
        anchors.centerIn: parent
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
    }
    /*!
    @Function    : btnClicked()
    @Description : 按钮点击
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    //function btnClicked(){
    //    rectCustomsetBtn.changeValues(rectCustomsetBtn.setpValue);
    //}

    MouseArea
    {
        id:mouseArea
        anchors.fill: parent
        onPressed:
        {
            rectCustomsetBtn.state="press";
        }
        onReleased:
        {
            rectCustomsetBtn.state="release";
        }

        onClicked:
        {                       
            rectCustomsetBtn.enabled=false;
            rectCustomsetBtn.changeValues(rectCustomsetBtn.setpValue);
            btnTimer.start();
        }
    }
    Timer
    {
        id:btnTimer
        interval: 200
        repeat: false
        running: false
        onTriggered:
        {
            rectCustomsetBtn.enabled=true;
            btnTimer.stop();
        }
    }
}
