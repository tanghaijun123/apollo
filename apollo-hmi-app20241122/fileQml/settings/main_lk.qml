import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.VirtualKeyboard 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import  "./pages/mainFrame/assembly"
import "./pages/mainFrame/subpage"
import "./pages/homePage"
import "./pages/recordings"
import "./pages/warnings"
import "./pages/settings"

ApplicationWindow {
    property string alarm_name: "alarm_name"
    property bool mutevisible:true
    property string mutenumbers:"120s"
    id: window
    minimumWidth: 1280
    minimumHeight:  800
    visible: true
//    flags: Qt.FramelessWindowHint|Qt.WindowMinMaxButtonsHint
    header:ToolBar
    {
//        width: parent.minimumWidth
        height:96

        background: Rectangle
        {
            width: parent.width
            height: parent.height
            color:"#272727"
            anchors.fill: parent
        }
        leftPadding:16
        RowLayout
        {
            id:toolbar
            spacing: 0
            anchors.verticalCenter:   parent.verticalCenter
            layoutDirection: Qt.LeftToRight
            ToolBarBtn
            {
                m_width: 64
                m_height: 64
                state_off_name:"machinery_off"
                state_on_name: "machinery_on"
                state_off_source: "/images/on_off=off@2x.png"
                state_on_source: "/images/on_off=on@2x.png"
                btn_id: 1

            }
            Customspacing
            {
                customWidth: 16
            }
            CustomLine
            {

            }
            Customspacing
            {
                customWidth: 16
            }
            ToolBarBtn
            {
                m_width: 64
                m_height: 64
                state_off_name:"bar_sensor_off"
                state_on_name: "bar_sensor_on"
                state_off_source: "/images/on_off=off@2x(1).png"
                state_on_source: "/images/on_off=on@2x(1).png"
                btn_id: 2
            }
            Customspacing
            {
                customWidth: 16
            }
            CustomLine{}
            Customspacing
            {
                customWidth: 16
            }
            ToolBarBtn
            {
                m_width: 64
                m_height: 64
                state_off_name:"bar_pump_off"
                state_on_name: "bar_pump_on"
                state_off_source: "/images/on_off=off@2x(2).png"
                state_on_source: "/images/on_off=on@2x(2).png"
                btn_id: 3
            }
            Customspacing
            {
                customWidth: 16
            }
            Rectangle
            {
                width: 547
                height: 96
                color: "transparent"
                ComboBox
                {
                    id: cbox_alarm
                    anchors.fill: parent
                    background:Rectangle
                    {
                        anchors.fill:parent
                        color:"transparent"
                    }
                    model:ListModel
                    {
                        id:listmode
                        ListElement
                        {
                            serialnumbervisible:true
                            alarmvisible:true                           
                        }
                        ListElement
                        {
                            serialnumbervisible:true
                            alarmvisible:true                            
                        }
                    }
                    indicator: Image {
                        id: img
                        source: ""
                    }
                    delegate:myDelegate
                    contentItem: Alarm
                    {
                        id:contentalarm
                        serial_number_visible:listmode.get(0).serialnumbervisible
                        alarm_visible:listmode.get(0).alarmvisible

                    }
                     Component
                     {
                         id:myDelegate
                         Alarm
                         {
                             serial_number_visible:serialnumbervisible
                             alarm_visible:alarmvisible                            
                         }
                     }
                }
            }
            Customspacing
            {
                customWidth: 2
            }
            Mute
            {
                id:mute
                Layout.minimumWidth: 2
                alarm_mute_visible:mutevisible
                alarm_mute_text_content:mutenumbers
            }
            Customspacing
            {
                customWidth: 16
            }
            CustomDateTime{}
            CustomLine{}
            Customspacing
            {
                customWidth: 16
            }
            GroupBatterys{}
            Customspacing
            {
                customWidth: 16
            }
            CustomLine{}
            Customspacing
            {
                customWidth: 5
            }
            ToolBarBtn
            {
                m_width: 64
                m_height: 64
                state_off_name:"bar_AC_off"
                state_on_name: "bar_AC_on"
                state_off_source: "/images/on_off=off@2x(3).png"
                state_on_source: "/images/on_off=on@2x(3).png"
                btn_id: 4
            }
            Customspacing
            {
                customWidth: 16
            }
        }
    }
    footer: CustomFooter{id:customFooter}
    StackLayout
    {
        id:pageLayout
        width:1280
        height:624                
        currentIndex: 0
        HomePage{id:homePage}
        WarningSetPage{id:warningSetPage}
        RecordPage{id:recordPage}
        SetPage{id:setPage}
    }
    Rectangle
    {
        id:rectLine
        height: 2
        width: 1280
        color: "#000000"
    }

    Connections
    {
        target:customFooter
        function onSendPageIndex(index)
        {
            pageLayout.currentIndex=index
        }
    }
}
