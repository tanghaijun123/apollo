import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../publicAssembly"
import QtQuick.LocalStorage 2.15
//import "../../database/apolloSettingDB.js" as ApolloSettingDB
import pollo.SettingDB 1.0

/*! @File        : WarningSetControl.qml
 *  @Brief       : 警报设置页面,双向进度条控件
 *  @Author      : likun
 *  @Date        : 2024-08-22
 *  @Version     : v1.0
*/
Rectangle
{
    property real firstTextValueContent: 2.5
    property real secTextValueContent: 4.5
    property real fromValue: 0
    property real toValue: 8.0
    property int fixValue: 1
    property real stepValue:0.1
    property real betweenMaxAndMin: 0.1;//最大值与最小值之间的差距
    id: root
    width: 1220
    height: 60
    color: "transparent"
    //    border.color: "#FFFFFF"
    //    border.width: 1
    CustomSetButton //减按钮
    {
        id:btnSubtraction
        imgSource:"/images/icon_reduce.png"
        stepValue:root.stepValue
        anchors.left:parent.left
        anchors.leftMargin:0

    }
    /*!
    @Function    : onChangeValues(value)
    @Description : 接收更改值
    @Author      : likun
    @Parameter   : value real 值
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    Connections
    {
        target: btnSubtraction
        function onChangeValues(value)
        {
            if(rectFirst.state==="select" || rectFirst.state==="press")
            {
                if(control.first.value===control.from)
                {
                    return;
                }
                control.first.decrease();
                root.changeValue();
            }else if(rectSec.state==="select" || rectSec.state==="press")
            {
                if(control.second.value===control.first.value+betweenMaxAndMin)
                {
                    return;
                }
                control.second.decrease();
                if(control.second.value<=control.first.value+betweenMaxAndMin)
                {
                    control.second.value=control.first.value+betweenMaxAndMin;
                }
                root.changeValue();
            }
            //canvasface.requestPaint();
            console.debug("WarningSetControl", control.first.value, control.second.value)
        }
    }

    /*!
    @Function    : rangeSliderclick(int iIndex);
    @Description : 范围滑块点击信息
    @Author      : likun
    @Parameter   : ilndex 索引
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    signal rangeSliderclick(int iIndex);
    RangeSlider
    {
        id:control
        width:820
        height: 60
        from:root.fromValue
        to:root.toValue
//        live: false
//        snapMode: RangeSlider.SnapOnRelease
        first.value:root.firstTextValueContent
        second.value:root.secTextValueContent
        stepSize:root.stepValue//control.width/(control.to-control.from)*root.stepValue
        anchors.left: btnSubtraction.right
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 0
        first.onPressedChanged:
        {
            first.pressed===true?rectFirst.state="press":rectFirst.state="select";
            //rectFirst.state="select"
            rectSec.state="unPress";
            rangeSliderclick(0);
        }
        second.onPressedChanged:
        {
            second.pressed===true?rectSec.state="press":rectSec.state="select";
            rectFirst.state="unPress";
            rangeSliderclick(1);
        }

        first.onValueChanged:
        {
            if(first.value > second.value-betweenMaxAndMin)
            {
                first.value=second.value-betweenMaxAndMin;
            }
        }
        second.onValueChanged:
        {
            if(first.value+betweenMaxAndMin > second.value)
            {
                second.value=first.value+betweenMaxAndMin;
            }
        }

        background: Rectangle
        {
            id: rectBack
            width:control.availableWidth//control.width
            height:60//control.availableHeight//control.height
            color:"#B5B5B5"
            radius:4
            Canvas
            {
                id:canvasBack
                width: control.width
                height: control.height
                onPaint:
                {
                    var ctx=getContext("2d");
                    ctx.lineWidth=1;
                    ctx.strokeStyle="#000000";
                    ctx.fillStyle="#000000";
                    ctx.beginPath();
                    for(var i=41;i<control.width;i+=41)
                    {
                        ctx.moveTo(rectBack.x+i,rectBack.y+11);
                        ctx.lineTo(rectBack.x+i,rectBack.y+49);
                        ctx.closePath();
                        ctx.fill();
                        ctx.stroke();
                    }
                }
            }
        }
        Rectangle
        {
            id:rectFoce
            x:control.first.visualPosition*control.availableWidth
            width: control.second.visualPosition*control.availableWidth-x
            height: 60//control.availableHeight
            color:"#1A9079"
            radius:4
            Canvas
            {
                id:canvasface
                width: control.availableWidth
                height: 60
                onPaint:
                {
                    var ctx=getContext("2d");
                    ctx.clearRect(canvasface.x,canvasface.y,canvasface.width,canvasface.height);
                    ctx.lineWidth=3;
                    ctx.strokeStyle="#383838";
                    ctx.fillStyle="#383838";
                    ctx.beginPath();
                    for(var i=20;i<parent.width;i+=20)
                    {
                        ctx.moveTo(canvasface.x+i,0);
                        ctx.lineTo(canvasface.x+i,canvasface.y+60);
                        ctx.closePath();
                        ctx.fill();
                        ctx.stroke();
                    }
                }
            }
        }


        first.handle:Rectangle
        {
            id:rectFirst
            implicitWidth:36
            implicitHeight:114           
            color:"transparent"

            x:(control.first.visualPosition)*(control.availableWidth-width)//rectFirst.implicitWidth/2
            y:-20
            z:1
            states: [
                State {
                    name: "unPress"//未选中
                    PropertyChanges {
                        target: firstRectValue; width:82;height:30;anchors.leftMargin:-23;color:"transparent";
                    }
                    PropertyChanges {
                        target: firstImg; source:"/images/default_down.png";
                    }
                    PropertyChanges {
                        target: firstTextValue; font.weight:Font.DemiBold;font.pixelSize: 30;color:"#989898"
                    }
                },
                State {
                    name: "press"//按下                   
                    PropertyChanges {
                        //width:120;
                        //-38
                        target: firstRectValue;width:firstTextValue.contentWidth*1.5; height:firstTextValue.contentHeight/**1.2*/;color: /*"transparent"*/"#FFFFFF";radius:4
                    }
                    PropertyChanges {
                        target: firstImg; source:"/images/current_down.png";
                    }
                    PropertyChanges {
                        target: firstTextValue; font.weight:Font.DemiBold;font.pixelSize: 60;color:  /*"#FFFFFF"*/"#383838"
                    }
                },
                State {
                    name: "select"//选中
                    PropertyChanges {
                        target: firstRectValue; width:82;height:30;anchors.leftMargin:-23; color:"transparent";radius:4
                    }
                    PropertyChanges {
                        target: firstImg; source:"/images/current_down.png";
                    }
                    PropertyChanges {
                        target: firstTextValue; font.weight:Font.DemiBold;font.pixelSize: 40;color:"#FFFFFF"
                    }
                }
            ]
            state:"unPress"

            Image
            {
                id: firstImg
                source: "/images/default_down.png"
                width:36
                height: 114

            }
            Rectangle
            {
                id:firstRectValue
                width: 120
                height: 75
                color: "transparent"
                anchors.horizontalCenter: rectFirst.horizontalCenter
                anchors.top: rectFirst.bottom
                anchors.topMargin:     17
                Text {
                    id: firstTextValue
                    text: root.firstTextValueContent
                    color:"#FFFFFF"
                    font.family: "Quicksand"
                    font.weight: Font.DemiBold
                    font.pixelSize: 60
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

        }

        second.handle:Rectangle
        {
            id:rectSec
            implicitWidth:36
            implicitHeight:114
            color:"transparent"
            x:(control.second.visualPosition)*(control.availableWidth-width)//rectFirst.implicitWidth/2
            y:-40
            states: [
                State {
                    name: "unPress"//未选中
                    PropertyChanges {
                        target: secRectValue; width:82;height:30;anchors.leftMargin:-23; color:"transparent";
                    }
                    PropertyChanges {
                        target: imgSec; source:"/images/default_up.png";
                    }
                    PropertyChanges {
                        target: secTextValue; font.weight:Font.DemiBold;font.pixelSize: 30;color:"#989898"
                    }
                },
                State {
                    name: "press"//按下
                    PropertyChanges {
                        target: secRectValue; width:secTextValue.contentWidth*1.5;height:secTextValue.contentHeight/**1.2*/;anchors.leftMargin:-38; color: /*"transparent"*/"#FFFFFF";radius:4
                    }
                    PropertyChanges {
                        target: imgSec; source:"/images/current_up.png";
                    }
                    PropertyChanges {
                        target: secTextValue; font.weight:Font.DemiBold;font.pixelSize: 60;color: /*"#FFFFFF"*/ "#383838"
                    }
                },
                State {
                    name: "select"//选中
                    PropertyChanges {
                        target: secRectValue; width:82;height:30;anchors.leftMargin:-23; color:"transparent";radius:4
                    }
                    PropertyChanges {
                        target: imgSec; source:"/images/current_up.png";
                    }
                    PropertyChanges {
                        target: secTextValue; font.weight:Font.DemiBold;font.pixelSize: 40;color:"#FFFFFF"
                    }
                }
            ]
            state:"select"
            Image
            {
                id: imgSec
                source: "/images/button_slide(current)@2x.png"
                width:36
                height: 114
            }
            Rectangle
            {
                id:secRectValue
                width: 82
                height: 48
                color:rectSec.state=="press"?"#FFFFFF":"transparent"
                anchors.horizontalCenter: imgSec.horizontalCenter
                anchors.bottom: imgSec.top
                anchors.bottomMargin: 23
                Text
                {
                    id: secTextValue
                    text: root.secTextValueContent
                    color:"#FFFFFF"
                    font.family: "Quicksand"
                    font.weight: Font.DemiBold
                    font.pixelSize: 60
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
    Text {
        id: textLeft
        text: root.fromValue.toString()
        color:"#FFFFFF"
        opacity: 0.8
        font.family: "Quicksand"
        font.weight: Font.Normal
        font.pixelSize: 34
        anchors.left: control.left
        anchors.leftMargin: -textLeft.width/2
        anchors.top: control.bottom
        anchors.topMargin: -5
    }
    Text {
        id: textRight
        text: root.toValue.toString()
        color:"#FFFFFF"
        opacity: 0.8
        font.family: "Quicksand"
        font.weight: Font.Normal
        font.pixelSize: 34
        anchors.right: control.right
        anchors.rightMargin: -7
        anchors.top: control.bottom
        anchors.topMargin: -5
    }
    CustomSetButton
    {
        id:btnAdd
        imgSource: "/images/icon_button_plus@2x(2).png"
        stepValue: root.stepValue
        anchors.left: control.right
        anchors.leftMargin: 30
    }
    /*!
    @Function    : onChangeValues(value)
    @Description : 接收更改值
    @Author      : likun
    @Parameter   : value real 值
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    Connections
    {
        target: btnAdd
        function onChangeValues(value)
        {
            if(rectFirst.state==="select" || rectFirst.state==="press")
            {
                if(control.first.value===control.second.value-betweenMaxAndMin)
                {
                    return;
                }
                control.first.increase();
                changeValue();
            }else if(rectSec.state==="select" || rectSec.state==="press")
            {
                if(control.second.value===control.to)
                {
                    return;
                }
                control.second.increase();
                changeValue();
            }
        }
    }

    Component.onCompleted:
    {
        control.first.moved.connect(changeValue);
        control.second.moved.connect(changeValue);
    }
    signal valueChangedByMan();
    /*!
    @Function    : changeValue()
    @Description : 更改值
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    function changeValue()
    {
        console.debug("WarningSetcontrol changeValue")
        root.firstTextValueContent=control.first.value.toFixed(root.fixValue).toString();
        root.secTextValueContent=control.second.value.toFixed(root.fixValue).toString();
        canvasface.requestPaint();
        valueChangedByMan();
    }

    function saveParamValue(varName, paramMin, paramMax){
        console.debug("WarningSetcontrol saveParamValue", varName, paramMin, paramMax)
        var res = mainSettingDB.setParam(varName, paramMin, paramMax);
        if(res !== 0){
            //console.debug("save param value fail! error code: ", res);
        }
    }
    /*!
    @Function    : setFirstSelected()
    @Description : 设置第一个滑块的选择状态
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    function setFirstSelected()
    {
        rectFirst.state="select";
        //rectFirst.state="press"
        rectSec.state = "unPress"
    }
    /*!
    @Function    : setSecondSelected()
    @Description : 设置第二个滑块的选择状态
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    function setSecondSelected()
    {
        rectSec.state="select";
       // rectSec.state="press";
        rectFirst.state="unPress";
    }
    /*!
    @Function    : addValue(step)
    @Description : 加值
    @Author      : likun
    @Parameter   : step real 步进值
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    function addValue(step){
        if(step < 0){
            btnSubtraction.btnClicked();
        }
        else{
            btnAdd.btnClicked();
        }
    }
    /*!
    @Function    : setUnPressed()
    @Description : 设置未按下状态
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    function setUnPressed(){
        if(rectFirst.state === "press"){
            rectFirst.state = "select";
        }
        else if(rectSec.state === "press"){
            rectSec.state = "select";
        }
    }


    /*!
    @Function    : confirmSlid(bConfirmed)
    @Description : 确认滑块
    @Author      : likun
    @Parameter   : bConfirmed bool  true false
    @Return      :
    @Output      :
    @Date        : 2024-08-22
*/
    function confirmSlid(bConfirmed){
        if(bConfirmed === true){
            if(rectFirst.state == "select"){
                rectFirst.state = "press";
            }
            else if(rectSec.state === "select"){
                rectSec.state = "press";
            }
        }
        else{
            if(rectFirst.state === "press"){
                rectFirst.state = "select";
            }
            else if(rectSec.state === "press"){
                rectSec.state = "select";
            }
        }
    }
}
