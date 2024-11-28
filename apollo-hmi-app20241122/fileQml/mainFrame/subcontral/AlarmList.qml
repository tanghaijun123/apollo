import QtQuick 2.15
import QtQuick.Controls 2.5
import QtCharts 2.3
import "../assembly"
/*! @File        : AlarmList.qml
 *  @Brief       : 报警列表
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/

Rectangle
{
    readonly property real singleWarningHeight: 96 //单个警报高度
    readonly property real listHeight: 96*recordModel.count+8*2 //报警列表总高度
    readonly property real clearingButtonHeight: 60 // 清除报警按钮高度
    property bool haveAlarmText: false //是否存在报警记录
    property string firstAlarmText:"";// "! ! ! 电量过低"//文字框内容
    property int firstAlarmType:0;//警报类型 0:错误 1:警告
    property bool viewVisible: true
    property int numbers: 0;//报警的数量
    property var footHandle : null;
    readonly property int rowNumbers: 20;
    property int maxPage: 0;
    property int currentPage: 0;
    property alias recordModel: recordModel
    id:root
    width: 547
    height: singleWarningHeight
    color: "transparent"

    SerialNumber
    {
        id:serNumber
        z:9
        serialNumberTextContent:`${numbers}`
        serialNumberVisible: numbers>1
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 25
    }
    onNumbersChanged:
    {
        serNumber.serialNumberVisible=numbers>1
        if(numbers<=1)
        {
            pop.close();
        }
    }

    ListModel
    {
        id:recordModel
        //查询这个类型第一个index
        function findfirstTypeIndex(iWarningType: integer)
        {
            var iIndex = -1;

            var i = 0;
            for(i = 0; i < recordModel.count; i++){
                if(iWarningType <= recordModel.get(i).alarmType){
                    iIndex = i;
                    break;
                }
            }

            return iIndex;
        }

        //根据内容查找数据 true:存在数据;false:不存在数据
        function findItemByWarningTitle(strWarningTitle)
        {
            for(var i=0;i<recordModel.count;i++)
            {
                var data=recordModel.get(i).textDateContent;
                if(data===strWarningTitle)
                    return true;
            }
            return false;
        }

        //插入一行数据在listmode
        function appendItemByValue(strWarningName: string, iWarningType: int, strWarningTitle: string)
        {
            //如果该报警存在报警列表里，则不添加
            if(findItemByWarningTitle(strWarningTitle))
                return;

            var iIndex = findfirstTypeIndex(iWarningType);
            if(iIndex !== -1) {
                recordModel.insert(iIndex,{textDateContent:strWarningTitle,alarmType:iWarningType,alarmName:strWarningName});
            } else {
                recordModel.append({textDateContent:strWarningTitle,alarmType:iWarningType,alarmName:strWarningName});
            }

            numbers = recordModel.count;
        }
        //通过名称进行删除
        function removeItemByName(strName: string){
            var i=0;           
            for(i = 0; i < recordModel.count; i ++){
                if(recordModel.get(i).alarmName === strName){
                    recordModel.remove(i);
                    break;
                }
            }
            //numbers>1?numbers-=1:numbers=0;
            numbers= recordModel.count;
        }
        onCountChanged:
        {
            if(recordModel.count>0)
            {
                horAlarms.visible=true;
            }
            else
            {
                horAlarms.visible=false;
                myToolBar.closeMute();
            }

        }
    }
    ListView
    {
        id:horAlarms
        anchors.fill: parent
        model: recordModel
        orientation: ListView.Horizontal
        //must set
        highlightRangeMode: ListView.StrictlyEnforceRange
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        Component
        {
            id:delegateHorAlarm
            Alarm{}
        }
        delegate: delegateHorAlarm
        Timer
        {
            id:horTimer
            interval: 3000;running: true;repeat: true
            onTriggered:
            {
                var currentIndex=horAlarms.currentIndex;
                if(currentIndex<recordModel.count)
                {
                    horAlarms.currentIndex=currentIndex+1;
                }
                else
                {
                    horAlarms.currentIndex=0;
                }
            }
        }
        MouseArea
        {
            id:mouseArea
            anchors.fill: parent
            enabled: !mainWindow.bLocked
            onClicked:
            {
                pop.open();
                horAlarms.visible=false;
                btnClearWaring.visible = numbers > 0;
            }
        }
    }

    Popup
    {
        id:pop
        width:root.width
        height: listHeight + clearingButtonHeight
        margins:0
        padding:0
        visible: !mainWindow.bLocked

        z:2
        background: Rectangle
        {
            color:"transparent"
        }
        Component
        {
            id:delegateAlarm
            Alarm{}
        }
        Connections{
            target: m_RunningTestManager

            function onAppendWarningShow(strWarningName: string, iWarningType: int, strWarningTitle: string){
                //console.debug("AlarmList-warningName:", strWarningName, strWarningTitle)
                recordModel.appendItemByValue(strWarningName, iWarningType, strWarningTitle);                
            }

            function onRemoveWarningShow(strWarningName: string){
                recordModel.removeItemByName(strWarningName);
            }
        }
        ListView
        {
            id:verAlarms
            width:parent.width
            height: listHeight
            anchors.top: parent.top
            anchors.left: parent.left
            spacing: 8
            model: recordModel
            delegate: delegateAlarm
            boundsBehavior: Flickable.OvershootBounds|Flickable.StopAtBounds
            clip: true
            footer: recordModel.count>=4?lastFooter:null
            Component
            {
                id:lastFooter
                Rectangle
                {
                    id:rectFooter
                    width: verAlarms.width
                    height: 48
                    color: "transparent"
                    //footer与listview间隔
                    Rectangle
                    {
                        id:topRect
                        width: parent.width
                        height: 8
                        color:"transparent"
                    }
                    Rectangle
                    {
                        id:bottomRect
                        width: parent.width
                        height: 40
                        color: "#EBEBEB"
                        radius:4
                        anchors.top: topRect.bottom
                        Text {
                            id: txtFooter
                            text: "《"
                            rotation: 90
                            font.family: "OPPOSans"
                            font.weight: Font.Medium
                            font.pixelSize: 24
                            color: "#000000"
                            anchors.centerIn: parent
                        }
                        MouseArea
                        {
                            id:mouseFooter
                            anchors.fill: parent
                            onClicked:
                            {
                                verAlarms.currentIndex=0;
                                verAlarms.contentY = verAlarms.atYBeginning;
                            }
                        }
                    }
                }
            }
        }

        Button {
            id: btnClearWaring
            width: parent.width
            height: clearingButtonHeight
            anchors.top: verAlarms.bottom
            anchors.left: verAlarms.left
            text: "清除报警"
            font.family: "OPPOSans"
            font.weight: Font.Medium
            font.pixelSize: 24
            onClicked: {
                btnClearWaring.visible = false
            }

            onReleased: {
                m_RunningTestManager.clearWarnings(false);
                pop.close();
            }
        }

        Connections
        {
            target: pop
            function onClosed()
            {
                horAlarms.visible=recordModel.count>0;
            }
            function onOpened()
            {
                verAlarms.currentIndex=0;
                verAlarms.contentY=verAlarms.atYBeginning;
            }
        }
    }

    /*!
    @Function    : getNewCreatRecord()
    @Description : 获取新创建的报警记录
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function getNewCreatRecord()
    {
        var number=0;
        //...
        setNumber(number);
    }
    /*!
    @Function    : setAlarmTextContent(alarmTextContent)
    @Description : 设置报警内容
    @Author      : likun
    @Parameter   : alarmTextContent string 内容
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setAlarmTextContent(alarmTextContent)
    {
        firstAlarmText=alarmTextContent;
    }
    function setAlarmType(alarmType)
    {
        firstAlarmType=alarmType;
    }
    /*!
    @Function    : setNumber(number)
    @Description : 设置数量
    @Author      : likun
    @Parameter   : number int 数量
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setNumber(number)
    {
        numbers=number.toString();
    }
    /*!
    @Function    : setSerialNumberVisible(visible)
    @Description : 设置序号是否可见
    @Author      : likun
    @Parameter   : visible bool true false
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setSerialNumberVisible(visible)
    {
        number.serialNumberVisible=visible;
    }
    /*!
    @Function    : clearMute()
    @Description : 清空报警
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function clearMute()
    {
        recordModel.clear();
        numbers = recordModel.count;
        //numbers=0;
    }

}
