/******************************************************************************/
/*! @File        : HomeSpeedShow.qml
 *  @Brief       : 简要说明
 *  @Details     : 详细说明
 *  @Author      : han
 *  @Date        : 2024-08-13
 *  @Version     : v1.0
 *  @Copyright   : Copyright By yongrenxing, All Rights Reserved
 *
 **********************************************************
 *
 *  @Attention   :速度显示及背景控制
 *  @par 修改日志:
 *  <table>
 *  <tr><th>Date       <th>Version   <th>Author    <th>Description
 *  <tr><td>2024-08-13 <td>1.0       <td>xxx     <td>创建初始版本
 *  </table>
 *
 **********************************************************
*/

import QtQuick 2.12
import QtQuick.Controls 2.4
import "../mainFrame/subpage"
Item {
    id: carItem
    width: 500
    height: 500

    antialiasing: true

    property int iSpeedRangeMin: 4000 //正常最小值
    property int iSpeedRangeMax: globalMaxMotorSpeed //正常最大值

    // 背景圆弧线宽
    property int btm_lineWidth: 30
    // 背景圆弧颜色
    property color btm_backgroundColor: Qt.rgba(255, 255, 255, 0.1);
    // 背景圆弧半径 开始角度 结束角度
    property int btm_r: 40
    property double btm_startAngle: 0
    property double btm_endAngle: 90  //90


    onBtm_lineWidthChanged: canvas.requestPaint()
    onBtm_backgroundColorChanged: canvas.requestPaint()
    onBtm_rChanged: canvas.requestPaint()
    onBtm_startAngleChanged: canvas.requestPaint()
    onBtm_endAngleChanged: canvas.requestPaint()

    onISpeedRangeMinChanged: cvsSpeedRange.requestPaint()
    onISpeedRangeMaxChanged: cvsSpeedRange.requestPaint()

    // 顶层圆弧线宽
    property int top_lineWidth: 3
    // 顶层圆弧颜色
    property color top_backgroundColor: "lightgreen"
    // 顶层圆弧半径 开始角度 结束角度
    property int top_r: 20
    property double top_startAngle: 0
    property double top_endAngle_setting: 120
    property double top_endAngle_current: 90
    property int maxSpeed: globalMaxMotorSpeed

    onTop_lineWidthChanged: canvas.requestPaint()
    onTop_backgroundColorChanged: canvas.requestPaint()
    onTop_rChanged: canvas.requestPaint()
    onTop_startAngleChanged: canvas.requestPaint()
    onTop_endAngle_settingChanged: canvas.requestPaint()
    onTop_endAngle_currentChanged: canvas.requestPaint()

    //property int iValueDiff: 10  //与真实值之间差值
    //内部渐变圆
    property int iInner_Gradent_Circle_R: 82
    property color cInner_Gradent_Circle_inner_color: "#0F1214"
    property color cInner_Gradent_Circle_Mid_color: "#1A1F20"
    property color cInner_Gradent_Circle_Outer_color: "#27322F"
    //画背景内虚线圆

    property int inner_DashCircle_R: 105
    property color inner_DashColor:  "#40665F"  //Qt.rgba(33,51,49,1)
    property int inner_DashLineLenght: 2
    property int inner_DashLineSpace: 5
    property int inner_DashLineWidth: 2
    //画背景外虚线圆
    property int outer_DashCircle_R: 72
    property color outer_DashColor:  "#292B2B"//Qt.rgba(15,26,24,1)
    property int outer_DashLineLenght: 3
    property int outer_DashLineSpace: 5
    property int outer_DashLineWidth: 2

    //横线圆
    property int lineAcitveAngle: 30
    property int line_Circle_R: 24
    property color line_CircleLowerColor:  "#15BE9E"//Qt.rgba(15,26,24,1)
    property color line_CircleActiveLowColor:  "#18CFAC"//Qt.rgba(15,26,24,1)
    property color line_CircleActiveHighColor:  "#19584C"//Qt.rgba(15,26,24,1)
    property color line_CircleBackColor: "#292B2B" // "#1A1A1A"//Qt.rgba(15,26,24,1)
    property int line_Circle_lowR: 19
    property int line_Circle_lowg: 59
    property int line_Circle_lowb: 55
    property int line_Circle_highR: 25
    property int line_Circle_highg: 182
    property int line_Circle_highb: 151
    property int line_CircleLineLenght: 27
    //property int line_CircleLineSpace: 5
    property int line_CircleLineSWidth: 2
    property int line_CircleLineSCount: 180

    //感兴趣区域
    property int rectAcive_circle_R: 6
    property color rectAcive_circle_Color: "#004538"

    //白色实时值标线
    property int rectValue_White_Line_R: -4
    property int rectValue_White_Line_Width: 2
    property int rectValue_White_Line_Lenght: 34
    property color rectValue_White_Line_Color: "#FFFFFF"

    //内部实时值指示
    property int rectValue_White_sign_R: 3
    property int rectValue_White_sign_Height: 5

    //外部数据值指示
    property int rectValue_Green_sign_R: 8
    property int rectValue_Green_sign_Height: 5
    property color rectValue_Green_sign_Color: "#00D7AD"

    //外部字体
    property int rectValue_Font_sign_R: 28
    property int rectValue_Font_size: 50

    // 刻度盘
    property color dial_color:  "#094E57"//"#1A1A1A"
    property int dial_lineWidth: 2
    property int dial_addR: 2          // 通过调整该变量可以控制刻度盘圆弧与底层圆弧的距离
    property int dial_longNum: 12       // 刻度盘长刻度线的数量
    property int dial_longLen: 10      // 刻度盘长刻度线的长度
    property int realValue: globalDefMotorSpeed
    property int nPowerButtonR: 60
    property int  nTriangleSize: 18
    property  bool  bModifingRealSpeed: false

//    Connections{
//        target: mainWindow
//        function onSignalRequestPaint(){
//            canvas.requestPaint()
//        }
//    }

    Rectangle {
        id: txtShowValue
        x: 0
        y: 0
        width: 100
        height: 30
        //外圈显示的设置目标速度
        Text{
            id: txtValue
            font.family: "Quicksand"
            font.pixelSize: mainWindow.bModifySpeed ? 50:35//35: 32
            color:  mainWindow.bModifySpeed ? "#FFFFFF" :  Qt.lighter(rectValue_Green_sign_Color)
            font.weight: (mainWindow.bModifySpeed === true) ? Font.Bold : Font.Normal
            text: qsTr("text")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: parent.verticalCenter;
            anchors.horizontalCenter: parent.horizontalCenter;
            antialiasing: true
        }
        //外圈显示的设置前引符号
        Text{
           id: txtTail
           text: "◀"
           visible: !mainWindow.bModifySpeed
           font.family: "Quicksand"
           font.pixelSize: 8
           color: mainWindow.bModifySpeed ? "black" : "#234F47"
         //          ((mainWindow.pgCurIndex ==0 && mainWindow.iSubPageSelectIndex == 0 &&  !mainWindow.bSubComConfirmed) ? "white":"#234F47")
           anchors.verticalCenter: parent.verticalCenter;
           anchors.right: txtValue.left
           antialiasing: true
        }

        //外圈显示的设置后引符号
        Text{
            id: txtHeard
            text: "▶"
            visible: !mainWindow.bModifySpeed
            font.family: "Quicksand"
            font.pixelSize: 8
            color: mainWindow.bModifySpeed ? "black" : "#234F47"
       //             ((mainWindow.pgCurIndex ==0 && mainWindow.iSubPageSelectIndex == 0 &&  !mainWindow.bSubComConfirmed) ? "white":"#234F47")
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: txtValue.right
            antialiasing: true
        }
        antialiasing: true
        radius: 4
        color: /*(mainWindow.pgCurIndex ==0 && mainWindow.iSubPageSelectIndex == 0 && mainWindow.bSubComConfirmed) ? "#C2FFF3":*/ "transparent"
    }


    onDial_colorChanged: canvas.requestPaint()
    onDial_lineWidthChanged: canvas.requestPaint()
    onDial_addRChanged: canvas.requestPaint()
    onDial_longNumChanged: canvas.requestPaint()
    onDial_longLenChanged: canvas.requestPaint()
    onRealValueChanged: canvas.requestPaint()
    // 更新速度字符显示位置
    function updateLoginSpeedText(){

        txtValue.text = realValue ;

        //console.debug(iValueDiff);
        var iConnrectValueAngle = carItem.btm_startAngle + (carItem.btm_endAngle - carItem.btm_startAngle)/ maxSpeed * realValue;

        txtShowValue.x = (carItem.width/2) - txtShowValue.width/2  + (carItem.top_r + rectValue_Font_sign_R /*+ txtShowValue.width/2*/ ) * Math.cos(iConnrectValueAngle/180*Math.PI);
        txtShowValue.y = (carItem.width/2) - txtShowValue.height/2 + (carItem.top_r + rectValue_Font_sign_R /*+ txtShowValue.height/2*/) * Math.sin(iConnrectValueAngle/180*Math.PI);
        txtShowValue.rotation = iConnrectValueAngle + 90 ;
        //txtShowValue.visible = true;

    }
    //绘制转速范围半透明弧线
    Rectangle{
        id: rcSpeedRange
        color: "transparent"
        Canvas{
            id: cvsSpeedRange
            width: carItem.width
            height: carItem.height
            antialiasing: true
            onPaint: {
                var ctx = getContext("2d");

                ctx.clearRect(0, 0, canvas.width, canvas.height);
                ctx.save();               


                //感兴趣区域
                ctx.strokeStyle = "#47ACD8"; //"#04D7AC"; // "#028070";//line_CircleActiveHighColor; //"04D7AC";
                ctx.globalAlpha = 0.6;
                var iRealValueAngle = carItem.top_endAngle_setting;
                var activeMinValue = carItem.iSpeedRangeMin * (carItem.btm_endAngle - carItem.btm_startAngle) / maxSpeed;
                var activeMaxValue = carItem.iSpeedRangeMax * (carItem.btm_endAngle - carItem.btm_startAngle) / maxSpeed;
//                if(top_endAngle_setting > top_startAngle)
//                {
                    ctx.strokeStyle = "#028070"; // "#04D7AC"; // "#47ACD8";// rectAcive_circle_Color;
                    ctx.lineWidth = line_Circle_R + rectAcive_circle_R*2;
                    ctx.beginPath();
                    ctx.arc(carItem.width/2, carItem.width/2, carItem.top_r - ctx.lineWidth - 1, ((carItem.btm_startAngle + activeMinValue)/180*Math.PI), ((carItem.btm_startAngle + activeMaxValue)/180*Math.PI));
                    ctx.stroke();
                //
               // ctx.restore();
            }
        }
       // border.width: (mainWindow.pgCurIndex ===0 && mainWindow.iSubPageSelectIndex === 0) ? mainWindow.rotraySelectBorderWidth : 1;
       // border.color: (mainWindow.pgCurIndex ===0 && mainWindow.iSubPageSelectIndex === 0) ? mainWindow.rotraySelectRectColor : "black";
    }

    //任务启停止时处理与转速相关事件
    function startMotorRunning()
    {
        if(mainWindow.bPowerON === false)
        {
            if(m_RunningTestManager.canStartMotorUnderWarning() === false){
                if(!closePage.visible){
                    closePage.open(pubCode.messageType.Information, "有报警需要处理后启动", closePage.conMPNone);
                }
                return;
            }

            //在启动前保证电机、流量传感器、泵头是正确安装
            if(mainHeader.g_tbShowMotor.getClickState() === false)
            {
                closePage.open(pubCode.messageType.Information, "请先确认电机是否安装", closePage.conMPNone)
            }
            else if(mainHeader.g_tbShowFlowValue.getClickState() === false)
            {
                closePage.open(pubCode.messageType.Information, "请先确认流量传感器是否安装", closePage.conMPNone)
            }
            else if(mainHeader.g_tbShowPump.getClickState() === false)
            {
                closePage.open(pubCode.messageType.Information, "请先确认泵头是否安装", closePage.conMPNone)
            }
            else
            {
                if(m_motor.getSettingMotorSpeed() === 0) {
                    closePage.open(pubCode.messageType.Question, "未设置初始转速，确认以默认转速 2000RPM启动", closePage.conMPStartRunning);
                } else {
                    console.debug("requestWriteMotorState: Start motor")
                    mainWindow.bPowerON = true;
                    m_motor.setMotorStarted(true);
                    // 如果用户没有设定，默认转速为2000RPM
                    if(m_motor.getSettingMotorSpeed() === 0) {
                        m_motor.setSpeedDefault();
                    }
                    m_motor.requestCmd("Start")
                    //signalRequestPaint();
                }
            }
        } else {
            if(closePage.visible){
                return;
            }
            console.debug("carItem.realValue ", carItem.realValue);
            //if(carItem.realValue !== 0){
            if(!closePage.visible){
                closePage.open(pubCode.messageType.Question, "当前泵运行中，若泵停止将无法提供体外循环支持，确认停止？", closePage.conMPCloseRunning);
            }
            //  }
        }

        nTriangleSize = 20
    }

    //任务启停的屏幕处理事件
    MouseArea{
        id: mouseAreaPower
        width: 240
        height: 240

        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        onPressed: {
            nTriangleSize = 22
        }
        //鼠标按钮释放后处理任务启停操作
        onReleased: {
            if(mainWindow.bLocked === false)
            {
                if(!mainWindow.bPowerON){
                    startMotorRunning()
                }
                else{
                    if(m_RunningTestManager.isSIMULATION()){
                        startMotorRunning()
                    }
                }
            } else {
                m_RunningTestManager.playKeySound();
                popWindow.open("设备已锁定！", true);
            }
        }
        //鼠标进入时按钮显示
        onEntered: {
            nTriangleSize = 20
            canvas.requestPaint()
        }
        //鼠标离开时按钮显示
        onExited: {
            nTriangleSize = 18
            canvas.requestPaint()
        }
        //鼠标在按钮中移动处理
        onMouseXChanged:
        {
            nTriangleSize = 20
            canvas.requestPaint()
        }
        //鼠标在按钮中移动处理
        onMouseYChanged:
        {
            nTriangleSize = 20
            canvas.requestPaint()
        }
        //刷新按钮图片显示
        function updateCanasPaint(){
            canvas.requestPaint();
        }

        anchors.horizontalCenter: carItem.horizontalCenter
        anchors.verticalCenter: carItem.verticalCenter

        //连接主界面的启停按钮消息
        Connections{
            target: mainWindow
            function onKey_Start_Stop(){ //signal key_Start_Stop()
                startMotorRunning()
            }
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
    Connections{
        target: mainWindow
        //onBSubComConfirmedChanged: canvas.requestPaint();
        //更新速度变化时速度钮显示
        function onBModifySpeedChanged(){
            canvas.requestPaint();
        }
        //更新启停时速度显示
        function onBPowerONChanged(){
            canvas.requestPaint();
        }
    }

    Canvas {
        id: canvas
        width: carItem.width
        height: carItem.height
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d");

            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.save();

            //内部渐变圆
            ctx.lineWidth = 1;
            ctx.strokeStyle = cInner_Gradent_Circle_Outer_color;
            var grd= ctx.createRadialGradient(carItem.width/2, carItem.width/2, 0, carItem.width/2,carItem.width/2, carItem.top_r - iInner_Gradent_Circle_R);
            grd.addColorStop(0, cInner_Gradent_Circle_inner_color);
            grd.addColorStop(0.85, cInner_Gradent_Circle_Mid_color);
            grd.addColorStop(1, cInner_Gradent_Circle_Outer_color);

            ctx.fillStyle=grd;
            ctx.beginPath();
            ctx.arc(carItem.width/2, carItem.width/2, carItem.top_r - iInner_Gradent_Circle_R, 0, 2 * Math.PI);
            ctx.stroke();
            ctx.fill();

             //    //中心按钮
            if(!mainWindow.bPowerON)
            {
                ctx.lineWidth = 1;
                ctx.strokeStyle = cInner_Gradent_Circle_Outer_color;
                grd= ctx.createRadialGradient(carItem.width/2, carItem.width/2, 0, carItem.width/2,carItem.width/2, 60);
                grd.addColorStop(0, "#006551");
                grd.addColorStop(1, "#03987B");
                ctx.fillStyle=grd;
                ctx.beginPath();
                ctx.arc(carItem.width/2, carItem.width/2, 60, 0, 2 * Math.PI);
                ctx.stroke();
                ctx.fill();


                ctx.lineWidth = 1;
                ctx.strokeStyle = "#FFFFFF";
                ctx.fillStyle="#FFFFFF";
                ctx.beginPath();
                var tmp_r = nTriangleSize
                ctx.moveTo(carItem.width/2 + tmp_r *Math.cos(0), carItem.width/2 + tmp_r *Math.sin(0));
                ctx.lineTo(carItem.width/2 + tmp_r *Math.cos(120/180 * Math.PI), carItem.width/2 + tmp_r *Math.sin(120/180 * Math.PI));
                ctx.lineTo(carItem.width/2 + tmp_r *Math.cos(240/180 * Math.PI), carItem.width/2 + tmp_r *Math.sin(240/180 * Math.PI));
                //ctx.lineTo(carItem.width/2 + tmp_r *Math.cos(0), carItem.width/2 + tmp_r *Math.sin(0));
                ctx.stroke();
                ctx.fill();
            }

            //画背景内虚线圆
            ctx.lineWidth = inner_DashLineWidth;
            ctx.strokeStyle = inner_DashColor;
            ctx.lineDashOffset = 0;
            ctx.setLineDash([inner_DashLineLenght, inner_DashLineSpace]);
            ctx.beginPath();
            ctx.arc(carItem.width/2, carItem.width/2, carItem.top_r - inner_DashCircle_R, 0, 2*Math.PI);
            ctx.stroke();

            //画背景外虚线圆
            ctx.lineWidth = outer_DashLineWidth;
            ctx.strokeStyle = outer_DashColor;
            ctx.lineDashOffset = 0;
            ctx.setLineDash([outer_DashLineLenght, outer_DashLineSpace]);
            ctx.beginPath();
            ctx.arc(carItem.width/2, carItem.width/2, carItem.top_r - outer_DashCircle_R, 0, 2*Math.PI);
            ctx.stroke();

            ctx.setLineDash([1, 0]);

            var iRealValueAngle = carItem.top_endAngle_current;
            var activeMinValue = iSpeedRangeMin * (carItem.btm_endAngle - carItem.btm_startAngle) / maxSpeed;
            var activeMaxValue = iSpeedRangeMax * (carItem.btm_endAngle - carItem.btm_startAngle) / maxSpeed;

            //横线圆
            ctx.lineWidth = line_CircleLineSWidth;
            ctx.strokeStyle = line_CircleLowerColor;

            var iStep = -1;

            var tmp_step = (carItem.btm_endAngle-carItem.btm_startAngle)/line_CircleLineSCount;

            //计算低于当前值数量
            var tmp_nCount = Math.floor((carItem.top_endAngle_current - carItem.top_startAngle)/tmp_step);
            var tmp_rStep = (carItem.line_Circle_highR - carItem.line_Circle_lowR)/tmp_nCount;
            var tmp_gStep = (carItem.line_Circle_highg - carItem.line_Circle_lowg)/tmp_nCount;
            var tmp_bStep = (carItem.line_Circle_highb - carItem.line_Circle_lowb)/tmp_nCount;
            var tmp_curCount = 0
            for(var i=carItem.btm_startAngle;i<carItem.btm_endAngle+tmp_step;i+=tmp_step) {
                var tmp_x = (carItem.width/2)+(carItem.top_r - line_Circle_R)*Math.cos(i/180*Math.PI);
                var tmp_y = (carItem.width/2)+(carItem.top_r- line_Circle_R)*Math.sin(i/180*Math.PI);
                ctx.beginPath();
                if(top_endAngle_current == top_startAngle)
                {

                    ctx.strokeStyle = line_CircleBackColor;

                }
                else{
                    if(i < iRealValueAngle){

                        ctx.strokeStyle = Qt.rgba((carItem.line_Circle_lowR + tmp_rStep * tmp_curCount)/255,
                                                 (carItem.line_Circle_lowg + tmp_gStep * tmp_curCount)/255,
                                                  (carItem.line_Circle_lowb + tmp_bStep * tmp_curCount)/255, 1);
                        tmp_curCount ++ ;
                    }
                    else{
                       ctx.strokeStyle = line_CircleBackColor;
                    }
                }

                ctx.moveTo(tmp_x, tmp_y);
                // 绘制长刻度线
                ctx.lineTo(tmp_x-line_CircleLineLenght*Math.cos(i/180*Math.PI), tmp_y-(line_CircleLineLenght*Math.sin(i/180*Math.PI)));
                ctx.stroke();
            }


//            if(top_endAngle_current == top_startAngle)
//            {
//                ctx.restore();
//                return;
//            }

            // 画刻度盘
            ctx.lineWidth = carItem.dial_lineWidth;
            ctx.strokeStyle = carItem.dial_color;
            ctx.beginPath();
            ctx.arc(carItem.width/2, carItem.width/2, carItem.top_r, (carItem.btm_startAngle/180*Math.PI), (carItem.btm_endAngle/180*Math.PI));
            tmp_step = (carItem.btm_endAngle-carItem.btm_startAngle)/carItem.dial_longNum;
            for( i=carItem.btm_startAngle;i<carItem.btm_endAngle+tmp_step;i+=tmp_step) {
                tmp_x = (carItem.width/2)+carItem.top_r*Math.cos(i/180*Math.PI);
                tmp_y = (carItem.width/2)+carItem.top_r*Math.sin(i/180*Math.PI);
                ctx.moveTo(tmp_x, tmp_y);
                // 绘制长刻度线
                ctx.lineTo(tmp_x-carItem.dial_longLen*Math.cos(i/180*Math.PI), tmp_y-(carItem.dial_longLen*Math.sin(i/180*Math.PI)));
            }
            ctx.stroke();

            ctx.setLineDash([1, 0]);

            //var iRageValueCenter = (iSpeedRangeMax + iSpeedRangeMin) / 2 * (carItem.btm_endAngle - carItem.btm_startAngle) / maxSpeed;
            //白色实时值标线
            ctx.lineWidth = rectValue_White_Line_Width;
            ctx.strokeStyle = rectValue_White_Line_Color;
            ctx.beginPath();
            var tmp_white_r =line_Circle_R + rectValue_White_Line_R
            tmp_x = (carItem.width/2)+(carItem.top_r - tmp_white_r)*Math.cos((iRealValueAngle)/180*Math.PI);
            tmp_y = (carItem.width/2)+(carItem.top_r- tmp_white_r)*Math.sin((iRealValueAngle)/180*Math.PI);
            ctx.moveTo(tmp_x, tmp_y);
            // 绘制长刻度线
            ctx.lineTo(tmp_x-rectValue_White_Line_Lenght*Math.cos((iRealValueAngle)/180*Math.PI), tmp_y-(rectValue_White_Line_Lenght*Math.sin((iRealValueAngle)/180*Math.PI)));
            ctx.stroke();

            //内部实时值指示
            ctx.lineWidth = 1;
            ctx.strokeStyle = rectValue_White_Line_Color;
            ctx.beginPath();
            ctx.fillStyle = rectValue_White_Line_Color;
            tmp_white_r =line_Circle_R + line_CircleLineLenght + rectAcive_circle_R + rectValue_White_sign_R
            var tmp_rout = carItem.top_r - tmp_white_r;
            tmp_x = (carItem.width/2)+(tmp_rout)*Math.cos(iRealValueAngle/180*Math.PI);
            tmp_y = (carItem.width/2)+(tmp_rout)*Math.sin(iRealValueAngle/180*Math.PI);
            ctx.moveTo(tmp_x, tmp_y);
            var tmp_v = tmp_rout - rectValue_White_sign_Height;
            var tmp_angle = Math.atan(rectValue_White_sign_Height * Math.tan(30 / 180 * Math.PI) / tmp_v) / Math.PI * 180;
             tmp_r = tmp_v/Math.cos(tmp_angle/180 *Math.PI);

            var tmp_x1 = (carItem.width/2) + tmp_r*Math.cos((iRealValueAngle + tmp_angle)/180*Math.PI);
            var tmp_y1 = (carItem.width/2) + tmp_r*Math.sin((iRealValueAngle + tmp_angle)/180*Math.PI);
            ctx.lineTo(tmp_x1, tmp_y1);
            tmp_x1 = (carItem.width/2) + tmp_r*Math.cos((iRealValueAngle - tmp_angle)/180*Math.PI);
            tmp_y1 = (carItem.width/2) + tmp_r*Math.sin((iRealValueAngle - tmp_angle)/180*Math.PI);
            ctx.lineTo(tmp_x1, tmp_y1);
            ctx.stroke();
            ctx.fill();

//            if(!mainWindow.bPowerON)
//                return;
            // 画实时圆弧

            var iConnrectValueAngle = carItem.btm_startAngle + (carItem.btm_endAngle - carItem.top_startAngle)/ maxSpeed * carItem.realValue;

            if(bModifingRealSpeed){

                ctx.lineWidth = 8;
                ctx.strokeStyle = "white";
                ctx.beginPath();
                //ctx.lineJoin = Qt.RoundJoin
                ctx.lineCap = "round";
                ctx.arc(carItem.width/2, carItem.width/2, carItem.top_r, (carItem.top_startAngle/180*Math.PI), (iConnrectValueAngle/180*Math.PI));
                //ctx.arc(carItem.width/2, carItem.width/2, carItem.top_r-5, (carItem.top_endAngle/180*Math.PI), (carItem.top_startAngle/180*Math.PI), true);
                ctx.stroke();
            }
            else{
                grd = ctx.createLinearGradient(carItem.width/2 + carItem.top_r * Math.cos(carItem.top_startAngle/180*Math.PI),
                                               carItem.width/2 + carItem.top_r * Math.sin(carItem.top_startAngle/180*Math.PI),
                                               carItem.width/2 + carItem.top_r * Math.cos(iConnrectValueAngle/180*Math.PI),
                                               carItem.width/2 + carItem.top_r * Math.sin(iConnrectValueAngle/180*Math.PI));

                grd.addColorStop(0, mainWindow.bModifySpeed ? Qt.lighter("#013228") : "#013228");
                grd.addColorStop(1, mainWindow.bModifySpeed ? Qt.lighter("#03987B") :"#03987B");

                //ctx.fillStyle = grd;
                ctx.lineWidth = 8;
                //               ctx.capStyle = Qt.RoundCap
                //               ctx.joinStyle = Qt.RoundJoin
                ctx.strokeStyle = grd;
                ctx.beginPath();
                //ctx.lineJoin = Qt.RoundJoin
                ctx.lineCap = "round";
                ctx.arc(carItem.width/2, carItem.width/2, carItem.top_r, (carItem.top_startAngle/180*Math.PI), (iConnrectValueAngle/180*Math.PI));
                //ctx.arc(carItem.width/2, carItem.width/2, carItem.top_r-5, (carItem.top_endAngle/180*Math.PI), (carItem.top_startAngle/180*Math.PI), true);
                ctx.stroke();
                //ctx.fill();
            }
            ctx.lineCap = "butt"  //"square"
            //外部实时值指示
            ctx.lineWidth = 1;
            ctx.strokeStyle = rectValue_Green_sign_Color;
            ctx.beginPath();
            ctx.fillStyle = rectValue_Green_sign_Color;
            tmp_white_r =rectValue_Green_sign_R
            tmp_rout = carItem.top_r + tmp_white_r;
            tmp_x = (carItem.width/2)+(tmp_rout)*Math.cos(iConnrectValueAngle/180*Math.PI);
            tmp_y = (carItem.width/2)+(tmp_rout)*Math.sin(iConnrectValueAngle/180*Math.PI);
            ctx.moveTo(tmp_x, tmp_y);
            tmp_v = tmp_rout + rectValue_Green_sign_Height;
            tmp_angle = Math.atan(rectValue_Green_sign_Height * Math.tan(30 / 180 * Math.PI) / tmp_v) / Math.PI * 180;
            tmp_r = tmp_v / Math.cos(tmp_angle/180 *Math.PI);

            tmp_x1 = (carItem.width/2) + tmp_r*Math.cos((iConnrectValueAngle + tmp_angle)/180*Math.PI);
            tmp_y1 = (carItem.width/2) + tmp_r*Math.sin((iConnrectValueAngle + tmp_angle)/180*Math.PI);
            ctx.lineTo(tmp_x1, tmp_y1);
            tmp_x1 = (carItem.width/2) + tmp_r*Math.cos((iConnrectValueAngle - tmp_angle)/180*Math.PI);
            tmp_y1 = (carItem.width/2) + tmp_r*Math.sin((iConnrectValueAngle - tmp_angle)/180*Math.PI);
            ctx.lineTo(tmp_x1, tmp_y1);
            ctx.stroke();
            ctx.fill();

            //ctx.save();

            //               ctx.strokeStyle = rectValue_Green_sign_Color;
            //               ctx.fillStyle = rectValue_Green_sign_Color;
            //               //ctx.lineWidth = 10;
            //               ctx.font = "28px Source Quicksand";
            //              // ctx.font.pixelSize = rectValue_Font_size;
            //               ctx.beginPath();
            //               ctx.textAlign = "center";
            //               //ctx.rotate(-Math.PI / 20);
            //               ctx.fillText(realValue, (carItem.width/2) + (carItem.top_r + rectValue_Font_sign_R) * Math.cos(iConnrectValueAngle/180*Math.PI),
            //                            (carItem.width/2) + (carItem.top_r + rectValue_Font_sign_R) * Math.sin(iConnrectValueAngle/180*Math.PI));

            ///               //ctx.translate(-50, -50);
            ctx.stroke();



        }
    }

    //速度变化速显示刷新
    Connections{
        target: carItem
        function onRealValueChanged(){
            bModifingRealSpeed = true;
            canvas.requestPaint();
            tmrDelayCloseModifySpeedStatus.restart();
        }
    }

    //延时刷新速度显示
    Timer{
        id: tmrDelayCloseModifySpeedStatus;
        interval: 500
        onTriggered: {
            bModifingRealSpeed = false;
            canvas.requestPaint();
        }
    }
}

