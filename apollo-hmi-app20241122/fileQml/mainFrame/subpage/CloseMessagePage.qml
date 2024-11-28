import QtQuick 2.15
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.5

/*! @File        : CloseMessagePage.qml
 *  @Brief       : 关闭页面
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/

Popup {
    property string textContent: "";
    property int msgType: 0
    signal sendClose();

    //enum: reciev close message postion
    readonly property int conMPNone: -1
    readonly property int conMPMainWindowClosing: 0
    readonly property int conMPStartRunning: 1
    readonly property int conMPCloseRunning: 2
    readonly property int conMPDonwloadCurRunningRecord: 3
    readonly property int conMPDonwloadCurRunningRecordDone: 4
    readonly property int conMPDonwloadWaringRecord: 5
    readonly property int conMPDonwloadWaringRecordDone: 6
    readonly property int conMPDonwloadActionRecord: 7
    readonly property int conMPDonwloadActionRecordDone: 8
    readonly property int conMPPowerOffHmi: 9
    readonly property int conInformNoTime: 10
    readonly property int conInformWait: 11


    property int closeMsgPos: conMPMainWindowClosing

    id:root
    x:355
    y:243-96
    closePolicy: Popup.NoAutoClose
    modal:true
    background: Rectangle
    {
        id:backRect
        width:570
        height:314
        radius:8
        color:"#272727"
        border.color:"#4B4B4B"
        border.width:2
    }
    visible: false
    onVisibleChanged:
    {
        if(visible)
        {

            if(conInformNoTime == closeMsgPos){
                btnAccess.visible =false;
                closeTimer.stop();
                countDown.stop();
            }
            else{
                //timeNumber=5;
                //countDown.start();
                //closeTimer.start();
                btnAccess.visible =true;
            }
        }


    }

    Text {
        id: txtContent
        text: ""
        font.family: "OPPOSans"
        font.weight: Font.Medium
        font.pixelSize: 30
        color:"#FFFFFF"

        anchors.top: parent.top
        anchors.topMargin: 90
        width: 560
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }
    Rectangle
    {
        id:btnCancel
        width: 168
        height: 64
        color: mouseCancel.pressed ? "#008E73" : "#404040"
        visible: !(root.msgType>0)
        radius: 4
        border.color: Qt.rgba(255,255,255,0.5)
        border.width: 2
        anchors.left: parent.left
        anchors.leftMargin: 75
        anchors.top: parent.top
        anchors.topMargin: 190
        Text {
            id: btnCancelText
            text: qsTr("返回")
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 24
            color:"#FFFFFF"
            anchors.centerIn: parent
        }

        MouseArea
        {
            id:mouseCancel
            anchors.fill: parent
            onReleased:
            {
                countDown.stop();
                closeTimer.stop();
                root.close();
            }

        }
    }
    Rectangle
    {
        id:btnAccess
        width: 168
        height: 64
        color: mouseConfirm.pressed ? "#008E73" : "#404040"
        radius: 4
        border.color: "#008E73"
        border.width: 2
        anchors.left: parent.left
        anchors.leftMargin: root.msgType > 0 ? 327-135:327
        anchors.top: parent.top
        anchors.topMargin: 190
        Text {
            id: btnAccessText
            text: qsTr("确认")
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 24
            color:"#FFFFFF"
            anchors.centerIn: parent
        }
        MouseArea
        {
            id:mouseConfirm
            anchors.fill: parent
            onReleased:
            {
                //if(root.msgType>0)
                //{
                    countDown.stop();
                    closeTimer.stop();
                    root.close();
                //}

                root.sendClose();
            }
        }
    }
    property int timeNumber: 5
    Timer
    {
        id:countDown
        interval: 1000
        triggeredOnStart: true
        repeat: true
        onTriggered:
        {
            if(conInformWait === root.closeMsgPos)
                txtContent.text= `${textContent}`;
            else
                txtContent.text= `${textContent} (${timeNumber}秒)`;

            if(timeNumber == 0) {
                root.close();
                countDown.stop();
            }
            timeNumber--;
        }
    }

    Timer
    {
        id:closeTimer
        interval: 5000
        onTriggered:
        {
            //root.close();
        }
    }

    /*!
    @Function    : open(curType=pubCode.messageType.Question,msg="",closePos int 位置)
    @Description : 打开关闭页
    @Author      : likun
    @Parameter   : curType int 关闭页面类型,msg string 提示语,closePos
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function open(curType=pubCode.messageType.Question,msg="",closePos= conMPNone)
    {
        root.msgType=curType;
        textContent=msg;
        root.closeMsgPos = closePos;
        root.visible=true;
        if(closeMsgPos === conInformNoTime){
            txtContent.text= textContent;
        }
        else{
            if(conInformWait === root.closeMsgPos)
            {
                timeNumber = 2;
                txtContent.text= `${textContent} `;
                btnAccess.visible = false
            } else {
                timeNumber = 5;
                txtContent.text= `${textContent} (${timeNumber}秒)`;
                btnAccess.visible = true
            }

            countDown.restart();
            closeTimer.restart();
        }
    }

}
